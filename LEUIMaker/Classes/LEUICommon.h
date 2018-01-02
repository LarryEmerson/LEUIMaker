//
//  LEUICommon.h
//  LEUIMaker
//
//  Created by emerson larry on 2016/11/1.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LEUIFoundation.h"

#pragma mark Define Colors
#define LEColorClear          [UIColor clearColor]
#define LEColorWhite          [UIColor whiteColor]
#define LEColorBlack          [UIColor blackColor]
#define LERandomColor         [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
/** 测试颜色 */
#define LEColorTest           [UIColor colorWithRed:0.985 green:0.000 blue:0.961 alpha:1.000]
#define LEColorBlue           [UIColor colorWithRed:0.2071 green:0.467 blue:0.8529 alpha:1.0]
#define LEColorRed 			  [UIColor colorWithRed:0.9337 green:0.2135 blue:0.3201  alpha:1.0]

#pragma mark ColorText
#define LEColorText         LEColorWhite
/** B - - ^ - W */
#define LEColorText9        [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
/** B - ^ - W */
#define LEColorText6        [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]
/** B - ^ - - W */
#define LEColorText3        [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
/** 分割线颜色 */
#define LEColorSplitline    [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1]
#define LEColorBG           LEColorWhite
/** White 249 */
#define LEColorBG9          [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1]
/** White 245 */
#define LEColorBG5          [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]

#pragma mark Color Mask
/** 高亮颜色 */
#define LEColorHighlighted  [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1]

#define LEColorMaskLight      [[UIColor alloc] initWithWhite:0.906 alpha:1.000]
#define LEColorMask           [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.1]
#define LEColorMask2          [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.2]
#define LEColorMask5          [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.5]
#define LEColorMask8          [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.8]
#pragma mark Sidespace
#define LESideSpace60   60
#define LESideSpace27   27
#define LESideSpace20   20
#define LESideSpace16   16
#define LESideSpace15   15
#define LESideSpace     10
#pragma mark Linespace
#define LELineSpace         12
#define LETextLineSpace     10
#define LESubtextLineSpace  8
#pragma mark AvatarSize
#define LEAvatarSizeBig     60
#define LEAvatarSizeMid     40
#define LEAvatarSize        30
#define LEAvatarSpace       20
#pragma mark Font

#define LEFontSizeLL        20
#define LEFontSizeLS        18
#define LEFontSizeML        16
#define LEFontSizeMS        14
#define LEFontSizeSL        12
#define LEFontSizeSS        11
/** normal font 9.5 */
#define LEFontLL        LEFont(LEFontSizeLL)
/** normal font 9 */
#define LEFontLS        LEFont(LEFontSizeLS)
/** normal font 8 */
#define LEFontML        LEFont(LEFontSizeML)
/** normal font 7 */
#define LEFontMS        LEFont(LEFontSizeMS)
/** normal font 6 */
#define LEFontSL        LEFont(LEFontSizeSL)
/** normal font 5.5 */
#define LEFontSS        LEFont(LEFontSizeSS)
/** normal font 9.5 */
#define LEBoldFontLL    LEBoldFont(LEFontSizeLL)
/** normal font 9 */
#define LEBoldFontLS    LEBoldFont(LEFontSizeLS)
/** normal font 8 */
#define LEBoldFontML    LEBoldFont(LEFontSizeML)
/** normal font 7 */
#define LEBoldFontMS    LEBoldFont(LEFontSizeMS)
/** normal font 6 */
#define LEBoldFontSL    LEBoldFont(LEFontSizeSL)
/** normal font 5.5 */
#define LEBoldFontSS    LEBoldFont(LEFontSizeSS)


#pragma mark List
/** 列表高度 64 */
#define LECellHL 64.0
/** 列表高度 52 */
#define LECellHM 52.0
/** 列表高度 44 */
#define LECellHS 44.0
/** 列表高度 根据不同机器返回不同高度。6p->HL, 6->HM, Oth->HS */
#define LECellH (LEIS_IPHONE_6P?LECellHL:(LEIS_IPHONE_6?LECellHM:LECellHS))
/** 列表Section 24 */
#define LESectionHL 24.0
/** 列表Section 12 */
#define LESectionHM 12.0
/** 列表Section 8 */
#define LESectionHS 8.0

/** 列表回调 info的key值，index */
#define LEKeyIndex  @"index"
/** 列表回调 info的key值，info */
#define LEKeyInfo   @"info"

@interface LEUICommon : NSObject
LESingleton_interface(LEUICommon) 
/** 导航栏标题字体 */
@property (nonatomic, readonly) UIFont  *leNaviTitleFont;
/** 导航栏按钮字体 */
@property (nonatomic, readonly) UIFont  *leNaviBtnFont;
/** 导航栏返回按钮 */
@property (nonatomic, readonly) UIImage *leNaviBackImage;
/** 导航栏背景填充图片 */
@property (nonatomic, readonly) UIImage *leNaviBGImage;
/** 导航栏背景填充色 */
@property (nonatomic, readonly) UIColor *leNaviBGColor;
/** 导航栏标题颜色 */
@property (nonatomic, readonly) UIColor *leNaviTitleColor;
/** 导航栏下方View的底色 */
@property (nonatomic, readonly) UIColor *leViewBGColor;
/** 列表右侧箭头 */
@property (nonatomic, readonly) UIImage *leListRightArrow;
/** 图片多选选中标识 */
@property (nonatomic, readonly) UIImage *leMultiImagePickerCheckbox;

/** 二维码扫码框 */
@property (nonatomic, readonly) UIImage *leQRCodeScanRect;
/** 二维码扫描条 */
@property (nonatomic, readonly) UIImage *leQRCodeScanLine;

/** 设置导航栏标题字体 */
-(void) leSetNaviTitleFont:(UIFont *) font;
/** 设置导航栏按钮字体 */
-(void) leSetNaviBtnFont:(UIFont *) font;
/** 设置导航栏返回按钮 */
-(void) leSetNaviBackImage:(UIImage *) image;
/** 设置导航栏背景填充图片 */
-(void) leSetNaviBGImage:(UIImage *) image;
/** 设置导航栏背景填充色 */
-(void) leSetNaviBGColor:(UIColor *) color;
/** 设置导航栏标题颜色 */
-(void) leSetNaviTitleColor:(UIColor *) color;
/** 设置导航栏下方View的底色 */
-(void) leSetViewBGColor:(UIColor *) color;
/** 设置列表右侧箭头 */
-(void) leSetListRightArrow:(UIImage *) image;

/** 设置图片多选选中标识 */
-(void) leSetMultiImagePickerCheckbox:(UIImage *) image;

/** 设置图片多选选中标识 */
-(void) leSetQRCodeScanRect:(UIImage *) image;
/** 设置图片多选选中标识 */
-(void) leSetQRCodeScanLine:(UIImage *) image;

/** 获得最顶端的window */
-(UIWindow *) leGetTopWindow;
/** 获得最顶端的VC */
-(UIViewController *) leGetTopVC;
@end
