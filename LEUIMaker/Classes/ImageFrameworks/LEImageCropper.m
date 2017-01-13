//
//  LEImageCropper.m
//  Pods
//
//  Created by emerson larry on 2017/1/12.
//
//

#import "LEImageCropper.h"

@interface LEImageCropper ()<LENavigationDelegate,UIScrollViewDelegate>
@end
@implementation LEImageCropper{
    __weak id<LEImageCropperDelegate> curDelegate;
    LEView *curView;
    LENavigation *curNavi;
    UIImage *curImage;
    float curAspect;
    UIScrollView *scrollView;
    UIImageView *imageView;
    float curRadius;
}
-(id) initWithImage:(UIImage *) image Aspect:(float) aspect Radius:(float) radius Delegate:(id<LEImageCropperDelegate>) delegate{
    curDelegate=delegate;
    curImage=image;
    curAspect=aspect;
    curRadius=radius;
    self=[super init];
    return self;
}
-(void) leNavigationLeftButtonTapped{
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnCancelImageCropper)]){
        [curDelegate leOnCancelImageCropper];
    }
    [super lePop];
}
-(void) leNavigationRightButtonTapped{
    UIImage *image=[self captureView];
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnDoneCroppedWithImage:)]){
        [curDelegate leOnDoneCroppedWithImage:image];
    }
    [self lePop];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}
-(UIImage*)captureView{
    UIGraphicsBeginImageContextWithOptions(curView.leSubViewContainer.frame.size,NO,[[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [curView.leSubViewContainer.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size,NO,[[UIScreen mainScreen] scale]);
    [img drawAtPoint:CGPointMake(0, -scrollView.frame.origin.y)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
-(void) leExtraInits{
    curView=[LEView new].leSuperViewcontroller(self);
    curNavi=[LENavigation new].leSuperView(curView).leDelegate(self).leLeftItemText(@"取消").leRightItemText(@"完成");
    curView.leSubViewContainer.backgroundColor=[UIColor colorWithRed:0.412 green:0.396 blue:0.409 alpha:1.000];
    scrollView=[UIScrollView new].leAddTo(curView.leSubViewContainer).leAnchor(LEI_C).leSize(CGSizeMake(LESCREEN_WIDTH, LESCREEN_WIDTH*curAspect));
    [scrollView setBackgroundColor:LEColorClear];
    [scrollView setDelegate:self];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    float minWA=LESCREEN_WIDTH/curImage.size.width;
    float minHA=curView.leSubViewContainer.bounds.size.height/curImage.size.height;
    float miniAspect=minWA>minHA?minWA:minHA;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, curImage.size.width, curImage.size.height)];
    [imageView setImage:curImage];
    [scrollView setContentSize:[imageView frame].size];
    [scrollView setMinimumZoomScale:miniAspect];
    [scrollView setZoomScale:[scrollView minimumZoomScale]];
    [scrollView addSubview:imageView];
    [scrollView setMaximumZoomScale:2.5<miniAspect?miniAspect:2.5];
    [scrollView setClipsToBounds:NO];
    [self setTransparentLayerForView:[UIView new].leAddTo(curView.leSubViewContainer).leAnchor(LEI_C).leSize(curView.leSubViewContainer.bounds.size).leBgColor(LEColorMask5) Rect:scrollView.frame Radius:curRadius];
    
}
-(void) setTransparentLayerForView:(UIView *) view Rect:(CGRect) rect Radius:(float) radius{
    view.userInteractionEnabled=NO;
    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:0];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] bezierPathByReversingPath]];
    CAShapeLayer *layer=[CAShapeLayer layer];
    layer.path=path.CGPath;
    layer.fillRule=kCAFillRuleEvenOdd;
    view.layer.masksToBounds=YES;
    view.layer.mask=layer;
}
@end

