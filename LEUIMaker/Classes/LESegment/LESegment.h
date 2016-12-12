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
-(void) leOnSegmentSelectedWithIndex:(NSInteger) index;
@end

@interface LESegment : UIView<UIScrollViewDelegate>

-(__kindof LESegment *(^)(UIView *superView, NSArray *titles, NSArray *pages)) leInit;
-(__kindof LESegment *(^)(id<LESegmentDelegate>)) leDelegate;
-(__kindof LESegment *(^)(BOOL)) leEqualWidth;
-(__kindof LESegment *(^)(UIColor *)) leNormalColor;
-(__kindof LESegment *(^)(UIColor *)) leHighlightedColor;
-(__kindof LESegment *(^)(float)) leMargin;
-(__kindof LESegment *(^)(UIImage *)) leIndicator;
-(__kindof LESegment *(^)(NSArray *)) leTitles;
-(__kindof LESegment *(^)(float)) leOffset;
-(__kindof LESegment *(^)(float)) leBarHeight;
-(__kindof LESegment *(^)(NSArray *)) lePages;
-(NSArray *) leTitleCache;
@end
