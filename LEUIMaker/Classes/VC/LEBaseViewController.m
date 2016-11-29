//
//  LEBaseViewController.m
//  https://github.com/LarryEmerson/LEFrameworks
//
//  Created by Larry Emerson on 15/2/2.
//  Copyright (c) 2015年 Syan. All rights reserved.
//

#import "LEBaseViewController.h"
@interface LEBaseView()
@property (nonatomic, readwrite) UISwipeGestureRecognizer *recognizerRight;
@property (nonatomic, readwrite) int leCurrentFrameWidth;
@property (nonatomic, readwrite) int leCurrentFrameHight;
@property (nonatomic, readwrite) int leFrameHightForCustomizedView;
@property (nonatomic, readwrite) UIView *leViewContainer;
@property (nonatomic, readwrite) UIView *leViewBelowCustomizedNavigation;
@property (nonatomic, readwrite) LEBaseViewController *leCurrentViewController;
@end
@implementation LEBaseView{
    UIView *curSuperView; 
}
-(void) leReleaseView{
    [self.recognizerRight removeTarget:self action:@selector(swipGesture:)];
    self.recognizerRight=nil;
    self.leCurrentViewController=nil;
    [self.leViewBelowCustomizedNavigation removeFromSuperview];
    [self.leViewContainer removeFromSuperview];
    self.leViewContainer=nil;
    self.leViewBelowCustomizedNavigation=nil;
    [self removeFromSuperview];
} 
-(id) initWithViewController:(LEBaseViewController *) vc{
    curSuperView=vc.view;
    self.leCurrentViewController=vc;
    self=[super initWithFrame:curSuperView.bounds];
    [self setBackgroundColor:LEColorWhite];
    [curSuperView addSubview:self];
    self.leCurrentFrameWidth=self.bounds.size.width;
    self.leCurrentFrameHight=self.bounds.size.height-(self.leCurrentViewController.extendedLayoutIncludesOpaqueBars?0:(LEStatusBarHeight+LENavigationBarHeight));
    self.leFrameHightForCustomizedView=self.leCurrentFrameHight;
    self.leViewContainer=[UIView new].leAddTo(self).leAnchor(LEInsideTopCenter).leEqualSuperViewWidth(1).leEqualSuperViewHeight(1).leBgColor([LEUICommon sharedInstance].leViewBGColor);
    //
    if(self.leCurrentFrameHight==LESCREEN_HEIGHT){
        self.leViewBelowCustomizedNavigation=[UIView new].leAddTo(self.leViewContainer).leMargins(UIEdgeInsetsMake(LEStatusBarHeight+LENavigationBarHeight, 0, 0, 0)); 
        self.leFrameHightForCustomizedView=self.leViewBelowCustomizedNavigation.bounds.size.height;
    }
    self.recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGesture:)];
    [self.recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.leViewContainer addGestureRecognizer:self.recognizerRight];
    //
    [self leExtraInits];
    return self;
}
-(void) leOnSetRightSwipGesture:(BOOL) gesture{
    [self.recognizerRight setEnabled:gesture];
} 
-(UIView *)leSuperViewContainer{
    return curSuperView;
}
- (void)swipGesture:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self leSwipGestureLogic];
    }
}
-(void) leSwipGestureLogic{
    [self.leCurrentViewController.navigationController popViewControllerAnimated:YES];
} 
@end
@interface LEBaseViewController ()
@property (nonatomic, readwrite) id<LEViewControllerPopDelegate> lePopDelegate;
@end
@implementation LEBaseViewController
-(id) initWithDelegate:(id<LEViewControllerPopDelegate>) delegate{
    self.lePopDelegate=delegate;
    return [super init];
}
-(void) viewDidLoad{
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [super viewDidLoad];
    [self leExtraInits];
}
-(void) leExtraInits{
    NSString *class=NSStringFromClass(self.class);
    class=[class stringByAppendingString:@"Page"];
    NSObject *obj=[NSClassFromString(class) alloc];
    if(obj&&([obj isKindOfClass:[LEBaseView class]]||[obj isMemberOfClass:[LEBaseView class]])){
        [[(LEBaseView *) obj initWithViewController:self] setUserInteractionEnabled:YES];
    }
}
@end

@interface LEBaseNavigation ()
@property (nonatomic, weak) UIViewController *curViewController;
@end
@implementation LEBaseNavigation{
    id<LENavigationDelegate> curDelegate;
    UIImageView *background;
    UIView *bottomSplit;
}
-(id) initWithSuperViewAsDelegate:(LEBaseView *)superview Title:(NSString *) title{
    return [self initWithDelegate:(id)superview SuperView:superview Title:title];
}
-(id) initWithDelegate:(id<LENavigationDelegate>)delegate SuperView:(LEBaseView *)superview Title:(NSString *) title{
    self= [self initWithDelegate:delegate ViewController:superview.leCurrentViewController SuperView:superview Offset:LEStatusBarHeight BackgroundImage:[LEUICommon sharedInstance].leNaviBackImage TitleColor:[LEUICommon sharedInstance].leNaviTitleColor LeftItemImage:[LEUICommon sharedInstance].leNaviBackImage];
    [self leSetNavigationTitle:title];
    return self;
}
-(id) initWithDelegate:(id<LENavigationDelegate>) delegate ViewController:(UIViewController *) viewController SuperView:(UIView *) superview Offset:(int) offset BackgroundImage:(UIImage *) bg TitleColor:(UIColor *) color LeftItemImage:(UIImage *) left{
    self=[super init];
    self.leAddTo(superview).leAnchor(LEInsideTopCenter).leTop(offset).leEqualSuperViewWidth(1).leHeight(LENavigationBarHeight);
    self.curViewController=viewController;
    curDelegate=delegate;
    background=[UIImageView new].leAddTo(self).leAnchor(LEInsideBottomCenter).leWidth(LESCREEN_WIDTH).leHeight(LENavigationBarHeight+offset).leBgColor([LEUICommon sharedInstance].leNaviBGColor);
    [background setImage:bg];
    //
    leBackButton=[UIButton new].leAddTo(self).leAnchor(LEInsideLeftCenter).leFont([LEUICommon sharedInstance].leNaviBtnFont).leBtnColorN(LEColorBlack).leBtnColorH(LEColorHighlighted).leTouchEvent(@selector(onLeft),self);
    [leBackButton setClipsToBounds:YES];
    leRightButton=[UIButton new].leAddTo(self).leAnchor(LEInsideRightCenter).leFont([LEUICommon sharedInstance].leNaviBtnFont).leBtnColorN(LEColorBlack).leBtnColorH(LEColorHighlighted).leTouchEvent(@selector(onRight),self);
    [leRightButton setClipsToBounds:YES];
    //
    self.leTitleViewContainer=[UIView new].leAddTo(self).leRelativeTo(leBackButton).leAnchor(LEOutsideRightCenter).leWidth(LESCREEN_WIDTH-LENavigationBarHeight*2).leHeight(LENavigationBarHeight);
    leNavigationTitle=[UILabel new].leAddTo(self).leAnchor(LEInsideCenter).leFont([LEUICommon sharedInstance].leNaviTitleFont).leLine(1).leColor(color).leAlignment(NSTextAlignmentCenter);
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
        leNavigationTitle=leNavigationTitle.leText(title);
        float width=LESCREEN_WIDTH-leBackButton.bounds.size.width-leRightButton.bounds.size.width;
        self.leTitleViewContainer=self.leTitleViewContainer.leWidth(width).leHeight(LENavigationBarHeight);
        if(curDelegate&&[curDelegate respondsToSelector:@selector(leNavigationNotifyTitleViewContainerWidth:)]){
            [curDelegate leNavigationNotifyTitleViewContainerWidth:width];
        }
        leNavigationTitle.leMargins(UIEdgeInsetsZero);
        leNavigationTitle.leWidth(width-LESideSpace*2).leText(leNavigationTitle.text);
        float x1=self.leTitleViewContainer.frame.origin.x;
        float x2=leNavigationTitle.frame.origin.x;
        float w1=self.leTitleViewContainer.frame.size.width;
        float w2=leNavigationTitle.frame.size.width;
        float offset=(MAX(0, (x1-x2+LESideSpace))+MIN(0, (x1-x2+w1-w2-LESideSpace)))/1;
        leNavigationTitle.leLeft(offset<0?fabsf(offset):0).leRight(offset>0?offset:0);
    }];
    //    LELog(@"%f %f %f %f",leBackButton.bounds.size.width,leRightButton.bounds.size.width,width,leNavigationTitle.leAutoLayoutSettings.leOffset.x)
}
//-(void) leSetLeftButton:(UIImage *) img{
//    [leBackButton setImage:img forState:UIControlStateNormal];
//    [leBackButton leSetSize:LESquareSize(LENavigationBarHeight)];
//    [self onCheckTitleView];
//}
-(void) leEnableBottomSplit:(BOOL) enable Color:(UIColor *) color{
    if(enable&&bottomSplit==nil){
        bottomSplit=[UIView new].leAddTo(self).leAnchor(LEInsideBottomCenter).leBgColor(color).leWidth(LESCREEN_WIDTH).leHeight(1.0/LESCREEN_SCALE);
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
    background.leWidth(LESCREEN_WIDTH).leHeight(offset+LENavigationBarHeight);
    self.leBottom(offset); 
}
-(void) onLeft{
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leNavigationLeftButtonTapped)]){
        [curDelegate leNavigationLeftButtonTapped];
    }else{
        [self.curViewController.navigationController popViewControllerAnimated:YES];
    }
}
-(void) onRight{
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leNavigationRightButtonTapped)]){
        [curDelegate leNavigationRightButtonTapped];
    }
}
@end

//@implementation LEBaseNavigationView{
//}
//-(id) initWithAutoLayoutSettings:(LEAutoLayoutSettings *) autoLayoutSettings ViewDataModel:(NSDictionary *) dataModel{
//    self.navigationDataModel=dataModel;
//    self=[super initWithAutoLayoutSettings:autoLayoutSettings];
//    self.curViewLeft=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.leAutoLayoutSettings.leAddTo Anchor:LEAnchorInsideTopLeft Offset:CGPointMake(0, LEStatusBarHeight) CGSize:CGSizeMake(LENavigationBarHeight, LENavigationBarHeight)]];
//    self.curViewMiddle=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.leAutoLayoutSettings.leAddTo Anchor:LEAnchorInsideTopCenter Offset:CGPointMake(0, LEStatusBarHeight) CGSize:CGSizeMake(self.leAutoLayoutSettings.leAddTo.bounds.size.width-LENavigationBarHeight*2-LESideSpace*2, LENavigationBarHeight)]];
//    [self.curViewMiddle setUserInteractionEnabled:NO];
//    self.curViewRight=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.leAutoLayoutSettings.leAddTo Anchor:LEAnchorInsideTopRight Offset:CGPointMake(0, LEStatusBarHeight) CGSize:CGSizeMake(LENavigationBarHeight, LENavigationBarHeight)]];
//    [self onSetupView];
//    [self onUpdateViewWithDataModel:dataModel];
//    return self;
//}
//-(void) onSetupView{}
//-(void) onUpdateViewWithDataModel:(NSDictionary *) dataModel{
//    if(dataModel){
//        BOOL fullScreen=NO;
//        if([dataModel objectForKey:KeyOfNavigationInFullScreenMode]){
//            fullScreen=[[dataModel objectForKey:KeyOfNavigationInFullScreenMode] boolValue];
//        }else{
//            fullScreen=IsFullScreenMode;
//        } 
//        [self setUserInteractionEnabled:!fullScreen];
//        [self setBackgroundColor:fullScreen?LEColorClear:[LEUIFramework sharedInstance].leColorNavigationBar];
//        UIImage *background=[dataModel objectForKey:KeyOfNavigationBackground];
//        if(background){
//            [self setImage:[background leMiddleStrechedImage]];
//        }
//    }
//}
//@end
//@implementation LENavigationView
//-(void) onSetupView{
//    [self setBackgroundColor:[LEUIFramework sharedInstance].leColorNavigationBar];
//    self.curButtonBack=[LEUIFramework leGetButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.curViewLeft  Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:self.curViewLeft.bounds.size] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:nil FontSize:0 Font:nil Image:nil BackgroundImage:nil Color:nil SelectedColor:nil MaxWidth:0 SEL:@selector(onButtonClicked:) Target:self]];
//    self.curButtonRight=[LEUIFramework leGetButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.curViewRight Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:self.curViewRight.bounds.size] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:nil FontSize:0 Font:nil Image:nil BackgroundImage:nil Color:nil SelectedColor:nil MaxWidth:0 SEL:@selector(onButtonClicked:) Target:self]];
//    self.curLabelTitle=[LEUIFramework leGetLabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.curViewMiddle Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:0 Font:[UIFont boldSystemFontOfSize:NavigationBarFontSize] Width:LESCREEN_WIDTH-LESideSpace*4-LENavigationBarHeight*2 Height:0 Color:[LEUIFramework sharedInstance].leColorNavigationContent Line:1 Alignment:NSTextAlignmentCenter]];
//}
//-(void) onUpdateViewWithDataModel:(NSDictionary *) dataModel{
//    [super onUpdateViewWithDataModel:dataModel];
//    self.navigationDataModel=dataModel;
//    UIImage *back=nil;
//    NSString *title=nil;
//    UIImage *right=nil;
//    if(dataModel){
//        back=[dataModel objectForKey:KeyOfNavigationBackButton];
//        title=[dataModel objectForKey:KeyOfNavigationTitle];
//        right=[dataModel objectForKey:KeyOfNavigationRightButton];
//        if(back){
//            [self.curButtonBack setImage:back forState:UIControlStateNormal];
//        }
//        if(title){
//            [self.curLabelTitle leSetText:title];
//        }
//        if(right){
//            [self.curButtonRight setImage:right forState:UIControlStateNormal];
//        }
//    }
//    [self.curViewMiddle setHidden:!title];
//    [self.curViewLeft setHidden:(back==nil)];
//    [self.curViewRight setHidden:(right==nil)];
//}
//-(void) onButtonClicked:(UIButton *) button{
//    NSString *code=@"";
//    if([button isEqual:self.curButtonBack]){
//        code=KeyOfNavigationBackButton;
//    }else if([button isEqual:self.curButtonRight]){
//        code=KeyOfNavigationRightButton;
//    }
//    if([self.superview respondsToSelector:NSSelectorFromString(@"onNavigationBarClickedWithCode:")]){
//        LESuppressPerformSelectorLeakWarning(
//                                           [self.superview performSelector:NSSelectorFromString(@"onNavigationBarClickedWithCode:") withObject:code];
//                                           );
//    }
//}
//@end
//@implementation LEBaseViewController{
//    UIView *curSuperViewContainer;
//    UISwipeGestureRecognizer *recognizerRight;
//    UIStatusBarStyle targetStatusStyle;
//    UIStatusBarStyle lastStatusStyle;
//}
//@synthesize leViewContainer=_leViewContainer;
//@synthesize globalVar=_globalVar;
//@synthesize leCurrentFrameHight=_leCurrentFrameHight;
//@synthesize leCurrentFrameWidth=_leCurrentFrameWidth;
//-(void) onNavigationBarClickedWithCode:(NSString *) code{
//    //    LELogObject(code);
//    if([code isEqualToString:KeyOfNavigationBackButton]){
//        [self onClickedForLeftButton];
//    }else if([code isEqualToString:KeyOfNavigationRightButton]){
//        [self onClickedForRightButton];
//    }
//}
//-(void) onClickedForLeftButton{
//    [self leEaseOutView];
//}
//-(void) onClickedForRightButton{
//    
//}
//-(void) setStatusBarStyle:(UIStatusBarStyle) style{
//    [[UIApplication sharedApplication] setStatusBarStyle:style animated:YES];
//} 
//-(UIView *) leSuperViewContainer{
//    return curSuperViewContainer;
//}
//-(void) setSuperViewContainer:(UIView *) view{
//    curSuperViewContainer=view;
//}
//-(id) initWithSuperView:(UIView *)view{
//    return [self initWithSuperView:view NavigationViewClassName:nil NavigationDataModel:nil  EffectType:EffectTypeWithAlpha];
//}
//-(id) initWithSuperView:(UIView *)view NavigationDataModel:(NSDictionary *)dataModel EffectType:(EffectType)effectType{
//    return [self initWithSuperView:view NavigationViewClassName:@"LENavigationView" NavigationDataModel:dataModel EffectType:effectType];
//}
//-(id) initWithSuperView:(UIView *)view NavigationViewClassName:(NSString *) navigationClass NavigationDataModel:(NSDictionary *) dataModel EffectType:(EffectType) effectType{
//    curSuperViewContainer=view;
//    self.curNavigationClassName=navigationClass;
//    lastStatusStyle=[[UIApplication sharedApplication] statusBarStyle];
//    self.globalVar = [LEUIFramework sharedInstance];
//    self.leCurrentFrameWidth=LESCREEN_WIDTH;
//    self.leCurrentFrameHight=LESCREEN_HEIGHT;
//    self.leCurrentFrameHight=view.frame.size.height;
//    self = [super initWithFrame:CGRectMake(0, 0, self.leCurrentFrameWidth,self.leCurrentFrameHight)];
//    BOOL fullScreen=NO;
//    if([dataModel objectForKey:KeyOfNavigationInFullScreenMode]){
//        fullScreen=[[dataModel objectForKey:KeyOfNavigationInFullScreenMode] boolValue];
//    }else{
//        fullScreen=IsFullScreenMode;
//    }
//    //
//    self.curEffectType=effectType;
//    if(effectType==EffectTypeFromRight){
//        [self leSetFrame:CGRectMake(self.leCurrentFrameWidth, 0, self.leCurrentFrameWidth, self.leCurrentFrameHight)];
//    }
//    recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGesture:)];
//    [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self addGestureRecognizer:recognizerRight];
//    //
//    [view addSubview:self];
//    [self setBackgroundColor:LEColorWhite];
//    //Container
//    self.leViewContainer=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopCenter Offset:CGPointMake(0, fullScreen?0:(LENavigationBarHeight+LEStatusBarHeight)) CGSize:CGSizeMake(self.leCurrentFrameWidth, self.leCurrentFrameHight-(fullScreen?0:(LENavigationBarHeight+LEStatusBarHeight)))]];
//    [self.leViewContainer setBackgroundColor:[LEUIFramework sharedInstance].leColorViewContainer];
//    //
//    if(navigationClass&&navigationClass.length>0){
//        LESuppressPerformSelectorLeakWarning(
//                                           self.curNavigationView=[[NSClassFromString(navigationClass) alloc] performSelector:NSSelectorFromString(@"initWithAutoLayoutSettings:ViewDataModel:") withObject:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopCenter Offset:CGPointZero CGSize:CGSizeMake(self.leCurrentFrameWidth, LENavigationBarHeight+LEStatusBarHeight)] withObject:dataModel];
//                                           );
//    }
//    [self setExtraViewInits];
//    return self;
//}
//-(void) setExtraViewInits{
//}
//-(void) leEaseInView{
//    if(self.curEffectType==EffectTypeWithAlpha){
//        [self setAlpha:0];
//        [UIView animateWithDuration:0.2f animations:^(void){
//            [self setAlpha:1];
//        }completion:^(BOOL isDone){
//            [self leEaseInViewLogic];
//        }];
//    }else if(self.curEffectType==EffectTypeFromRight){
//        [self leSetFrame:CGRectMake(self.leCurrentFrameWidth, 0, self.leCurrentFrameWidth, self.leCurrentFrameHight)];
//        [UIView animateWithDuration:0.2 animations:^(void){
//            [self leSetFrame:CGRectMake(0, 0, self.leCurrentFrameWidth, self.leCurrentFrameHight)];
//        } completion:^(BOOL isDone){
//            [self leEaseInViewLogic];
//        }];
//    }
//}
//-(void) leEaseOutView{
//    [self setStatusBarStyle:lastStatusStyle];
//    if(self.curEffectType==EffectTypeWithAlpha){
//        [UIView animateWithDuration:0.2f animations:^(void){
//            [self setAlpha:0];
//        } completion:^(BOOL isDone){
//            [self dismissView];
//        }];
//    }else if(self.curEffectType==EffectTypeFromRight){
//        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
//            [self leSetFrame:CGRectMake(self.leCurrentFrameWidth, 0, self.leCurrentFrameWidth, self.leCurrentFrameHight)];
//        } completion:^(BOOL isFinished){
//            [self leEaseOutViewLogic];
//        }];
//    }else{
//        [self leEaseOutViewLogic];
//    }
//}
//-(void) leEaseInViewLogic{
//}
//-(void) leEaseOutViewLogic{
//    [self dismissView];
//}
//-(void) eventCallFromChild{
//}
//-(void) dismissView{
//    [self removeFromSuperview];
//}
//- (void)swipGesture:(UISwipeGestureRecognizer *)recognizer {
//    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
//        [self leEaseOutView];
//    }
//}
//@end
//
