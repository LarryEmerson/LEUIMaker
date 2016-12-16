//
//  LEBottomTabbar.m
//  Pods
//
//  Created by emerson larry on 2016/12/2.
//
//

#import "LEBottomTabbar.h"
 
@implementation LEBottomTabbarPage

-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self setAlpha:0];
    [self leExtraInits];
    return self;
}
-(void) leEaseInView{
    [self setHidden:NO];
    [self setAlpha:0];
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^(void){
        [self setAlpha:1];
    }completion:^(BOOL isDone){
        [self leEaseInViewLogic];
    }];
}
-(void) leEaseOutView{
    [self setHidden:NO];
    [self leEaseOutViewLogic];
    [UIView animateWithDuration:0 animations:^(void){
        [self setAlpha:0];
    } completion:^(BOOL isDone){
        [self setHidden:YES];
    }];
}
-(void) leEaseInViewLogic{}
-(void) leEaseOutViewLogic{}
-(void) leNotifyPageSelected{}
@end

@implementation LEBottomTabbar{
    __weak id<LEBottomTabbarDelegate> curDelegate;
    NSArray *normalIcons;
    NSArray *highlightedIcons;
    NSArray *titles;
    NSArray *pages;
    NSMutableArray *curPages;
    NSMutableArray *curItems;
    UIColor *normalColor;
    UIColor *highlightedColor;
    int lastIndex;

}

-(__kindof LEBottomTabbar *(^)(id<LEBottomTabbarDelegate>)) leDelegate{
    return ^id(id<LEBottomTabbarDelegate> value){
        curDelegate=value;
        return self;
    };
}
-(__kindof LEBottomTabbar *(^)(NSArray *)) leNormalIccons{
    return ^id(NSArray *value){
        normalIcons=value;
        return self;
    };
}
-(__kindof LEBottomTabbar *(^)(NSArray *)) leHighlightedIcons{
    return ^id(NSArray *value){
        highlightedIcons=value;
        return self;
    };
}
-(__kindof LEBottomTabbar *(^)(NSArray *)) leTitles{
    return ^id(NSArray *value){
        titles=value;
        return self;
    };
}
-(__kindof LEBottomTabbar *(^)(NSArray *)) lePages{
    return ^id(NSArray *value){
        pages=value;
        return self;
    };
}
-(__kindof LEBottomTabbar *(^)(UIColor *)) leNormalColor{
    return ^id(UIColor *value){
        normalColor=value;
        return self;
    };
}
-(__kindof LEBottomTabbar *(^)(UIColor *)) leHighlightedColor{
    return ^id(UIColor *value){
        highlightedColor=value;
        return self;
    };
}
-(__kindof LEBottomTabbar *(^)(UIView *)) leSuperView{
    return ^id(UIView *value){
        NSAssert(normalIcons.count>0,@"请在调用leSuperView前调用leNormalIccons且长度不为0");
        NSAssert(highlightedIcons.count>0,@"请在调用leSuperView前调用leHighlightedIcons且长度不为0");
        NSAssert(titles.count>0,@"请在调用leSuperView前调用leTitles且长度不为0");
        NSAssert(pages.count>0,@"请在调用leSuperView前调用lePages且长度不为0");
        NSAssert(normalIcons.count==highlightedIcons.count&&highlightedIcons.count==titles.count&&titles.count==pages.count,@"leNormalIccons、leHighlightedIcons、leTitles、lePages传入数组长度不一致");
        lastIndex=-1;
        self.leAddTo(value).leAnchor(LEInsideBottomCenter).leEqualSuperViewWidth(1).leHeight(LEBottomTabbarHeight).leEnableTouch(YES).leBgColor(LEColorWhite).leHorizontalStack().leAddTopSplitline;
        curPages=[NSMutableArray new];
        for (NSInteger i=0; i<pages.count; i++) {
            NSString *classname=[pages objectAtIndex:i];
            id obj=[classname leGetInstanceFromClassName];
            NSAssert([obj isKindOfClass:[LEBottomTabbarPage class]],@"lePages中的类名需继承LEBottomTabbarPage");
            LEBottomTabbarPage *page=[obj init];
            page.leAddTo(value).leMargins(UIEdgeInsetsMake(0, 0, LEBottomTabbarHeight, 0));
            [curPages addObject:page];
        }
        curItems=[NSMutableArray new];
        float buttonWidth=LESCREEN_WIDTH*1.0/normalIcons.count;
        for (NSInteger i=0; i<normalIcons.count; i++) {
            UIButton *item=[UIButton new].leBtnVerticalLayout(YES).leBtnFixedSize(CGSizeMake(buttonWidth, LEBottomTabbarHeight)).leFont(LEFont(LEFontSS)).leBtnImg_N([normalIcons objectAtIndex:i]).leBtnColorN(normalColor).leBtnColorH(highlightedColor).leTouchEvent(@selector(onClickForButton:),self).leText(titles?[titles objectAtIndex:i]:nil);
            [curItems addObject:item];
            [self lePushToStack:item, nil];
        }
        return self;
    };
}
-(void) leDidRotateFrom:(UIInterfaceOrientation)from{
    float buttonWidth=LESCREEN_WIDTH*1.0/curItems.count;
    for (NSInteger i=0; i<curItems.count; i++) {
        UIButton *item=[curItems objectAtIndex:i];
        item.leBtnFixedWidth(buttonWidth);
        [item leUpdateLayout];
    }
}
-(void) onClickForButton:(UIButton *) btn{
    int index=(int)[curItems indexOfObject:btn];
    if(index==lastIndex){
        return;
    }
    BOOL okToGo=YES;
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leWillShowPageWithIndex:)]){
        okToGo=[curDelegate leWillShowPageWithIndex:index];
    }
    if(!okToGo){
        return;
    }
    lastIndex=index;
    for (int i=0; i<curItems.count; i++) {
        UIButton *item=[curItems objectAtIndex:i];
        item.leBtnImg_N([(i==index?highlightedIcons:normalIcons) objectAtIndex:i]);
        if(titles){
            item.leBtnColorN(i==index?highlightedColor:normalColor);
        }
        LEBottomTabbarPage *page=[curPages objectAtIndex:i];
        if(i==index){
            [page leEaseInView];
        }else{
            [page leEaseOutView];
        }
    }
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leTabbarDidTappedWith:)]){
        [curDelegate leTabbarDidTappedWith:index];
    }
}

-(void) leDidChoosedPageWith:(int) index{
    if(index<curItems.count){
        [self onClickForButton:[curItems objectAtIndex:index]];
    }
}
-(NSArray *) getTabbars{
    return curItems;
}
@end
