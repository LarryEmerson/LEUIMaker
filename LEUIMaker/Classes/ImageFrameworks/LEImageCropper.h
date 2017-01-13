//
//  LEImageCropper.h
//  Pods
//
//  Created by emerson larry on 2017/1/12.
//
//

#import "LEViewAdditions.h"
#import "LEUICommon.h"
#import "LEViewController.h"

@protocol LEImageCropperDelegate <NSObject>
- (void)leOnDoneCroppedWithImage:(UIImage *)image;
@optional
- (void)leOnCancelImageCropper;
@end

@interface LEImageCropper : LEViewController
/** 参数：切割图片对象、切割高宽比、圆角、回调 */
-(id) initWithImage:(UIImage *) image Aspect:(float) aspect Radius:(float) radius Delegate:(id<LEImageCropperDelegate>) delegate;
@end
