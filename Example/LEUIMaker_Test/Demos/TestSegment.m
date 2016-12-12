//
//  TestSegment.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/12/5.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "TestSegment.h"

@interface SegmentPage : UIView
@end
@implementation SegmentPage{
    UILabel *label;
}
-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self leExtraInits];
    return self;
}
-(void) leExtraInits{
    self.leBgColor(LERandomColor);
    label=[UILabel new].leAddTo(self).leAnchor(LEInsideCenter).leAlignment(NSTextAlignmentCenter).leColor(LEColorWhite).leText(NSStringFromClass(self.class));
}
@end
@interface TestSegmentPage:LEView<LESegmentDelegate>
@end
@implementation TestSegmentPage{

}
-(void) leExtraInits{
    [LENavigation new].leSuperView(self).leTitle(NSStringFromClass(self.class));
    NSArray *titles=@[
                      @"测",
                      @"测试",
                      @"测试页",
                      @"测试页面",
                      @"测试页面标",
                      @"测试页面标题",
                      ];
    NSArray *pages=@[
                     @"SegmentPage",
                     @"SegmentPage",
                     @"SegmentPage",
                     @"SegmentPage",
                     @"SegmentPage",
                     @"SegmentPage",
                     ];
    [LESegment new].leInit(self.leSubViewContainer,titles,pages).leDelegate(self).leEqualWidth(YES).leMargin(20).leIndicator([LEColorRed leImageWithSize:CGSizeMake(10, 4)]).leOffset(2);
}
-(void) leOnSegmentSelectedWithIndex:(NSInteger) index{
    LELogInt(index)
}
@end
@implementation TestSegment @end
