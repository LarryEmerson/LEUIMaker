//
//  LETableViewOptimized.m
//  Pods
//
//  Created by emerson larry on 2016/12/1.
//
//

#import "LETableViewOptimized.h"

@implementation LETableViewCellOptimized{
    UIButton *curTouch;
    BOOL curTouchEnabled;
    __weak id<LETableViewDelegate> curDelegate;
}
-(void) leSetDelegate:(id<LETableViewDelegate>) delegate{
    curDelegate=delegate;
}
-(id<LETableViewDelegate>) leDelegate{
    return curDelegate;
}
-(void) leTouchEnabled:(BOOL) touch{
    [curTouch setHidden:!touch];
}
-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LECellH)];
    [self leExtraInits];
    curTouch=[UIButton new].leAddTo(self).leMargins(UIEdgeInsetsZero).leTouchEvent(@selector(onTouchEvent),self).leBtnBGImgH([LEColorMask2 leImage]);
    return self;
}
-(void) onTouchEvent{
    [self leOnCellEventWithIndex:0];
}
-(void) leSetData:(id)data {
    self.leData=data;
}
-(void) leSetIndex:(NSIndexPath *)index{
    self.leIndexPath=index;
    [self leOnIndexSet];
}
-(void) leOnIndexSet{}
-(void) leOnCellEventWithInfo:(NSDictionary *) info{
    if(self.leDelegate&&self.leIndexPath){
        [self.leDelegate leOnCellEventWithInfo:@{LEKeyIndex:self.leIndexPath,LEKeyInfo:info}];
    }
}
-(void) leOnCellEventWithIndex:(int) index{
    if(self.leDelegate&&self.leIndexPath){
        [self.leDelegate leOnCellEventWithInfo:@{LEKeyIndex:self.leIndexPath,LEKeyInfo:[NSNumber numberWithInt:index]}];
    }
}
-(CGFloat) leGetHeight{
    return self.bounds.size.height;
}
@end
@interface LETableViewOptimizedCellContainer : UITableViewCell
-(void) leSetDisplayCell:(LETableViewCellOptimized *) cell;
@end
@implementation LETableViewOptimizedCellContainer{
    LETableViewCellOptimized *lastCell;
}
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LECellH)];
    return self;
}
-(void) leSetDisplayCell:(LETableViewCellOptimized *)cell{
    if(lastCell){
        [lastCell setHidden:YES];
    }
    [cell setHidden:NO];
    [self addSubview:cell];
    [self setFrame:CGRectMake(0, 0, LESCREEN_WIDTH, cell.leGetHeight)];
    lastCell=cell;
}
@end

@implementation LETableViewOptimized
-(void) leExtraInits{
    [super leExtraInits];
    [self registerClass:[LETableViewOptimizedCellContainer class] forCellReuseIdentifier:NSStringFromClass(self.class)];
}
-(void) dealloc{
    for (NSInteger i=0; i<self.leDisplayCellCache.count; i++) {
        [[self.leDisplayCellCache objectAtIndex:i] removeFromSuperview];
    }
    [self.leDisplayCellCache removeAllObjects];
    [self.leItemsArray removeAllObjects];
}
-(void) leOnRefreshedWithData:(NSMutableArray *)data{
    [self leOnRefreshedDataToDataSource:data];
    LEWeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself onLoadDisplayCellWithRange:NSMakeRange(0, weakself.leCellCountAppended)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself leOnReloadTableViewForRefreshedDataSource];
            [weakself leOnStopTopRefresh];
        });
    });
}

-(void) leOnLoadedMoreWithData:(NSMutableArray *)data{
    [self leOnAppendedDataToDataSource:data];
    LEWeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself onLoadDisplayCellWithRange:NSMakeRange(weakself.leItemsArray.count-weakself.leCellCountAppended, weakself.leCellCountAppended)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself leOnReloadTableViewForAppendedDataSource];
            [weakself leOnStopBottomRefresh];
        });
    });
}
-(void) onLoadDisplayCellWithRange:(NSRange) range{
    if(!self.leDisplayCellCache){
        self.leDisplayCellCache=[NSMutableArray new];
    }
    for (NSInteger i=range.location; i<range.location+range.length; i++) {
        LETableViewCellOptimized *cell=nil;
        if(i<self.leItemsArray.count){
            if(i<self.leDisplayCellCache.count){
                cell=[self.leDisplayCellCache objectAtIndex:i];
            }else{
                NSAssert([NSClassFromString([self leCellClassnameWithIndex:[NSIndexPath indexPathForRow:0 inSection:0]]) isKindOfClass:[LETableViewCellOptimized class]],([NSString stringWithFormat:@"请检查自定义DisplayCell是否继承于LETableViewCellOptimized：%@",self]));
                cell=[[[self leCellClassnameWithIndex:[NSIndexPath indexPathForRow:0 inSection:0]] leClass] init];
                [cell.leAutoCalcHeight() leSetDelegate:self.leGetDelegate];
                [cell leTouchEnabled:self.leGetTouchEnabled];
                [self.leDisplayCellCache addObject:cell];
            }
            [cell leSetData:[self.leItemsArray objectAtIndex:i]];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row<self.leDisplayCellCache.count){
        return [[self.leDisplayCellCache objectAtIndex:indexPath.row] leGetHeight];
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}
-(UITableViewCell *) leCellForRowAtIndexPath:(NSIndexPath *) indexPath{
    LETableViewOptimizedCellContainer *cell=[self dequeueReusableCellWithIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.leAutoCalcHeight();
    if(self.leDisplayCellCache&&indexPath.row<self.leDisplayCellCache.count){
        LETableViewCellOptimized *disCell=[self.leDisplayCellCache objectAtIndex:indexPath.row];
        [disCell leSetIndex:indexPath];
        [cell leSetDisplayCell:disCell];
    }
    return cell;
} 
@end

@implementation LETableViewOptimizedWithRefresh{
    LERefreshHeader *refreshHeader;
    LERefreshFooter *refreshFooter;
}
-(void) leExtraInits{
    [super leExtraInits];
    refreshHeader=[[LERefreshHeader alloc] initWithTarget:self];
    typeof(self) __weak weakSelf = self;
    refreshHeader.refreshBlock=^(){
        LESuppressPerformSelectorLeakWarning( [weakSelf performSelector:NSSelectorFromString(@"onDelegateRefreshData")]; );
    };
    refreshFooter=[[LERefreshFooter alloc] initWithTarget:self];
    refreshFooter.refreshBlock=^(){
        LESuppressPerformSelectorLeakWarning( [weakSelf performSelector:NSSelectorFromString(@"onDelegateLoadMore")]; );
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
