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
@interface LEHUD : UIView
-(void) leShowHud:(NSString *) text WithEnterTime:(float) time AndPauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRelease;
-(void) leShowHud:(NSString *) text Offset:(CGFloat) offset WithEnterTime:(float) time AndPauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRelease;
+(void) leShowHud:(NSString *) text ;
+(void) leShowHud:(NSString *) text EnterTime:(float) time PauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRealse;
+(void) leShowHud:(NSString *) text Offset:(CGFloat) offset EnterTime:(float) time PauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRealse;
@end
