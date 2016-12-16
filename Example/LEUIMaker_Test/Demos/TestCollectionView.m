//
//  TestCollectionView.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/12/3.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "TestCollectionView.h"
#import "LEHUD.h"


@interface TestItem : LECollectionItem
@end
@implementation TestItem{
    UILabel *label;
}
-(void) leExtraInits{
    self.backgroundView=[UIView new].leBgColor(LEColorMask2);
    self.selectedBackgroundView=[UIView new].leBgColor(LEColorMask5);
    label=[UILabel new].leAddTo(self.contentView).leAnchor(LEInsideCenter).leCenterAlign;
}
-(void) leSetData:(id)data IndexPath:(NSIndexPath *)path{
    [super leSetData:data IndexPath:path];
    label.leText(data);
}
@end


@interface TestCollectionViewPage : LEView<LECollectionDelegate,LECollectionDataSource>
@end
@implementation TestCollectionViewPage{
    LECollectionViewWithRefresh *collection;
    BOOL isDataLoaded;
}
-(void) leExtraInits{
    [LENavigation new].leSuperView(self).leTitle(NSStringFromClass(self.class));
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake((LESCREEN_WIDTH-LESideSpace16*4)*1.0/3, LENavigationBarHeight);
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    layout.sectionInset=UIEdgeInsetsMake(LESideSpace16, LESideSpace16, LESideSpace16, LESideSpace16);
    
    collection=[LECollectionViewWithRefresh alloc].leInit(self.leSubViewContainer,layout,@"TestItem").leDelegate(self).leDataSource(self);
    [collection leOnRefreshedWithData:[@[@"点击我"] mutableCopy]];
}
-(void) leOnRefreshDataForCollection{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *muta=[NSMutableArray new];
        for (NSInteger i=0; i<20; i++) {
            [muta addObject:[NSString stringWithFormat:@"第%zd个item",i+1]];
        }
        [collection leOnRefreshedWithData:muta];
    });
}
-(void) leOnLoadMoreForCollection{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *muta=[NSMutableArray new];
        for (NSInteger i=0; i<rand()%30; i++) {
            [muta addObject:[NSString stringWithFormat:@"第%zd个item",i]];
        }
        [collection leOnLoadedMoreWithData:muta];
    });
}
-(void) leOnItemEventWithInfo:(NSDictionary *)info{
    if(!isDataLoaded){
        [collection leOnAutoRefresh];
        isDataLoaded=YES;
    }
    [LEHUD leShowHud:[NSString stringWithFormat:@"leOnItemEventWithInfo:%zd",[[info objectForKey:LEKeyIndex] row]]];
}
@end
@implementation TestCollectionView
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self leDidRotateFrom:fromInterfaceOrientation];
}
@end
