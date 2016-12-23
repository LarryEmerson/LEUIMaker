//
//  LEImagePicker.m
//  Pods
//
//  Created by emerson larry on 2016/12/19.
//
//

#import "LEImagePicker.h"
#define LEImagePickerCheckbox @"check"
#define LEImagePickerCellAsset @"asset"
#define LEImagePickerPopup @"popup"
@interface LEMultiImagePickerItem : LECollectionItem
@end
@implementation LEMultiImagePickerItem{
    UIImageView *curIcon;
    UIView *checkStatus;
}
-(void) leExtraInits{
    curIcon=[UIImageView new].leAddTo(self).leMargins(UIEdgeInsetsZero).leMaxWidth(self.bounds.size.width).leMaxHeight(self.bounds.size.height);
    curIcon.contentMode=UIViewContentModeScaleAspectFill;
    curIcon.clipsToBounds=YES;
    checkStatus=[UIView new].leAddTo(curIcon).leMargins(UIEdgeInsetsZero).leBgColor([UIColor colorWithWhite:0.8 alpha:0.5]);
    [UIImageView new].leAddTo(checkStatus).leAnchor(LEI_TR).leTop(5).leRight(5).leImage([LEUICommon sharedInstance].leMultiImagePickerCheckbox);
    checkStatus.hidden=YES;
}
-(void) onSetSelection:(BOOL) value{
    checkStatus.hidden=!value;
}
-(void) leSetData:(id)data{
    NSMutableDictionary *dic=data;
    BOOL check=[[dic objectForKey:LEImagePickerCheckbox] boolValue];
    PHAsset *asset=[dic objectForKey:LEImagePickerCellAsset];
    [[LEImagePickerManager sharedInstance] leGetImageByAsset:asset makeSize:CGSizeMake(curIcon.bounds.size.width*LESCREEN_SCALE, curIcon.bounds.size.height*LESCREEN_SCALE) makeResizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage * value) {
        curIcon.leImage(value);
    }];
    checkStatus.hidden=!check;
}
@end
@interface LEMultiImagePicker : LEViewController<LENavigationDelegate,LECollectionDelegate>
@end
@implementation LEMultiImagePicker{
    __weak id<LEImagePickerDelegate> curDelegate;
    LECollectionView *collectionView;
    NSInteger curRemainCount;
    NSInteger curMaxCount;
    NSMutableArray *curArray;
    BOOL hasMaxCount;
    UILabel *labelCount;
    NSMutableArray *curSelections;
}
-(id) initWithCollection:(PHCollection *) collection Remain:(NSInteger) remain Max:(NSInteger) max Assets:(NSArray<PHAsset *> *)assets Delegate:(id<LEImagePickerDelegate>) delegate{
    self=[super init];
    curDelegate=delegate;
    curRemainCount=remain;
    curMaxCount=max;
    hasMaxCount=max!=INT_MAX&&(!(curRemainCount==1&&curMaxCount==1));
    LEView *view=[[LEView alloc] initWithViewController:self];
    [LENavigation new].leSuperView(view).leDelegate(self).leTitle([[LEImagePickerManager sharedInstance] leTransformAblumTitle:collection.localizedTitle]).leRightItemText(@"完成");
    view.leSubViewContainer.leBgColor(LEColorBG5);
    float cellSize=(LESCREEN_WIDTH-LESideSpace*5)*0.25; 
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake(cellSize,cellSize);
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing=LESideSpace;
    layout.minimumLineSpacing=LESideSpace;
    layout.sectionInset=UIEdgeInsetsMake(LESideSpace, LESideSpace, (hasMaxCount?LEBottomTabbarHeight:0)+LESideSpace, LESideSpace);
    collectionView=[LECollectionView alloc].leInit(view.leSubViewContainer, layout, @"LEMultiImagePickerItem").leDelegate(self);
    curArray=[NSMutableArray new];
    NSArray *array=[[LEImagePickerManager sharedInstance] leGetAssetsInAssetCollection:collection ascending:NO];
    curSelections=[NSMutableArray new];
    for (NSInteger i=0; i<array.count; i++) {
        PHAsset *asset=[array objectAtIndex:i];
        NSMutableDictionary *dic=[NSMutableDictionary new];
        if(assets&&[assets containsObject:asset]){
            [curSelections addObject:@(i)];
            [dic setObject:@(YES) forKey:LEImagePickerCheckbox];
        }else{
            [dic setObject:@(NO) forKey:LEImagePickerCheckbox];
        }
        [dic setObject:asset forKey:LEImagePickerCellAsset];
        [curArray addObject:dic];
    }
    [collectionView leOnRefreshedWithData:curArray];
    if(hasMaxCount){
        UIView *btm=[UIView new].leAddTo(view.leSubViewContainer).leAnchor(LEI_BC).leSize(CGSizeMake(LESCREEN_WIDTH, LEBottomTabbarHeight)).leBgColor(LEColorWhite).leAddTopSplitline(LEColorSplitline,0,LESCREEN_WIDTH);
        labelCount=[UILabel new].leAddTo(btm).leAnchor(LEI_C).leFont(LEBoldFont(LEFontLL)).leColor(LEColorBlack).leText([NSString stringWithFormat:@"%zd/%zd",curMaxCount-curRemainCount,curMaxCount]);
    }
    
    return self;
}
-(void) leNavigationRightButtonTapped{
    NSMutableArray *muta=[NSMutableArray new];
    for (NSInteger i=0; i<curSelections.count; i++) {
        NSInteger index=[[curSelections objectAtIndex:i] integerValue];
        if(index<curArray.count){
            [muta addObject:[[curArray objectAtIndex:index] objectForKey:LEImagePickerCellAsset]];
        }
    }
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnImageAssetPickedWith:)]){
        [curDelegate leOnImageAssetPickedWith:muta];
    }
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:LEImagePickerPopup object:nil];
}
-(void) leOnItemEventWithInfo:(NSDictionary *) info{
    NSIndexPath *index=[info objectForKey:LEKeyIndex];
    if(index.row<curArray.count){
        NSMutableDictionary *dic=[curArray objectAtIndex:index.row];
        BOOL check=[[dic objectForKey:LEImagePickerCheckbox] boolValue];
        if(check||curRemainCount>0){
            if(check){
                for (NSInteger i=0; i<curSelections.count; i++) {
                    NSInteger ind=[[curSelections objectAtIndex:i] integerValue];
                    if(ind==index.row){
                        [curSelections removeObjectAtIndex:i];
                        break;
                    }
                }
            }else{
                [curSelections addObject:@(index.row)];
            }
            [dic setObject:@(!check) forKey:LEImagePickerCheckbox];
            [collectionView reloadItemsAtIndexPaths:@[index]];
            curRemainCount+=(check?1:-1);
            if(labelCount){
                labelCount.leText([NSString stringWithFormat:@"%zd/%zd",curMaxCount-curRemainCount,curMaxCount]);
            }
        }
    }
}
@end

@interface LEAlbumCell : LETableViewCell
@property (nonatomic) NSMutableArray *imagesAssetArray;
@end
@implementation LEAlbumCell{
    UIImageView *curIcon;
    UILabel *curTitle;
    UILabel *curSubtitle;
    int cellH;
}
-(void) leExtraInits{
    cellH=80;
    UIView *container=[UIView new].leAddTo(self).leAnchor(LEI_TL).leEqualSuperViewWidth(1).leHeight(cellH);
    curIcon=[UIImageView new].leAddTo(container).leAnchor(LEI_LC).leLeft(LESideSpace20).leWidth(cellH-LESideSpace20).leHeight(cellH-LESideSpace20).leMaxWidth(cellH-LESideSpace20).leMaxHeight(cellH-LESideSpace20);
    curIcon.contentMode=UIViewContentModeScaleAspectFill;
    curIcon.clipsToBounds=YES;
    curTitle=[UILabel new].leAddTo(self).leAnchor(LEO_RC).leRelativeTo(curIcon).leLeft(LESideSpace).leFont(LEBoldFont(LEFontLL)).leLine(1);
    curSubtitle=[UILabel new].leAddTo(self).leAnchor(LEO_RC).leRelativeTo(curTitle).leLeft(LESideSpace).leFont(LEFont(LEFontML)).leLine(1).leColor(LEColorText9);
    self.leBottomView(container);
}
-(void) leSetData:(id)data  {
    if([data isKindOfClass:[PHAssetCollection class]]){
        PHAssetCollection *collection=data;
        PHFetchResult *result=[[LEImagePickerManager sharedInstance] leFetchAssetsInAssetCollection:collection ascending:NO];
        curTitle.leText([[LEImagePickerManager sharedInstance] leTransformAblumTitle:collection.localizedTitle]);
        curSubtitle.leText([NSString stringWithFormat:@"(%zd)", result.count]);
        [[LEImagePickerManager sharedInstance] leGetImageByAsset:result.firstObject makeSize:CGSizeMake(curIcon.bounds.size.width*LESCREEN_SCALE, curIcon.bounds.size.height*LESCREEN_SCALE) makeResizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage * value) {
            curIcon.leImage(value);
        }];
    }
}
@end
@interface LEImagePicker ()<LENavigationDelegate,LETableViewDelegate>
@end
@implementation LEImagePicker {
    __weak UIViewController *curVC;
    __weak id<LEImagePickerDelegate> curDelegate;
    NSArray *curArray;
    LETableView *tableView;
    NSInteger curRemainCount;
    NSInteger curMaxCount;
    NSArray<PHAsset *> *curSelectedAssets;
}
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LEImagePickerPopup object:nil];
} 
-(__kindof LEImagePicker *(^)(UIViewController *vc, id<LEImagePickerDelegate> delegate)) leInit{
    return ^id(UIViewController *vc, id<LEImagePickerDelegate> delegate){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lePop) name:LEImagePickerPopup object:nil];
        curRemainCount=INT_MAX;
        curMaxCount=INT_MAX;
        curVC=vc;
        curDelegate=delegate;
        LEView *view=[[LEView alloc] initWithViewController:self];
        [LENavigation new].leSuperView(view).leDelegate(self).leTitle(@"相册");
        tableView=[LETableView new].leSuperView(view.leSubViewContainer).leDelegate(self).leDataSource(self).leCellClassname(@"LEAlbumCell");
        if([LEImagePickerManager sharedInstance].leAlbumAuthorityNotDetermined){
            LEWeakSelf(self)
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if(status==PHAuthorizationStatusAuthorized){
                    [weakself checkAuthority];
                }
            }];
        }else{
            [self checkAuthority];
        }
        return self;
    };
}
-(void) checkAuthority{
    if([LEImagePickerManager sharedInstance].leAlbumAuthority){
        curArray=[[LEImagePickerManager sharedInstance] leGetAlbums];
        [tableView leOnRefreshedWithData:curArray.mutableCopy];
        if(curVC.navigationController){
            [curVC lePush:self];
        }else{
            [curVC presentViewController:self animated:YES completion:nil];
        }
    }else{
        if(curVC.navigationController){
            [self lePop];
        }else{
            [curVC dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
-(void) leOnCellEventWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:LEKeyIndex];
    if(index.row<curArray.count){
        PHAssetCollection *collection=[curArray objectAtIndex:index.row];
        [self lePush:[[LEMultiImagePicker alloc] initWithCollection:collection Remain:curRemainCount Max:curMaxCount Assets:curSelectedAssets Delegate:curDelegate]];
    }
}
-(__kindof LEImagePicker *(^)(NSInteger count)) leRemainCount{
    return ^id(NSInteger value){
        curRemainCount=value;
        return self;
    };
}
-(__kindof LEImagePicker *(^)(NSInteger count)) leMaxCount{
    return ^id(NSInteger value){
        curMaxCount=value;
        if(curSelectedAssets){
            curRemainCount=value-curSelectedAssets.count;
        }
        return self;
    };
}
-(__kindof LEImagePicker *(^)(NSArray<PHAsset *> *assets)) leSelectedAssets{
    return ^id(NSArray<PHAsset *> *value){
        curSelectedAssets=value;
        if(value){
            curRemainCount=curMaxCount-value.count;
        }else{
            curRemainCount=curMaxCount;
        }
        return self;
    };
}
@end

@implementation LEImagePickerManager{
    UIAlertController *alert;
}
LESingleton_implementation(LEImagePickerManager)
-(void) leShowTypeSelectionWithTitle:(NSString *) title Camera:(BOOL) camera Ablum:(BOOL) ablum Remain:(NSInteger) remain Max:(NSInteger) max Assets:(NSArray<PHAsset *> *)assets Delegate:(id<LEImagePickerDelegate>) delegate VC:(UIViewController *) vc{
    self.leDelegate=delegate;
    self.leVC=vc;
    alert=[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ablumAction = nil;
    if(ablum){
        LEWeakSelf(self)
        ablumAction=[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if([LEImagePickerManager sharedInstance].leAlbumAuthorityNotDetermined){
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if(status==PHAuthorizationStatusAuthorized){
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [LEImagePicker new].leInit(weakself.leVC,weakself.leDelegate).leRemainCount(remain).leMaxCount(max).leSelectedAssets(assets);
                        });
                    }
                }];
            }else if ([LEImagePickerManager sharedInstance].leAlbumAuthority) {
                [LEImagePicker new].leInit(weakself.leVC,weakself.leDelegate).leRemainCount(remain).leMaxCount(max).leSelectedAssets(assets);
            }else{
                if(weakself.leDelegate&&[weakself.leDelegate respondsToSelector:@selector(leOnShowMessage:)]){
                    NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
                    NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
                    [weakself.leDelegate leOnShowMessage: [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的相册", appName]];
                }
            }
        }];
    }
    UIAlertAction * cameraAction=nil;
    if(camera){
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            cameraAction=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if([LEImagePickerManager sharedInstance].leCameraAuthorityNotDetermined){
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        if(granted){
                            //                      [self takePhotoFromiPhone];
                        }
                    }];
                }else if ([LEImagePickerManager sharedInstance].leCameraAuthority) {
                    //                [self takePhotoFromiPhone];
                }else{
                    if([LEImagePickerManager sharedInstance].leDelegate&&[[LEImagePickerManager sharedInstance].leDelegate respondsToSelector:@selector(leOnShowMessage:)]){
                        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
                        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
                        [[LEImagePickerManager sharedInstance].leDelegate leOnShowMessage: [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的相机", appName]];
                    }
                }
            }];
        }
    }
    if(ablumAction){
        [alert addAction:ablumAction];
    }
    if(cameraAction){
        [alert addAction:cameraAction];
    }
    [alert addAction:cancleAction];
    [vc presentViewController:alert animated:YES completion:nil];
}
-(BOOL) leAlbumAuthorityNotDetermined{  
    return [PHPhotoLibrary authorizationStatus]==PHAuthorizationStatusNotDetermined;
}
-(BOOL) leAlbumAuthority{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}
-(BOOL) leCameraAuthorityNotDetermined{
    return [PHPhotoLibrary authorizationStatus]==AVAuthorizationStatusNotDetermined;
}
-(BOOL) leCameraAuthority{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}
-(NSArray<PHAsset *> *) leGetAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    PHFetchResult *result = [self leFetchAssetsInAssetCollection:assetCollection ascending:ascending];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:obj];
    }];
    return arr;
}
-(PHFetchResult *) leFetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    return [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
}
-(NSArray<PHAssetCollection *> *) leGetAlbums{
    NSMutableArray<PHAssetCollection *> * albums = [NSMutableArray array];
    PHFetchResult * smartAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbum enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!([collection.localizedTitle isEqualToString:@"Recently Deleted"] || [collection.localizedTitle isEqualToString:@"Videos"])) {
            PHFetchResult * result = [self leFetchAssetsInAssetCollection:collection ascending:YES];
            if (result.count > 0) {
                [albums addObject:collection];
            }
        }
    }];
    PHFetchResult * userAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbum enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult *result = [self leFetchAssetsInAssetCollection:collection ascending:YES];
        if (result.count > 0) {
            [albums addObject:collection];
        }
    }];
    return albums;
}

-(NSString *) leTransformAblumTitle:(NSString *)title{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }else if ([title isEqualToString:@"My Photo Stream"]){
        return @"我的照片流";
    }
    return nil;
}
-(void) leGetImageByAsset:(PHAsset *)asset makeSize:(CGSize)size makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *))completion{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    option.resizeMode = resizeMode;//控制照片尺寸
    //option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    //option.synchronous = YES;
    option.networkAccessAllowed = YES;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        completion(image);
    }];
}
@end
