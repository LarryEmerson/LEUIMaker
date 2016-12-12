//
//  LEViewController.h
//  https://github.com/LarryEmerson/LEFrameworks
//
//  Created by Larry Emerson on 15/2/2.
//  Copyright (c) 2015年 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LEFoundation/LEFoundations.h>
#import "LEViewAdditions.h"
#import "LEUICommon.h"
@protocol LEViewControllerPopDelegate <NSObject>
-(void) leOnViewControllerPopedWithPageName:(NSString *) order AndData:(id) data;
@end
/**
 * 如果LEViewController的子类（XXX）对应的view为LEView的子类，并且LEView的子类类名定义为“XXXPage"，则”XXXPage“类会被主动创建。如果需要重新定义子类的init方法，则需要复写XXX的方法：-(void) leExtraInits{}，这样可以避免XXX自动创建“XXXPage”。
 */
@interface LEViewController : UIViewController 
@property (nonatomic, readonly) id<LEViewControllerPopDelegate> lePopDelegate;
-(id) initWithDelegate:(id<LEViewControllerPopDelegate>) delegate; 
@end
@interface LEView : UIView
@property (nonatomic, readonly) int leContainerW;
@property (nonatomic, readonly) int leContainerH;
@property (nonatomic, readonly) int leSubContainerH;
@property (nonatomic, readonly) UIView *leViewContainer;
@property (nonatomic, readonly) UIView *leSubViewContainer;
@property (nonatomic, readonly) UISwipeGestureRecognizer *leRecognizerRight;
@property (nonatomic, weak, readonly) LEViewController *leViewController;
-(id) initWithViewController:(LEViewController *) vc;
-(void) leSwipGestureLogic;
-(void) leOnSetRightSwipGesture:(BOOL) gesture; 
@end

@protocol LENavigationDelegate <NSObject>
@optional
-(void) leNavigationRightButtonTapped;
-(void) leNavigationNotifyTitleViewContainerWidth:(int) width;
-(void) leNavigationLeftButtonTapped;
@end
@interface LENavigation : UIView{
    UILabel *leNavigationTitle;
    UIButton *leBackButton;
    UIButton *leRightButton;
}
@property (nonatomic) UIView *leTitleViewContainer;
-(__kindof LENavigation *(^)(LEView *)) leSuperView;
-(__kindof LENavigation *(^)(id<LENavigationDelegate>)) leDelegate;
-(__kindof LENavigation *(^)(CGFloat))      leOffset;
-(__kindof LENavigation *(^)(UIImage *))    leBGImage;
-(__kindof LENavigation *(^)(NSString *))   leTitle;
-(__kindof LENavigation *(^)(UIColor *))    leTitleColor;
-(__kindof LENavigation *(^)(BOOL enable, UIColor *color))         leSplit; 
-(__kindof LENavigation *(^)(UIImage *))    leLeftItemImg;
-(__kindof LENavigation *(^)(NSString *))   leLeftItemText;
-(__kindof LENavigation *(^)(UIColor *))    leLeftItemColor;
-(__kindof LENavigation *(^)(UIImage *))    leRightItemImg;
-(__kindof LENavigation *(^)(NSString *))   leRightItemText;
-(__kindof LENavigation *(^)(UIColor *))   leRightItemColor;

-(id) initWithSuperViewAsDelegate:(LEView *)superview Title:(NSString *) title;
-(id) initWithDelegate:(id<LENavigationDelegate>)delegate SuperView:(LEView *)superview Title:(NSString *) title;
-(id) initWithDelegate:(id<LENavigationDelegate>) delegate ViewController:(UIViewController *) viewController SuperView:(UIView *) superview Offset:(int) offset BackgroundImage:(UIImage *) background TitleColor:(UIColor *) color LeftItemImage:(UIImage *) left;
-(void) leSetNavigationTitle:(NSString *) title;
-(void) leEnableBottomSplit:(BOOL) enable Color:(UIColor *) color;
-(void) leSetBackground:(UIImage *) image;
-(void) leSetLeftNavigationItemWith:(NSString *)title Image:(UIImage *)image Color:(UIColor *) color;
-(void) leSetRightNavigationItemWith:(NSString *) title Image:(UIImage *) image;
-(void) leSetRightNavigationItemWith:(NSString *) title Image:(UIImage *) image Color:(UIColor *) color;
-(void) leSetNavigationOffset:(int) offset;
@end

