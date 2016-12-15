//
//  LETableView.m
//  Pods
//
//  Created by emerson larry on 2016/11/30.
//
//

#import "LETableView.h"


@implementation LETableViewSection {
    UIView *curSideSpace;
    UIImageView *curIcon;
    UILabel *curTitle;
    UIView *curSplitline;
}
-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    self.leAutoCalcHeight();
    curSideSpace=[UIView new].leAddTo(self).leAnchor(LEInsideLeftCenter).leLeft(LESideSpace).leSize(CGSizeZero);
    curIcon=[UIImageView new].leAddTo(self).leRelativeTo(curSideSpace).leAnchor(LEOutsideRightCenter);
    curTitle=[UILabel new].leAddTo(self).leRelativeTo(curIcon).leAnchor(LEOutsideRightCenter).leWidth(LESCREEN_WIDTH-LESideSpace*2).leLine(1);
    [self leExtraInits];
    curSplitline=[UIView new].leAddTo(self).leAnchor(LEInsideBottomCenter).leEqualSuperViewWidth(1).leHeight(LESplitlineH).leBgColor(LEColorSplitline);
    return self;
}
-(__kindof LETableViewSection *(^)(CGFloat)) leSideSpace{
    return ^id(CGFloat value){
        curSideSpace.leLeft(value);
        return self;
    };
}
-(__kindof LETableViewSection *(^)(UIImage *)) leIcon{
    return ^id(UIImage *value){
        curIcon.leImage(value);
        curTitle.leWidth(LESCREEN_WIDTH-LESideSpace*2-(value?value.size.width+LESideSpace:0)).leLeft(value?LESideSpace:0);
        return self;
    };
}
-(__kindof LETableViewSection *(^)(NSString *)) leText{
    return ^id(NSString *value){
        curTitle.leText(value);
        return self;
    };
}
-(__kindof LETableViewSection *(^)(UIColor *)) leColor{
    return ^id(UIColor *value){
        curTitle.leColor(value);
        return self;
    };
}
-(__kindof LETableViewSection *(^)(BOOL)) leSplitline{
    return ^id(BOOL value){
        [curSplitline setHidden:!value];
        return self;
    };
}
@end


@implementation LEEmptyTableViewCell
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setAlpha:0];
    [self leEaseInView];
    return self;
}
-(void) leEaseInView{
    [UIView animateWithDuration:0.4 delay:0.08 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
        [self setAlpha:1];
    } completion:^(BOOL isDone){}];
}
-(void) leCommendsFromTableView:(NSString *) commends{}
-(void) onTouchEvent{
    [self leOnCellEventWithInfo:LEEmptyCellTouchEvent];
}
@end


@implementation LETableViewCell{
    __weak id<LETableViewDelegate> curDelegate;
    BOOL hasGesture;
    UIImageView *curArrow;
    UIButton *curTouch;
    UIView *curSplit;
    __weak UIView *bottomView;
    BOOL touchDisabled;
}
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.leWidth(LESCREEN_WIDTH).leHeight(LECellH).leBgColor(LEColorWhite);
    self.leArrow=[UIView new].leAddTo(self).leAnchor(LEInsideRightCenter).leRight(LESideSpace).leHorizontalStack();
    curArrow=[UIImageView new].leImage([LEUICommon sharedInstance].leListRightArrow);
    [curArrow setHidden:YES];
    [self.leArrow lePushToStack:curArrow,nil];
    [self leExtraInits];
    curTouch=[UIButton new].leAddTo(self).leMargins(UIEdgeInsetsZero).leTouchEvent(@selector(onTouchEvent),self).leBtnBGImgH([LEColorMask2 leImage]);
    curTouch.hidden=touchDisabled;
    curSplit=[UIView new].leAddTo(self).leAnchor(LEInsideBottomCenter).leWidth(LESCREEN_WIDTH).leHeight(1/LESCREEN_SCALE).leBgColor(LEColorSplitline); 
    return self;
}
-(id<LETableViewDelegate>) leGetDelegate{
    return curDelegate;
}
-(__kindof LETableViewCell *(^)(id<LETableViewDelegate>)) leDelegate{
    return ^id(id<LETableViewDelegate> value){
        curDelegate=value;
        return self;
    };
}
-(__kindof LETableViewCell *(^)(BOOL)) leTouchEnabled{
    return ^id(BOOL value){
        touchDisabled=!value;
        curTouch.hidden=!value;
        return self;
    };
}
-(__kindof LETableViewCell *(^)(BOOL)) leArrowEnabled{
    return ^id(BOOL value){
        curArrow.leLeft(value?LESideSpace:0);
        [curArrow setHidden:!value];
        [curArrow leUpdateLayout]; 
        return self;
    };
}
-(__kindof LETableViewCell *(^)(BOOL)) leSplitlineEnabled{
    return ^id(BOOL value){
        curSplit.hidden=!value;
        return self;
    };
} 
-(void) onTouchEvent{
    [self leOnCellEventWithInfo:nil];
}
-(void) leOnCellEventWithInfo:(id) info{
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnCellEventWithInfo:)]){
        NSMutableDictionary *dic=[NSMutableDictionary new];
        if(self.leIndexPath){
            [dic setObject:self.leIndexPath forKey:LEKeyIndex];
        }
        if(info){
            [dic setObject:info forKey:LEKeyInfo];
        }
        [curDelegate leOnCellEventWithInfo:dic];
    }
}
-(__kindof LETableViewCell *(^)(UIView *)) leBottomView{
    return ^id(UIView *value){
        bottomView=value;
        return self;
    };
}
-(void) leSetData:(id) data{}
-(void) layoutCellAfterConfig{
    self.leWidth(LESCREEN_WIDTH).leHeight([self leGetCellHeightWithBottomView:bottomView]);
}
-(CGSize)sizeThatFits:(CGSize)size {
    size.height=[self leGetCellHeightWithBottomView:bottomView];
    return size;
} 
@end


@interface LETableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, readwrite) NSMutableArray *leItemsArray;
@property (nonatomic, readwrite) LEEmptyTableViewCell *leEmptyCell;
@end
@implementation LETableView{
    __weak id<LETableViewDataSource> curDataSource;
    __weak id<LETableViewDelegate> curDelegate;
    BOOL curTouchEnabled;
    BOOL curAutoRefresh;
    NSMutableArray *curCellClassnames;
    NSString *curEmptyCellClassname;
    NSMutableDictionary *tempCellsForHeightCalc;
    NSInteger lastCellCounts;
}

-(id<LETableViewDelegate>) leGetDelegate{
    return curDelegate;
}

-(void) leRegisterCellWith:(NSString *)classname,...{
    NSMutableArray *muta=[NSMutableArray new];
    if(classname){
        [muta addObject:classname];
    }
    va_list params;
    va_start(params,classname);
    id arg;
    if (classname) {
        while( (arg = va_arg(params, NSString *)) ) {
            if ( arg ){
                [muta addObject:arg];
            }
        }
        va_end(params);
    }
    if(!curCellClassnames){
        curCellClassnames=[NSMutableArray new];
    }
    for (NSInteger i=0; i<muta.count; i++) {
        classname=[muta objectAtIndex:i];
        Class cls=NSClassFromString(classname);
        id obj=[cls alloc];
        if([obj isKindOfClass:[UITableViewCell class]]){
            [curCellClassnames addObject:classname];
            [self registerClass:cls forCellReuseIdentifier:classname];
        }
        obj=nil;
    }
}

-(BOOL) leGetTouchEnabled{
    return curTouchEnabled;
}
-(__kindof LETableView *(^)(UIView *)) leSuperView{
    return ^id(UIView *value){
        self.leAddTo(value).leMargins(UIEdgeInsetsZero).leBgColor(LEColorClear);
        self.delegate=self;
        self.dataSource=self;
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.allowsSelection=NO;
        tempCellsForHeightCalc=[NSMutableDictionary new];
        [self leExtraInits];
        if(curAutoRefresh){
            [self leOnAutoRefresh];
        }
        return self;
    };
}
-(__kindof LETableView *(^)(id<LETableViewDataSource>)) leDataSource{
    return ^id(id<LETableViewDataSource> value){
        curDataSource=value;
        return self;
    };
}
-(__kindof LETableView *(^)(id<LETableViewDelegate>)) leDelegate{
    return ^id(id<LETableViewDelegate> value){
        curDelegate=value;
        return self;
    };
}
-(__kindof LETableView *(^)(NSString *)) leCellClassname{
    return ^id(NSString *value){
        if(!curCellClassnames){
            curCellClassnames=[NSMutableArray new];
        }
        Class cls=NSClassFromString(value);
        id obj=[cls alloc];
        if([obj isKindOfClass:[UITableViewCell class]]){
            [curCellClassnames addObject:value];
            [self registerClass:cls forCellReuseIdentifier:value];
        }
        obj=nil;
        return self;
    };
}
-(__kindof LETableView *(^)(NSString *)) leEmptyCellClassname{
    return ^id(NSString *value){
        curEmptyCellClassname=value;
        [self registerClass:NSClassFromString(value) forCellReuseIdentifier:value];
        return self;
    };
}
-(__kindof LETableView *(^)(BOOL)) leTouchEnabled{
    return ^id(BOOL value){
        curTouchEnabled=value;
        return self;
    };
}
-(__kindof LETableView *(^)()) leAutoRefresh{
    return ^id(){
        curAutoRefresh=YES;
        if(self.superview){
            [self leOnAutoRefresh];
        }
        return self;
    };
}
//
-(void) onDelegateRefreshData{
    if(curDataSource){
        if([curDataSource respondsToSelector:@selector(leOnRefreshData)]){
            [curDataSource leOnRefreshData];
        }
    }
}
-(void) onDelegateLoadMore{
    if(curDataSource){
        if([curDataSource respondsToSelector:@selector(leOnLoadMore)]){
            [curDataSource leOnLoadMore];
        }
    }
}
-(void) leOnAutoRefresh{
    [self onDelegateRefreshData];
}
-(void) leOnAutoRefreshWithDuration:(float) duration{
    [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(leOnAutoRefresh) userInfo:nil repeats:NO];
}
#pragma mark Refresh
-(void) leSetTopRefresh:(BOOL) enable{}
-(void) leOnRefreshedWithData:(NSMutableArray *)data{
    [self leOnRefreshedDataToDataSource:data];
    [self leOnReloadTableViewForRefreshedDataSource];
    [self leOnStopTopRefresh];
}
-(void) leOnRefreshedDataToDataSource:(NSMutableArray *) data{
    if(data){
        self.leItemsArray=[data mutableCopy];
        self.leCellCountAppended=data.count;
        lastCellCounts=self.leCellCountAppended;
    }
}
-(void) leOnReloadTableViewForRefreshedDataSource{
    [self reloadData];
}
-(void) leOnStopTopRefresh{}
#pragma mark Append
-(void) leSetBottomRefresh:(BOOL) enable{}
-(void) leOnLoadedMoreWithData:(NSMutableArray *)data{
    [self leOnAppendedDataToDataSource:data];
    [self leOnReloadTableViewForAppendedDataSource];
    [self leOnStopBottomRefresh];
}
-(void) leOnAppendedDataToDataSource:(NSMutableArray *) data{
    if(data){
        if(!self.leItemsArray){
            self.leItemsArray=[[NSMutableArray alloc] init];
        }
        self.leCellCountAppended=data.count;
        [self.leItemsArray addObjectsFromArray:data];
    }
}
-(void) leOnReloadTableViewForAppendedDataSource{
    if(self.leCellCountAppended>0&&lastCellCounts>0){
        [self beginUpdates];
        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
        NSInteger section=[self getNumberOfSections]>1?[self getNumberOfSections]-1:0;
        for (int ind = 0; ind < self.leCellCountAppended; ind++) {
            NSIndexPath *newPath =  [NSIndexPath indexPathForRow:self.leItemsArray.count-self.leCellCountAppended+ind inSection:section];
            [insertIndexPaths addObject:newPath]; 
        }
        [self insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self endUpdates];
        lastCellCounts=self.leCellCountAppended;
    }else{
        [self reloadData];
    }
}
-(void) leOnStopBottomRefresh{}
//
-(NSInteger) getNumberOfSections{
    if(curDataSource&&[curDataSource respondsToSelector:@selector(leNumberOfSections)]){
        return [curDataSource leNumberOfSections];
    }
    return 1;
}
-(NSInteger) getNumberOfRowsInSection:(NSInteger) section{
    if(curDataSource&&[curDataSource respondsToSelector:@selector(leNumberOfRowsInSection:)]){
        return [curDataSource leNumberOfRowsInSection:section];
    }
    return self.leItemsArray?self.leItemsArray.count:0;
}

-(NSString *) getCellClassnameWithIndex:(NSIndexPath *) index{
    if(curDataSource&&[curDataSource respondsToSelector:@selector(leCellClassnameWithIndex:)]){
        return [curDataSource leCellClassnameWithIndex:index];
    }
    if(index.section<curCellClassnames.count){
        return [curCellClassnames objectAtIndex:index.section];
    }
    return nil;
}
-(BOOL) checkEmptyCellCondition:(NSInteger) section{
    if([self getNumberOfRowsInSection:section]==0&&(([self getNumberOfSections]==1&&section==0)||([self getNumberOfSections]>1&&section==[self getNumberOfSections]-1))){
        return YES;
    }
    return NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows=[self getNumberOfRowsInSection:section];
    if(curEmptyCellClassname&&rows==0&&self.leItemsArray){
        if([self checkEmptyCellCondition:section]){
            return 1;
        }
    }else{
        return rows;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rows=[self getNumberOfRowsInSection:indexPath.section];
    if(rows==0){
        if([self checkEmptyCellCondition:indexPath.section]){
            self.leEmptyCell=curEmptyCellClassname?[self dequeueReusableCellWithIdentifier:curEmptyCellClassname forIndexPath:indexPath]:[UIView new];
            if(curEmptyCellClassname){
                self.leEmptyCell.leDelegate(curDelegate);
            }
            [self.leEmptyCell layoutCellAfterConfig];
            return self.leEmptyCell;
        }
    }
    LETableViewCell *cell=[self dequeueReusableCellWithIdentifier:[self getCellClassnameWithIndex:indexPath] forIndexPath:indexPath];
    cell.leDelegate(curDelegate).leTouchEnabled(curTouchEnabled);
    cell.leIndexPath=indexPath;
    [cell leSetData:[self getDataForIndex:indexPath]];
    [cell layoutCellAfterConfig];
    return cell;
}
-(id) getDataForIndex:(NSIndexPath *) index{
    if(curDataSource&&[curDataSource respondsToSelector:@selector(leDataForIndex:)]){
        return [curDataSource leDataForIndex:index];
    }
    if(self.leItemsArray&&index.row<self.leItemsArray.count){
        return [self.leItemsArray objectAtIndex:index.row];
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier=[self getCellClassnameWithIndex:indexPath];
    if(indexPath.row==0&&[self checkEmptyCellCondition:indexPath.section]){
        identifier=curEmptyCellClassname;
    }
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(LETableViewCell *cell) {
        cell.fd_enforceFrameLayout=YES;
        if(![identifier isEqualToString:curEmptyCellClassname]){
            cell.leIndexPath=indexPath;
            if(self.leItemsArray&&indexPath.row<self.leItemsArray.count){
                [cell leSetData:[self.leItemsArray objectAtIndex:indexPath.row]];
            }else{
                [cell leSetData:nil];
            }
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self getNumberOfSections];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(curDataSource&&[curDataSource respondsToSelector:@selector(leHeightForSection:)]){
        return [curDataSource leHeightForSection:section];
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(curDataSource&&[curDataSource respondsToSelector:@selector(leViewForHeaderInSection:)]){
        return [curDataSource leViewForHeaderInSection:section];
    }
    return nil;
}
@end

@implementation LETableViewWithRefresh{
    LERefreshHeader *refreshHeader;
    LERefreshFooter *refreshFooter;
}
-(void) leExtraInits{
    [super leExtraInits];
    
    refreshHeader=[[LERefreshHeader alloc] initWithTarget:self];
    typeof(self) __weak weakSelf = self;
    refreshHeader.refreshBlock=^(){
        [weakSelf onDelegateRefreshData];
    };
    refreshFooter=[[LERefreshFooter alloc] initWithTarget:self];
    refreshFooter.refreshBlock=^(){
        [weakSelf onDelegateLoadMore];
    };
}
-(void) leOnAutoRefresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [refreshHeader onBeginRefresh];
    });
}
-(void) leSetTopRefresh:(BOOL) enable{
    refreshHeader.isEnabled=enable;
}
-(void) leSetBottomRefresh:(BOOL) enable{
    refreshFooter.isEnabled=enable;
}
-(void) leOnStopTopRefresh {
    [self onStopRefreshLogic];
}
-(void) leOnStopBottomRefresh {
    [self onStopRefreshLogic];
}
-(void) onStopRefreshLogic{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshHeader onEndRefresh];
        [refreshFooter onEndRefresh];
    });
}
@end
