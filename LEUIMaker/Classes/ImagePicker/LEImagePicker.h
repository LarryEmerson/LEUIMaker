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
/** 回调已选择的assets */
-(void) leOnImageAssetPickedWith:(NSArray *)assets;
/** 回调拍照图片 */
-(void) leOnImagePickedWith:(UIImage *)image;
/** 回调弹出提示 */
-(void) leOnShowMessage:(NSString *) message;
@end

@interface LEImagePicker : LEViewController
/** 初始化：viewController、delegate */
-(__kindof LEImagePicker *(^)(UIViewController *vc, id<LEImagePickerDelegate> delegate)) leInit;
/** 设置剩余选择数量 */
-(__kindof LEImagePicker *(^)(NSInteger count)) leRemainCount;
/** 设置最大数量 */
-(__kindof LEImagePicker *(^)(NSInteger count)) leMaxCount;
/** 设置已选中assets */
-(__kindof LEImagePicker *(^)(NSArray<PHAsset *> *assets)) leSelectedAssets;
@end

@interface LEImagePickerManager : NSObject
@property (nonatomic, weak) id<LEImagePickerDelegate> leDelegate;
@property (nonatomic, weak) UIViewController *leVC;

LESingleton_interface(LEImagePickerManager)
/** 弹出相册相机选择页面后，根据选择内容回调：选择界面标题、是否允许相机、是否允许相册、剩余可选择数量、最大选择数量、已选择资源（PHAsset）、delegate回调、vc（用于弹出相册或相机界面） */
-(void) leShowTypeSelectionWithTitle:(NSString *) title Camera:(BOOL) camera Ablum:(BOOL) ablum Remain:(NSInteger) remain Max:(NSInteger) max Assets:(NSArray<PHAsset *> *)assets Delegate:(id<LEImagePickerDelegate>) delegate VC:(UIViewController *) vc;
/** 相册权限 */
-(BOOL) leAlbumAuthority;
/** 相机权限 */
-(BOOL) leCameraAuthority;
/** 相册权限未决定（初次使用app） */
-(BOOL) leAlbumAuthorityNotDetermined;
/** 相机权限未决定（初次使用app） */
-(BOOL) leCameraAuthorityNotDetermined;
/** 根据PHAsset及size、mode获取UIImage */
-(void) leGetImageByAsset:(PHAsset *)asset makeSize:(CGSize)size makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *))completion;
-(NSArray<PHFetchResult *> *) leGetAlbums;
-(NSArray<PHAsset *> *) leGetAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;
-(PHFetchResult *) leFetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;
@end
