//
//  LEScanQRCode.m
//  Pods
//
//  Created by emerson larry on 2016/12/22.
//
//

#import "LEScanQRCode.h"

@implementation LEScanQRCode{
    __weak id<LEScanQRCodeDelegate> curDelegate;
    LENavigation *curNavi;
}
-(__kindof LEScanQRCode *(^)(id<LEScanQRCodeDelegate> delegate)) leDelegate{
    return ^id(id<LEScanQRCodeDelegate> delegate){
        curDelegate=delegate;
        LEView *view=[LEView alloc].leInit(self);
        curNavi=[LENavigation new].leSuperView(view).leTitle(@"扫一扫");
        return self;
    };
}
-(__kindof LEScanQRCode *(^)(NSString *title)) leTitle{
    return ^id(NSString *title){
        curNavi.leTitle(title);
        return self;
    };
}
@end
