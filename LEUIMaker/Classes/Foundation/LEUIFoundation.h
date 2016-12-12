//
//  LEUIFoundation.h
//  Pods
//
//  Created by emerson larry on 2016/11/29.
//
//

#import <Foundation/Foundation.h>

#pragma mark Screen
#define LEStatusBarHeight       20
#define LENavigationBarHeight   44
#define LEBottomTabbarHeight    49
#define LESCREEN_BOUNDS     ([[UIScreen mainScreen] bounds])
#define LESCREEN_SCALE      ([[UIScreen mainScreen] scale])
#define LESCREEN_WIDTH      ([[UIScreen mainScreen] bounds].size.width)
#define LESCREEN_HEIGHT     ([[UIScreen mainScreen] bounds].size.height)
#define LESCREEN_SCALE_INT  ((int)[[UIScreen mainScreen] scale])
#define LESCREEN_MAX_LENGTH (MAX(LESCREEN_WIDTH, LESCREEN_HEIGHT))
#define LESCREEN_MIN_LENGTH (MIN(LESCREEN_WIDTH, LESCREEN_HEIGHT))


#pragma mark Font
#define LEFont(size) [UIFont systemFontOfSize:size]
#define LEBoldFont(size) [UIFont boldSystemFontOfSize:size]
#pragma mark
#define LESquareSize(__integer)         CGSizeMake(__integer,__integer)
#define LEDegreesToRadian(x) (M_PI * (x) / 180.0)
#define LERadianToDegrees(radian) (radian*180.0)/(M_PI)


@interface LEUIFoundation : NSObject

@end
