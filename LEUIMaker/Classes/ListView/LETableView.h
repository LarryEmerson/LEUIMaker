//
//  LETableView.h
//  Pods
//
//  Created by emerson larry on 2016/11/30.
//
//

#import <UIKit/UIKit.h> 
#import "LERefresh.h"
#define LEEmptyCellTouchEvent @"emptycelltouchevent"
@protocol LETableViewDelegate <NSObject>
/** Cell点击后触发，Key：LEKeyOfIndexPath、LEKeyOfClickStatus... */
-(void) leOnCellEventWithInfo:(NSDictionary *) info;
@end
@protocol LETableViewDataSource <NSObject>
@optional
/** 列表下拉后触发，列表需支持下拉组件或者下拉功能已开启 */
-(void) leOnRefreshData;
/** 列表上拉后触发，列表需支持上拉组件或者上拉功能已开启 */
-(void) leOnLoadMore;

/** 自定义section数量 */
-(NSInteger)    leNumberOfSections;
/** 自定义section的高度 */
-(CGFloat)      leHeightForSection:(NSInteger) section;
/** 自定义section的view */
-(UIView *)     leViewForHeaderInSection:(NSInteger) section;
/** 自定义row的数量 */
-(NSInteger)    leNumberOfRowsInSection:(NSInteger) section;
/** 自定义每个cell对应的数据 */
-(id)           leDataForIndex:(NSIndexPath *) index;
/** 自定义每个cell的类名称 */
-(NSString *)   leCellClassnameWithIndex:(NSIndexPath *) index;

/** 高度固定的Cell，建议自定义为NO。返回值决定列表在获取Cell高度时是否根据数据源动态计算高度（默认为允许，允许时会牺牲流畅度）。 */
-(BOOL) leAllowCellConfigrationWithDatasourceForHeightCalculation;
@end

@interface LETableViewSection : UIView
/** 设定左侧间隔 */
-(__kindof LETableViewSection *(^)(CGFloat)) leSideSpace;
/** 设定图标 */
-(__kindof LETableViewSection *(^)(UIImage *)) leIcon;
/** 设定标题 */
-(__kindof LETableViewSection *(^)(NSString *)) leText;
/** 设定标题颜色 */
-(__kindof LETableViewSection *(^)(UIColor *)) leColor;
/** 设定是否显示分割线 */
-(__kindof LETableViewSection *(^)(BOOL)) leSplitline;
@end



@interface LETableViewCell : UITableViewCell
/** 用于屏幕旋转时的处理 */
-(void) leDidRotateFrom:(UIInterfaceOrientation)from NS_REQUIRES_SUPER;
/** 右侧箭头 */
@property (nonatomic) UIView *leArrow;
@property (nonatomic) NSIndexPath *leIndexPath;
//
/** 获取delegate */
-(id<LETableViewDelegate>) leGetDelegate;
/** 设定delegate */
-(__kindof LETableViewCell *(^)(id<LETableViewDelegate>)) leDelegate;
/** 设定点击事件是否开启 */
-(__kindof LETableViewCell *(^)(BOOL)) leTouchEnabled;
/** 设定是否隐藏右侧按钮 */
-(__kindof LETableViewCell *(^)(BOOL)) leArrowEnabled;
/** 设定是否隐藏分割线 */
-(__kindof LETableViewCell *(^)(BOOL)) leSplitlineEnabled;
/** 设定bottomView，用于自动计算cell的高度 */
-(__kindof LETableViewCell *(^)(UIView *)) leBottomView;
/** 设定数据 */
-(void) leSetData:(id) data;
/** 自定义cell时，cell点击事件处理，传参类型为id */
-(void) leOnCellEventWithInfo:(id) info;
@end
@interface LEEmptyTableViewCell : LETableViewCell
-(void) leCommendsFromTableView:(NSString *) commends; 
@end
@interface LETableView : UITableView
/** 当前tableview中的数据 */
@property (nonatomic, readonly) NSMutableArray *leItemsArray;
@property (nonatomic, readonly) LEEmptyTableViewCell *leEmptyCell;
@property (nonatomic)           NSInteger leCellCountAppended;
-(id<LETableViewDelegate>) leGetDelegate;
/** 注册cell的classname，多个时默认每个cell对应一个分组，如需自定义分组情况，请重写leCellClassnameWithSection */
-(void) leRegisterCellWith:(NSString *)classname,...;
/** 返回index对应的cell的classname */
-(NSString *) leCellClassnameWithIndex:(NSIndexPath *) index;
/** 获取点击事件状态 */
-(BOOL) leGetTouchEnabled;
/** 设定superview */
-(__kindof LETableView *(^)(UIView *)) leSuperView;
/** 设定数据源及自定义列表 */
-(__kindof LETableView *(^)(id<LETableViewDataSource>)) leDataSource;
/** 设定delegate */
-(__kindof LETableView *(^)(id<LETableViewDelegate>)) leDelegate;
/** 设定单组列表cell的类名 */
-(__kindof LETableView *(^)(NSString *)) leCellClassname;
/** 设定空列表的类名 */
-(__kindof LETableView *(^)(NSString *)) leEmptyCellClassname;
/** 设定是否禁用点击事件 */
-(__kindof LETableView *(^)(BOOL)) leTouchEnabled;
/** 设定自动下拉刷新 */
-(__kindof LETableView *(^)()) leAutoRefresh;
/** 设定是否禁用下拉刷新 */
-(__kindof LETableView *(^)(BOOL)) leTopRefresh;
/** 设定是否禁用上拉刷新 */
-(__kindof LETableView *(^)(BOOL)) leBottomRefresh;
/** 设定停止下拉刷新 */
-(__kindof LETableView *(^)()) leStopTopRefresh;
/** 设定停止上拉刷新 */
-(__kindof LETableView *(^)()) leStopBottomRefresh;

/** 设定停止下拉刷新 */
-(__kindof LETableView *(^)(NSMutableArray *)) leRefreshedWithData;
/** 设定停止上拉刷新 */
-(__kindof LETableView *(^)(NSMutableArray *)) leLoadMoreWithData;

#define mark 不建议使用以下方法
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
@end

@interface LETableViewWithRefresh : LETableView
-(void) leExtraInits NS_REQUIRES_SUPER;
@end
