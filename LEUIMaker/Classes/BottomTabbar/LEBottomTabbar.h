//
//  LEBottomTabbar.h
//  Pods
//
//  Created by emerson larry on 2016/12/2.
//
//

#import "LEViewAdditions.h"
#import "LEUICommon.h"

@protocol LEBottomTabbarDelegate <NSObject>
/** BottomTabbar点击后回调 */
-(void) leTabbarDidTappedWith:(int) index;
/** BottomTabbar是否允许切换页面 */
-(BOOL) leWillShowPageWithIndex:(int) index;
@end

@interface LEBottomTabbarPage : UIView
-(void) leEaseInView;
-(void) leEaseOutView;
/** BottomTabbar可重写渐入逻辑 */
-(void) leEaseInViewLogic;
/** BottomTabbar可重写渐出逻辑 */
-(void) leEaseOutViewLogic;
/** BottomTabbar通知页面已被切换 */
-(void) leNotifyPageSelected;
@end

@interface LEBottomTabbar : UIImageView
/** 设定回调 */
-(__kindof LEBottomTabbar *(^)(id<LEBottomTabbarDelegate>)) leDelegate;
/** 设定支持图标 */
-(__kindof LEBottomTabbar *(^)(NSArray *)) leNormalIccons;
/** 设定高亮图标 */
-(__kindof LEBottomTabbar *(^)(NSArray *)) leHighlightedIcons;
/** 设定按钮标题 */
-(__kindof LEBottomTabbar *(^)(NSArray *)) leTitles;
/** 设定页面类名 */
-(__kindof LEBottomTabbar *(^)(NSArray *)) lePages;
/** 设定正常文字颜色 */
-(__kindof LEBottomTabbar *(^)(UIColor *)) leNormalColor;
/** 设定高亮文字颜色 */
-(__kindof LEBottomTabbar *(^)(UIColor *)) leHighlightedColor;
/** 初始化最后一步，需要在其他设置完成后调用 */
-(__kindof LEBottomTabbar *(^)(UIView *)) leSuperView;
/** 主动通过index（0->）选择页面 */
-(void) leDidChoosedPageWith:(int) index;
/** 获取tabbar的buttons */
-(NSArray *) getTabbars;
@end
