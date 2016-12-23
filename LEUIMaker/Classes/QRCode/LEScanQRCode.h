//
//  LEScanQRCode.h
//  Pods
//
//  Created by emerson larry on 2016/12/22.
//
//

#import <Foundation/Foundation.h>
#import "LEViewAdditions.h"
#import "LEUICommon.h"
#import "LEViewController.h"

@protocol LEScanQRCodeDelegate <NSObject>
-(void) leOnScannedQRCodeWithResult:(NSString *) code;
@end
@interface LEScanQRCode : LEViewController
-(__kindof LEScanQRCode *(^)(id<LEScanQRCodeDelegate> delegate)) leDelegate;
-(__kindof LEScanQRCode *(^)(NSString *title)) leTitle;
@end
