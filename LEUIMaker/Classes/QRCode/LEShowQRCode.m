//
//  LEShowQRCode.m
//  Pods
//
//  Created by emerson larry on 2016/12/22.
//
//

#import "LEShowQRCode.h"

@implementation LEShowQRCode
-(__kindof LEShowQRCode *(^)(NSString *title, NSString *qrcode)) leinit{
    return ^id(NSString *title, NSString *qrcode){
        LEView *view=[LEView new].leInit(self);
        [LENavigation new].leSuperView(view).leTitle(title);
        [UIImageView new].leAddTo(view.leSubViewContainer).leAnchor(LEI_C).leImage([qrcode leCreateQRWithSize:LESCREEN_WIDTH*3/4]);
        return self;
    };
}
@end
