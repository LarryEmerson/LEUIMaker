//
//  LEEmoji.m
//  guguxinge
//
//  Created by emerson larry on 2016/12/9.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "LEEmoji.h"

#define LEEmojiSize 30
#define LEEmojiMargin 10
@interface LEEmoji ()<UIScrollViewDelegate,LEEmojiDelegate>
@property (nonatomic) UIImage *deleteIcon;
@end
@interface LEEmojiItem : UIView
@property (nonatomic) UILabel *emoji;
@property (nonatomic) UIImageView *emojiImg;
@end
@implementation LEEmojiItem{
    __weak id<LEEmojiDelegate> curDelegate;
}
-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self leExtraInits];
    return self;
}
-(void) leExtraInits{
    self.emoji=[UILabel new].leAddTo(self).leAnchor(LEInsideCenter);
    self.leTouchEvent(@selector(onClick),self);
}
-(void) setDelegate:(id<LEEmojiDelegate>) delegate{
    curDelegate=delegate;
}
-(void) onClick{
    if(curDelegate){
        if(self.emojiImg.image){
            if([curDelegate respondsToSelector:@selector(leOnDeleteEmoji)]){
                [curDelegate leOnDeleteEmoji];
            }
        }else if(self.emoji.text.length>0){
            if([curDelegate respondsToSelector:@selector(leOnInputEmoji:)]){
                [curDelegate leOnInputEmoji:self.emoji.text];
            }
        }
    }
}
-(UIImageView *) emojiImg{
    if(!_emojiImg){
        _emojiImg=[UIImageView new].leAddTo(self).leAnchor(LEInsideCenter);
    }
    return _emojiImg;
}
@end
@interface LEEmojiPageItem : UIView
@end
@implementation LEEmojiPageItem{
    NSMutableArray *btns;
    __weak id<LEEmojiDelegate> curDelegate;
}
-(id) initWithFrame:(CGRect)frame Col:(NSInteger) col Row:(NSInteger) row Margin:(float) margin Size:(float) size Delegate:(id<LEEmojiDelegate>) delegate{
    self=[super initWithFrame:frame];
    curDelegate=delegate;
    btns=[NSMutableArray new];
    for (NSInteger i=0; i<col*row; i++) {
        LEEmojiItem *btn=[LEEmojiItem new].leAddTo(self).leAnchor(LEInsideTopLeft).leSize(LESquareSize(size)).leLeft(margin+(margin+size)*(i%col)).leTop(margin+(margin+size)*(i/col));
        [btn setDelegate:curDelegate];
        [btns addObject:btn];
        if(i+1==col*row){
            btn.emojiImg.leImage([LEEmoji sharedInstance].deleteIcon);
        }
    }
    return self;
}
-(void) setEmojis:(NSArray *) array{
    for (NSInteger i=0; i<btns.count; i++) {
        LEEmojiItem *item=[btns objectAtIndex:i];
        NSString *str=i<array.count?[array objectAtIndex:i]:@"";
        item.emoji.leText(str);
    }
} 
-(void) onDelete{
    if([curDelegate respondsToSelector:@selector(leOnDeleteEmoji)]){
        [curDelegate leOnDeleteEmoji];
    }
}
@end
@implementation LEEmoji{
    __weak id<LEEmojiDelegate> curDelegate;
    UIView *emojiPage;
    UIView *switchBar;
    UIButton *btnSwitch;
    BOOL isSwitchedToEmoji;
    UIScrollView *bottomBar;
    NSMutableArray *bottomBarItems;
    NSInteger curCategory;
    NSMutableArray *curEmojis;
    UIPageControl *pageControl;
    UIScrollView *emojiScrollPage;
    NSMutableArray *curEmojiPagesCache;
    int emojiColumn;
    float emojiMargin;
    int emojiCountPerPage;
    UIImage *switchKeyboard;
    UIImage *switchEmoji;
    //LocalHistory
    NSMutableArray *historyEmojis;
    NSMutableDictionary *historyEmojiCounter;
}
#define LEEmojis @"LEEmojis"
#define LEEmojisCount @"LEEmojisCount"
LESingleton_implementation(LEEmoji)

-(void) leOnInputEmoji:(NSString *) emoji{
    if([curDelegate respondsToSelector:@selector(leOnInputEmoji:)]){
        [curDelegate leOnInputEmoji:emoji];
        [self onSaveEmoji:emoji];
    }
}
-(void) leOnDeleteEmoji{
    if([curDelegate respondsToSelector:@selector(leOnDeleteEmoji)]){
        [curDelegate leOnDeleteEmoji];
    }
}
-(void) leExtraInits{
    NSString *emojis=[[NSUserDefaults standardUserDefaults] objectForKey:LEEmojis];
    NSString *emojisCount=[[NSUserDefaults standardUserDefaults] objectForKey:LEEmojisCount];
    historyEmojis=emojis?[[emojis leJSONValue] mutableCopy]:[NSMutableArray new];
    historyEmojiCounter=emojisCount?[[emojisCount leJSONValue] mutableCopy]:[NSMutableDictionary new];
}
-(void) onSaveEmoji:(NSString *) emoji{
    int counter=0;
    if([historyEmojis containsObject:emoji]){
        counter=[[historyEmojiCounter objectForKey:emoji] intValue];
        counter++;
    }else{
        [historyEmojis addObject:emoji];
    }
    [historyEmojiCounter setObject:[NSNumber numberWithInt:counter+1] forKey:emoji];
    [[NSUserDefaults standardUserDefaults] setObject:[historyEmojis leObjToJSONString] forKey:LEEmojis];
    [[NSUserDefaults standardUserDefaults] setObject:[historyEmojiCounter leObjToJSONString] forKey:LEEmojisCount];
}
-(void) leSetDelegate:(id<LEEmojiDelegate>)delegate{
    curDelegate=delegate;
}
-(void) leSetDeleteIcon:(UIImage *) icon{
    self.deleteIcon=icon;
}
-(void) leSetKeyboardIcon:(UIImage *) keyboard EmojiIcon:(UIImage *) emoji{
    switchKeyboard=keyboard;
    switchEmoji=emoji;
}
-(UIView *) leGetEmojiInputView{
    emojiPage.hidden=NO;
    return emojiPage;
}
-(UIView *) leGetSwitchBar{
    return switchBar;
}
-(void) leInitEmojiWithDeleteIcon:(UIImage *) del KeyboardIcon:(UIImage *) keyboard EmojiIcon:(UIImage *) emoji{
    
    self.deleteIcon=del;
    switchKeyboard=keyboard;
    switchEmoji=emoji;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //Switch
    switchBar=[UIView new].leWidth(LESCREEN_WIDTH).leHeight(LEBottomTabbarHeight).leBgColor(LEColorWhite).leAddTopSplitline(LEColorSplitline,0,LESCREEN_WIDTH);
    btnSwitch=[UIButton new].leAddTo(switchBar).leAnchor(LEInsideLeftCenter).leBtnFixedSize(LESquareSize(LEBottomTabbarHeight)).leTouchEvent(@selector(onSwitch),self).leBtnImg_N(switchEmoji);
    //Emoji
    float pcH=LEEmojiSize;
    emojiColumn=LESCREEN_WIDTH/(LEEmojiSize+LEEmojiMargin);
    emojiMargin=(LESCREEN_WIDTH-emojiColumn*LEEmojiSize)*1.0/(emojiColumn+1);
    float emojiH=LEEmojiSize*3+emojiMargin*3;
    emojiCountPerPage=emojiColumn*3-1;
    //
    emojiPage=[[UIView alloc] initWithFrame:CGRectMake(0, 0, LESCREEN_WIDTH, emojiH+pcH+LEBottomTabbarHeight)];
    emojiPage.backgroundColor=LEEmojiBGColor;
    //
    emojiScrollPage=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, LESCREEN_WIDTH, emojiH)];
    [emojiPage addSubview:emojiScrollPage];
    emojiScrollPage.pagingEnabled=YES;
    emojiScrollPage.delegate=self;
    emojiScrollPage.showsHorizontalScrollIndicator=NO;
    //
    UIView *pageControlContainer=[[UIView alloc] initWithFrame:CGRectMake(0, emojiH, LESCREEN_WIDTH, pcH)];
    [emojiPage addSubview:pageControlContainer];
    pageControl=[[UIPageControl alloc] initWithFrame:pageControlContainer.bounds];
    pageControl.currentPageIndicatorTintColor=LEColorMask5;
    pageControl.pageIndicatorTintColor=LEColorMask2;
    [pageControlContainer addSubview:pageControl];
    //
    bottomBar=[[UIScrollView alloc] initWithFrame:CGRectMake(0, emojiH+pcH, LESCREEN_WIDTH, LEBottomTabbarHeight)];
    [emojiPage addSubview:bottomBar];
    bottomBar.backgroundColor=LEColorWhite;
    //
    bottomBarItems=[NSMutableArray new];
    curEmojiPagesCache=[NSMutableArray new]; 
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageControl.currentPage = scrollView.contentOffset.x/LESCREEN_WIDTH;
}
-(void) leSetCategoryIcons:(NSArray *) icons Emojis:(NSArray *) emojis{
    curCategory=1;
    UIButton *last=nil;
    for (NSInteger i=0; i<icons.count; i++) {
        UIButton *btn=nil;
        if(i==0){
            btn=[UIButton new].leAnchor(LEInsideLeftCenter);
        }else{
            btn=[UIButton new].leAnchor(LEOutsideRightCenter).leRelativeTo(last);
        }
//        LELogObject([icons objectAtIndex:i])
        last=btn.leAddTo(bottomBar).leBtnImg_N([UIImage imageNamed:[icons objectAtIndex:i]]).leBtnFixedSize(CGSizeMake(0, LEBottomTabbarHeight)).leTouchEvent(@selector(onCategory:),self);
        [bottomBarItems addObject:last];
        if(i==1){
            last.leBgColor(LEEmojiBGColor);
        }
    }
    [bottomBar setContentSize:CGSizeMake(last.frame.origin.x+last.frame.size.width, LEBottomTabbarHeight)];
    curEmojis=[NSMutableArray new];
    for (NSInteger i=0; i<emojis.count; i++) {
        [curEmojis addObject:[[emojis objectAtIndex:i] componentsSeparatedByString:@"\n"]];
    }
    [self onCategorySelected];
}
-(void) onCategory:(UIButton *) btn{
    NSInteger category =[bottomBarItems indexOfObject:btn];
    if(category!=curCategory){
        curCategory=category;
        for (NSInteger i=0; i<bottomBarItems.count; i++) {
            [[bottomBarItems objectAtIndex:i] setBackgroundColor:i==curCategory?LEEmojiBGColor:LEColorClear];
        }
        [self onCategorySelected];
    }
}
-(void) onCategorySelected{
    NSArray *array=nil;
    if(curCategory==0){
        array=[historyEmojis sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if([[historyEmojiCounter objectForKey:obj1] intValue]>=[[historyEmojiCounter objectForKey:obj2] intValue]){
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }];
//        LELogObject(array)
    }else{
        array=[curEmojis objectAtIndex:curCategory-1];
    }
    NSMutableArray *tmp=[NSMutableArray new];
    NSInteger page=(array.count/emojiCountPerPage)+(array.count%emojiCountPerPage==0?0:1);
    pageControl.numberOfPages=page;
    emojiScrollPage.contentOffset=CGPointZero;
    pageControl.currentPage=0;
    for (NSInteger i=0; i<MAX(page, curEmojiPagesCache.count); i++) {
        if(i<page){
            LEEmojiPageItem *item=nil;
            if(i<curEmojiPagesCache.count){
                item=[curEmojiPagesCache objectAtIndex:i];
                [item setHidden:NO];
            }else{
                item=[[LEEmojiPageItem alloc] initWithFrame:CGRectMake(i*LESCREEN_WIDTH, 0, LESCREEN_WIDTH, emojiScrollPage.bounds.size.height) Col:emojiColumn Row:3 Margin:emojiMargin Size:LEEmojiSize Delegate:self];
                [curEmojiPagesCache addObject:item];
                [emojiScrollPage addSubview:item];
            }
            for (NSInteger j=emojiCountPerPage*i; j<MIN(j+emojiCountPerPage, array.count); j++) {
                [tmp addObject:[array objectAtIndex:j]];
            }
            [item setEmojis:tmp];
            [tmp removeAllObjects];
        }else if(i<curEmojiPagesCache.count){
            [[curEmojiPagesCache objectAtIndex:i] setHidden:YES];
        }
    }
    [emojiScrollPage setContentSize:CGSizeMake(page*LESCREEN_WIDTH, emojiScrollPage.bounds.size.height)];
}
-(void) onSwitch{
//    LELogInt(isSwitchedToEmoji)
    isSwitchedToEmoji=!isSwitchedToEmoji;
    btnSwitch.leImage(isSwitchedToEmoji?switchKeyboard:switchEmoji);
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnSwitchedToEmoji:)]){
        [curDelegate leOnSwitchedToEmoji:isSwitchedToEmoji];
    }
}
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnKeyboardHeightChanged:)]){
            [curDelegate leOnKeyboardHeightChanged:keyboardRect.size.height];
        }
    } completion:^(BOOL finished){}];
}
-(void)keyboardWillHide:(NSNotification *)notification {
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnKeyboardHeightChanged:)]){
            [curDelegate leOnKeyboardHeightChanged:0];
        }
    } completion:^(BOOL finished){}];
}
+(NSString *) leDeleteLastFrom:(NSString *) string{
    if(string&&string.length>0){
        NSRange rangeIndex = [string rangeOfComposedCharacterSequenceAtIndex:string.length-1];
        return [string substringToIndex:(rangeIndex.location)];
    }
    return string;
}
@end
