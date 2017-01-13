//
//  LECollectionView.h
//  Pods
//
//  Created by emerson larry on 2016/12/2.
//
//

#import <UIKit/UIKit.h>
#import "LEUICommon.h"
#import "LEViewAdditions.h"
#import "LERefresh.h"


#define LECollectionIdentifierItem @"collectionitem"
#define LECollectionIdentifierSection @"collectionsection"
@protocol LECollectionDelegate <NSObject>
/** Item点击后的回调 */
-(void) leOnItemEventWithInfo:(NSDictionary *) info;
@end
@protocol LECollectionDataSource <NSObject>
/** 刷新数据 */
-(void) leOnRefreshDataForCollection;
@optional
/** 加载更多 */
-(void) leOnLoadMoreForCollection;
/** 自定义每个section的item数量 */
-(NSInteger)leCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
/** 自定义item */
-(UICollectionViewCell *)leCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
/** 自定义section的数量 */
-(NSInteger)leNumberOfSectionsInCollectionView:(UICollectionView *)collectionView;
@end
 
@class LECollectionView;
@interface LECollectionItem : UICollectionViewCell
@property (nonatomic, weak) LECollectionView *leCollectionView;
@property (nonatomic) NSIndexPath *leIndexPath;
/** 设定数据 */
-(void) leSetData:(id)data;
@end
@interface LECollectionSection : UICollectionReusableView
@property (nonatomic) BOOL isInited;
@property (nonatomic, readonly) NSIndexPath *leIndexPath;
-(void) leSetData:(id) data Kind:(NSString *) kind IndexPath:(NSIndexPath *) path;
@end

@interface LECollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, readonly) NSMutableArray *leItemsArray;
@property (nonatomic, readwrite) NSMutableArray *leSectionHeaderArray;
/** alloc 初始化后调用：superView、layout、itemClassname(继承LECollectionItem) */
-(__kindof LECollectionView *(^)(UIView *superView, UICollectionViewLayout *layout, NSString *cellClassname)) leSuperview;
/** 设定delegate */
-(__kindof LECollectionView *(^)(id<LECollectionDelegate>)) leDelegate;
/** 设定数据源 */
-(__kindof LECollectionView *(^)(id<LECollectionDataSource>)) leDataSource;
/** 设定section的类名称 */
-(__kindof LECollectionView *(^)(NSString *sectionClassname)) leSectionClassname;
/** 获取delegate*/
-(id<LECollectionDelegate>) leGetDelegate;
/** 设定是否禁用下拉刷新 */
-(void) leSetTopRefresh:(BOOL) enable;
/** 设定是否禁用上拉加载更多 */
-(void) leSetBottomRefresh:(BOOL) enable;
/** 设定Item点击后是否自动释放选中状态（默认为自动释放） */
-(void) leAutoDeselectCellAfterSelection:(BOOL) enable;
/** 停止下拉刷新动画 */
-(void) leOnStopTopRefresh;
/** 停止上拉刷新动画 */
-(void) leOnStopBottomRefresh;
/** 启动下拉刷新动画 */
-(void) leOnAutoRefresh;
/** 计划执行启动下拉刷新动画 */
-(void) leOnAutoRefreshWithDuration:(float) duration;
/** 下拉刷新数据设定 */
-(void) leOnRefreshedWithData:(NSMutableArray *)data;
/** 上拉加载数据设定 */
-(void) leOnLoadedMoreWithData:(NSMutableArray *)data;
/** 主动选中item */
-(void) leSelectCellAtIndex:(NSIndexPath *)index;
/** 主动释放选中item */
-(void) leDeselectCellAtIndex:(NSIndexPath *) index;
@end

@interface LEVerticalFlowLayout : UICollectionViewFlowLayout
typedef CGFloat(^LEVerticalFlowLayoutCellHeight)(id data, NSIndexPath *index);
-(void) leSetCollectionView:(LECollectionView *) target CellHeightGetter:(LEVerticalFlowLayoutCellHeight) block;
@end

@interface LEHorizontalFlowLayout : UICollectionViewFlowLayout
typedef CGFloat(^LEHorizontalFlowLayoutCellWidth)(id data, NSIndexPath *index);
-(void) leSetCollectionView:(LECollectionView *) target CellWidthGetter:(LEHorizontalFlowLayoutCellWidth) block;
@end
@interface LECollectionViewWithRefresh : LECollectionView
/** 为了解决CollectionView 使用FlowLayout后设置了SectionInsects，如果cell内容没有撑满Frame则会造成上啦刷新的位置有偏差*/
-(void) leOnSetContentInsects:(UIEdgeInsets) insects;
@end
