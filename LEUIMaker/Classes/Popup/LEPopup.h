//
//  LEPopup.h
//  Pods
//
//  Created by emerson larry on 2016/12/13.
//
//

#import <Foundation/Foundation.h>
#import "LEViewAdditions.h"
#import "LEUICommon.h"
#define PopupTitleFontSize 15
#define PopupSubtitleFontSize 14

typedef NS_ENUM(NSInteger, LEPopopType) {
    LEPopupQuestion,
    LEPopupTip
};

@protocol LEPopupDelegate<NSObject>
@optional
-(void) leOnPopupBackgroundClicked;
-(void) leOnPopupLeftButtonClicked;
-(void) leOnPopupRightButtonClicked;
-(void) leOnPopupCenterButtonClicked;
-(void) leOnPopupBackgroundClickedWith:(NSString *) identification;
-(void) leOnPopupLeftButtonClickedWith:(NSString *) identification;
-(void) leOnPopupRightButtonClickedWith:(NSString *) identification;
-(void) leOnPopupCenterButtonClickedWith:(NSString *) identification;
@end

@interface LEPopup : UIView
@property (nonatomic) UIImageView *leBackground;
@property (nonatomic) UILabel *leTitle;
@property (nonatomic) UIView *leSplit;
@property (nonatomic) UILabel *leSubtitle;
@property (nonatomic) UIButton *leLeftButton;
@property (nonatomic) UIButton *leRightButton;
@property (nonatomic) UIButton *leCenterButton;
-(void) leEaseIn;
-(id) initWithDelegate:(id<LEPopupDelegate>) delegate Type:(LEPopopType) type;
-(id) initWithDelegate:(id<LEPopupDelegate>) delegate Type:(LEPopopType) type Identifier:(NSString *) identifier;

/** 询问：delegate、subtitle、identifier */
+(LEPopup *) leShowQuestionPopupWithDelegate:(id<LEPopupDelegate>) delegate Subtitle:(NSString *) subtitle Identifier:(NSString *) identifier;
/** 询问：delegate、title、subtitle、alignment、identifier */
+(LEPopup *) leShowQuestionPopupWithDelegate:(id<LEPopupDelegate>) delegate Title:(NSString *) title Subtitle:(NSString *) subtitle Alignment:(NSTextAlignment) alignment Identifier:(NSString *) identifier;
/** 询问：delegate、title、subtitle、alignment、leftbuttontext、rightbuttontext、identifier */
+(LEPopup *) leShowQuestionPopupWithDelegate:(id<LEPopupDelegate>) delegate Title:(NSString *) title Subtitle:(NSString *) subtitle Alignment:(NSTextAlignment) alignment LeftButtonText:(NSString *)leftText RightButtonText:(NSString *)rightText Identifier:(NSString *) identifier;
/** 提示：delegate、title、subtitle、identifier */
+(LEPopup *) leShowTipPopupWithDelegate:(id<LEPopupDelegate>) delegate Title:(NSString *) title Subtitle:(NSString *) subtitle Identifier:(NSString *) identifier;
/** 提示：delegate、title、subtitle、alignment、identifier */
+(LEPopup *) leShowTipPopupWithDelegate:(id<LEPopupDelegate>) delegate Title:(NSString *) title Subtitle:(NSString *) subtitle Aligment:(NSTextAlignment) aligment Identifier:(NSString *) identifier;
/** 提示：delegate、title、subtitle、alignment、buttontext、identifier */
+(LEPopup *) leShowTipPopupWithDelegate:(id<LEPopupDelegate>) delegate Title:(NSString *) title Subtitle:(NSString *) subtitle Aligment:(NSTextAlignment) aligment ButtonText:(NSString *) text Identifier:(NSString *) identifier;
@end
