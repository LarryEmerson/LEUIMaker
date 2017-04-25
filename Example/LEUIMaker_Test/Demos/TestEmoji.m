//
//  TestEmoji.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/12/12.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "TestEmoji.h"
#import "LEEmoji.h"

@interface TestEmojiPage : LEView <LENavigationDelegate,LEEmojiDelegate> @end
@implementation TestEmojiPage{
    UIScrollView *scrollView;
    UITextView *textView;
}
-(void) leAdditionalInits{
    [LENavigation new].leSuperView(self).leDelegate(self).leRightItemText(@"发布");
    scrollView=[UIScrollView new].leAddTo(self.leSubViewContainer).leMargins(UIEdgeInsetsMake(0, 0, LEBottomTabbarHeight, 0));
    [scrollView setContentSize:CGSizeMake(LESCREEN_WIDTH, scrollView.bounds.size.height)];
    textView=[UITextView new].leAddTo(scrollView).leEqualSuperViewWidth(1).leHeight(LESCREEN_WIDTH/2).leBgColor(LEColorMask);
    
    [[LEEmoji sharedInstance] leSetDelegate:self];
    [[LEEmoji sharedInstance].leGetSwitchBar.leAddTo(self.leSubViewContainer).leAnchor(LEOutsideBottomCenter).leRelativeTo(scrollView) leUpdateLayout]; 
}
-(void) leNavigationRightButtonTapped{
    [textView resignFirstResponder];
}
-(void) leOnInputEmoji:(NSString *)emoji{
    LELogObject(emoji)
    [textView insertText:emoji];
}
-(void) leOnDeleteEmoji{
    LELogFunc
    [textView deleteBackward];
}
-(void) leOnKeyboardHeightChanged:(CGFloat) height Duration:(NSTimeInterval)duration{
    [UIView animateWithDuration:duration animations:^{
        scrollView.leSize(CGSizeMake(LESCREEN_WIDTH, self.leSubContainerH-height-LEBottomTabbarHeight));
    }];
}
-(void) leOnSwitchedToEmoji:(BOOL)emoji{
    if(emoji){
        textView.inputView=[LEEmoji sharedInstance].leGetEmojiInputView;
    }else{
        textView.inputView=nil;
    }
    [textView reloadInputViews];
}
@end
@implementation TestEmoji
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self leDidRotateFrom:fromInterfaceOrientation];
    [[LEEmoji sharedInstance] leDidRotateFrom:fromInterfaceOrientation];
}
@end
