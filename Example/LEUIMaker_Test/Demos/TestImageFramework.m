//
//  TestImageFramework.m
//  LEUIMaker
//
//  Created by emerson larry on 2017/1/7.
//  Copyright © 2017年 LarryEmerson. All rights reserved.
//

#import "TestImageFramework.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface TestImageFramework ()<LEImageFrameworksDelegate>
@end
@implementation TestImageFramework{
}
-(void) leOnCancleImageDownloading:(UIImageView *) view{
    [view sd_cancelCurrentAnimationImagesLoad];
}
-(UIImage *) leOnGetImageFromCacheWithURL:(NSString *) url{
    UIImage *img=[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
    if(!img){
        img=[[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:url];
    }
    return img;
}
-(void) leOnDownloadImageWithURL:(NSString *) url For:(UIImageView *) view Completion:(LEImageCompletionBlock) block{
    [view sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:view.lePlaceholderImage options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        block(image,error);
    }];
}
-(void) leAdditionalInits{
    [[LEImageFrameworks sharedInstance] leSetDelegate:self];
    LEView *view=[LEView new].leSuperViewcontroller(self);
    [LENavigation new].leSuperView(view).leTitle(@"测试TestImageFramework");
    view.leSubViewContainer.leBgColor(LEColorBG5);
    UIImageView *img= [UIImageView new].leAddTo(view.leSubViewContainer).leAnchor(LEI_TC).leBgColor(LEColorTest);
    img.leDownloadWithURL(@"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png");
    UIImageView *imgHolder= [UIImageView new].leAddTo(view.leSubViewContainer).leAnchor(LEI_BC).leSize(LESquareSize(100)).leBgColor(LEColorWhite);
    imgHolder.lePlaceholder([LEColorTest leImageWithSize:LESquareSize(80)]).leDownloadWithURL(@"https://xxx.png");
    
    
}

@end
