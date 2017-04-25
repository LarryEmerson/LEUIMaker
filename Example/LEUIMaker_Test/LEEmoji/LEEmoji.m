//
//  LEEmoji.m
//  guguxinge
//
//  Created by emerson larry on 2016/12/9.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "LEEmoji.h"

#define LEEmojiSize 38
#define LEEmojiMargin 8
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
    [self leAdditionalInits];
    return self;
}
-(void) leAdditionalInits{
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
-(void) onSetEmojiSize:(float) size{
    self.emoji=self.emoji.leFont(LEFont(size));
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
    float curMargin;
    LEEmojiItem *curDeleteItem;
}
-(void) onSetCol:(NSInteger) col Row:(NSInteger) row Margin:(float) margin Size:(float) size Delegate:(id<LEEmojiDelegate>) delegate{
    curMargin=margin;
    curDelegate=delegate;
    NSInteger i=col*row-1;
    if(!curDeleteItem){
        curDeleteItem=[LEEmojiItem new].leAddTo(self).leAnchor(LEInsideTopLeft).leSize(LESquareSize(size)).leLeft(margin+(margin+size)*(i%col)).leTop(margin+(margin+size)*(i/col));
        [curDeleteItem onSetEmojiSize:MIN(self.bounds.size.width,self.bounds.size.height)*0.2];
        [curDeleteItem setDelegate:curDelegate];
        curDeleteItem.emojiImg.leImage([LEEmoji sharedInstance].deleteIcon);
    }else{
        curDeleteItem.leLeft(margin+(margin+size)*(i%col)).leTop(margin+(margin+size)*(i/col));
    }
    if(!btns){
        btns=[NSMutableArray new];
    }
    for (NSInteger i=0; i<col*row-1; i++) {
        LEEmojiItem *btn=nil;
        if(i<btns.count){
            btn=[btns objectAtIndex:i];
            btn.leLeft(margin+(margin+size)*(i%col)).leTop(margin+(margin+size)*(i/col));
        }else{
            btn=[LEEmojiItem new].leAddTo(self).leAnchor(LEInsideTopLeft).leSize(LESquareSize(size)).leLeft(margin+(margin+size)*(i%col)).leTop(margin+(margin+size)*(i/col));
            [btn onSetEmojiSize:MIN(self.bounds.size.width,self.bounds.size.height)*0.2];
            [btn setDelegate:curDelegate];
            [btns addObject:btn];
        }
    }
}
-(id) initWithFrame:(CGRect)frame Col:(NSInteger) col Row:(NSInteger) row Margin:(float) margin Size:(float) size Delegate:(id<LEEmojiDelegate>) delegate{
    self=[super initWithFrame:frame];
    curMargin=margin;
    curDelegate=delegate;
    btns=[NSMutableArray new];
    for (NSInteger i=0; i<col*row; i++) {
        LEEmojiItem *btn=[LEEmojiItem new].leAddTo(self).leAnchor(LEInsideTopLeft).leSize(LESquareSize(size)).leLeft(margin+(margin+size)*(i%col)).leTop(margin+(margin+size)*(i/col));
        [btn onSetEmojiSize:MIN(self.bounds.size.width,self.bounds.size.height)*0.2];
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
-(void) leAdditionalInits{
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
    curCategory=1;
    isSwitchedToEmoji=NO;
    btnSwitch.leBtnImg_N(isSwitchedToEmoji?switchKeyboard:switchEmoji);
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
-(void) leDidRotateFrom:(UIInterfaceOrientation)from{
    emojiColumn=LESCREEN_WIDTH/(LEEmojiSize+LEEmojiMargin);
    emojiMargin=(LESCREEN_WIDTH-emojiColumn*LEEmojiSize)*1.0/(emojiColumn+1);
    float emojiH=LEEmojiSize*3+emojiMargin*3;
    emojiCountPerPage=emojiColumn*3-1;
    [emojiPage setFrame:CGRectMake(0, 0, LESCREEN_WIDTH, emojiH+LEEmojiSize+LEBottomTabbarHeight)];
    for (UIView *view in emojiPage.subviews) {
        [view leUpdateLayout];
    }
    emojiScrollPage.leHeight(emojiH);
    float maxW=0;
    for (NSInteger i=0; i<bottomBarItems.count; i++) {
        UIButton *btn=[bottomBarItems objectAtIndex:i];
        maxW+=btn.bounds.size.width;
    }
    if(maxW<LESCREEN_WIDTH){
        maxW=LESCREEN_WIDTH*1.0/bottomBarItems.count;
        for (NSInteger i=0; i<bottomBarItems.count; i++) {
            UIButton *btn=[bottomBarItems objectAtIndex:i];
            btn.leWidth(maxW);
        }
    } 
    [self onCategorySelected];
}
-(void) leInitEmojiWithDeleteIcon:(UIImage *) del KeyboardIcon:(UIImage *) keyboard EmojiIcon:(UIImage *) emoji{
    
    self.deleteIcon=del;
    switchKeyboard=keyboard;
    switchEmoji=emoji;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //Switch
    switchBar=[UIView new].leEqualSuperViewWidth(1).leHeight(LEBottomTabbarHeight).leBgColor(LEColorWhite);
    [UIView new].leAddTo(switchBar).leAnchor(LEI_BC).leEqualSuperViewWidth(1).leHeight(LESplitlineH).leBgColor(LEColorSplitline); 
    btnSwitch=[UIButton new].leAddTo(switchBar).leAnchor(LEInsideLeftCenter).leBtnFixedSize(LESquareSize(LEBottomTabbarHeight)).leTouchEvent(@selector(onSwitch),self).leBtnImg_N(switchEmoji);
    //Emoji
    emojiColumn=LESCREEN_WIDTH/(LEEmojiSize+LEEmojiMargin);
    emojiMargin=(LESCREEN_WIDTH-emojiColumn*LEEmojiSize)*1.0/(emojiColumn+1);
    float emojiH=LEEmojiSize*3+emojiMargin*3;
    emojiCountPerPage=emojiColumn*3-1;
    //
    emojiPage=[[UIView alloc] initWithFrame:CGRectMake(0, 0, LESCREEN_WIDTH, emojiH+LEEmojiSize+LEBottomTabbarHeight)];
    emojiPage.backgroundColor=LEEmojiBGColor;
    //
    emojiScrollPage=[UIScrollView new].leAddTo(emojiPage).leAnchor(LEI_TC).leEqualSuperViewWidth(1).leHeight(emojiH);
    emojiScrollPage.pagingEnabled=YES;
    emojiScrollPage.delegate=self;
    emojiScrollPage.showsHorizontalScrollIndicator=NO;
    //
    UIView *pageControlContainer=[UIView new].leAddTo(emojiPage).leAnchor(LEI_BC).leEqualSuperViewWidth(1).leBottom(LEBottomTabbarHeight).leHeight(LEEmojiSize);
    pageControl=[UIPageControl new].leAddTo(pageControlContainer).leMargins(UIEdgeInsetsZero);
    pageControl.currentPageIndicatorTintColor=LEColorMask5;
    pageControl.pageIndicatorTintColor=LEColorMask2;
    //
    bottomBar=[UIScrollView new].leAddTo(emojiPage).leAnchor(LEI_BC).leEqualSuperViewWidth(1).leHeight(LEBottomTabbarHeight).leBgColor(LEColorWhite);
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
    }else{
        array=[curEmojis objectAtIndex:curCategory-1];
    }
    NSMutableArray *tmp=[NSMutableArray new];
    NSInteger page=(array.count/emojiCountPerPage)+(array.count%emojiCountPerPage==0?0:1);
    pageControl.numberOfPages=page;
    emojiScrollPage.contentOffset=CGPointZero;
    pageControl.currentPage=0;
    LEEmojiPageItem *last=nil;
    for (NSInteger i=0; i<MAX(page, curEmojiPagesCache.count); i++) {
        if(i<page){
            LEEmojiPageItem *item=nil;
            if(i<curEmojiPagesCache.count){
                item=[curEmojiPagesCache objectAtIndex:i];
                [item setHidden:NO];
            }else{
                if(last){
                    item=[LEEmojiPageItem new].leAddTo(emojiScrollPage).leRelativeTo(last).leAnchor(LEO_RC).leEqualSuperViewWidth(1).leEqualSuperViewHeight(1);
                }else{
                    item=[LEEmojiPageItem new].leAddTo(emojiScrollPage).leAnchor(LEI_LC).leEqualSuperViewHeight(1).leEqualSuperViewWidth(1);
                }
                [curEmojiPagesCache addObject:item];
            }
            [item onSetCol:emojiColumn Row:3 Margin:emojiMargin Size:LEEmojiSize Delegate:self];
            last=item;
            for (NSInteger j=emojiCountPerPage*i; j<MIN(i*emojiCountPerPage+emojiCountPerPage, array.count); j++) {
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
        if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnKeyboardHeightChanged:Duration:)]){
            [curDelegate leOnKeyboardHeightChanged:keyboardRect.size.height Duration:animationDuration];
        }
    } completion:^(BOOL finished){}];
}
-(void)keyboardWillHide:(NSNotification *)notification {
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnKeyboardHeightChanged:Duration:)]){
            [curDelegate leOnKeyboardHeightChanged:0 Duration:animationDuration];
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
