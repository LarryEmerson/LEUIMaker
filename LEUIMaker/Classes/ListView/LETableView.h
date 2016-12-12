//
//  LETableView.h
//  Pods
//
//  Created by emerson larry on 2016/11/30.
//
//

#import <UIKit/UIKit.h>
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "LERefresh.h"
#define LEEmptyCellTouchEvent @"emptycelltouchevent"
@protocol LETableViewDelegate <NSObject>
/** Cell点击后触发，Key：LEKeyOfIndexPath、LEKeyOfClickStatus... */
-(void) leOnCellEventWithInfo:(NSDictionary *) info;
@end
@protocol LETableViewDataSource <NSObject>
/** 列表下拉后触发，列表需支持下拉组件或者下拉功能已开启 */
-(void) leOnRefreshData;
@optional
/** 列表上拉后触发，列表需支持上拉组件或者上拉功能已开启 */
-(void) leOnLoadMore;


@end

@interface LETableViewSection : UIView
-(__kindof LETableViewSection *(^)(CGFloat)) leSideSpace;
-(__kindof LETableViewSection *(^)(UIImage *)) leIcon;
-(__kindof LETableViewSection *(^)(NSString *)) leText;
-(__kindof LETableViewSection *(^)(UIColor *)) leColor;
-(__kindof LETableViewSection *(^)(BOOL)) leSplitline;
@end



@interface LETableViewCell : UITableViewCell
-(void) leExtraInits NS_REQUIRES_SUPER;
@property (nonatomic) UIView *leArrow;
@property (nonatomic) NSIndexPath *leIndexPath;
//
-(id<LETableViewDelegate>) leGetDelegate;
-(__kindof LETableViewCell *(^)(id<LETableViewDelegate>)) leDelegate;
-(__kindof LETableViewCell *(^)(BOOL)) leTouchEnabled;
-(__kindof LETableViewCell *(^)(BOOL)) leArrowEnabled;
-(__kindof LETableViewCell *(^)(BOOL)) leSplitlineEnabled;
-(__kindof LETableViewCell *(^)(UIView *)) leBottomView;
//
-(void) leSetData:(id) data;
-(void) leOnCellEventWithInfo:(id) info;
@end
@interface LEEmptyTableViewCell : LETableViewCell
-(void) leCommendsFromTableView:(NSString *) commends; 
@end
@interface LETableView : UITableView
@property (nonatomic, readonly) NSMutableArray *leItemsArray;
@property (nonatomic, readonly) LEEmptyTableViewCell *leEmptyCell;
@property (nonatomic)           NSInteger leCellCountAppended;
-(id<LETableViewDelegate>) leGetDelegate;
/** 注册cell的classname，多个时默认每个cell对应一个分组，如需自定义分组情况，请重写leCellClassnameWithSection */
-(void) leRegisterCellWith:(NSString *)classname,...;
/** 返回index对应的cell的classname */
-(NSString *) leCellClassnameWithIndex:(NSIndexPath *) index;
-(BOOL) leGetTouchEnabled;
-(__kindof LETableView *(^)(UIView *)) leSuperView;
-(__kindof LETableView *(^)(id<LETableViewDataSource>)) leDataSource;
-(__kindof LETableView *(^)(id<LETableViewDelegate>)) leDelegate;
-(__kindof LETableView *(^)(NSString *)) leCellClassname;
-(__kindof LETableView *(^)(NSString *)) leEmptyCellClassname;
-(__kindof LETableView *(^)(BOOL)) leTouchEnabled;
-(__kindof LETableView *(^)()) leAutoRefresh;
#pragma mark Refresh
-(void) leSetTopRefresh:(BOOL) enable;
-(void) leOnAutoRefresh;
-(void) leOnAutoRefreshWithDuration:(float) duration;

-(void) leOnRefreshedWithData:(NSMutableArray *)data;
-(void) leOnRefreshedDataToDataSource:(NSMutableArray *) data;
-(void) leOnReloadTableViewForRefreshedDataSource;
-(void) leOnStopTopRefresh;
#pragma mark Append
-(void) leSetBottomRefresh:(BOOL) enable;
-(void) leOnLoadedMoreWithData:(NSMutableArray *)data;
-(void) leOnAppendedDataToDataSource:(NSMutableArray *) data;
-(void) leOnReloadTableViewForAppendedDataSource;
-(void) leOnStopBottomRefresh;
#pragma mark TableView datasource & delegate
-(NSInteger) leNumberOfSections;
-(CGFloat) leHeightForSection:(NSInteger) section;
-(UIView *) leViewForHeaderInSection:(NSInteger) section;
-(NSInteger) leNumberOfRowsInSection:(NSInteger) section;
-(UITableViewCell *) leCellForRowAtIndexPath:(NSIndexPath *) indexPath;
@end

@interface LETableViewWithRefresh : LETableView
-(void) leExtraInits NS_REQUIRES_SUPER;
@end
