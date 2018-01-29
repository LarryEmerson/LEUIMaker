//
//  LEUIFoundation.h
//  Pods
//
//  Created by emerson larry on 2016/11/29.
//
//
#import <LEFoundation/LEFoundation.h>
#pragma mark DeviceInfo
#define LESCREEN_BOUNDS         ([[UIScreen mainScreen] bounds])
#define LESCREEN_SCALE          ([[UIScreen mainScreen] scale])
#define LESCREEN_WIDTH          (LESCREEN_BOUNDS.size.width)
#define LESCREEN_HEIGHT         (LESCREEN_BOUNDS.size.height)
#define LESCREEN_SCALE_INT      ((int)LESCREEN_SCALE)
#define LESCREEN_MAX_LENGTH     (MAX(LESCREEN_WIDTH, LESCREEN_HEIGHT))
#define LESCREEN_MIN_LENGTH     (MIN(LESCREEN_WIDTH, LESCREEN_HEIGHT))

#define LEIS_IPAD               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define LEIS_IPHONE             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define LEIS_IPHONE_4_OR_LESS   (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define LEIS_IPHONE_5           (LEIS_IPHONE && LESCREEN_MAX_LENGTH == 568.0)
#define LEIS_IPHONE_6           (LEIS_IPHONE && LESCREEN_MAX_LENGTH == 667.0)
#define LEIS_IPHONE_6P          (LEIS_IPHONE && LESCREEN_MAX_LENGTH == 736.0)
#define LEIS_IPHONE_X           (LEIS_IPHONE && LESCREEN_MAX_LENGTH == 812.0)

/** 状态栏高度 */
#define LEStatusBarHeight ([LEUICommon sharedInstance].leStatusBarHeight)
/** 导航栏高度 */
#define LENavigationBarHeight   44
/** 底部tabbar高度 */
#define LEBottomTabbarHeight    (LEIS_IPHONE_X?49+34:49)

#pragma mark Font
/** 根据字号获取正常字体 */
#define LEFont(size) [UIFont systemFontOfSize:size]
/** 根据字号获取加粗字体 */
#define LEBoldFont(size) [UIFont boldSystemFontOfSize:size]
#pragma mark
/** 返回 CGSize(size, size) */
#define LESquareSize(__integer)         CGSizeMake(__integer,__integer)
/** 返回 UIEdgeInsetsMake(value, value, value, value) */
#define LEEdgeInsets(__integer)         UIEdgeInsetsMake(__integer, __integer, __integer, __integer)
#define LEDegreesToRadian(x) (M_PI * (x) / 180.0)
#define LERadianToDegrees(radian) (radian*180.0)/(M_PI)
/** 分割线高度 */
#define LESplitlineH            1

@interface NSString (QRCode)
/** 根据字符串创建二维码图片 */
-(UIImage *) leCreateQRWithSize:(float) size; 
@end
@interface UIImage (BlackToTransparent)
-(UIImage *) leImageBlackToTransparentWithRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;
@end

@interface UIViewController (LEAdditions)
-(void) lePush:(UIViewController *) vc;
-(void) lePop;
@end
@interface UIImage (LEAdditions)
/** 根据字符串创建二维码图片 */
-(UIImage *)leStreched;
@end
@interface UIColor (LEAdditions)
/** 根据颜色获取图片 */
-(UIImage *) leImage;
/** 根据颜色及大小获取图片 */
-(UIImage *) leImageWithSize:(CGSize)size;
@end

@interface NSAttributedString (LEAdditions)
/** 获取文字大小 */
-(CGRect) leRectWithMaxSize:(CGSize) size;
@end
@interface UIView (LERotate)
/** 用于旋转屏幕的处理 */
-(void)leDidRotateFrom:(UIInterfaceOrientation)from;
/** 用于处理必要的重新排版 */
-(void) leRelayout NS_REQUIRES_SUPER;
@end
@interface LEUIFoundation : NSObject
+(UIImage *) leCreateQRForString:(NSString *)qrString Size:(CGFloat) size;
+(UIImage *) leImageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;
@end
