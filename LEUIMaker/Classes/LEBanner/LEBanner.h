//
//  LEBanner.h
//  Pods
//
//  Created by emerson larry on 2017/1/11.
//
//
#import <UIKit/UIKit.h>
#import "LEUICommon.h"
#import "LEViewAdditions.h"


#define LEBannerWidth   30
#define LEBannerOffset  15
#define LEBannerSize    16


typedef NS_ENUM(NSInteger, LEBannerDirection){
    LEBannerLandscape,
    LEBannerPortrait,
};

typedef NS_ENUM(NSInteger, LEBannerIndicatorStyle){
    LEBannerIndicator_None,
    LEBannerIndicator_Left,
    LEBannerIndicator_Right,
    LEBannerIndicator_Center
};
@class LEBanner;

@interface LEBannerView : UIImageView
-(void) leSetData:(id) data;
@end

@protocol LEBannerDelegate <NSObject>
@optional
-(void) leDidTapBanner:(LEBanner *) banner Index:(NSInteger) index Data:(NSDictionary *) data;
@end

@interface LEBanner : UIView<UIScrollViewDelegate>{
    UIScrollView *leScrollView;
    NSInteger leTotalPages;
    NSInteger leCurrentPage;
}
/** UIView *superView, NSString *classname, LEBannerDirection direction, id<LEBannerDelegate> delegate */
-(__kindof LEBanner *(^)(UIView *superView, NSString *classname, LEBannerDirection direction, id<LEBannerDelegate> delegate)) leSuperview;
 
-(__kindof LEBanner *(^)(id<LEBannerDelegate> delegate)) leDelegate;
-(__kindof LEBanner *(^)(LEBannerIndicatorStyle style)) leIndicatorStyle;
-(__kindof LEBanner *(^)(UIEdgeInsets insets)) leIndicatorOffset;
-(__kindof LEBanner *(^)(NSTimeInterval time)) leDelay;

-(void) leReloadBannerWithData:(NSArray *) data;
-(void) leScroll;
-(void) leStop;
-(void) leDidRotateFrom:(UIInterfaceOrientation)from NS_REQUIRES_SUPER;

@end
