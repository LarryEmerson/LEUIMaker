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
-(void) leOnItemEventWithInfo:(NSDictionary *) info;
@end
@protocol LECollectionDataSource <NSObject>
-(void) leOnRefreshDataForCollection;
@optional
-(void) leOnLoadMoreForCollection;
-(NSInteger)leCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
-(UICollectionViewCell *)leCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)leNumberOfSectionsInCollectionView:(UICollectionView *)collectionView;
@end
 
@class LECollectionView;
@interface LECollectionItem : UICollectionViewCell
@property (nonatomic) LECollectionView *leCollectionView; 
@property (nonatomic) NSIndexPath *leIndexPath;
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
//
-(__kindof LECollectionView *(^)(UIView *superView, UICollectionViewLayout *layout, NSString *cellClassname)) leInit;
-(__kindof LECollectionView *(^)(id<LECollectionDelegate>)) leDelegate;
-(__kindof LECollectionView *(^)(id<LECollectionDataSource>)) leDataSource;
-(__kindof LECollectionView *(^)(NSString *sectionClassname)) leSectionClassname;
-(id<LECollectionDelegate>) leGetDelegate;
-(void) leSetTopRefresh:(BOOL) enable;
-(void) leSetBottomRefresh:(BOOL) enable;
-(void) leAutoDeselectCellAfterSelection:(BOOL) enable;
-(void) leOnStopTopRefresh;
-(void) leOnStopBottomRefresh;
-(void) leOnAutoRefresh;
-(void) leOnAutoRefreshWithDuration:(float) duration;
-(void) leOnRefreshedWithData:(NSMutableArray *)data;
-(void) leOnLoadedMoreWithData:(NSMutableArray *)data;
-(void) leSelectCellAtIndex:(NSIndexPath *)index;
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
