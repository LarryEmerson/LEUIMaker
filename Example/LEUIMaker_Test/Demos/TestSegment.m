//
//  TestSegment.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/12/5.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "TestSegment.h"
#import "LEHUD.h"

@interface SegmentPage : UIView
@end
@implementation SegmentPage{
    UILabel *label;
}
-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self leAdditionalInits];
    return self;
}
-(void) leAdditionalInits{
    self.leBgColor(LERandomColor);
    label=[UILabel new].leAddTo(self).leAnchor(LEInsideCenter).leAlignment(NSTextAlignmentCenter).leColor(LEColorWhite).leText(NSStringFromClass(self.class));
}
@end
@interface TestSegmentPage:LEView<LESegmentDelegate>
@end
@implementation TestSegmentPage{

}
-(void) leAdditionalInits{
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
    [LESegment new].leSuperview(self.leSubViewContainer,titles,pages).leDelegate(self).leEqualWidth(NO).leMargin(20).leIndicator([LEColorRed leImageWithSize:CGSizeMake(10, 4)]).leOffset(2);
}
-(void) leOnSegmentSelectedWithIndex:(NSInteger) index{
    LELogInteger(index)
    [LEHUD leShowHud:[NSString stringWithFormat:@"leOnSegmentSelectedWithIndex:%zd",index]];
}
@end
@implementation TestSegment
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self leDidRotateFrom:fromInterfaceOrientation];
}
@end
