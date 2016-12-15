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
-(void) leTabbarDidTappedWith:(int) index;
-(BOOL) leWillShowPageWithIndex:(int) index;
@end

@interface LEBottomTabbarPage : UIView
-(void) leEaseInView;
-(void) leEaseOutView;
-(void) leEaseInViewLogic;
-(void) leEaseOutViewLogic;
-(void) leNotifyPageSelected;
@end

@interface LEBottomTabbar : UIImageView
-(__kindof LEBottomTabbar *(^)(id<LEBottomTabbarDelegate>)) leDelegate;
-(__kindof LEBottomTabbar *(^)(NSArray *)) leNormalIccons;
-(__kindof LEBottomTabbar *(^)(NSArray *)) leHighlightedIcons;
-(__kindof LEBottomTabbar *(^)(NSArray *)) leTitles;
-(__kindof LEBottomTabbar *(^)(NSArray *)) lePages;
-(__kindof LEBottomTabbar *(^)(UIColor *)) leNormalColor;
-(__kindof LEBottomTabbar *(^)(UIColor *)) leHighlightedColor;
-(__kindof LEBottomTabbar *(^)(UIView *)) leSuperView;

-(void) leDidChoosedPageWith:(int) index;
-(NSArray *) getTabbars;
@end
