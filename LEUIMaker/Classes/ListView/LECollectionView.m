//
//  LECollectionView.m
//  Pods
//
//  Created by emerson larry on 2016/12/2.
//
//

#import "LECollectionView.h"


//Item
@implementation LECollectionItem
-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self leExtraInits];
    return self;
}
-(void) leSetData:(id) data {}
@end
//Section
@interface LECollectionSection ()
@property (nonatomic, readwrite) NSIndexPath *leIndexPath;
@end
@implementation LECollectionSection
-(void) leSetData:(id) data Kind:(NSString *) kind IndexPath:(NSIndexPath *) path{
    self.leIndexPath=path;
}
@end
//View
@interface LECollectionView ()
@property (nonatomic, readwrite) NSMutableArray *leItemsArray;
@end
@implementation LECollectionView{
    BOOL autoDeselect;
    NSString *curCellClassname;
    __weak id<LECollectionDelegate> curDelegate;
    __weak id<LECollectionDataSource> curDataSource;
}
-(void) leAutoDeselectCellAfterSelection:(BOOL) enable{
    autoDeselect=enable;
}
-(void) leSetTopRefresh:(BOOL) enable{}
-(void) leSetBottomRefresh:(BOOL) enable{}
-(void) leOnStopTopRefresh {
    [self reloadData];
}
-(void) leOnStopBottomRefresh {
    [self reloadData];
}
-(void) onDelegateRefreshData{
    if(curDataSource){
        if([curDataSource respondsToSelector:@selector(leOnRefreshDataForCollection)]){
            [curDataSource leOnRefreshDataForCollection];
        }
    }
}
-(void) onDelegateLoadMore{
    if(curDataSource){
        if([curDataSource respondsToSelector: @selector(leOnLoadMoreForCollection)]){
            [curDataSource leOnLoadMoreForCollection];
        }
    }
}
-(void) leOnAutoRefresh{}
-(void) leOnAutoRefreshWithDuration:(float) duration{
    [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(leOnAutoRefresh) userInfo:nil repeats:NO];
}
//
-(void) leOnRefreshedWithData:(NSMutableArray *)data{
    if(data){
        self.leItemsArray=[data mutableCopy];
    }
    [self leOnStopTopRefresh];
}
-(void) leOnLoadedMoreWithData:(NSMutableArray *)data{
    if(data){
        NSInteger section=[self numberOfSectionsInCollectionView:self];
        if(section>1){
            [self leOnStopBottomRefresh];
            return;
        }
        if(!self.leItemsArray){
            self.leItemsArray=[[NSMutableArray alloc] init];
        }
        [self.leItemsArray addObjectsFromArray:data];
    }
    [self leOnStopBottomRefresh];
}
-(void) leSelectCellAtIndex:(NSIndexPath *)index{
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnItemEventWithInfo:)]){
        [curDelegate leOnItemEventWithInfo:@{LEKeyIndex:index}];
    }
}
-(void) leDeselectCellAtIndex:(NSIndexPath *) index{
    [self deselectItemAtIndexPath:index animated:YES];
}
-(__kindof LECollectionView *(^)(UIView *superView, UICollectionViewLayout *layout, NSString *cellClassname)) leInit{
    return ^id(UIView *superView, UICollectionViewLayout *layout, NSString *cellClassname){
        [self initWithFrame:superView.bounds collectionViewLayout:layout];
        self.leAddTo(superView).leMargins(UIEdgeInsetsZero);
        [superView addSubview:self];
        self.allowsSelection=YES;
        self.delegate=self;
        self.dataSource=self;
        LECollectionItem *item=[cellClassname leGetInstanceFromClassName];
        NSAssert([item isKindOfClass:[LECollectionItem class]],([NSString stringWithFormat:@"请检查自定义(%@)是否继承于LECollectionCell",cellClassname]));
        item=nil;
        [self registerClass:NSClassFromString(cellClassname) forCellWithReuseIdentifier:LECollectionIdentifierItem];
        self.backgroundColor=LEColorClear;
        [self leExtraInits];
        [self setAlwaysBounceVertical:YES];
        autoDeselect=YES;
        return self;
    };
}
-(__kindof LECollectionView *(^)(id<LECollectionDelegate>)) leDelegate{
    return ^id(id<LECollectionDelegate> value){
        curDelegate=value;
        return self;
    };
}
-(__kindof LECollectionView *(^)(id<LECollectionDataSource>)) leDataSource{
    return ^id(id<LECollectionDataSource> value){
        curDataSource=value;
        return self;
    };
}
-(__kindof LECollectionView *(^)(NSString *sectionClassname)) leSectionClassname{
    return ^id(NSString *value){
        LECollectionSection *sec=[value leGetInstanceFromClassName];
        NSAssert([sec isKindOfClass:[LECollectionSection class]],([NSString stringWithFormat:@"请检查自定义(%@)是否继承于LECollectionSection",value]));
        sec=nil;
        [self registerClass:NSClassFromString(value) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:LECollectionIdentifierSection];
        [self registerClass:NSClassFromString(value) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:LECollectionIdentifierSection];
        return self;
    };
}
-(id<LECollectionDelegate>) leGetDelegate{
    return curDelegate;
}
//Sections
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(curDataSource&&[curDataSource respondsToSelector:@selector(leNumberOfSectionsInCollectionView:)]){
        return [curDataSource leNumberOfSectionsInCollectionView:collectionView];
    }
    NSInteger section=0;
    if(self.leItemsArray.count>0){
        id obj=[self.leItemsArray objectAtIndex:0];
        if([obj isKindOfClass:[NSArray class]]||[obj isMemberOfClass:[NSArray class]]){
            section=self.leItemsArray.count;
        }else{
            section=1;
        }
    }
    if(self.leSectionHeaderArray.count>0){
        section=MAX(section, self.leSectionHeaderArray.count);
    }
    return section;
}
//numbers
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(curDataSource&&[curDataSource respondsToSelector:@selector(leCollectionView:numberOfItemsInSection:)]){
        return [curDataSource leCollectionView:collectionView numberOfItemsInSection:section];
    }
    NSInteger items=0;
    if(self.leItemsArray&&self.leItemsArray.count>0){
        NSInteger sections=[self numberOfSectionsInCollectionView:collectionView];
        if(sections==1){
            items= self.leItemsArray.count;
        }else if(sections>1){
            if(section<self.leItemsArray.count){
                id obj=[self.leItemsArray objectAtIndex:section];
                if(obj&&([obj isKindOfClass:[NSArray class]]||[obj isMemberOfClass:[NSArray class]])){
                    items= [obj count];
                }
            }
        }
    }
    return items;
}
//items
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(curDataSource&&[curDataSource respondsToSelector:@selector(leCollectionView:cellForItemAtIndexPath:)]){
        return [curDataSource leCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    LECollectionItem *cell=[self dequeueReusableCellWithReuseIdentifier:LECollectionIdentifierItem forIndexPath:indexPath];
    cell.leCollectionView=self;
    cell.leIndexPath=indexPath;
    BOOL hasSet=NO;
    if(self.leItemsArray&&self.self.leItemsArray.count>0){
        NSInteger section=[self numberOfSectionsInCollectionView:collectionView];
        if(section==1){
            [cell leSetData:indexPath.row<self.leItemsArray.count?[self.leItemsArray objectAtIndex:indexPath.row]:nil];
            hasSet=YES;
        }else if(section>1){
            if(indexPath.section<self.leItemsArray.count){
                id obj=[self.leItemsArray objectAtIndex:indexPath.section];
                if(obj&&([obj isKindOfClass:[NSArray class]]||[obj isMemberOfClass:[NSArray class]])){
                    if(indexPath.row<[obj count]){
                        [cell leSetData:[obj objectAtIndex:indexPath.row]];
                        hasSet=YES;
                    }
                }
            }
        }
    }
    if(!hasSet){
        [cell leSetData:nil];
    }
    return cell;
}
//
- (void)leCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnItemEventWithInfo:)]){
        [curDelegate leOnItemEventWithInfo:@{LEKeyIndex:indexPath}];
    }
    if(autoDeselect){
        [self leDeselectCellAtIndex:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self leCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
}
//
- (UICollectionReusableView *)leCollectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    LECollectionSection *view=[self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:LECollectionIdentifierSection forIndexPath:indexPath];
    if(!view.isInited){
        view.isInited=YES;
        [view leExtraInits];
    }
    [view leSetData:self.leSectionHeaderArray&&indexPath.section<self.leSectionHeaderArray.count?[self.leSectionHeaderArray objectAtIndex:indexPath.section]:nil Kind:kind IndexPath:indexPath];
    return view;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return [self leCollectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}
@end

@implementation LEVerticalFlowLayout{
    NSMutableArray * _attributeAttay;
    LEVerticalFlowLayoutCellHeight cellHeight;
    LECollectionView *curTarget;
}
-(void) leSetCollectionView:(LECollectionView *) target CellHeightGetter:(LEVerticalFlowLayoutCellHeight) block{
    curTarget=target;
    cellHeight=block;
    [curTarget setAlwaysBounceHorizontal:NO];
    [curTarget setAlwaysBounceVertical:YES];
    self.scrollDirection=UICollectionViewScrollDirectionVertical;
}
-(void)prepareLayout{
    if(!_attributeAttay){
        _attributeAttay = [[NSMutableArray alloc]init];
    }else{
        [_attributeAttay removeAllObjects];
    }
    [super prepareLayout];
    float WIDTH =LESCREEN_WIDTH*1.0;
    float colHight=0.0;
    for (int i=0; i<curTarget.leItemsArray.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
        float hight = LECellH;
        if(cellHeight){
            hight=cellHeight(curTarget.leItemsArray,index);
        }
        attris.frame = CGRectMake(0, colHight, WIDTH, hight);
        colHight+=hight;
        [_attributeAttay addObject:attris];
    }
    self.itemSize=CGSizeMake(LESCREEN_WIDTH, colHight/curTarget.leItemsArray.count);
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attributeAttay;
}
@end
@implementation LEHorizontalFlowLayout{
    NSMutableArray * _attributeAttay;
    LEHorizontalFlowLayoutCellWidth cellWidth;
    LECollectionView *curTarget;
}
-(void) leSetCollectionView:(LECollectionView *) target CellWidthGetter:(LEHorizontalFlowLayoutCellWidth) block{
    curTarget=target;
    [curTarget setAlwaysBounceHorizontal:YES];
    [curTarget setAlwaysBounceVertical:NO];
    self.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    cellWidth=block;
}
-(void)prepareLayout{
    if(!_attributeAttay){
        _attributeAttay = [[NSMutableArray alloc]init];
    }else{
        [_attributeAttay removeAllObjects];
    }
    [super prepareLayout];
    float colWidth=0;
    float HEIGHT=curTarget.bounds.size.height-1;
    for (int i=0; i<curTarget.leItemsArray.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
        float width = cellWidth(curTarget.leItemsArray,index);
        attris.frame = CGRectMake(colWidth, 0, width, HEIGHT);
        colWidth+=width;
        [_attributeAttay addObject:attris];
    }
    self.itemSize=CGSizeMake(colWidth/curTarget.leItemsArray.count, HEIGHT);
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attributeAttay;
}
@end
@implementation LECollectionViewWithRefresh{
    LERefreshHeader *refreshHeader;
    LERefreshFooter *refreshFooter;
}

-(void) leExtraInits{
    typeof(self) __weak weakSelf = self;
    refreshHeader=[[LERefreshHeader alloc] initWithTarget:self];
    refreshHeader.refreshBlock=^(){
        LESuppressPerformSelectorLeakWarning(
                                             [weakSelf performSelector:NSSelectorFromString(@"onDelegateRefreshData")];
                                             );
    };
    refreshFooter=[[LERefreshFooter alloc] initWithTarget:self];
    
    refreshFooter.refreshBlock=^(){
        LESuppressPerformSelectorLeakWarning(
                                             [weakSelf performSelector:NSSelectorFromString(@"onDelegateLoadMore")];
                                             );
    };
}
-(void) leOnSetContentInsects:(UIEdgeInsets) insects{
    [refreshFooter onSetCollectionViewContentInsects:insects];
}
-(void) leOnAutoRefresh{
    //    LELogFunc
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
    //    LELogFunc
    [self onStopRefreshLogic];
}
-(void) leOnStopBottomRefresh {
    //    LELogFunc;
    [self onStopRefreshLogic];
}
-(void) onStopRefreshLogic{
    //    LELogFunc
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 结束刷新
        [refreshHeader onEndRefresh];
        [refreshFooter onEndRefresh];
        [self reloadData];
    });
}

@end
