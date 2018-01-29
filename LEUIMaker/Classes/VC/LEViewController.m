//
//  LEViewController.m
//  https://github.com/LarryEmerson/LEFrameworks
//
//  Created by Larry Emerson on 15/2/2.
//  Copyright (c) 2015年 Syan. All rights reserved.
//

#import "LEViewController.h"
@implementation UIViewController (StatusBarChange)
-(void) leRelayout{}
-(void) leAddStatusBarChangeNotification{
    //    LELogFunc
    [[ NSNotificationCenter defaultCenter ] addObserver : self selector : @selector (leRelayout) name : UIApplicationDidChangeStatusBarFrameNotification object : nil ];
}
-(void) leRemoveStatusBarChangeNotification{
    //    LELogFunc
    [[ NSNotificationCenter defaultCenter ] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}
@end

@interface LEView()
@property (nonatomic, readwrite) UISwipeGestureRecognizer *recognizerRight;
@property (nonatomic, readwrite) int leContainerW;
@property (nonatomic, readwrite) int leContainerH;
@property (nonatomic, readwrite) int leSubContainerH;
@property (nonatomic, readwrite) UIView *leViewContainer;
@property (nonatomic, readwrite) UIView *leSubViewContainer;
@property (nonatomic, readwrite) LEViewController *leViewController;
@end
@implementation LEView
-(void) leReleaseView{
    [self.recognizerRight removeTarget:self action:@selector(swipGesture:)];
    self.recognizerRight=nil;
    self.leViewController=nil;
    [self.leSubViewContainer removeFromSuperview];
    [self.leViewContainer removeFromSuperview];
    self.leViewContainer=nil;
    self.leSubViewContainer=nil;
    [self removeFromSuperview];
}
-(__kindof LEView *(^)(LEViewController *)) leSuperViewcontroller{
    return ^id(LEViewController *value){
        self.leViewController=value;
        [self setFrame:self.leViewController.view.bounds];
        [self selfInits];
        return self; 
    };
}
-(void) selfInits{
    if(![self.leViewController.view isEqual:self]){
        self.leViewController.view=self;
    }
    [self setBackgroundColor:LEColorWhite];
    self.leContainerW=self.bounds.size.width;
    self.leContainerH=self.bounds.size.height-(self.leViewController.extendedLayoutIncludesOpaqueBars?0:(LESCREEN_HEIGHT>LESCREEN_WIDTH?LEStatusBarHeight+LENavigationBarHeight:LENavigationBarHeight));
    self.leSubContainerH=self.leContainerH;
    self.leViewContainer=[UIView new].leAddTo(self).leMargins(UIEdgeInsetsZero).leBgColor([LEUICommon sharedInstance].leViewBGColor);
    //
//    if(self.leContainerH==LESCREEN_HEIGHT){
        self.leSubViewContainer=[UIView new].leAddTo(self.leViewContainer) .leTop(LESCREEN_HEIGHT>LESCREEN_WIDTH?LEStatusBarHeight+LENavigationBarHeight:LENavigationBarHeight);
        self.leSubContainerH=self.leSubViewContainer.bounds.size.height;
//    }
    self.recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGesture:)];
    [self.recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.leViewContainer addGestureRecognizer:self.recognizerRight];
    //
    [self leAdditionalInits];
}
-(id) initWithViewController:(LEViewController *) vc{
    self=[super initWithFrame:vc.view.bounds];
    self.leViewController=vc;
    [self selfInits];
    return self;
}
-(void) leOnSetRightSwipGesture:(BOOL) gesture{
    [self.recognizerRight setEnabled:gesture];
}
- (void)swipGesture:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self leSwipGestureLogic];
    }
}
-(void) leSwipGestureLogic{
    [self.leViewController.navigationController popViewControllerAnimated:YES];
}
- (void)leDidRotateFrom:(UIInterfaceOrientation)from{
    [self.leViewContainer leUpdateLayout];
    [self leRelayout];
    for (UIView *view in self.leViewContainer.subviews) {
        [view leDidRotateFrom:from];
    }
    for (UIView *view in self.leSubViewContainer.subviews) {
        [view leDidRotateFrom:from];
    }
}
-(void) leRelayout{
    [super leRelayout];
    self.leContainerW=self.bounds.size.width;
    self.leContainerH=self.bounds.size.height-(self.leViewController.extendedLayoutIncludesOpaqueBars?0:(LESCREEN_HEIGHT>LESCREEN_WIDTH?LEStatusBarHeight+LENavigationBarHeight:LENavigationBarHeight));
    [self.leViewContainer leUpdateLayout];
    int top=LESCREEN_HEIGHT>LESCREEN_WIDTH?(LEIS_IPHONE_X||![LEUICommon sharedInstance].leIsStatusBarChanged?LEStatusBarHeight:20):0;
    self.leSubViewContainer.leTop(top+LENavigationBarHeight);
    self.leSubContainerH=self.leSubViewContainer.bounds.size.height;
    NSMutableArray *searchClass=[[NSMutableArray alloc] initWithArray:self.subviews];
    for (NSInteger i=0; i<searchClass.count; i++) {
        UIView *v=[searchClass objectAtIndex:i];
        if([v isKindOfClass:NSClassFromString(@"LENavigation")]){
            LESuppressPerformSelectorLeakWarning(
                                                 [v performSelector:NSSelectorFromString(@"leRelayout")];
                                                 );
        }
    }
}
@end
@interface LEViewController ()
@property (nonatomic, readwrite) id<LEViewControllerPopDelegate> lePopDelegate;
@end
@implementation LEViewController{
    UIDeviceOrientation deviceOrientation;
    BOOL isBarHidden;
}
-(void) leRelayout{
    [super leRelayout];
    if([self.view isKindOfClass:[LEView class]]){
        [self.view leRelayout];
    }
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(deviceOrientation==UIDeviceOrientationUnknown){
        deviceOrientation=[UIDevice currentDevice].orientation;
    }else if(deviceOrientation!=[UIDevice currentDevice].orientation){
        [self leDidRotateFrom:(UIInterfaceOrientation)deviceOrientation];
    }
    [self.navigationController setNavigationBarHidden:YES];
    [self leAddStatusBarChangeNotification];
    [self leRelayout];
    
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self leRemoveStatusBarChangeNotification];
    [self.navigationController setNavigationBarHidden:isBarHidden animated:YES];
}
-(id) initWithDelegate:(id<LEViewControllerPopDelegate>) delegate{
    self.lePopDelegate=delegate;
    return [super init];
}
-(void) viewDidLoad{
    isBarHidden=self.navigationController.navigationBarHidden; 
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [super viewDidLoad];
    [self leAdditionalInits];
}
-(void) leAdditionalInits{
    NSString *className=NSStringFromClass(self.class);
    className=[className stringByAppendingString:@"Page"];
    LEView *view=(LEView *)[className leGetInstanceFromClassName];
    if(view&&([view isKindOfClass:[LEView class]]||[view isMemberOfClass:[LEView class]])){
        self.view=((LEView *)[view init]).leSuperViewcontroller(self);
    }else{
        view=nil;
    }
}
-(void) leDidRotateFrom:(UIInterfaceOrientation)from{
    [UIView animateWithDuration:0.25 animations:^(void){
        [self.view leDidRotateFrom:from];
        for (UIView *view in self.view.subviews) {
            [view leDidRotateFrom:from];
        }
    }];
}
@end

@implementation LENavigation{
    __weak id<LENavigationDelegate> curDelegate;
    UIImageView *background;
    UIView *bottomSplit;
}
-(void) leDidRotateFrom:(UIInterfaceOrientation)from{
    int top=LESCREEN_HEIGHT>LESCREEN_WIDTH?(LEIS_IPHONE_X||![LEUICommon sharedInstance].leIsStatusBarChanged?LEStatusBarHeight:20):0;
//    LELog(@"did rotate %d",LESCREEN_HEIGHT>LESCREEN_WIDTH?top:0)
    [self.leTop(LESCREEN_HEIGHT>LESCREEN_WIDTH?top:0) onCheckTitleView] ;
}
-(__kindof LENavigation *(^)(LEView *)) leSuperView{
    return ^id(LEView *value){
        self.leAddTo(value).leAnchor(LEInsideTopCenter).leEqualSuperViewWidth(1).leHeight(LENavigationBarHeight);
        background=[UIImageView new].leAddTo(self).leAnchor(LEInsideBottomCenter).leEqualSuperViewWidth(1).leHeight(LENavigationBarHeight).leBgColor([LEUICommon sharedInstance].leNaviBGColor);
        leBackButton=[UIButton new].leAddTo(self).leAnchor(LEInsideLeftCenter).leFont([LEUICommon sharedInstance].leNaviBtnFont).leBtnColorN(LEColorBlack).leBtnColorH(LEColorHighlighted).leTouchEvent(@selector(onLeft),self);
        [leBackButton setClipsToBounds:YES];
        leRightButton=[UIButton new].leAddTo(self).leAnchor(LEInsideRightCenter).leFont([LEUICommon sharedInstance].leNaviBtnFont).leBtnColorN(LEColorBlack).leBtnColorH(LEColorHighlighted).leTouchEvent(@selector(onRight),self);
        [leRightButton setClipsToBounds:YES];
        //
        self.leTitleViewContainer=[UIView new].leAddTo(self).leRelativeTo(leBackButton).leAnchor(LEOutsideRightCenter).leWidth(LESCREEN_WIDTH-LENavigationBarHeight*2).leHeight(LENavigationBarHeight);
        leNavigationTitle=[UILabel new].leAddTo(self).leAnchor(LEInsideCenter).leFont([LEUICommon sharedInstance].leNaviTitleFont).leLine(1).leColor(LEColorBlack).leAlignment(NSTextAlignmentCenter);
        self.leOffset(LESCREEN_HEIGHT>LESCREEN_WIDTH?LEStatusBarHeight:0).leLeftItemImg([LEUICommon sharedInstance].leNaviBackImage);
        self.leSplit(YES,LEColorSplitline);
        return self;
    };
}
-(void) leRelayout{
    [super leRelayout];
    int top=LEIS_IPHONE_X||![LEUICommon sharedInstance].leIsStatusBarChanged?LEStatusBarHeight:20;
//    LELog(@"ipx= %d Status=%d barH=%d top=%d",LEIS_IPHONE_X,[LEUICommon sharedInstance].leIsStatusBarChanged,LEStatusBarHeight, top)
    [self.leTop(LESCREEN_HEIGHT>LESCREEN_WIDTH?top:0) onCheckTitleView];
}
-(__kindof LENavigation *(^)(id<LENavigationDelegate>)) leDelegate{
    return ^id(id<LENavigationDelegate> value){
        curDelegate=value;
        return self;
    };
}
-(__kindof LENavigation *(^)(CGFloat))      leOffset{
    return ^id(CGFloat value){
        self.leTop(value);
        background.leHeight(LENavigationBarHeight+value);
        return self;
    };
}
-(__kindof LENavigation *(^)(UIImage *))    leBGImage{
    return ^id(UIImage *value){
        background.leImage(value);
        return self;
    };
}
-(__kindof LENavigation *(^)(NSString *))   leTitle{
    return ^id(NSString *value){
        [self leSetNavigationTitle:value];
        return self;
    };
}
-(__kindof LENavigation *(^)(UIColor *))    leTitleColor{
    return ^id(UIColor *value){
        [leNavigationTitle setTextColor:value];
        return self;
    };
}
-(__kindof LENavigation *(^)(BOOL enable, UIColor *color))  leSplit{
    return ^id(BOOL enable, UIColor *color){
        [self leEnableBottomSplit:enable Color:color];
        return self;
    };
}
-(__kindof LENavigation *(^)(UIImage *))    leLeftItemImg{
    return ^id(UIImage *value){
        [self leSetLeftNavigationItemWith:leBackButton.titleLabel.text Image:value Color:leBackButton.titleLabel.textColor];
        return self;
    };
}
-(__kindof LENavigation *(^)(NSString *))   leLeftItemText{
    return ^id(NSString *value){
        [self leSetLeftNavigationItemWith:value Image:leBackButton.imageView.image Color:leBackButton.titleLabel.textColor];
        return self;
    };
}
-(__kindof LENavigation *(^)(UIColor *))    leLeftItemColor{
    return ^id(UIColor *value){
        [self leSetLeftNavigationItemWith:leBackButton.titleLabel.text Image:leBackButton.imageView.image Color:value];
        return self;
    };
}
-(__kindof LENavigation *(^)(UIImage *))    leRightItemImg{
    return ^id(UIImage *value){
        [self leSetRightNavigationItemWith:leRightButton.titleLabel.text Image:value Color:leRightButton.titleLabel.textColor];
        return self;
    };
}
-(__kindof LENavigation *(^)(NSString *))   leRightItemText{
    return ^id(NSString *value){
        [self leSetRightNavigationItemWith:value Image:leRightButton.imageView.image Color:leRightButton.titleLabel.textColor];
        return self;
    };
}
-(__kindof LENavigation *(^)(UIColor *))   leRightItemColor{
    return ^id(UIColor *value){
        [self leSetRightNavigationItemWith:leRightButton.titleLabel.text Image:leRightButton.imageView.image Color:value];
        return self;
    };
}
-(id) initWithSuperViewAsDelegate:(LEView *)superview Title:(NSString *) title{
    return [self initWithDelegate:(id)superview SuperView:superview Title:title];
}
-(id) initWithDelegate:(id<LENavigationDelegate>)delegate SuperView:(LEView *)superview Title:(NSString *) title{
    self= [self initWithDelegate:delegate ViewController:superview.leViewController SuperView:superview Offset:LEStatusBarHeight BackgroundImage:[LEUICommon sharedInstance].leNaviBGImage TitleColor:[LEUICommon sharedInstance].leNaviTitleColor LeftItemImage:[LEUICommon sharedInstance].leNaviBackImage];
    [self leSetNavigationTitle:title];
    return self;
}
-(id) initWithDelegate:(id<LENavigationDelegate>) delegate ViewController:(UIViewController *) viewController SuperView:(UIView *) superview Offset:(int) offset BackgroundImage:(UIImage *) bg TitleColor:(UIColor *) color LeftItemImage:(UIImage *) left{
    self=[super init];
    self.leAddTo(superview).leAnchor(LEInsideTopCenter).leTop(offset).leEqualSuperViewWidth(1).leHeight(LENavigationBarHeight);
    curDelegate=delegate;
    background=[UIImageView new].leAddTo(self).leAnchor(LEInsideBottomCenter).leEqualSuperViewWidth(1).leHeight(LENavigationBarHeight+offset).leBgColor([LEUICommon sharedInstance].leNaviBGColor);
    [background setImage:bg];
    //
    leBackButton=[UIButton new].leAddTo(self).leAnchor(LEInsideLeftCenter).leFont([LEUICommon sharedInstance].leNaviBtnFont).leBtnColorN(LEColorBlack).leBtnColorH(LEColorHighlighted).leTouchEvent(@selector(onLeft),self);
    [leBackButton setClipsToBounds:YES];
    leRightButton=[UIButton new].leAddTo(self).leAnchor(LEInsideRightCenter).leFont([LEUICommon sharedInstance].leNaviBtnFont).leBtnColorN(LEColorBlack).leBtnColorH(LEColorHighlighted).leTouchEvent(@selector(onRight),self);
    [leRightButton setClipsToBounds:YES];
    //
    self.leTitleViewContainer=[UIView new].leAddTo(self).leRelativeTo(leBackButton).leAnchor(LEOutsideRightCenter).leWidth(LESCREEN_WIDTH-LENavigationBarHeight*2).leHeight(LENavigationBarHeight);
    leNavigationTitle=[UILabel new].leAddTo(self).leAnchor(LEI_C).leFont([LEUICommon sharedInstance].leNaviTitleFont).leLine(1).leColor(color).leAlignment(NSTextAlignmentCenter);
    //
    [self leSetLeftNavigationItemWith:nil Image:left Color:nil];
    [self leEnableBottomSplit:YES Color:LEColorSplitline];
    return self;
}
-(void) onCheckTitleView{
    [self onCheckTitleViewWith:leNavigationTitle.text];
}
-(void) onCheckTitleViewWith:(NSString *) title{
    [UIView animateWithDuration:0.2 animations:^{ 
        float width=LESCREEN_WIDTH-(leBackButton.titleLabel.hidden&&leBackButton.imageView.hidden?0:leBackButton.bounds.size.width)-(leRightButton.titleLabel.hidden&&leRightButton.imageView.hidden?0:leRightButton.bounds.size.width);
        self.leTitleViewContainer.leWidth(width).leHeight(LENavigationBarHeight);
        if(curDelegate&&[curDelegate respondsToSelector:@selector(leNavigationNotifyTitleViewContainerWidth:)]){
            [curDelegate leNavigationNotifyTitleViewContainerWidth:width];
        }
        leNavigationTitle.leLeft(0).leRight(0).leMaxWidth(width-LESideSpace*2).leText(title);
        float x1=self.leTitleViewContainer.frame.origin.x;
        float x2=leNavigationTitle.frame.origin.x;
        float w1=self.leTitleViewContainer.frame.size.width;
        float w2=leNavigationTitle.frame.size.width;
        leNavigationTitle.leLeft(MAX(0, (x1-x2+LESideSpace))).leRight(MIN(0, (x1-x2+w1-w2-LESideSpace)));
    }];
}
-(void) leEnableBottomSplit:(BOOL) enable Color:(UIColor *) color{
    if(enable&&bottomSplit==nil){
        bottomSplit=[UIView new].leAddTo(self).leAnchor(LEInsideBottomCenter).leBgColor(color).leEqualSuperViewWidth(1).leHeight(1.0/LESCREEN_SCALE);
    }
    [bottomSplit setHidden:!enable];
}
-(void) leSetBackground:(UIImage *) image{
    [background setImage:image];
}
-(void) leSetNavigationTitle:(NSString *) title{
    [self onCheckTitleViewWith:title];
}
-(void) leSetLeftNavigationItemWith:(NSString *)title Image:(UIImage *)image Color:(UIColor *) color{
    leBackButton.leText(title);
    if(color){
        leBackButton.leBtnColorN(color);
    }
    if(image){
        leBackButton.leBtnImg_N(image);
    }else{
        leBackButton.leBtnImg_N(nil);
    }
    [self onCheckTitleView];
}
-(void) leSetRightNavigationItemWith:(NSString *) title Image:(UIImage *) image{
    [self leSetRightNavigationItemWith:title Image:image Color:LEColorBlack];
}
-(void) leSetRightNavigationItemWith:(NSString *) title Image:(UIImage *) image Color:(UIColor *) color{
    leRightButton.leText(title);
    if(color){
        leRightButton.leBtnColorN(color);
    }
    if(image){
        leRightButton.leImage(image);
    }else{
        leRightButton.leImage(nil);
    }
    [self onCheckTitleView];
}

-(void) leSetNavigationOffset:(int) offset{
    background.leEqualSuperViewWidth(1).leHeight(offset+LENavigationBarHeight);
    self.leBottom(offset); 
}
-(void) onLeft{
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leNavigationLeftButtonTapped)]){
        [curDelegate leNavigationLeftButtonTapped];
    }else{ 
        if([self.superview isKindOfClass:[LEView class]]){
            [((LEView *)self.superview).leViewController lePop];
        }else{
            LELogObject(@"LENavigation's superview should be kind of LEView")
        }
    }
}
-(void) onRight{
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leNavigationRightButtonTapped)]){
        [curDelegate leNavigationRightButtonTapped];
    }
}
@end
