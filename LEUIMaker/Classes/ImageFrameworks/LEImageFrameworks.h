//
//  LEImageFrameworks.h
//  Pods
//
//  Created by emerson larry on 2017/1/7.
//
//

#import <Foundation/Foundation.h>
#import "LEUICommon.h"
#import <objc/runtime.h> 
#import "LEViewAdditions.h"
typedef void(^LEImageCompletionBlock)(UIImage *image, NSError *error);

@protocol LEImageFrameworksDelegate <NSObject>
-(void) leOnCancleImageDownloading:(UIImageView *) view;
-(UIImage *) leOnGetImageFromCacheWithURL:(NSString *) url;
-(void) leOnDownloadImageWithURL:(NSString *) url For:(UIImageView *) view Completion:(LEImageCompletionBlock) block;
@end

@protocol LEImageDownloadDelegate <NSObject>
-(void) leOnDownloadImageWithError:(NSError *) error;
-(void) leOnDownloadedImageWith:(UIImage *) image;
@end

@interface UIImageView (LEExtension)
@property (nonatomic) UIImage *lePlaceholderImage;
@property (nonatomic) id<LEImageDownloadDelegate> leImageDownloadDelegate;

-(__kindof UIImageView *(^)(NSString *url)) leDownloadWithURL;
-(__kindof UIImageView *(^)(NSString *url)) leQiniuImageWithURL;
-(__kindof UIImageView *(^)(NSString *url, float w, float h)) leQiniuImageWithURLAndSize;
-(__kindof UIImageView *(^)(UIImage *image)) lePlaceholder;
-(__kindof UIImageView *(^)(id<LEImageDownloadDelegate>)) leDelegate;
/** 以下接口 */
-(void) leDownloadWithURL:(NSString *) url;
-(void) leQiniuImageWithURL:(NSString *) url Width:(float) w Height:(float) h;
-(void) leQiniuImageWithURL:(NSString *) url;
-(void) lePlaceholder:(UIImage *) image;
-(void) leSetImageDownloadDelegate:(id<LEImageDownloadDelegate>) delegate;
@end

@interface LEImageFrameworks : NSObject
LESingleton_interface(LEImageFrameworks)
-(void) leSetDelegate:(id<LEImageFrameworksDelegate>) delegate;
@end
