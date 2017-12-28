//
//  TestLineChart.m
//  LEUIMaker_Test
//
//  Created by emerson larry on 2017/11/27.
//  Copyright © 2017年 LarryEmerson. All rights reserved.
//

#import "TestLineChart.h"
#define ColorPurple [UIColor colorWithRed:0.333 green:0.173 blue:0.624 alpha:1.000]
#define LEColorGray [UIColor colorWithRed:0.6384 green:0.6588 blue:0.7095 alpha:1.0]
#define LEColorGrayLight [UIColor colorWithRed:0.9264 green:0.9263 blue:0.9263 alpha:1.0]
@interface TestLineChart()
@end
@implementation TestLineChart{
    NSArray *dataSource;
    LELineChart *line;
    UILabel *label;
    NSMutableArray *curData;
    NSDateFormatter *formatter;
}
-(void) leAdditionalInits{
    formatter=[NSDateFormatter new];
    [formatter setDateFormat:@"MM-dd"];
    dataSource=@[
                 @{@"label":@"10-01",@"value":@"10",},
                 @{@"label":@"10-02",@"value":@"54",},
                 @{@"label":@"10-03",@"value":@"20",},
                 @{@"label":@"10-04",@"value":@"91",},
                 @{@"label":@"10-05",@"value":@"14",},
                 @{@"label":@"10-06",@"value":@"30",},
                 @{@"label":@"10-07",@"value":@"11",},
                 @{@"label":@"10-08",@"value":@"15",},
                 @{@"label":@"10-09",@"value":@"5",},
                 @{@"label":@"10-10",@"value":@"6",},
                 @{@"label":@"10-11",@"value":@"2",},
                 @{@"label":@"10-12",@"value":@"66",},
                 ];
    [[LEUICommon sharedInstance] leSetViewBGColor:LEColorBG9];
    LEView *view=[LEView new].leSuperViewcontroller(self);
    [view leOnSetRightSwipGesture:NO];
    [LENavigation new].leSuperView(view).leTitle(@"TestLineChart");

    line=[LELineChart new].leAddTo(view.leSubViewContainer).leSize(CGSizeMake(LESCREEN_WIDTH, LESCREEN_WIDTH/1.5)).leBgColor(LEColorBG5);
    line.block = ^(id data) {
      LELogObject(data)
        label.leText([NSString stringWithFormat:@"%@",data]);
    };
    line.chartSettings.scrollviewMargins=UIEdgeInsetsMake(10, 50, 50, 0);
    line.chartSettings.tooltipSettings.offset=4;
    line.chartSettings.gridWidth=61;
    line.chartSettings.gridBGColor=LEColorWhite;
    line.chartSettings.smooth=0.6;
    line.chartSettings.yAxisPrecision=0;
    line.chartSettings.rows=10;
    line.chartSettings.rows=0;
    line.chartSettings.tooltipSettings.margins=UIEdgeInsetsMake(4, 8, 4, 8);
//    line.chartSettings.tooltipSettings.size=CGSizeMake(40, 20);
//    [line leConfigChart];
//    [line leSetDataSource:dataSource Min:0 Max:100];
    
    UIView *settings=[UIView new].leAddTo(view.leSubViewContainer).leRelativeTo(line).leAnchor(LEO_BC).leWrapper();
    [UIButton new].leAddTo(settings).leAnchor(LEI_TL).leBtnBGImgN([LEColorBlue leImage]).leBtnBGImgH([LEColorMask5 leImage]).leTouchEvent(@selector(onTap2),self).leText(@"随机设置配置");
    label=[UILabel new].leAddTo(view.leSubViewContainer).leRelativeTo(settings).leAnchor(LEO_BC).leTop(10).leMaxWidth(LESCREEN_WIDTH-10).leLine(0);
    [self onTap2];
}
-(void) onTap2{
    LELineChart *lineChart=line;
    lineChart.chartSettings.rows=10;
    lineChart.chartSettings.smooth=0;
    lineChart.chartSettings.lineWidth=2;
    lineChart.chartSettings.lineColor=ColorPurple;
    lineChart.chartSettings.dotOutlineWidth=1;
    lineChart.chartSettings.dotOutlineColor=LEColorWhite;
    lineChart.chartSettings.dotRadius=5;
    lineChart.chartSettings.dotColor=ColorPurple;
    lineChart.chartSettings.tooltipSettings.bgColor=ColorPurple;//LEColorClear;
    lineChart.chartSettings.tooltipSettings.textColor=LEColorWhite;//ColorPurple;
    lineChart.chartSettings.tooltipSettings.offset=10;
    lineChart.chartSettings.gridWidth=80;
    //    lineChart.chartSettings.gridBGColor=LEColorWhite;
    lineChart.chartSettings.gridColor=LEColorGrayLight;
    lineChart.chartSettings.gridLineWidth=1;
    lineChart.chartSettings.tickLineColorX=LEColorGray;
    lineChart.chartSettings.tickLineTextColorX=LEColorGray;
    //    lineChart.chartSettings.tickLineFontsizeX=14;
    lineChart.chartSettings.tickLineWidthX=1;
    lineChart.chartSettings.tickLineColorY=LEColorGray;
    lineChart.chartSettings.tickLineTextColorY=LEColorGray;
    //    lineChart.chartSettings.tickLineFontsizeY=14;
    lineChart.chartSettings.tickLineWidthY=1;
    lineChart.chartSettings.noDataText=@"无内容无内容无内容无内容无内容";
    lineChart.chartSettings.noDataTextWidth=80;
    lineChart.chartSettings.noDataTextFontsize=18;
    lineChart.chartSettings.noDataTextColor=LEColorTest;
    
    
    lineChart.chartSettings.scrollviewMargins=UIEdgeInsetsMake(30, 60, 60, 10);
    [lineChart leConfigChart];
    
    NSMutableArray *muta=[NSMutableArray new];
    for (NSInteger i=0; i<rand()%dataSource.count; i++) {
        [muta addObject:[dataSource objectAtIndex:i]];
    }
    [line leSetDataSource:muta Min:0 Max: 100];
}
-(float) getSegment:(float) max {
    max = max / 10;
    int number;
    float level;
    if (max > 1) {
        number = 1;
        level = 1;
        while (max / (number * level) > 1) {
            number++;
            if (number >= 10) {
                number = 1;
                level *= 10;
            }
        }
    } else {
        number = 1;
        level = 1;
        int newnumber = 1;
        float newlevel = 1;
        while (max / (newnumber * newlevel) <= 1) {
            number = newnumber;
            level = newlevel;
            newnumber--;
            if (newnumber <= 0) {
                newnumber = 9;
                newlevel /= 10;
            }
        }
    }
    LELog(@"getSegment %f %f %d %f",max,number * level,number,level)
    return number * level*10;
}
-(void) onTap{
    line.chartSettings.tooltipSettings.bgColor=LERandomColor;
    line.chartSettings.tooltipSettings.textColor=LERandomColor;
    line.chartSettings.tooltipSettings.fontSize=8+rand()%6;
    line.chartSettings.tooltipSettings.offset=4+rand()%10;
    line.chartSettings.tooltipSettings.size=rand()%2==0?CGSizeZero:CGSizeMake(20+rand()%20, 20+rand()%10);
    float x=3+rand()%6;
    float y=3+rand()%6;
    line.chartSettings.tooltipSettings.margins=UIEdgeInsetsMake(x,y,x,y);
    line.chartSettings.tooltipSettings.radius=2+rand()%3*0.5;

    line.chartSettings.scrollviewMargins=UIEdgeInsetsMake(40+rand()%10, 50+rand()%50, 50+rand()%50, 20+rand()%50);
    line.chartSettings.lineWidth=0.5+rand()%10*0.5;
    line.chartSettings.lineColor=LERandomColor;
    line.chartSettings.dotOutlineWidth=0.5+rand()%10*0.5;
    line.chartSettings.dotOutlineColor=LERandomColor;
    line.chartSettings.dotRadius=2+rand()%3*0.5;
    line.chartSettings.dotColor=LERandomColor;
    line.chartSettings.rows=rand()%2==0?10:0;
    line.chartSettings.gridWidth=rand()%2==0?0:100;
    line.chartSettings.gridBGColor=LEColorWhite;
    line.chartSettings.gridColor=LERandomColor;
    line.chartSettings.gridLineWidth=0.5+rand()%2*0.5;
    line.chartSettings.tickLineColorX=LERandomColor;
    line.chartSettings.tickLineTextColorX=LERandomColor;
    line.chartSettings.tickLineOffsetX=rand()%4;
    line.chartSettings.tickLineFontsizeX=10+rand()%6;
    line.chartSettings.tickLineWidthX=0.5+rand()%2*0.5;
    line.chartSettings.tickLineColorY=LERandomColor;
    line.chartSettings.tickLineTextColorY=LERandomColor;
    line.chartSettings.tickLineOffsetY=4+rand()%10;
    line.chartSettings.tickLineFontsizeY=10+rand()%6;
    line.chartSettings.tickLineWidthY=0.5+rand()%2*0.5;
    line.chartSettings.yAxisPrecision=rand()%5;
    line.chartSettings.rows=10;
    [line leConfigChart];
    NSMutableArray *muta=[NSMutableArray new];
    for (NSInteger i=0; i<rand()%dataSource.count; i++) {
        [muta addObject:[dataSource objectAtIndex:i]];
    }
    [line leSetDataSource:muta Min:0 Max: 100];
//    [line leSetDataSource:muta Min:0 Max:rand()%2==(rand()%100)?0:100];
}
-(void) leOnLineChartSelection:(NSUInteger) index{
  LELogInt(index)
}

@end
