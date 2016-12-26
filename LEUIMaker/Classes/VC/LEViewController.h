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
/** ViewController回调 */
-(void) leOnViewControllerPopedWithPageName:(NSString *) order AndData:(id) data;
@end
/**
 * 如果LEViewController的子类（XXX）对应的view为LEView的子类，并且LEView的子类类名定义为“XXXPage"，则”XXXPage“类会被主动创建。如果需要重新定义子类的init方法，则需要复写XXX的方法：-(void) leExtraInits{}，这样可以避免XXX自动创建“XXXPage”。
 */
@interface LEViewController : UIViewController
/** 回调引用：用于处理vc跳转的消息传递 */
@property (nonatomic, readonly) id<LEViewControllerPopDelegate> lePopDelegate;
-(void) viewWillAppear:(BOOL)animated NS_REQUIRES_SUPER;
-(void) viewWillDisappear:(BOOL)animated NS_REQUIRES_SUPER;
-(id) initWithDelegate:(id<LEViewControllerPopDelegate>) delegate;
/** 用于屏幕旋转时的处理 */
- (void)leDidRotateFrom:(UIInterfaceOrientation)from;
@end
@interface LEView : UIView
/** 容器的宽度 */
@property (nonatomic, readonly) int leContainerW;
/** 容器的高度 */
@property (nonatomic, readonly) int leContainerH;
/** 子容器的高度（不包含状态栏及导航栏） */
@property (nonatomic, readonly) int leSubContainerH;
/** 全屏容器 */
@property (nonatomic, readonly) UIView *leViewContainer;
/** 子容器（不包含状态栏及导航栏部分） */
@property (nonatomic, readonly) UIView *leSubViewContainer;
/** 当前右划的gesture */
@property (nonatomic, readonly) UISwipeGestureRecognizer *leRecognizerRight;
/** 当前附属的vc的引用 */
@property (nonatomic, weak, readonly) LEViewController *leViewController;
/** 初始化：vc */
-(__kindof LEView *(^)(LEViewController *vc)) leInit;
-(id) initWithViewController:(LEViewController *) vc;
/** 可重写右划后逻辑（默认pop当前vc） */
-(void) leSwipGestureLogic;
/** 设定右划逻辑的开关 */
-(void) leOnSetRightSwipGesture:(BOOL) gesture; 
@end

@protocol LENavigationDelegate <NSObject>
@optional
/** 右侧按钮回调 */
-(void) leNavigationRightButtonTapped;
/** 标题容器宽度变动通知 */
-(void) leNavigationNotifyTitleViewContainerWidth:(int) width;
/** 左侧按钮回调 */
-(void) leNavigationLeftButtonTapped;
@end
@interface LENavigation : UIView{
    UILabel *leNavigationTitle;
    UIButton *leBackButton;
    UIButton *leRightButton;
}
/** 获取自动变动宽度的标题容器 */
@property (nonatomic) UIView *leTitleViewContainer;
/** 设定superview */
-(__kindof LENavigation *(^)(LEView *)) leSuperView;
/** 设定delegate */
-(__kindof LENavigation *(^)(id<LENavigationDelegate>)) leDelegate;
/** 设定状态栏偏移量 */
-(__kindof LENavigation *(^)(CGFloat))      leOffset;
/** 设定导航栏背景图 */
-(__kindof LENavigation *(^)(UIImage *))    leBGImage;
/** 设定标题 */
-(__kindof LENavigation *(^)(NSString *))   leTitle;
/** 设定不同颜色 */
-(__kindof LENavigation *(^)(UIColor *))    leTitleColor;
/** 设定分割线：enable、color */
-(__kindof LENavigation *(^)(BOOL enable, UIColor *color))         leSplit;
/** 设定左侧按钮图片 */
-(__kindof LENavigation *(^)(UIImage *))    leLeftItemImg;
/** 设定左侧按钮文字 */
-(__kindof LENavigation *(^)(NSString *))   leLeftItemText;
/** 设定左侧按钮文字颜色 */
-(__kindof LENavigation *(^)(UIColor *))    leLeftItemColor;
/** 设定右侧按钮图片 */
-(__kindof LENavigation *(^)(UIImage *))    leRightItemImg;
/** 设定右侧按钮文字 */
-(__kindof LENavigation *(^)(NSString *))   leRightItemText;
/** 设定右侧按钮文字颜色 */
-(__kindof LENavigation *(^)(UIColor *))   leRightItemColor;
#pragma mark 以下是旧的接口
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

