//
//  LEShowQRCode.h
//  Pods
//
//  Created by emerson larry on 2016/12/22.
//
//

#import <Foundation/Foundation.h>
#import "LEViewAdditions.h"
#import "LEUICommon.h"
#import "LEViewController.h"
@interface LEShowQRCode : LEViewController
/** 显示二维码界面：标题、二维码字符串 */
-(__kindof LEShowQRCode *(^)(NSString *title, NSString *qrcode)) leinit;
@end
