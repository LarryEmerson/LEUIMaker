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
/** 回调二维码 */
-(void) leOnScannedQRCodeWithResult:(NSString *) code;
@end
@interface LEScanQRCode : LEViewController
/** 设定delegate */
-(__kindof LEScanQRCode *(^)(id<LEScanQRCodeDelegate> delegate)) leDelegate;
/** 设定标题 */
-(__kindof LEScanQRCode *(^)(NSString *title)) leTitle;
/** 重新延时扫描 */
-(void) leRescanWithDelay:(NSTimeInterval) seconds;
/** 设定扫码结束界面 */
-(void) leSetCustomizedResultView:(UIView *) view;
/** 设定显示或隐藏扫码结束界面 */
-(void) leShowOrHideResultView:(BOOL) show;
/** 设定扫码界面的提示语 */
-(void) leSetCustomizedTip:(NSString *) tip;
@end
