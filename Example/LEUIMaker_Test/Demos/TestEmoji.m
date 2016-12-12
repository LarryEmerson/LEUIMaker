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
-(void) leExtraInits{
    [LENavigation new].leSuperView(self).leDelegate(self).leRightItemText(@"发布");
    scrollView=[UIScrollView new].leAddTo(self.leSubViewContainer).leAnchor(LEInsideTopCenter).leWidth(LESCREEN_WIDTH).leHeight(self.leSubContainerH-LEBottomTabbarHeight);
    [scrollView setContentSize:CGSizeMake(LESCREEN_WIDTH, scrollView.bounds.size.height)];
    textView=[UITextView new].leAddTo(scrollView).leWidth(LESCREEN_WIDTH).leHeight(LESCREEN_WIDTH/2).leBgColor(LEColorMask);
    [[LEEmoji sharedInstance] leSetDelegate:self];
    [[LEEmoji sharedInstance] leInitEmojiWithDeleteIcon:[UIImage imageNamed:LEEmojiDeleteIcon] KeyboardIcon:[UIImage imageNamed:LEEmojiSwitchToKeyboard] EmojiIcon:[UIImage imageNamed:LEEmojiSwitchToEmoji]];
    [[LEEmoji sharedInstance] leSetCategoryIcons:LEEmojiIcons Emojis:LEEmojiData];
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
-(void) leOnKeyboardHeightChanged:(CGFloat) height{
    scrollView.leSize(CGSizeMake(LESCREEN_WIDTH, self.leSubContainerH-height-LEBottomTabbarHeight));
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
@implementation TestEmoji @end
