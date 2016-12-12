//
//  TestMultiSectionTableView.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/12/7.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "TestMultiSectionTableView.h"

@interface MultiSectionTableViewCell : LETableViewCell @end
@implementation MultiSectionTableViewCell{
    UILabel *label;
}
-(void) leExtraInits{
    [super leExtraInits];
    label=[UILabel new].leAddTo(self).leAnchor(LEInsideCenter).leMaxWidth(LESCREEN_WIDTH-LESideSpace*2).leTop(LESideSpace).leAlignment(NSTextAlignmentCenter).leLine(0).leBottom(LESideSpace).leLineSpace(8);
    self.leBottomView(label);
}
-(void) leSetData:(id)data{ 
    label.leText([NSString stringWithFormat:@"类名：%@，当前indexpath为：{ %zd, %zd }",NSStringFromClass(self.class), self.leIndexPath.section,self.leIndexPath.row]);
}
@end

@interface CellSection0Row0 : MultiSectionTableViewCell @end
@implementation CellSection0Row0 @end
@interface CellSection0Row1 : MultiSectionTableViewCell @end
@implementation CellSection0Row1 @end
@interface CellSection0Row2 : MultiSectionTableViewCell @end
@implementation CellSection0Row2 @end
@interface CellSection2Rows : MultiSectionTableViewCell @end
@implementation CellSection2Rows @end
@interface CellSection1Row0 : MultiSectionTableViewCell @end
@implementation CellSection1Row0 @end
@interface CellSection1Row1 : MultiSectionTableViewCell @end
@implementation CellSection1Row1 @end
@interface CellSection1Row2 : MultiSectionTableViewCell @end
@implementation CellSection1Row2 @end

@interface MultiSectionTableView : LETableViewWithRefresh
@end
@implementation MultiSectionTableView
-(CGFloat) leHeightForSection:(NSInteger)section{
    return LENavigationBarHeight;
}
-(UIView *) leViewForHeaderInSection:(NSInteger)section{
    return [UIView new].leBgColor(LERandomColor).leWidth(LESCREEN_WIDTH).leHeight(LENavigationBarHeight);
}
-(NSInteger) leNumberOfSections{
    NSInteger sections=3;
    return sections;
}
-(NSInteger) leNumberOfRowsInSection:(NSInteger)section{
    NSInteger rows=0;
    if(section==0)rows= 3;
    else if(section==1)rows= 3;
    else rows= self.leItemsArray.count;
    return rows;
}
-(NSString *) leCellClassnameWithIndex:(NSIndexPath *)index{
    NSString *classname=nil;
    if(index.section==0&&index.row==0) classname= @"CellSection0Row0";
    else if(index.section==0&&index.row==1) classname= @"CellSection0Row1";
    else if(index.section==0&&index.row==2) classname= @"CellSection0Row2";
    if(index.section==1&&index.row==0) classname= @"CellSection1Row0";
    else if(index.section==1&&index.row==1) classname= @"CellSection1Row1";
    else if(index.section==1&&index.row==2) classname= @"CellSection1Row2";
    else classname= @"CellSection2Rows";
    return classname;
}
@end
@interface TestMultiSectionTableViewPage:LEView<LETableViewDataSource,LETableViewDelegate>
@end
@implementation TestMultiSectionTableViewPage{
    MultiSectionTableView *tableView;
}
-(void) leExtraInits{
    [LENavigation new].leSuperView(self).leTitle(NSStringFromClass(self.class));
    tableView=[MultiSectionTableView new].leSuperView(self.leSubViewContainer).leDataSource(self).leDelegate(self).leTouchEnabled(YES);
    [tableView leRegisterCellWith:
     @"CellSection0Row0",@"CellSection0Row1",@"CellSection0Row2",
     @"CellSection1Row0",@"CellSection1Row1",@"CellSection1Row2",
     @"CellSection2Rows",
     nil];
    [self leOnRefreshData];
}
-(void) leOnRefreshData{
    [tableView leOnRefreshedWithData:@[@"",@"",@""].mutableCopy];
}
-(void) leOnLoadMore{
    [tableView leOnLoadedMoreWithData:@[@""].mutableCopy];
}
-(void) leOnCellEventWithInfo:(NSDictionary *)info{
    LELogObject(info)
}
@end
@implementation TestMultiSectionTableView @end















