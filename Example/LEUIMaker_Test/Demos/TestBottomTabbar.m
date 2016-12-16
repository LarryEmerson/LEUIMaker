//
//  TestBottomTabbar.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/12/5.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "TestBottomTabbar.h"
#import "LEHUD.h"

@interface TabbarPage : LEBottomTabbarPage
@end
@implementation TabbarPage{
    UILabel *label;
}
-(void) leExtraInits{
    self.leBgColor(LERandomColor);
    label=[UILabel new].leAddTo(self).leAnchor(LEInsideCenter).leAlignment(NSTextAlignmentCenter).leColor(LEColorWhite).leText(NSStringFromClass(self.class));
}
@end

@interface TabbarPageA : TabbarPage @end
@implementation TabbarPageA @end

@interface TabbarPageB : TabbarPage @end
@implementation TabbarPageB @end

@interface TabbarPageC : TabbarPage @end
@implementation TabbarPageC @end

@interface TabbarPageD : TabbarPage @end
@implementation TabbarPageD @end

@interface TestBottomTabbarPage : LEView<LEBottomTabbarDelegate>
@end
@implementation TestBottomTabbarPage{
    LEBottomTabbar *tabbar;
}
-(void) leExtraInits{
    [LENavigation new].leSuperView(self).leTitle(NSStringFromClass(self.class));
    NSArray *normalIcons=@[
                          [LEColorBlue leImageWithSize:LESquareSize(20)],
                          [LEColorBlue leImageWithSize:LESquareSize(20)],
                          [LEColorBlue leImageWithSize:LESquareSize(20)],
                          [LEColorBlue leImageWithSize:LESquareSize(20)],
                          ];
    NSArray *highlightedIcons=@[
                          [LEColorRed leImageWithSize:LESquareSize(20)],
                          [LEColorRed leImageWithSize:LESquareSize(20)],
                          [LEColorRed leImageWithSize:LESquareSize(20)],
                          [LEColorRed leImageWithSize:LESquareSize(20)],
                          ];
    NSArray *titles=@[
                      @"测试页面A",
                      @"测试页面B",
                      @"测试页面C",
                      @"测试页面D",
                      ];
    NSArray *pages=@[
                      @"TabbarPageA",
                      @"TabbarPageB",
                      @"TabbarPageC",
                      @"TabbarPageD",
                      ];
    tabbar=[LEBottomTabbar new]
    .leDelegate(self)
    .leNormalIccons(normalIcons)
    .leHighlightedIcons(highlightedIcons)
    .leTitles(titles)
    .lePages(pages)
    .leNormalColor(LEColorBlue)
    .leHighlightedColor(LEColorRed)
    .leSuperView(self.leSubViewContainer);
    [tabbar leDidChoosedPageWith:0];
}
-(void) leTabbarDidTappedWith:(int) index{
    LELogInt(index)
    [LEHUD leShowHud:[NSString stringWithFormat:@"leTabbarDidTappedWith:%d",index]];
}
-(BOOL) leWillShowPageWithIndex:(int) index{
    return YES;
}
@end

@implementation TestBottomTabbar
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
