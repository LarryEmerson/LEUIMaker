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
/** 图片多选选中标识 */
@property (nonatomic, readwrite) UIImage *leMultiImagePickerCheckbox;
/** 二维码扫码框 */
@property (nonatomic, readwrite) UIImage *leQRCodeScanRect;
/** 二维码扫描条 */
@property (nonatomic, readwrite) UIImage *leQRCodeScanLine;
@end
@implementation LEUICommon
LESingleton_implementation(LEUICommon)
-(UIFont *) leNaviTitleFont{
    if(!_leNaviTitleFont){
        _leNaviTitleFont=LEBoldFontLS;
    }
    return _leNaviTitleFont;
}
-(UIFont *) leNaviBtnFont{
    if(!_leNaviBtnFont){
        _leNaviBtnFont=LEFontMS;
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
        _leNaviBGColor=LEColorBG;
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
-(UIImage *) leMultiImagePickerCheckbox{
    if(!_leMultiImagePickerCheckbox){
        NSString *value=nil;
        if(LESCREEN_SCALE_INT==3){
            value=@"iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAhOAAAITgBRZYxYAAAABxpRE9UAAAAAgAAAAAAAAAYAAAAKAAAABgAAAAYAAABuFFlVyMAAAGESURBVGgF7JW/S8NAFMcDTvofOXqdRBRERAQRnHTyHxDBQXAxoYooWnBQBxF/i/gPCK4uDuLipbUNqUPVggklPt+LKWiT9q5YOQ/y4JYLST6ffO+9GEZC9Vr57ozJJ3AdMpM7uEDB8plpc3zvBbPsqcHNYk8CanyLwKMbVUC3eqfTZ/LJOHG0M3oAXWibU/ClW0EnXcsRa0yEWTyrAfyXELL+EGDL9rg28PV+ROZQghoW4Z+0E0BmYjeoMTSED49S2NQ4oo50FcBpeWww8/FeYwGOAryqrwD3SSBp1mqzlwqoTjBNIE0gGiJjWwXYuanA6e0bzJ240kPkXxyh6d0SvLwH8L22rytSEsoFZvZK8NoATyK14AOG1vJCCaUCzeDrSVAyoh5TJiCCr3oBDKzanRMY2SjA/JkLs/sOZKzf/b1F8Hh6YPGyLISndKQSWDgvg1fDp0Z1V/RgeF18PpPil4FfunqWgpcS6F+xgeJsrAfXb1ui0/BSAtRIzaodib+AJ4FPAAAA///+WWjgAAABk0lEQVTVlsFKw0AQQFdQf8gfMMlNqCJS8BP8A48WFLwkPYgoHkSEXhQ86MUv0JMHEQoexLpbQaqC1R5s0WbcEUNjyS7ZZEebwCabZDPzHpndhLkBB10rbTbhox+Cart57MH8VlMbY6n2AG/vfVUIwPDrp8/aGCpGproRv7531lYmxxs6CUp4ZEwl4MmBx5cdYwlq+NQCONBU4i/gjQRMJJaPWtDp0tQ8csRbqhKKP5DmTehqLc+EjXNEfWMBfDCrhG14ZMkkkEWCAj6XgIkEFXxugTQSlPBWBHQS1PDWBCKJ/fM2fP6snq/y12Hl5OnXkofjbLfMk1gFsrB9D/gRm9kQ1mGTcloXSEpCeQ0FupQJiGP3mBPwW+IklKXUYK7PDwoscMi8qlgsqgCys3KlPukGghdPQnBkZ7g5VTEnBcICSYTI/A0f7VxfrBZH4G4t4h4cAcakhD/yEpKRSdYB+FDPrfKSlKiPoEjDCcTsEG7y6XQFxrHGvEDsymX2Wsq8/INQS+a8kt+pmjyWp3YuJpJovwD43KRUhUcxPAAAAABJRU5ErkJggg==";
        }else{
            value=@"iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAABxpRE9UAAAAAgAAAAAAAAAQAAAAKAAAABAAAAAQAAABRIjWT1MAAAEQSURBVFgJYmBAAi69Dwydeh/Od+x9+AhI/wHi/1TCf6BmzgfZgWQllPn/P6NTz6NmoGV/qWQhPocD7XjQwgC0E+4QqOX4NNFADugIEHDsvadPJ5+je+IvyG4G595Hc+kQ7OiWg/kgu4EhAE5wWBXQwWH3GYCW/KODRbg8+AvkAFySdBEfdQDNQiBw2uP/G85/+n/w1tf/mUue44xOmjggaPqT/w/e/PoPAx++/f3vPuERVkdQ3QHolsMcEQx0FLYEj9MBzsDckQEMusjZT7FqxGYYLssP3PyK0wycDth97QvY8f/+/f8/ae87nAbAHILL8pP3vv13wxH8IL1YHQAyDBkA3fB/yj7cjiDXcpADAAAAAP//Cw6x+AAAASNJREFUxZNdDgExEMfrOiTuYDfhXRyFJwkHYMWD4EE4AGfglSNIkG15kYhIhPhYqrPRbFOq9d1kNtPt7P//y2wHWQ6mcsTLhK62JyquM9tUusub2mRtRt3FQSz188FkS0FH1pb3SH7B9+n2nO6OYBssGeJdc/BSAsBhpqOG+IS5FuARxGLtBa25Zn3DtoMuj4cd4EX3OiG7v2IO+kYAUHjvTnCIV82fAlBBvGP+NACH4CPaG26MRg2+U4XxLxAFEmy+U/WZUlSs1eUAcNIVffH8DADuFw00XSIYAFp/Ayi6TRQr4QgD8P4A4dlFHEawLIdkfw9Asr65/6A0ZJdw7kedgG7nEfMMAK6ZXZhGLcetsoIRiz0LzSUyPgetccwhDfAQjS/vtvxBFK+Q/AAAAABJRU5ErkJggg==";
        }
        UIImage *img=[UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:value options:NSDataBase64DecodingIgnoreUnknownCharacters]];
        _leMultiImagePickerCheckbox = [UIImage imageWithCGImage:img.CGImage scale:2 orientation:img.imageOrientation];
        img=nil;
        value=nil;
    }
    return _leMultiImagePickerCheckbox;
}
//
-(UIImage *) leQRCodeScanRect{
    if(!_leQRCodeScanRect){
        NSString *value=nil;
        if(LESCREEN_SCALE_INT==3){
            value=@"iVBORw0KGgoAAAANSUhEUgAAADwAAAA8CAYAAAA6/NlyAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAhOAAAITgBRZYxYAAAABxpRE9UAAAAAgAAAAAAAAAeAAAAKAAAAB4AAAAeAAAA08lw5ZAAAACfSURBVGgF7JQxDsAgDAP5/8f6qUqtWI8MLFipekgd8NAk9oUxrvuJfgMnXj9e0IHDhJnw4Z0G0dH3Y4abL4iJ44TFCzqwj9bRNdv6OShse91ZTweuXGobKRqreqdmwnRk3r9yqt6pmTAdMeHGfFdhURNpOiLSIt3HgYpOau4wHXGH+xC8dFKFRU2k6YhILyD1EaqwqP0P6T752MkJB14AAAD//yfpndIAAACvSURBVO2ZQQqAMAwE+/+P+SlBqSdZF9K0l1RG8NCYSnZ3etHWuP7uwHFeLbp38SDS0Z+HYp+mTRQj2NBLwg6LTYgeC88J1BqCizqgQbn1GAZFBepYTqDWEKyO9PUul5tdaySsjpBwYb5dWFoDaXUEpEG6jgOOTq1xhtURznAdgj+TuLC0NoS0blpZ65Qr75rZi+AZ1zJ7SNh8aMsYmO0F6axj2X6QBun410+Wqlf/DYTb0mxNqtCAAAAAAElFTkSuQmCC";
        }else{
            value=@"iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAABxpRE9UAAAAAgAAAAAAAAAUAAAAKAAAABQAAAAUAAAAkbwQiEoAAABdSURBVFgJ7JQxCgAgDAP7/4/5KUEXM3ZJQ0CIIJnSplexau0ju/WOtKa0WAIO150VT9+jlSCaubSD034xrmDok4AgwWoIsuTgC0GQYDUEWXLwhSBIsPovQXZik+8CAAD//3ue0MMAAABoSURBVGNgGPTg+J//DNgwvR2OzQ0gMayOA0vQ2YWjDqQ0wEdDcDQE0dMApSFCqn50+2H80WKG2JCEhRg6PRqCIzcE0dMCMXxYaBGjllg1ONMgsQYgqxt1IHJokMMeDUFyQg1ZDw1CEADfJ0Z5C0+/xwAAAABJRU5ErkJggg==";
        }
        UIImage *img=[UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:value options:NSDataBase64DecodingIgnoreUnknownCharacters]];
        _leQRCodeScanRect = [UIImage imageWithCGImage:img.CGImage scale:2 orientation:img.imageOrientation];
        img=nil;
        value=nil;
    }
    return _leQRCodeScanRect;
}
-(UIImage *) leQRCodeScanLine{
    if(!_leQRCodeScanLine){
        _leQRCodeScanLine = [[UIColor colorWithRed:37/255.0 green:200/255.0 blue:250/255.0 alpha:1] leImageWithSize:LESquareSize(3)]; 
    }
    return _leQRCodeScanLine;
}
//
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
-(void) leSetMultiImagePickerCheckbox:(UIImage *) image{
    self.leMultiImagePickerCheckbox=image;
}
/** 设置图片多选选中标识 */
-(void) leSetQRCodeScanRect:(UIImage *) image{
    self.leQRCodeScanRect=image;
}
/** 设置图片多选选中标识 */
-(void) leSetQRCodeScanLine:(UIImage *) image{
    self.leQRCodeScanLine=image;
}

-(UIWindow *) leGetTopWindow{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal);
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return [[[UIApplication sharedApplication] delegate] window];
}
@end
