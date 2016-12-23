//
//  LEImagePicker.h
//  Pods
//
//  Created by emerson larry on 2016/12/19.
//
//

#import "LEViewAdditions.h"
#import "LEUICommon.h"
#import "LEViewController.h"
#import <Photos/Photos.h>
#import "LETableView.h"
#import "LECollectionView.h"

@protocol LEImagePickerDelegate <NSObject>
@optional 
-(void) leOnImageAssetPickedWith:(NSArray *)assets;
-(void) leOnShowMessage:(NSString *) message;
@end

@interface LEImagePicker : LEViewController

-(__kindof LEImagePicker *(^)(UIViewController *vc, id<LEImagePickerDelegate> delegate)) leInit;
-(__kindof LEImagePicker *(^)(NSInteger count)) leRemainCount;
-(__kindof LEImagePicker *(^)(NSInteger count)) leMaxCount;
-(__kindof LEImagePicker *(^)(NSArray<PHAsset *> *assets)) leSelectedAssets;
@end

@interface LEImagePickerManager : NSObject
@property (nonatomic, weak) id<LEImagePickerDelegate> leDelegate;
@property (nonatomic, weak) UIViewController *leVC;

LESingleton_interface(LEImagePickerManager)
-(void) leShowTypeSelectionWithTitle:(NSString *) title Camera:(BOOL) camera Ablum:(BOOL) ablum Remain:(NSInteger) remain Max:(NSInteger) max Assets:(NSArray<PHAsset *> *)assets Delegate:(id<LEImagePickerDelegate>) delegate VC:(UIViewController *) vc;
-(BOOL) leAlbumAuthority;
-(BOOL) leCameraAuthority;
-(BOOL) leAlbumAuthorityNotDetermined;
-(BOOL) leCameraAuthorityNotDetermined;
-(NSArray<PHFetchResult *> *) leGetAlbums;
-(NSArray<PHAsset *> *) leGetAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;
-(PHFetchResult *) leFetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;
-(NSString *) leTransformAblumTitle:(NSString *)title;
-(void) leGetImageByAsset:(PHAsset *)asset makeSize:(CGSize)size makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *))completion;
@end
