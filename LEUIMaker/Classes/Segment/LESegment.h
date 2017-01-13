//
//  LESegment.h
//  Pods
//
//  Created by emerson larry on 2016/12/3.
//
//

#import "LEViewAdditions.h"
#import "LEUICommon.h"

@protocol LESegmentDelegate <NSObject>
@optional
/** 回调当前选中的界面 */
-(void) leOnSegmentSelectedWithIndex:(NSInteger) index;
@end

@interface LESegment : UIView<UIScrollViewDelegate>
/** 初始化：superView、titles、pages(类名字符串)*/
-(__kindof LESegment *(^)(UIView *superView, NSArray *titles, NSArray *pages)) leSuperview;
/** 设定回调 */
-(__kindof LESegment *(^)(id<LESegmentDelegate>)) leDelegate;
/** 设定是否等宽 */
-(__kindof LESegment *(^)(BOOL)) leEqualWidth;
/** 设定文字正常颜色 */
-(__kindof LESegment *(^)(UIColor *)) leNormalColor;
/** 设定文字高亮颜色 */
-(__kindof LESegment *(^)(UIColor *)) leHighlightedColor;
/** 设定标签间隔 */
-(__kindof LESegment *(^)(float)) leMargin;
/** 设定指示图片 */
-(__kindof LESegment *(^)(UIImage *)) leIndicator;
/** 重新设定标题 */
-(__kindof LESegment *(^)(NSArray *)) leTitles;
/** 设定指示图片的偏移 */
-(__kindof LESegment *(^)(float)) leOffset;
/** 设定bar的高度 */
-(__kindof LESegment *(^)(float)) leBarHeight;
/** 重新设定界面的类名称 */
-(__kindof LESegment *(^)(NSArray *)) lePages;
-(NSArray *) leTitleCache;
@end
