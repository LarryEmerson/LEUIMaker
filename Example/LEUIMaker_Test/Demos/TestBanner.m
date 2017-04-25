
//
//  TestBanner.m
//  LEUIMaker
//
//  Created by emerson larry on 2017/1/11.
//  Copyright © 2017年 LarryEmerson. All rights reserved.
//

#import "TestBanner.h"
#import "LEUICommon.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface TestBannerCell :LEBannerView
@end
@implementation TestBannerCell{
    
}
-(void) leAdditionalInits{
    [self setContentMode:UIViewContentModeScaleAspectFit];
}
-(void) leSetData:(id)data{ 
    self.leDownloadWithURL(data);
}
@end


@interface TestBanner ()<LEBannerDelegate,LEImageFrameworksDelegate>
@end
@implementation TestBanner{
    UIView *bannerContainer;
    LEBanner *banner;
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
    [LENavigation new].leSuperView(view).leTitle(@"测试LEBanner");
    bannerContainer=[UIView new].leAddTo(view.leSubViewContainer).leAnchor(LEI_TC).leEqualSuperViewWidth(1).leHeightEqualWidth(0.5);
    banner=[LEBanner new].leSuperview(bannerContainer,@"TestBannerCell",LEBannerLandscape,self).leDelay(1).leBgColor(LEColorMask5);
    [banner leReloadBannerWithData:@[
                                     @"https://avatars2.githubusercontent.com/u/4223389?v=3&s=460",
                                     @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png",
                                     @"https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png",
                                     ]];
    [banner leScroll];
}
-(void) leDidTapBanner:(LEBanner *)banner Index:(NSInteger)index Data:(NSDictionary *)data{
    LELogInteger(index)
    LELogObject(data)
    [LEHUD leShowHud:[NSString stringWithFormat:@"%zd-%@",index,data]];
}

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

-(void) leDidRotateFrom:(UIInterfaceOrientation)from{
    [super leDidRotateFrom:from];
    [banner leDidRotateFrom:from];
}
@end
