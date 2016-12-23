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
    PHAsset *asset=data;
    [[LEImagePickerManager sharedInstance] leGetImageByAsset:asset makeSize:CGSizeMake(curIcon.bounds.size.width*LESCREEN_SCALE, curIcon.bounds.size.height*LESCREEN_SCALE) makeResizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage * value) {
        curIcon.leImage(value);
    }];
}
@end


@interface TestImagePickerPage : LEView<LEImagePickerDelegate,LENavigationDelegate>
@end
@implementation TestImagePickerPage{
    NSArray<PHAsset *> *curSelected;
    LECollectionView *collectionView;
}
-(void) leExtraInits{
    [LENavigation new].leSuperView(self).leTitle(@"最大照片数量随机生成").leRightItemText(@"有序添加").leDelegate(self);
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
    [[LEImagePickerManager sharedInstance] leShowTypeSelectionWithTitle:@"选择图片" Camera:YES Ablum:YES Remain:0 Max:MAX(curSelected.count, rand()%10) Assets:curSelected Delegate:self VC:self.leViewController];
}
-(void) leOnImageAssetPickedWith:(NSArray *)assets{
    curSelected=assets;
    [collectionView leOnRefreshedWithData:curSelected.mutableCopy];
}
-(void) leOnShowMessage:(NSString *) message{ 
    [LEHUD leShowHud:message];
}
@end
@implementation TestImagePicker @end
