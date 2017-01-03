//
//  TestImagePicker.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/12/21.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "TestImagePicker.h"

@interface TestImagePickerItem : LECollectionItem
@end
@implementation TestImagePickerItem{
    UIImageView *curIcon;
    UIView *checkStatus;
}
-(void) leExtraInits{
    curIcon=[UIImageView new].leAddTo(self).leMargins(UIEdgeInsetsZero).leMaxWidth(self.bounds.size.width).leMaxHeight(self.bounds.size.height);
    curIcon.contentMode=UIViewContentModeScaleAspectFill;
    curIcon.clipsToBounds=YES; 
}
-(void) onSetSelection:(BOOL) value{
    checkStatus.hidden=!value;
}
-(void) leSetData:(id)data{
    if([data isKindOfClass:[UIImage class]]){
        [curIcon setImage:data];
    }else{
        PHAsset *asset=data;
        [[LEImagePickerManager sharedInstance] leGetImageByAsset:asset makeSize:CGSizeMake(curIcon.bounds.size.width*LESCREEN_SCALE, curIcon.bounds.size.height*LESCREEN_SCALE) makeResizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage * value) {
            curIcon.leImageWithSize(value,curIcon.bounds.size);
        }];
    }
}
@end

@interface TestImagePickerPage : LEView<LEImagePickerDelegate,LENavigationDelegate>
@end
@implementation TestImagePickerPage{
    NSArray<PHAsset *> *curSelected;
    LECollectionView *collectionView;
    NSMutableArray *curDataSource;
}
-(void) leExtraInits{
    curDataSource=[NSMutableArray new];
    [LENavigation new].leSuperView(self).leTitle(@"随机最大照片数量").leRightItemText(@"有序添加").leDelegate(self);
    float cellSize=(LESCREEN_WIDTH-LESideSpace*5)*0.25;
    UICollectionViewFlowLayout *layout=[UICollectionViewFlowLayout new];
    layout.itemSize=CGSizeMake(cellSize,cellSize);
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing=LESideSpace;
    layout.minimumLineSpacing=LESideSpace;
    layout.sectionInset=UIEdgeInsetsMake(LESideSpace, LESideSpace, LESideSpace, LESideSpace);
    collectionView=[LECollectionView alloc].leInit(self.leSubViewContainer, layout, @"TestImagePickerItem");
    [collectionView leOnRefreshedWithData:curSelected.mutableCopy];
}
-(void) leNavigationRightButtonTapped{
//    LEImagePicker *picker=[LEImagePicker new].leInit(self.leViewController,self);
//    picker.leMaxCount(MAX(curSelected.count, rand()%10)).leSelectedAssets(curSelected);
    NSInteger ran=rand()%10;
    NSInteger max=MAX(curDataSource.count+1, ran);
    [[LEImagePickerManager sharedInstance] leShowTypeSelectionWithTitle:@"选择图片" Camera:YES Ablum:YES Remain:max-curDataSource.count Max:max Assets:curSelected Delegate:self VC:self.leViewController];
}
-(void) leOnImageAssetPickedWith:(NSArray *)assets{
    curSelected=assets;
    for (NSInteger i=curDataSource.count-1;i>=0; i--) {
        id obj=[curDataSource objectAtIndex:i];
        if(![obj isKindOfClass:[UIImage class]]){
            if(![assets containsObject:obj]){
                [curDataSource removeObjectAtIndex:i];
            }
        }
    }
    for (NSInteger i=0; i<assets.count; i++) {
        PHAsset *asset=[assets objectAtIndex:i];
        if(![curDataSource containsObject:asset]){
            [curDataSource addObject:asset];
        }
    }
    [collectionView leOnRefreshedWithData:curDataSource];
}
-(void) leOnImagePickedWith:(UIImage *) image{
    [curDataSource addObject:image];
    [collectionView leOnRefreshedWithData:curDataSource];
}
-(void) leOnShowMessage:(NSString *) message{ 
    [LEHUD leShowHud:message];
}
@end
@implementation TestImagePicker
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
