//
//  LEPopup.m
//  Pods
//
//  Created by emerson larry on 2016/12/13.
//
//

#import "LEPopup.h"
 

@implementation LEPopup{
    int contentW;
    __weak id<LEPopupDelegate> curDelegate;
    NSString *curIdentifier;
}

-(id) initWithDelegate:(id<LEPopupDelegate>) delegate Type:(LEPopopType) type {
    return [self initWithDelegate:delegate Type:type Identifier:nil];
}
-(id) initWithDelegate:(id<LEPopupDelegate>) delegate Type:(LEPopopType) type Identifier:(NSString *) identifier{
    self=[super initWithFrame:LESCREEN_BOUNDS];
    [[[LEUICommon sharedInstance] leGetTopWindow] addSubview:self];
    [self.leBgColor(LEColorMask5).leTouchEvent(@selector(onBackgroundTapped),self) setAlpha:0];
    curIdentifier=identifier;
    curDelegate=delegate;
    contentW=LESCREEN_WIDTH-LENavigationBarHeight*2;
    self.leBackground=[UIImageView new].leAddTo(self).leAnchor(LEI_C).leWidth(contentW).leImage([LEColorWhite leImage]).leCorner(8).leEnableTouch(YES).leTouchEvent(nil,nil).leWrapper();
    UIView *curContentContainer=[UIView new].leAddTo(self.leBackground).leAnchor(LEI_C).leVerticalStack();
    contentW-=LESideSpace*2;
    self.leTitle=[UILabel new].leLeft(LESideSpace).leRight(LESideSpace).leTop(LESideSpace).leBottom(LESideSpace).leFont(LEBoldFont(LEFontML)).leMaxWidth(contentW).leColor(LEColorBlack).leLine(0).leLineSpace(8).leCenterAlign;
    self.leSplit=[UIView new].leWidth(contentW+LESideSpace*2).leHeight(LESplitlineH).leBgColor(LEColorSplitline);
    self.leSubtitle=[UILabel new].leTop(LESideSpace).leBottom(LESideSpace).leMaxWidth(contentW).leFont(LEFont(LEFontMS)).leLine(0).leLineSpace(6).leCenterAlign;
    UIView *btnGroup=[UIView new].leBottom(LESideSpace).leHorizontalStack();
    [curContentContainer lePushToStack:self.leTitle,self.leSplit,self.leSubtitle,btnGroup,nil];
    if(type==LEPopupTip){
        self.leCenterButton=[UIButton new].leBtnFixedWidth(contentW).leBtnFixedHeight(LENavigationBarHeight-LESideSpace).leCorner(6).leBtnBGImgN([LEColorBlue leImage]).leBtnColorN(LEColorWhite).leFont(LEFont(LEFontML)).leTouchEvent(@selector(onCenter),self).leText(@"确定");
        [btnGroup lePushToStack:self.leCenterButton,nil];
    }else{
        self.leLeftButton=[UIButton new].leBtnFixedWidth(contentW/2-LESideSpace).leRight(LESideSpace).leBtnFixedHeight(LENavigationBarHeight-LESideSpace).leCorner(6).leBtnBGImgN([LEColorText9 leImage]).leBtnColorN(LEColorWhite).leFont(LEFont(LEFontML)).leTouchEvent(@selector(onLeft),self).leText(@"取消");
        self.leRightButton=[UIButton new].leBtnFixedWidth(contentW/2-LESideSpace).leLeft(LESideSpace).leBtnFixedHeight(LENavigationBarHeight-LESideSpace).leCorner(6).leBtnBGImgN([LEColorBlue leImage]).leBtnColorN(LEColorWhite).leFont(LEFont(LEFontML)).leTouchEvent(@selector(onRight),self).leText(@"确定");
        [btnGroup lePushToStack:self.leLeftButton,self.leRightButton, nil];
    }
    return self;
}
+(LEPopup *) leShowQuestionPopupWithDelegate:(id<LEPopupDelegate>) delegate Subtitle:(NSString *) subtitle Identifier:(NSString *) identifier{
    LEPopup *popup= [[LEPopup alloc] initWithDelegate:delegate Type:LEPopupQuestion Identifier:identifier];
    popup.leSplit.hidden=YES;
    popup.leSubtitle.leText(subtitle);
    [popup leEaseIn];
    return popup;
}
+(LEPopup *) leShowQuestionPopupWithDelegate:(id<LEPopupDelegate>) delegate Title:(NSString *) title Subtitle:(NSString *) subtitle Alignment:(NSTextAlignment) alignment Identifier:(NSString *) identifier{
    LEPopup *popup= [[LEPopup alloc] initWithDelegate:delegate Type:LEPopupQuestion Identifier:identifier];
    popup.leTitle.leText(title);
    popup.leSubtitle.leAlignment(alignment).leText(subtitle);
    [popup leEaseIn];
    return popup;
}
+(LEPopup *) leShowQuestionPopupWithDelegate:(id<LEPopupDelegate>) delegate Title:(NSString *) title Subtitle:(NSString *) subtitle Alignment:(NSTextAlignment) alignment LeftButtonText:(NSString *)leftText RightButtonText:(NSString *)rightText Identifier:(NSString *) identifier{
    LEPopup *popup= [LEPopup leShowQuestionPopupWithDelegate:delegate Title:title Subtitle:subtitle Alignment:alignment Identifier:identifier];
    popup.leLeftButton.leText(leftText);
    popup.leRightButton.leText(rightText);
    return popup;
}
+(LEPopup *) leShowTipPopupWithDelegate:(id<LEPopupDelegate>) delegate Title:(NSString *) title Subtitle:(NSString *) subtitle Identifier:(NSString *) identifier{
    LEPopup *popup= [[LEPopup alloc] initWithDelegate:delegate Type:LEPopupTip Identifier:identifier];
    popup.leTitle.leText(title);
    popup.leSubtitle.leText(subtitle);
    [popup leEaseIn];
    return popup;
}
+(LEPopup *) leShowTipPopupWithDelegate:(id<LEPopupDelegate>) delegate Title:(NSString *) title Subtitle:(NSString *) subtitle Aligment:(NSTextAlignment) aligment Identifier:(NSString *) identifier{
    LEPopup *popup= [LEPopup leShowTipPopupWithDelegate:delegate Title:title Subtitle:subtitle Identifier:identifier];
    popup.leSubtitle.leAlignment(aligment);
    return popup;
}
+(LEPopup *) leShowTipPopupWithDelegate:(id<LEPopupDelegate>) delegate Title:(NSString *) title Subtitle:(NSString *) subtitle Aligment:(NSTextAlignment) aligment ButtonText:(NSString *) text Identifier:(NSString *) identifier{
    LEPopup *popup= [LEPopup leShowTipPopupWithDelegate:delegate Title:title Subtitle:subtitle Aligment:aligment Identifier:identifier];
    popup.leCenterButton.leText(text);
    return popup;
}
-(void) onLeft{
    [self leEaseOut:@selector(onLeftLogic)];
}
-(void) onLeftLogic{
    if(curIdentifier&&curDelegate&&[curDelegate respondsToSelector:@selector(leOnPopupLeftButtonClickedWith:)]){
        [curDelegate leOnPopupLeftButtonClickedWith:curIdentifier];
    }else if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnPopupLeftButtonClicked)]){
        [curDelegate leOnPopupLeftButtonClicked];
    }
}
-(void) onRight{
    [self leEaseOut:@selector(onRightLogic)];
}
-(void) onRightLogic{
    if(curIdentifier&&curDelegate&&[curDelegate respondsToSelector:@selector(leOnPopupRightButtonClickedWith:)]){
        [curDelegate leOnPopupRightButtonClickedWith:curIdentifier];
    }else if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnPopupRightButtonClicked)]){
        [curDelegate leOnPopupRightButtonClicked];
    }
}
-(void) onCenter{
    [self leEaseOut:@selector(onCenterLogic)];
}
-(void) onCenterLogic{
    if(curIdentifier&&curDelegate&&[curDelegate respondsToSelector:@selector(leOnPopupCenterButtonClickedWith:)]){
        [curDelegate leOnPopupCenterButtonClickedWith:curIdentifier];
    }else if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnPopupCenterButtonClicked)]){
        [curDelegate leOnPopupCenterButtonClicked];
    }
}
-(void) onBackgroundLogic{
    if(curIdentifier&&curDelegate&&[curDelegate respondsToSelector:@selector(leOnPopupBackgroundClickedWith:)]){
        [curDelegate leOnPopupBackgroundClickedWith:curIdentifier];
    }else if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnPopupBackgroundClicked)]){
        [curDelegate leOnPopupBackgroundClicked];
    }
}
-(void) onBackgroundTapped{
    [self leEaseOut:@selector(onBackgroundLogic)];
}
-(void) leEaseIn{
    [UIView animateWithDuration:0.4 animations:^(void){
        [self setAlpha:1];
    }];
}
-(void) leEaseOut:(SEL) sel{
    [UIView animateWithDuration:0.4 animations:^(void){
        [self setAlpha:0];
    } completion:^(BOOL done){
        if(sel&&[self respondsToSelector:sel]){
            [self performSelector:sel];
        }
        [self removeFromSuperview];
    }];
}
@end

