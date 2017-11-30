//
//  LELineChart.h
//  campuslife
//
//  Created by emerson larry on 16/6/30.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//
 
#import "LEUIMaker.h"
/* 数据源格式
 @[
    @{
        @"value":@"0.1",
        @"label":@"Mon",
    }
 ]
 */
#define KeyValue @"value"
#define KeyLabel @"label"
typedef void(^LineChartBlock)(id data);

/** Tooltip 设置 */
@interface TooltipSettings:NSObject
/** Tooltip 背景色 */
@property (nonatomic) UIColor *bgColor;
/** Tooltip 文字颜色 */
@property (nonatomic) UIColor *textColor;
/** Tooltip 文字字号 */
@property (nonatomic) int fontSize;
/** Tooltip 偏移量 */
@property (nonatomic) int offset;
/** Tooltip size， 如果为CGSizeZero 则Tooltip的大小会自动计算，否则为设定的大小 */
@property (nonatomic) CGSize size;
/** Tooltip 文字四周的边间距 */
@property (nonatomic) UIEdgeInsets margins;
/** Tooltip 圆角 */
@property (nonatomic) int radius;
@end
/** Chart 设置 */
@interface ChartSettings:NSObject
/** Tooltip 设置 */
@property (nonatomic) TooltipSettings *tooltipSettings;
/** Chart 四边距设置：left为左侧Y轴的宽度，top为顶部间距，right为右侧间距，bottom为底部X轴高度 */
@property (nonatomic) UIEdgeInsets scrollviewMargins;
/** Chart 曲线宽度 */
@property (nonatomic) float lineWidth;
/** Chart 曲线颜色 */
@property (nonatomic) UIColor *lineColor;
/** Chart 曲线节点外描边宽度 */
@property (nonatomic) float dotOutlineWidth;
/** Chart 曲线节点外描边颜色 */
@property (nonatomic) UIColor *dotOutlineColor;
/** Chart 曲线节点半径 */
@property (nonatomic) float dotRadius;
/** Chart 曲线节点颜色 */
@property (nonatomic) UIColor *dotColor;
/** Chart 曲线平滑度0~1 */
@property (nonatomic) float smooth;
/** Chart 行数：0-自动根据数据源计算行数，N-手动设定行数 */
@property (nonatomic) NSInteger rows;
/** Chart 曲线背景格子宽度 */
@property (nonatomic) float gridWidth;
/** Chart 曲线格子背景颜色 */
@property (nonatomic) UIColor *gridBGColor;
/** Chart 曲线格子线条颜色 */
@property (nonatomic) UIColor *gridColor;
/** Chart 曲线格子线条宽度 */
@property (nonatomic) float gridLineWidth;
/** Chart 无数据的提示文字 */
@property (nonatomic) NSString *noDataText;
/** Chart X轴线条颜色 */
@property (nonatomic) UIColor *tickLineColorX;
/** Chart X轴线条文字颜色 */
@property (nonatomic) UIColor *tickLineTextColorX;
/** Chart X轴文字偏移量 */
@property (nonatomic) float tickLineOffsetX;
/** Chart X轴文字字号 */
@property (nonatomic) float tickLineFontsizeX;
/** Chart X轴线条宽度 */
@property (nonatomic) float tickLineWidthX;
/** Chart Y轴线条颜色 */
@property (nonatomic) UIColor *tickLineColorY;
/** Chart Y轴文字颜色 */
@property (nonatomic) UIColor *tickLineTextColorY;
/** Chart Y轴文字偏移量 */
@property (nonatomic) float tickLineOffsetY;
/** Chart Y轴文字字号 */
@property (nonatomic) float tickLineFontsizeY;
/** Chart Y轴线条宽度 */
@property (nonatomic) float tickLineWidthY;
/** Chart Y轴文字浮点数小数位 */
@property (nonatomic) int yAxisPrecision;
/** Chart X轴自定义类名 */
@property (nonatomic) NSString *xAxisClassname;
/** Chart Y轴自定义类名 */
@property (nonatomic) NSString *yAxisClassname;
@end
/** Chart X轴类名 */
@interface ChartXaxisView:UIView
@property (nonatomic) UILabel *label; 
-(void) leSetData:(id) data; 
@end
/** Chart Y轴类名 */
@interface ChartYaxisView:UIView
@property (nonatomic) UILabel *label;
/** Chart Y轴：min-最小值，max-最大值，index-当前行，rows-总行数，precision-浮点数小数位数 */
-(void) leSetMin:(float) min Max:(float) max Index:(NSInteger) index Rows:(NSInteger) rows Precision:(int) precision;
@end
/** Chart 类名 */
@interface LELineChart : UIView
@property (nonatomic) LineChartBlock block;
@property (nonatomic) ChartSettings *chartSettings;
/** 自定义chartSettings后，调用leConfigChart完成配置 */
-(void) leConfigChart;
/** 设置数据源，min=max=0表示自动根据数据源计算而来 */
-(void) leSetDataSource:(NSArray *) datasource Min:(float) min Max:(float) max;
@end
