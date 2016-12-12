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
/** 列表右侧箭头 */
@property (nonatomic, readwrite) UIImage *leListRightArrow;
@end
@implementation LEUICommon
LESingleton_implementation(LEUICommon)
-(UIFont *) leNaviTitleFont{
    if(!_leNaviTitleFont){
        _leNaviTitleFont=LEBoldFont(LEFontLS);
    }
    return _leNaviTitleFont;
}
-(UIFont *) leNaviBtnFont{
    if(!_leNaviBtnFont){
        _leNaviBtnFont=LEFont(LEFontMS);
    }
    return _leNaviBtnFont;
}
-(UIImage *) leNaviBackImage{
    if(!_leNaviBackImage){ 
        NSString *back=nil;
        if(LESCREEN_SCALE_INT==3){
            back=@"iVBORw0KGgoAAAANSUhEUgAAADwAAAA8CAYAAAA6/NlyAAAAAXNSR0IArs4c6QAA\r\nAAlwSFlzAAAhOAAAITgBRZYxYAAAABxpRE9UAAAAAgAAAAAAAAAeAAAAKAAAAB4A\r\nAAAeAAABBb/bozAAAADRSURBVGgF7Ji9DsIgFEb7EK76GE5KGSy3i6PK5QkcfU4H\r\nX8WhIaaTQoLR4B+j3HxNGLpxzj2hKU2DBwZgAAZgAAZgAAaCgcVqM9PEB012r4yd\r\nipYSQPuWeAjrmtage6tFQifYyxPsHfokDvgLbIQeRQH/gA3A7igGuADWL8nNRQCX\r\nwKpuZwBbmwFM9vHNjQeUR8a1JRz3i4yRcY3dZntGxsg4S6LGV2ScZdwa7moc5Mue\r\nSyYrB3bNk/CTfn5zU5FuLJwXAxtHrYi3n2F5/EfYGwAAAP//IRC8xwAAANxJREFU\r\nY2CgADi6R3jbu0f+x42jqigwfvBp9fT0ZAd69iZuD4MCY5h52sEjQgHo4QejnsZI\r\n6iMwpu3cIqsHX8akwEXEJO9RT1MQwING62hMYxRgkLp7NHkPmjRKgUNGk/do8ka0\r\nxUfzNAVZadBoHcl5+j6+DsdwTd4EPB2RNGiSJjUcAk3eeDwdcY8a9gwqMwh4+seg\r\nciy1HIPL03bukVuoZcegMwfq6YtIBdlFB89omUHnUKo6qKGBydY93MjOJVyTAcim\r\nqtmjho2GwGgIjIbAaAiMhsBoCAx4CAAAW3+yiyeFOhoAAAAASUVORK5CYII=";
        }else{
            back=@"iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAAXNSR0IArs4c6QAA\r\nAAlwSFlzAAAWJQAAFiUBSVIk8AAAABxpRE9UAAAAAgAAAAAAAAAUAAAAKAAAABQA\r\nAAAUAAAA4JsSyeAAAACsSURBVFgJYmAYBaMhMBoCAxcC1n5JvPZu4Z42LlFKA+cK\r\nHDY7eEQo2LtH3LN3j/wPxL8cPSPtcSilvzDEcZH3oY4DOfC/g1vEHPq7BIuN2BwH\r\ndqB7VA4W5fQVwuU4e/eopaGhocz0dQ2abaOOQwsQormjIUd0UKEpHA05tAAhmosr\r\n5Bw8IpcM2qJkUDjOyi1WDFgjoFRf4BpiMIQcKP4d3CNbQA5Cw8toHa0AAAAA//8e\r\nhnt+AAAAkklEQVRjYCASOLhFVti7R/5HxnYeEUfMPaP5iDSCtsqMfX25gI47huxA\r\nEHtQOdLFJZR/1JHUSAijIUmNUASZMRqSoyE5lMpJUEFPrRijyBxcGcfePaKVIoOp\r\nqRnsSLeI42jV4mxq2kGxWSBH2rlH7YE68rmje7g+xYbSwABGJ68oeQeHBA4amD1q\r\n5GgIjIYAKAQAqp1R/d/aGjwAAAAASUVORK5CYII=";
        }
        UIImage *img=[UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:back options:NSDataBase64DecodingIgnoreUnknownCharacters]];
        _leNaviBackImage = [UIImage imageWithCGImage:img.CGImage scale:2 orientation:img.imageOrientation];
        img=nil;
        back=nil;
    }
    return _leNaviBackImage;
}

-(UIColor *) leNaviTitleColor{
    if(!_leNaviTitleColor){
        _leNaviTitleColor=LEColorBlack;
    }
    return _leNaviTitleColor;
}
-(UIColor *) leNaviBGColor{
    if(!_leNaviBGColor){
        _leNaviBGColor=LEColorBG9;
    }
    return _leNaviBGColor;
}
-(UIImage *) leListRightArrow{
    if(!_leListRightArrow){
        NSString *back=nil;
        if(LESCREEN_SCALE_INT==3){
            back=@"iVBORw0KGgoAAAANSUhEUgAAABIAAAAeCAYAAAAhDE4sAAAAAXNSR0IArs4c6QAA\nAAlwSFlzAAAhOAAAITgBRZYxYAAAABxpRE9UAAAAAgAAAAAAAAAPAAAAKAAAAA8A\nAAAPAAAAnFnfA68AAABoSURBVEgNYmCgJliweK33/MXrns1fvP7hvEVr3Mk2G2LI\nuv9AGoR/ggwmy7AFi9c9hhoCN2zeknU+JBsGNMQD5BLqGLZog++oYaTFwXxqhhko\nCWCLAJAlpDkLqHooGrbGi1revAkyCAAAAP//gCIvPQAAAHZJREFUY2AgAcxbuM5/\n/uJ1P4H4PxK+Q4IRDAw4DAEZ6kG0QfMXrw/A4pKfC5es9xyphixcsjYQS5j8IClM\nhpkh8xet8aI4TEAJCmjIEyBGTvY/gHziUywsVQI1PUMyiDxDoC7ymL947T2gYTfn\nLVzrArNgQGgAnnLwzjOvtzAAAAAASUVORK5CYII=";
        }else{
            back=@"iVBORw0KGgoAAAANSUhEUgAAAAwAAAAUCAYAAAC58NwRAAAAAXNSR0IArs4c6QAA\nAAlwSFlzAAAWJQAAFiUBSVIk8AAAABxpRE9UAAAAAgAAAAAAAAAKAAAAKAAAAAoA\nAAAKAAAAkCawaTcAAABcSURBVDgRYmAAgvlL1xvMWbROB8QmCECK5y9e9w+I/8xb\nsj6GoIaFC9fogRQD8X+iNc1ftDaWYk0gQwg6D90mojSBPI7sPNppWrB4XTSyTUB+\nHEE/oWuat2SDFgAAAP//TAU7wAAAAFRJREFUY2DAAxYsXhc3f/G6P0D8H0wvW6OB\nUzm6YiA/GqfieUvWxaOYvGRt1LBSPHfxOn2iPQjy+fyl6w2gGv7MxxcayMG0cOEa\nvUWL1mkii+FiAwCLVfI5c3jALAAAAABJRU5ErkJggg==";
        }
        UIImage *img=[UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:back options:NSDataBase64DecodingIgnoreUnknownCharacters]];
        _leListRightArrow = [UIImage imageWithCGImage:img.CGImage scale:2 orientation:img.imageOrientation];
        img=nil;
        back=nil;
    }
    return _leListRightArrow;
}
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
/** 设置列表右侧箭头 */
-(void) leSetListRightArrow:(UIImage *) image{
    self.leListRightArrow=image;
}
 
@end
