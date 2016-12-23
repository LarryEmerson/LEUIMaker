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
-(__kindof LEShowQRCode *(^)(NSString *title, NSString *qrcode)) leinit;
@end
