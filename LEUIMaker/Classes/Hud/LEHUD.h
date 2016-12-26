//
//  LEHUD.h
//  Pods
//
//  Created by emerson larry on 2016/12/15.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LEViewAdditions.h"
#import "LEUICommon.h"
/** 弹出文字提示 */
@interface LEHUD : UIView
-(void) leShowHud:(NSString *) text WithEnterTime:(float) time AndPauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRelease;
-(void) leShowHud:(NSString *) text Offset:(CGFloat) offset WithEnterTime:(float) time AndPauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRelease;
/** 弹出文字提示：文字 */
+(void) leShowHud:(NSString *) text ;
/** 弹出文字提示：文字、进入时间、暂停时间、完成后释放 */
+(void) leShowHud:(NSString *) text EnterTime:(float) time PauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRealse;
/** 弹出文字提示：文字、偏移、进入时间、暂停时间、完成后释放 */
+(void) leShowHud:(NSString *) text Offset:(CGFloat) offset EnterTime:(float) time PauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRealse;
@end
