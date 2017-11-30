//
//  LELineChart.m
//  campuslife
//
//  Created by emerson larry on 16/6/30.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "LELineChart.h"

@implementation ChartXaxisView{
    id curData;
    LineChartBlock curBlock;
}
-(id) init{
    self=[super init];
    [self leAdditionalInits];
    return self;
}
-(void) leAdditionalInits{
    self.leTouchEvent(@selector(onTap),self);
    self.label=[UILabel new].leAddTo(self).leAnchor(LEI_C);
}
-(void) onTap{
    if(curBlock){
        curBlock(curData);
    }
}
-(void) setTextColor:(UIColor *) color Offset:(float) offset FontSize:(int) fontSize Block:(LineChartBlock) block{
    curBlock=block;
    self.label=self.label.leColor(color).leFont(LEFont(fontSize)).leBgColor(LEColorClear).leTop(offset);
}
-(void) leSetData:(id) data {
    curData=data;
    self.label=self.label.leText([curData objectForKey:KeyLabel]);
    [self.label leUpdateLayout];
} 
@end
@implementation ChartYaxisView{
}
-(id) init{
    self=[super init];
    [self leAdditionalInits];
    return self;
}
-(void) leAdditionalInits{
    self.label=[UILabel new].leAddTo(self).leAnchor(LEI_RC);
}
-(void) setTextColor:(UIColor *) color Offset:(float) offset FontSize:(int) fontSize{
    self.label=self.label.leColor(color).leRight(offset).leFont(LEFont(fontSize)).leBgColor(LEColorClear);
}
-(void) leSetMin:(float) min Max:(float) max Index:(NSInteger) index Rows:(NSInteger) rows Precision:(int) precision{
    float value=(rows==0?max:(max-min)*index/rows);
    NSString *format=[NSString stringWithFormat:@"%%.%df",precision]; 
    self.label=self.label.leText(min==max?(index==rows?[NSString stringWithFormat:@"%.0f",max]:@""):[NSString stringWithFormat:format,value]);
    [self.label leUpdateLayout];
}
@end
@interface TooltipSettings()
@property (nonatomic) float chartHeight;
@end
@interface ChartSettings()
@property (nonatomic) float gridHeight;
@end
@implementation TooltipSettings @end
@implementation ChartSettings @end

@interface LELineChartTooltip :UIView
@property (nonatomic) LineChartBlock block;
@end
@implementation LELineChartTooltip{
    TooltipSettings *curSettings;
    UIView *anchor;
    UILabel *label;
    UIButton *touch;
    id curData;
}
-(id) init{
    self=[super init];
    [self leAdditionalInits];
    return self;
}
-(void) leAdditionalInits{
    anchor=[UIView new];
    self.leRelativeTo(anchor).leAnchor(LEO_BC);
    label=[UILabel new].leAddTo(self).leAnchor(LEI_C).leAlignment(NSTextAlignmentCenter).leBgColor(LEColorClear);
    touch=[UIButton new].leAddTo(self).leEqualSuperViewWidth(1).leEqualSuperViewHeight(1).leBtnBGImg([LEColorMask5 leImage],UIControlStateHighlighted).leTouchEvent(@selector(onTap),self);
}
-(void) onTap{
    if(self.block){
        self.block(curData);
    }
}
-(void) setSettings:(TooltipSettings *) settings{
    curSettings=settings;
    self.leBgColor(settings.bgColor).leCorner(settings.radius).leTop(settings.offset);
    label=label.leMargins(settings.margins).leFont(LEFont(settings.fontSize)).leColor(settings.textColor);
    if(CGSizeEqualToSize(settings.size, CGSizeZero)){
        self.leWrapper();
    }else{
        self.leWidth(settings.size.width).leHeight(settings.size.height);
        label=label.leMaxWidth(settings.size.width-settings.margins.left-settings.margins.right).leLine(1);
    }
}
-(void) setText:(NSString *) text Point:(CGPoint) point Start:(BOOL) start End:(BOOL) end Data:(id) data Block:(LineChartBlock) block{
    self.block = block;
    curData=data;
    [anchor setFrame:CGRectMake(point.x, point.y, 0, 0)];
    self.leAnchor(point.y*2>curSettings.chartHeight?(start?LEO_2:(end?LEO_1:LEO_TC)):(start?LEO_4:(end?LEO_3:LEO_BC)))
    .leTop(point.y*2>curSettings.chartHeight?0:curSettings.offset)
    .leBottom(point.y*2>curSettings.chartHeight?curSettings.offset:0)
    .leLeft(start?curSettings.offset:0)
    .leRight(end?curSettings.offset:0);
    label=label.leText(text);
}
@end
@interface LELineChartView :UIView
@property (nonatomic) ChartSettings *chartSettings;
@property (nonatomic) LineChartBlock block;
@end
@implementation LELineChartView{
    BOOL needsDisplay;
    NSArray *pointsArray;
    float maxValue;
    float minValue;
    float chartWidth;
    float chartHeight; 
    NSMutableArray *tooltips;
    NSArray *dataSource;
    UIView *splitline;
    NSMutableArray *verticalLines;
}
-(void) setSettings:(ChartSettings *) settings{
    self.chartSettings=settings;
    if(!splitline){
        splitline=[UIView new].leAddTo(self).leAnchor(LEI_BC).leBottom(0).leEqualSuperViewWidth(1).leHeight(settings.tickLineWidthX).leBgColor(settings.tickLineColorX);
    }else{
        splitline=splitline.leEqualSuperViewWidth(1).leHeight(settings.tickLineWidthX).leBgColor(settings.tickLineColorX);
    }
}
-(void) setPoints:(NSArray *) points DataSource:(NSArray *) ds Min:(float) min Max:(float) max Height:(float) height{
    dataSource=ds;
    pointsArray=points;
    minValue=min;
    maxValue=max;
    chartHeight=height;
    self.leWidth(self.chartSettings.gridWidth*dataSource.count+self.chartSettings.dotRadius*2);
    needsDisplay=YES;
    [self setNeedsDisplay];
    [self drawTooltip];
}
-(void) drawTooltip{
    LEWeakSelf(self);
    NSMutableArray *points=[NSMutableArray arrayWithArray:pointsArray];
    if(pointsArray.count>0){
        [points removeObjectAtIndex:0];
        [points removeLastObject];
    }
    NSInteger max=MAX(points.count, tooltips.count);
    for (NSInteger i=0; i<max; ++i) {
        if(i<points.count){
            NSDictionary *dic=[dataSource objectAtIndex:i];
            LELineChartTooltip *view=nil;
            if(i<tooltips.count){
                view=[tooltips objectAtIndex:i];
                [view setHidden:NO];
            }else{
                view=[LELineChartTooltip new].leAddTo(self);
                [tooltips addObject:view];
            }
            [view setSettings:self.chartSettings.tooltipSettings];
            [view setText:[dic objectForKey:KeyValue] Point:[[points objectAtIndex:i] CGPointValue] Start:i==0 End:i==points.count-1 Data:[dataSource objectAtIndex:i] Block:^(id data) {
                weakself.block(data);
            }];
        }else if(i<max){
            [[tooltips objectAtIndex:i] setHidden:YES];
        }
    }
}

-(id) init{
    self=[super init];
    self.backgroundColor=LEColorClear;
    tooltips=[NSMutableArray new];
    verticalLines=[NSMutableArray new];
    return self;
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if(!needsDisplay){
        return;
    }
    needsDisplay=NO;
    if(pointsArray.count==0)return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    for (int i=0; i<dataSource.count-1; i++) {
        CGPoint p1 = [[pointsArray objectAtIndex:i] CGPointValue];
        CGPoint p2 = [[pointsArray objectAtIndex:i+1] CGPointValue];
        CGPoint p3 = [[pointsArray objectAtIndex:i+2] CGPointValue];
        CGPoint p4 = [[pointsArray objectAtIndex:i+3] CGPointValue];
        if (i == 0) {
            CGContextMoveToPoint(context, p2.x, p2.y);
        }
        CGContextSetLineWidth(context, self.chartSettings.lineWidth);//线的宽度
        CGContextSetStrokeColorWithColor(context, self.chartSettings.lineColor.CGColor);
        [self getControlPointx0:p1.x andy0:p1.y x1:p2.x andy1:p2.y x2:p3.x andy2:p3.y x3:p4.x andy3:p4.y context:context];
    }
    CGContextStrokePath(context);
    for (int i=0; i<dataSource.count; i++) {
        CGPoint point=[[pointsArray objectAtIndex:i+1] CGPointValue];
        if (i == 0) {
            CGContextMoveToPoint(context, point.x, point.y);
        }
        CGContextSetStrokeColorWithColor(context, self.chartSettings.dotOutlineColor.CGColor);
        CGContextSetFillColorWithColor(context, self.chartSettings.dotColor.CGColor);//填充颜色
        CGContextSetLineWidth(context, self.chartSettings.dotOutlineWidth);//线的宽度
        CGContextAddArc(context, point.x, point.y, self.chartSettings.dotRadius, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
    }
    CGContextStrokePath(context);
}
- (void)getControlPointx0:(CGFloat)x0 andy0:(CGFloat)y0
                       x1:(CGFloat)x1 andy1:(CGFloat)y1
                       x2:(CGFloat)x2 andy2:(CGFloat)y2
                       x3:(CGFloat)x3 andy3:(CGFloat)y3
                  context:(CGContextRef) context{
    CGFloat smooth_value =self.chartSettings.smooth;
    CGFloat ctrl1_x;
    CGFloat ctrl1_y;
    CGFloat ctrl2_x;
    CGFloat ctrl2_y;
    CGFloat xc1 = (x0 + x1) /2.0;
    CGFloat yc1 = (y0 + y1) /2.0;
    CGFloat xc2 = (x1 + x2) /2.0;
    CGFloat yc2 = (y1 + y2) /2.0;
    CGFloat xc3 = (x2 + x3) /2.0;
    CGFloat yc3 = (y2 + y3) /2.0;
    CGFloat len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
    CGFloat len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
    CGFloat len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
    CGFloat k1 = len1 / (len1 + len2);
    CGFloat k2 = len2 / (len2 + len3);
    CGFloat xm1 = xc1 + (xc2 - xc1) * k1;
    CGFloat ym1 = yc1 + (yc2 - yc1) * k1;
    CGFloat xm2 = xc2 + (xc3 - xc2) * k2;
    CGFloat ym2 = yc2 + (yc3 - yc2) * k2;
    ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
    ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
    ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
    ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
    CGContextAddCurveToPoint(context, ctrl1_x, ctrl1_y, ctrl2_x, ctrl2_y, x2, y2);
}
@end
@interface GridView : UIView @end
@implementation GridView{
    NSMutableArray *verticalLines;
    NSMutableArray *horizontalLines;
}
-(id) init{
    self=[super init];
    self.backgroundColor=LEColorClear;
    verticalLines=[NSMutableArray new];
    horizontalLines=[NSMutableArray new];
    return self;
}
-(void) setSettings:(ChartSettings *) settings Size:(NSInteger) size{
    NSInteger max=MAX(verticalLines.count, size);
    for (NSInteger i=0; i<max; ++i) {
        if(i<size-1){
            UIView *view=nil;
            if(i<verticalLines.count){
                view=[verticalLines objectAtIndex:i];
                [view setHidden:NO];
            }else{
                view=[UIView new].leAddTo(self).leAnchor(LEI_LC).leLeft((i+1)*settings.gridWidth+settings.dotRadius).leWidth(settings.gridLineWidth).leBgColor(settings.gridColor).leEqualSuperViewHeight(1);
                [verticalLines addObject:view];
            }
            view=view.leLeft((i+1)*settings.gridWidth+settings.dotRadius).leBgColor(settings.gridColor).leWidth(settings.gridLineWidth);
        }else if(i<max){
            if(i<verticalLines.count){
                [[verticalLines objectAtIndex:i] setHidden:YES];
            }
        }
    }
    max=MAX(horizontalLines.count, settings.rows);
    for (NSInteger i=0; i<max; ++i) {
        if(i<settings.rows){
            UIView *view=nil;
            if(i<horizontalLines.count){
                view=[horizontalLines objectAtIndex:i];
                [view setHidden:NO];
            }else{
                view=[UIView new].leAddTo(self).leAnchor(LEI_TC).leTop(i*settings.gridHeight+settings.dotRadius).leHeight(settings.gridLineWidth).leBgColor(settings.gridColor).leEqualSuperViewWidth(1);
                [horizontalLines addObject:view];
            }
            view=view.leTop(i*settings.gridHeight+settings.dotRadius).leBgColor(settings.gridColor).leHeight(settings.gridLineWidth);
        }else if(i<max){
            [[horizontalLines objectAtIndex:i] setHidden:YES];
        }
    }
}
@end

@interface LELineChart () @end
@implementation LELineChart{
    UILabel *noDataLabel;
    NSArray *curDataSource;
    UIScrollView *chartScrollView;
    GridView *gridView;
    LELineChartView *chartView;
    UIView *y_axis;
    UIView *y_axisSplitline;
    float chartWidth;
    float chartHeight;
    
    float minValue;
    float maxValue;
    UIView *test;
    
    NSMutableArray *x_axisViews;
    NSMutableArray *y_axisViews;
}
-(id) init{
    self=[super init];
    [self leAdditionalInits];
    return self;
}
-(void) leAdditionalInits{
    x_axisViews=[NSMutableArray new];
    y_axisViews=[NSMutableArray new];
    self.chartSettings=[ChartSettings new];
    self.chartSettings.tooltipSettings=[TooltipSettings new];
    self.chartSettings.tooltipSettings.bgColor=LEColorBlue;
    self.chartSettings.tooltipSettings.textColor=LEColorWhite;
    self.chartSettings.tooltipSettings.fontSize=10;
    self.chartSettings.tooltipSettings.offset=14;
    self.chartSettings.tooltipSettings.size=CGSizeZero;
    self.chartSettings.tooltipSettings.margins=UIEdgeInsetsMake(8, 8, 8, 8);
    self.chartSettings.tooltipSettings.radius=6;
    
    self.chartSettings.lineWidth=1;
    self.chartSettings.lineColor=LEColorBlue;
    self.chartSettings.dotOutlineWidth=0.5;
    self.chartSettings.dotRadius=3;
    self.chartSettings.dotColor=LEColorBlue;
    self.chartSettings.dotOutlineColor=LEColorWhite;
    self.chartSettings.smooth=0.6;
    
    self.chartSettings.scrollviewMargins=UIEdgeInsetsZero;
    self.chartSettings.rows=0;
    self.chartSettings.gridWidth=0;
    self.chartSettings.gridBGColor=LEColorWhite;
    self.chartSettings.gridColor=LEColorMask2;
    self.chartSettings.gridLineWidth=0.5;
    
    self.chartSettings.noDataText=@"暂无数据";
    
    self.chartSettings.tickLineColorX=LEColorBlack;
    self.chartSettings.tickLineTextColorX=LEColorText;
    self.chartSettings.tickLineOffsetX=0;
    self.chartSettings.tickLineFontsizeX=10;
    self.chartSettings.tickLineWidthX=1;
    
    self.chartSettings.tickLineColorY=LEColorBlack;
    self.chartSettings.tickLineTextColorY=LEColorText;
    self.chartSettings.tickLineOffsetY=10;
    self.chartSettings.tickLineFontsizeY=10;
    self.chartSettings.tickLineWidthY=1;
    self.chartSettings.yAxisPrecision=2;
    self.chartSettings.xAxisClassname=@"ChartXaxisView";
    self.chartSettings.yAxisClassname=@"ChartYaxisView";
    
    [self leConfigChart];
}

-(void) leConfigChart{
    self.leBgColor(self.chartSettings.gridBGColor);
    UIEdgeInsets scrollviewMargins=self.chartSettings.scrollviewMargins;
    scrollviewMargins.bottom=0;
    scrollviewMargins.left=0;
    scrollviewMargins.top-=self.chartSettings.dotRadius;
    scrollviewMargins.right+=self.chartSettings.dotRadius;
    if(chartView){
        chartScrollView=chartScrollView.leMargins(scrollviewMargins);
        gridView=gridView.leLeft(self.chartSettings.scrollviewMargins.left);
        chartView=chartView.leLeft(self.chartSettings.scrollviewMargins.left);
        [chartView setSettings:self.chartSettings];
        y_axis=y_axis.leWidth(self.chartSettings.scrollviewMargins.left).leBgColor(self.chartSettings.gridBGColor).leTop(scrollviewMargins.top); 
        y_axisSplitline=y_axisSplitline.leWidth(self.chartSettings.tickLineWidthY).leBgColor(self.chartSettings.tickLineColorY);
        noDataLabel=noDataLabel.leText(self.chartSettings.noDataText);
    }else{
        chartScrollView=[UIScrollView new].leAddTo(self).leMargins(scrollviewMargins);
        [chartScrollView setShowsHorizontalScrollIndicator:NO];
        [chartScrollView setBounces:NO];
//        [chartScrollView setClipsToBounds:NO];
        gridView=[GridView new].leAddTo(chartScrollView).leAnchor(LEI_TL).leTop(0).leLeft(self.chartSettings.scrollviewMargins.left);
        chartView=[LELineChartView new].leAddTo(chartScrollView).leAnchor(LEI_TL).leTop(0).leLeft(self.chartSettings.scrollviewMargins.left);
        [chartView setSettings:self.chartSettings];
        y_axis=[UIView new].leAddTo(self).leAnchor(LEI_TL).leWidth(self.chartSettings.scrollviewMargins.left).leTop(scrollviewMargins.top).leBgColor(self.chartSettings.gridBGColor);
        y_axisSplitline=[UIView new].leAddTo(y_axis).leAnchor(LEI_RC).leEqualSuperViewHeight(1).leWidth(self.chartSettings.tickLineWidthY).leBgColor(self.chartSettings.tickLineColorY);
        noDataLabel=[UILabel new].leAddTo(self).leAnchor(LEI_C).leFont(LEFont(14)).leColor(self.chartSettings.lineColor).leLine(1).leAlignment(NSTextAlignmentCenter).leText(self.chartSettings.noDataText);
    }
    [noDataLabel setHidden:YES];
    chartWidth=chartScrollView.bounds.size.width;
    chartHeight=chartScrollView.bounds.size.height-self.chartSettings.scrollviewMargins.bottom;
    self.chartSettings.tooltipSettings.chartHeight=chartHeight;
}
-(void) leSetDataSource:(NSArray *) datasource Min:(float) min Max:(float) max{
    if(min!=max){
        minValue=min;
        maxValue=max;
        for (NSInteger i=0; i<datasource.count; i++) {
            NSDictionary *dic=[datasource objectAtIndex:i];
            NSAssert([dic objectForKey:KeyValue]&&[[dic objectForKey:KeyValue] floatValue],@"LELineChart数据源格式为：@[@{@\"value\":@\"0.1\",@\"label\":@\"Mon\",}]");
            float value=[[dic objectForKey:KeyValue] floatValue];
            maxValue=MAX(maxValue, value);
        }
    }else{
        minValue=maxValue=0;
        for (NSInteger i=0; i<datasource.count; i++) {
            NSDictionary *dic=[datasource objectAtIndex:i];
            NSAssert([dic objectForKey:KeyValue]&&[[dic objectForKey:KeyValue] floatValue],@"LELineChart数据源格式为：@[@{@\"value\":@\"0.1\",@\"label\":@\"Mon\",}]");
            float value=[[dic objectForKey:KeyValue] floatValue];
            if(i==0){
                minValue=value;
                maxValue=value;
            }else{
                minValue=MIN(minValue, value);
                maxValue=MAX(maxValue, value);
            }
        }
    }
    if(self.chartSettings.rows==0){
        self.chartSettings.rows=datasource.count;
    }
    self.chartSettings.gridHeight=self.chartSettings.rows==0?0:chartHeight/self.chartSettings.rows;
    [noDataLabel setHidden:datasource.count>0];
    curDataSource=datasource;
    if(self.chartSettings.gridWidth==0&&curDataSource.count>0){
        self.chartSettings.gridWidth = chartWidth/curDataSource.count;
    }
    NSMutableArray *muta=[NSMutableArray new];
    if(curDataSource.count>0){
        [muta addObject:[NSValue valueWithCGPoint:CGPointMake(0, chartHeight/2)]];
        for (NSInteger i=0; i<curDataSource.count; i++) {
            NSDictionary *dic=[curDataSource objectAtIndex:i];
            float value=[[dic objectForKey:KeyValue] floatValue];
            value=maxValue==minValue?0:chartHeight*(1-(value-minValue)/(maxValue-minValue));
            [muta addObject:[NSValue valueWithCGPoint:CGPointMake(i*self.chartSettings.gridWidth+self.chartSettings.dotRadius, value+self.chartSettings.dotRadius)]];
        }
        [muta addObject:[NSValue valueWithCGPoint:CGPointMake(self.chartSettings.gridWidth*curDataSource.count, chartHeight/2)]];
    }
    [chartView setPoints:muta DataSource:curDataSource Min:minValue Max:maxValue Height:chartHeight];
    chartView=chartView.leWidth(self.chartSettings.gridWidth*(curDataSource.count==0?0:curDataSource.count-1)+self.chartSettings.dotRadius*2+self.chartSettings.gridWidth/2)
    .leHeight(chartHeight+self.chartSettings.dotRadius*2+self.chartSettings.tickLineWidthX*2);
    y_axis=y_axis.leHeight(chartHeight+self.chartSettings.dotRadius*2+self.chartSettings.tickLineWidthX*2);
    [gridView setSettings:self.chartSettings Size:curDataSource.count];
    gridView=gridView.leWidth(self.chartSettings.gridWidth*(curDataSource.count==0?0:curDataSource.count-1)+self.chartSettings.dotRadius*2+self.chartSettings.gridWidth/2)
    .leHeight(chartHeight+self.chartSettings.dotRadius*2+self.chartSettings.tickLineWidthX*2);
    [chartScrollView setContentSize:CGSizeMake(self.chartSettings.scrollviewMargins.left+chartView.bounds.size.width, chartHeight)];
    [self displayXaxis];
    [self displayYaxis];
    chartView.block = self.block;
    if(maxValue!=0){
    }
}
-(void) displayXaxis{
    NSInteger max=MAX(curDataSource.count, x_axisViews.count);
    for (NSInteger i=0; i<max; ++i) {
        if(i<curDataSource.count){
            ChartXaxisView *view=nil;
            if(i<x_axisViews.count){
                view=[x_axisViews objectAtIndex:i];
                [view setHidden:NO];
            }else{
                view=((ChartXaxisView *)[[self.chartSettings.xAxisClassname leGetInstanceFromClassName]init]).leAddTo(chartScrollView).leAnchor(LEI_BL);
                [x_axisViews addObject:view];
            }
            view.leWidth(self.chartSettings.gridWidth).leHeight(self.chartSettings.scrollviewMargins.bottom-self.chartSettings.dotRadius*4-self.chartSettings.tickLineWidthX)
            .leLeft(self.chartSettings.scrollviewMargins.left+ (i-0.5)*self.chartSettings.gridWidth);
            [view setTextColor:self.chartSettings.tickLineTextColorX Offset:self.chartSettings.tickLineOffsetX FontSize:self.chartSettings.tickLineFontsizeX Block:self.block];
            [view leSetData:[curDataSource objectAtIndex:i]];
        }else if(i<max){
            [[x_axisViews objectAtIndex:i] setHidden:YES];
        }
    }
}
-(void) displayYaxis{
    NSInteger max=MAX(self.chartSettings.rows+1, y_axisViews.count);
    for (NSInteger i=0; i<max; ++i) {
        if(i<=self.chartSettings.rows){
            ChartYaxisView *view=nil;
            if(i<y_axisViews.count){
                view=[y_axisViews objectAtIndex:i];
                [view setHidden:NO];
            }else{
                view=((ChartYaxisView *)[[self.chartSettings.yAxisClassname leGetInstanceFromClassName]init]).leAddTo(y_axis).leAnchor(LEI_TC);
                [y_axisViews addObject:view];
            }
            view=view.leWidth(self.chartSettings.scrollviewMargins.left).leHeight(self.chartSettings.gridHeight)
            .leTop((i-0.5)*self.chartSettings.gridHeight+self.chartSettings.dotRadius);
            [view setTextColor:self.chartSettings.tickLineTextColorY Offset:self.chartSettings.tickLineOffsetY FontSize:self.chartSettings.tickLineFontsizeY];
            [view leSetMin:minValue Max:maxValue Index:self.chartSettings.rows-i Rows:self.chartSettings.rows Precision:self.chartSettings.yAxisPrecision];
        }else if(i<max){
            [[y_axisViews objectAtIndex:i] setHidden:YES];
        }
    }
    [y_axis leUpdateLayout];
}
@end
