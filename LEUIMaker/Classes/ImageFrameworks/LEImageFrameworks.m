//
//  LEImageFrameworks.m
//  Pods
//
//  Created by emerson larry on 2017/1/7.
//
//

#import "LEImageFrameworks.h"
@interface LEImageFrameworks ()
@property (nonatomic, weak) id<LEImageFrameworksDelegate> curDelegate;
@end
@implementation LEImageFrameworks
LESingleton_implementation(LEImageFrameworks)
-(void) leSetDelegate:(id<LEImageFrameworksDelegate>)delegate{
    self.curDelegate=delegate;
}
-(void) leCancleImageDonwloading:(UIImageView *) view{
    if(self.curDelegate&&[self.curDelegate respondsToSelector:@selector(leOnCancleImageDownloading:)]){
        [self.curDelegate leOnCancleImageDownloading:view];
    }
}
-(UIImage *) leGetImageFromCacheWithURL:(NSString *) url{
    if(self.curDelegate&&[self.curDelegate respondsToSelector:@selector(leOnGetImageFromCacheWithURL:)]){
        return [self.curDelegate leOnGetImageFromCacheWithURL:url];
    }
    return nil;
}
-(void) leOnDownloadImageWithURL:(NSString *) url For:(UIImageView *) view Completion:(LEImageCompletionBlock) block{
    if(self.curDelegate&&[self.curDelegate respondsToSelector:@selector(leOnDownloadImageWithURL:For:Completion:)]){
        [self.curDelegate leOnDownloadImageWithURL:url For:view Completion:block];
    }
}
@end

@implementation UIImageView (LEExtensileOnDownload)
static void * UIImageViewPlaceHolderKey = (void *) @"UIImageViewPlaceHolder";
- (UIImage *) lePlaceholderImage {
    return objc_getAssociatedObject(self, UIImageViewPlaceHolderKey);
}
- (void) setLePlaceholderImage:(UIImage *)lePlaceholderImage{
    objc_setAssociatedObject(self, UIImageViewPlaceHolderKey, lePlaceholderImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC); 
}
static void * UIImageDownloadDelegateKey = (void *) @"UIImageDownloadDelegateKey";
-(id<LEImageDownloadDelegate>) leImageDownloadDelegate{
    return objc_getAssociatedObject(self, UIImageDownloadDelegateKey);
}
-(void) setLeImageDownloadDelegate:(id<LEImageDownloadDelegate>)leImageDownloadDelegate{
    objc_setAssociatedObject(self, UIImageDownloadDelegateKey, leImageDownloadDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(__kindof UIImageView *(^)(NSString *url)) leDownloadWithURL{
    return ^id(NSString *value){
        [self leDownloadWithURL:value];
        return self;
    };
}
-(__kindof UIImageView *(^)(NSString *url)) leQiniuImageWithURL{
    return ^id(NSString *value){
        [self leQiniuImageWithURL:value];
        return self;
    };
}
-(__kindof UIImageView *(^)(NSString *url, float w, float h)) leQiniuImageWithURLAndSize{
    return ^id(NSString *url, float w, float h){
        [self leQiniuImageWithURL:url Width:w Height:h];
        return self;
    };
}
-(__kindof UIImageView *(^)(UIImage *image)) lePlaceholder{
    return ^id(UIImage *value){
        [self lePlaceholder:value];
        return self;
    };
}
-(__kindof UIImageView *(^)(id<LEImageDownloadDelegate>)) leDelegate{
    return ^id(id<LEImageDownloadDelegate> value){
        [self leSetImageDownloadDelegate:value];
        return self;
    };
} 
-(void) leQiniuImageWithURL:(NSString *) url Width:(float)w Height:(float) h{
    [self leDownloadWithURL:[NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",url,(int)(w)*LESCREEN_SCALE_INT,(int)h*LESCREEN_SCALE_INT]];
}
-(void) leQiniuImageWithURL:(NSString *) url{
    [self leDownloadWithURL:[NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",url,(int)(self.bounds.size.width)*LESCREEN_SCALE_INT,(int)(self.bounds.size.height)*LESCREEN_SCALE_INT]];
}
-(void) leDownloadWithURL:(NSString *) url {
    if(url){
        [[LEImageFrameworks sharedInstance] leCancleImageDonwloading:self];
        UIImage *img=[[LEImageFrameworks sharedInstance] leGetImageFromCacheWithURL:url];
        if(img){
            [self setImage:img];
            if(CGSizeEqualToSize(self.bounds.size, CGSizeZero)){
                self.leSize(img.size);
            }
            if(self.leImageDownloadDelegate&&[self.leImageDownloadDelegate respondsToSelector:@selector(leOnDownloadedImageWith:)]){
                [self.leImageDownloadDelegate leOnDownloadedImageWith:img];
            }
        }else{
            LEWeakSelf(self);
            [[LEImageFrameworks sharedInstance] leOnDownloadImageWithURL:url For:self Completion:^(UIImage *image, NSError *error) {
                if(error){
                    if(weakself.leImageDownloadDelegate&&[weakself.leImageDownloadDelegate respondsToSelector:@selector(leOnDownloadImageWithError:)]){
                        [weakself.leImageDownloadDelegate leOnDownloadImageWithError:error];
                    }
                }else if(image){
                    if(weakself.leImageDownloadDelegate&&[weakself.leImageDownloadDelegate respondsToSelector:@selector(leOnDownloadedImageWith:)]){
                        [weakself.leImageDownloadDelegate leOnDownloadedImageWith:image];
                    }
                }
            }];
        }
    }
}
-(void) lePlaceholder:(UIImage *)image{
    self.lePlaceholderImage=image;
}
-(void) leSetImageDownloadDelegate:(id<LEImageDownloadDelegate>) delegate{
    self.leImageDownloadDelegate=delegate;
} 
@end



