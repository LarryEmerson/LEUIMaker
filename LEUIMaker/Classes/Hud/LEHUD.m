//
//  LEHUD.m
//  Pods
//
//  Created by emerson larry on 2016/12/15.
//
//

#import "LEHUD.h"

#define MessageEnterTime    0.3
#define MessagePauseTime    1.2
@implementation LEHUD{
    NSTimer *extraCheck;
    CATransition *transition;
    UILabel *labelNoti;
}
-(id) init{
    self=[super init];
    [self leAdditionalInits];
    return self;
}

+(void) leShowHud:(NSString *) text {
    [LEHUD leShowHud:text EnterTime:MessageEnterTime PauseTime:MessagePauseTime ReleaseWhenFinished:YES];
}
+(void) leShowHud:(NSString *) text EnterTime:(float) time PauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRealse{
    [LEHUD leShowHud:text Offset:LENavigationBarHeight+LEStatusBarHeight EnterTime:time PauseTime:pauseTime ReleaseWhenFinished:isRealse];
}
+(void) leShowHud:(NSString *) text Offset:(CGFloat) offset EnterTime:(float) time PauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRealse{
    LEHUD *noti=[LEHUD new].leAddTo([LEUICommon sharedInstance].leGetTopWindow).leAnchor(LEI_BC).leBottom(LEStatusBarHeight);
    [noti leShowHud:text WithEnterTime:time AndPauseTime:pauseTime ReleaseWhenFinished:isRealse];
}
-(void) leAdditionalInits{
    self.leEqualSuperViewWidth(1-(LENavigationBarHeight*1.0/LESCREEN_WIDTH)).leEnableTouch(NO).leCorner(6).leBgColor(LEColorText3).leAutoCalcHeight();
    labelNoti=[UILabel new].leAddTo(self).leAnchor(LEI_C).leTop(6).leBottom(6).leMaxWidth(LESCREEN_WIDTH-LENavigationBarHeight-LESideSpace*2).leFont(LEFontML).leColor(LEColorWhite).leLine(0).leLineSpace(4).leCenterAlign;
    // effect
    transition = [CATransition animation];
    [transition setDuration:MessageEnterTime];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transition setType:kCATransitionFade];
    [self setAlpha:0];
}
-(void) leShowHud:(NSString *) text WithEnterTime:(float) time AndPauseTime:(float) pauseTime {
    [self.layer removeAllAnimations];
    [self leShowHud:text WithEnterTime:time AndPauseTime:pauseTime ReleaseWhenFinished:NO];
}
-(void) leRelease{
    [super leRelease];
    [extraCheck invalidate];
    extraCheck=nil;
    [transition setDelegate:nil];
    transition=nil;
    [self removeFromSuperview];
}
-(void) onCheck{
    [self leRelease];
}
-(void) leShowHud:(NSString *) text WithEnterTime:(float) time AndPauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRelease{
    [self leShowHud:text Offset:LEStatusBarHeight+LENavigationBarHeight WithEnterTime:time AndPauseTime:pauseTime ReleaseWhenFinished:isRelease];
}
-(void) leShowHud:(NSString *) text Offset:(CGFloat) offset WithEnterTime:(float) time AndPauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRelease{
    if(!text){
        [self leRelease];
        return;
    }
    [extraCheck invalidate];
    extraCheck=[NSTimer scheduledTimerWithTimeInterval:time+pauseTime+0.1 target:self selector:@selector(onCheck) userInfo:nil repeats:NO];
    [self setAlpha:0];
    labelNoti.leMaxWidth(LESCREEN_WIDTH-LENavigationBarHeight-LESideSpace*2).leText(text);
    [UIView  animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.leBottom(offset);
        [self setAlpha:1];
    } completion:^(BOOL isFinished){
        if(isFinished){
            [UIView animateWithDuration:time delay:pauseTime options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                [self setAlpha:0];
            } completion:^(BOOL done){
                if(isRelease){
                    [extraCheck invalidate];
                    [self leRelease];
                }
            }];
        }
    }];
}


@end
