//
//  LEUICommon.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/11/1.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "LEUICommon.h"

@interface LEUICommon ()
/** 导航栏标题字体 */
@property (nonatomic, readwrite) UIFont  *leNaviTitleFont;
/** 导航栏按钮字体 */
@property (nonatomic, readwrite) UIFont  *leNaviBtnFont;
/** 导航栏返回按钮 */
@property (nonatomic, readwrite) UIImage *leNaviBackImage;
/** 导航栏背景填充图片 */
@property (nonatomic, readwrite) UIImage *leNaviBGImage;
/** 导航栏背景填充色 */
@property (nonatomic, readwrite) UIColor *leNaviBGColor;
/** 导航栏标题颜色 */
@property (nonatomic, readwrite) UIColor *leNaviTitleColor;
/** 导航栏下方View的底色 */
@property (nonatomic, readwrite) UIColor *leViewBGColor;
@end
@implementation LEUICommon
LESingleton_implementation(LEUICommon)

/** 设置导航栏标题字体 */
-(void) leSetNaviTitleFont:(UIFont *) font{
    self.leNaviTitleFont=font;
}
/** 设置导航栏按钮字体 */
-(void) leSetNaviBtnFont:(UIFont *) font{
    self.leNaviBtnFont=font;
}
/** 设置导航栏返回按钮 */
-(void) leSetNaviBackImage:(UIImage *) image{
    self.leNaviBackImage=image;
}
/** 设置导航栏背景填充图片 */
-(void) leSetNaviBGImage:(UIImage *) image{
    self.leNaviBGImage=image;
}
/** 设置导航栏背景填充色 */
-(void) leSetNaviBGColor:(UIColor *) color{
    self.leNaviBGColor=color;
}
/** 设置导航栏标题颜色 */
-(void) leSetNaviTitleColor:(UIColor *) color{
    self.leNaviTitleColor=color;
}
/** 设置导航栏下方View的底色 */
-(void) leSetViewBGColor:(UIColor *) color{
    self.leViewBGColor=color;
}
@end
