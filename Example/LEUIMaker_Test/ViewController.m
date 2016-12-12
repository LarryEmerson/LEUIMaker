//
//  ViewController.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/10/31.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "ViewController.h"
#import <LEUIMaker/LEUIMaker.h>

@interface TestCellOptimized : LETableViewCellOptimized
@end
@implementation TestCellOptimized{
    UILabel *label;
    UILabel *label2;
}
-(void) leExtraInits{
    [super leExtraInits];
    label=[UILabel new].leAddTo(self).leAnchor(LEInsideTopLeft).leLeft(LESideSpace).leTop(LESideSpace).leMaxWidth(LESCREEN_WIDTH-LESideSpace*2).leBgColor(LEColorMask2).leLine(1);
    label2=[UILabel new].leAddTo(self).leAnchor(LEOutsideBottomLeft).leRelativeTo(label).leTop(LESideSpace).leMaxWidth(LESCREEN_WIDTH-LESideSpace*2).leLine(0).leColor(LEColorRed).leBgColor(LEColorMask5).leBottom(LESideSpace).leLineSpace(10);
}
-(void) leSetData:(id)data{
    [super leSetData:data];
    label.leText(data);
    label2.leText(data);
}
-(void) leOnIndexSet{
    self.leBgColor(self.leIndexPath.row%2==0?LEColorMask2:LEColorMask5);
}
@end
@interface TestCell : LETableViewCell
@end
@implementation TestCell{
    UILabel *label;
    UILabel *subLabel;
}
-(void) leExtraInits{ 
    [super leExtraInits];
    self.leArrowEnabled(YES);
    label=[UILabel new].leAddTo(self).leAnchor(LEInsideTopLeft).leLeft(LESideSpace).leTop(LESideSpace).leMaxWidth(self.leArrow.frame.origin.x-LESideSpace ).leLine(0).leLineSpace(10).leColor(LEColorRed).leFont(LEBoldFont(LEFontML));
    subLabel=[UILabel new].leAddTo(self).leAnchor(LEOutsideBottomLeft).leRelativeTo(label).leTop(LESideSpace).leMaxWidth(self.leArrow.frame.origin.x-LESideSpace ).leLine(0).leBottom(LESideSpace).leColor(LEColorText9).leLineSpace(10).leFont(LEFont(LEFontML));
    self.leBottomView(subLabel);
}
-(void) leSetData:(id)data  {
    label.leText([NSString stringWithFormat:@"%zd-%@",self.leIndexPath.row+1,[data objectForKey:@"classname"]?:@""]);
    subLabel.leText([data objectForKey:@"text"]);
} 
@end

@interface TestEmptyCell : LEEmptyTableViewCell
@end
@implementation TestEmptyCell{
    UILabel *label;
    UILabel *label2;
}
-(void) leExtraInits{
    [super leExtraInits];
    UIView *view=[UIView new].leAddTo(self).leWidth(LESCREEN_WIDTH).leHeight(LESCREEN_HEIGHT-LEStatusBarHeight-LENavigationBarHeight).leEnableTouch(NO);
    label=[UILabel new].leAddTo(self).leAnchor(LEInsideTopCenter).leTop(LESideSpace).leFont(LEBoldFont(LEFontLL)).leMaxWidth(LESCREEN_WIDTH-LESideSpace*2).leColor(LEColorRed).leAlignment(NSTextAlignmentCenter).leText(@"空列表展示");
    label2=[UILabel new].leAddTo(self).leAnchor(LEOutsideBottomCenter).leRelativeTo(label).leTop(LESideSpace).leBottom(LESideSpace).leMaxWidth(LESCREEN_WIDTH-LESideSpace*2).leLine(0).leAlignment(NSTextAlignmentCenter).leLineSpace(10).leText(@"这段文字本身也是一个Cell，用于展示空列表的处理。\n点击或下拉后，继续");
    self.leBottomView(view);
}
@end


@interface ViewControllerPage : LEView<LENavigationDelegate,LETableViewDataSource,LETableViewDelegate>
@end
@implementation ViewControllerPage{
    LENavigation *navigationView;
    BOOL isLeft,isRight;
    int naviClick;
    LETableViewWithRefresh *curList;
    
    NSArray *navigationTitles;
    NSArray *demoClassnames;
    
}
 
/** 初始化内容位置 */
- (void)leExtraInits {
    navigationTitles=@[@"点我",@"点我-测试",@"点我-测试导航栏",@"点我-测试导航栏标题文字",@"点我-测试导航栏标题文字的宽度",@"点我-测试导航栏标题文字的宽度变动"];
    demoClassnames=@[
                     @{@"classname":@"TestLayoutFramework", @"text":@"测试布局的使用，包括：参照布局示意图、可自动根据label进行拉伸的容器、view的移动和缩放操作、栈的使用、ScrollView的contentsize的自动计算"},
                     @{@"classname":@"TestCollectionView", @"text":@"测试Collection封装模块的使用"},
                     @{@"classname":@"TestBottomTabbar", @"text":@"测试BottomTabbar封装模块的使用"},
                     @{@"classname":@"TestSegment", @"text":@"测试Segment封装模块的使用"},
                     @{@"classname":@"TestMultiSectionTableView", @"text":@"测试多个分组的列表的使用"},
                     @{@"classname":@"TestEmoji", @"text":@"新项目需求，添加表情输入模块"},
                     ];
    navigationView=[LENavigation new].leSuperView(self).leDelegate(self).leRightItemText(@"右按钮");
    navigationView.leTitleViewContainer .leTouchEvent(@selector(onTestNavigation) ,self);
    [self onTestNavigation];
    curList=[LETableViewWithRefresh new].leSuperView(self.leSubViewContainer).leDelegate(self).leDataSource(self).leCellClassname(@"TestCell").leEmptyCellClassname(@"TestEmptyCell").leTouchEnabled(YES);
    [curList leOnRefreshedWithData:[@[] mutableCopy]]; 
}
-(void) onTestNavigation{
    naviClick%=navigationTitles.count;
    [navigationView leSetNavigationTitle:[navigationTitles objectAtIndex:naviClick]];
    naviClick++;
}
-(void) leNavigationLeftButtonTapped{
    isRight=!isRight;
    navigationView.leRightItemText(isRight?nil: @"右按钮");
}
-(void) leNavigationRightButtonTapped{ 
    isLeft=!isLeft;
    navigationView.leLeftItemText(isLeft?@"左按钮":nil).leLeftItemImg(isLeft?[LEColorRed leImageWithSize:CGSizeMake(30, 30)]:nil);
}
-(void) leNavigationNotifyTitleViewContainerWidth:(int)width{
    LELogInt(width);
}
-(void) leOnRefreshData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [curList leOnRefreshedWithData:[demoClassnames mutableCopy]];
    });
}
-(void) leOnLoadMore{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *muta=[NSMutableArray new];
        for (NSInteger i=0; i<rand()%500; i++) {
            [muta addObject:@{@"text":@"测试加载更多"}];
        }
        [curList leOnLoadedMoreWithData:muta];
    });
}
-(void) leOnCellEventWithInfo:(NSDictionary *)info{
    LELogObject(info)
    if([[info objectForKey:LEKeyInfo] isEqualToString:LEEmptyCellTouchEvent]){
        [self leOnRefreshData];
    }else{
        NSIndexPath *index=[info objectForKey:LEKeyIndex];
        if(index.row<demoClassnames.count){
            NSString *classname=[[demoClassnames objectAtIndex:index.row] objectForKey:@"classname"];
            if(classname){
                [self.leViewController lePush:[[classname leGetInstanceFromClassName] init]];
            }
        }
    }
}

@end

@implementation ViewController @end

