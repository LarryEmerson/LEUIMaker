//
//  LESegment.m
//  Pods
//
//  Created by emerson larry on 2016/12/3.
//
//

#import "LESegment.h"

@implementation LESegment{
    UIScrollView *curSegmentContainer;
    UIView *curIndicator;
    UIScrollView *curPageContainer;
    NSMutableArray *curTitlesCache;
    NSMutableArray *curTitlesWidth;
    NSMutableArray *curTitlesWidthSum;
    NSMutableArray *curPages;
    NSInteger curSelectedIndex;
    float segmentSpeed;
    
    __weak id<LESegmentDelegate> curDelegate;
    NSArray *titles;
    NSArray *pages;
    float height;
    BOOL equalWidth;
    UIColor *normalColor;
    UIColor *highlightedColor;
    float margin;
    UIImage *indicator;
    NSArray *lastTitles;
}
-(NSArray *) getTitleCache{
    return curTitlesCache;
}
-(__kindof LESegment *(^)(UIView *superView, NSArray *titles, NSArray *pages)) leInit{
    return ^id(UIView *superView, NSArray *titles, NSArray *pages){
        self.leAddTo(superView).leMargins(UIEdgeInsetsZero).leBgColor(LEColorWhite) ;
        lastTitles=titles;
        if(!curSegmentContainer){
            normalColor=LEColorBlack;
            highlightedColor=LEColorBlue;
            
            curSegmentContainer=[UIScrollView new].leAddTo(self).leAnchor(LEInsideTopCenter).leEqualSuperViewWidth(1).leAutoResizeContentView();
            curIndicator=[UIImageView new].leAddTo(curSegmentContainer).leAnchor(LEInsideBottomLeft);
            
            curPageContainer=[UIScrollView new].leAddTo(self).leAnchor(LEOutsideBottomCenter).leRelativeTo(curSegmentContainer).leEqualSuperViewWidth(1).leAutoResizeContentView();
            [curPageContainer setDelegate:self];
            [curPageContainer setScrollEnabled:YES];
            [curPageContainer setBounces:NO];
            [curPageContainer setPagingEnabled:YES];
            [curSegmentContainer setShowsVerticalScrollIndicator:NO];
            [curSegmentContainer setShowsHorizontalScrollIndicator:NO];
            curTitlesCache=[NSMutableArray new];
            curTitlesWidth=[NSMutableArray new];
            curTitlesWidthSum=[NSMutableArray new];
            curPages=[NSMutableArray new];
            self.leBarHeight(LENavigationBarHeight);
            [self leOnSetTitles:titles];
            [self leOnSetPages:pages];
        }
        return self;
    };
}

-(__kindof LESegment *(^)(id<LESegmentDelegate>)) leDelegate{
    return ^id(id<LESegmentDelegate> value){
        curDelegate=value;
        return self;
    };
}
-(__kindof LESegment *(^)(BOOL)) leEqualWidth{
    return ^id(BOOL value){
        equalWidth=value;
        return self;
    };
}
-(__kindof LESegment *(^)(UIColor *)) leNormalColor{
    return ^id(UIColor *value){
        normalColor=value;
        return self;
    };
}
-(__kindof LESegment *(^)(UIColor *)) leHighlightedColor{
    return ^id(UIColor *value){
        highlightedColor=value;
        return self;
    };
}
-(__kindof LESegment *(^)(float)) leMargin{
    return ^id(float value){
        margin=value;
        return self;
    };
}
-(__kindof LESegment *(^)(NSArray *)) leTitles{
    return ^id(NSArray *value){
        [self leOnSetTitles:value];
        return self;
    };
}
-(__kindof LESegment *(^)(NSArray *)) lePages{
    return ^id(NSArray *value){
        [self leOnSetPages:value];
        return self;
    };
}
-(__kindof LESegment *(^)(float)) leOffset{
    return ^id(float value){
        curIndicator.leBottom(value);
        return self;
    };
}
-(__kindof LESegment *(^)(float)) leBarHeight{
    return ^id(float value){
        height=value;
        if(curTitlesCache.count>0){
            for (NSInteger i=0; i<curTitlesCache.count; i++) {
                UIButton *btn=[curTitlesCache objectAtIndex:i];
                btn.leHeight(value);
            }
        }
        curSegmentContainer.leHeight(value);
        curPageContainer.leHeight(self.bounds.size.height-value);
        return self;
    };
}

-(__kindof LESegment *(^)(UIImage *)) leIndicator{
    return ^id(UIImage *value){
        curIndicator.leImage(value);
        return self;
    };
}

-(void) leOnSetTitles:(NSArray *) titles{
    [curTitlesWidth removeAllObjects];
    [curTitlesWidthSum removeAllObjects];
    UIButton *last=nil;
    float maxWidth;
    for (int i=0; i<titles.count; i++) {
        UIButton *btn=nil;
        if(i<curTitlesCache.count){
            btn=[curTitlesCache objectAtIndex:i];
            [btn setHidden:NO];
            if(last){
                [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
                [btn setTitleColor:normalColor forState:UIControlStateNormal];
                [btn setTitleColor:highlightedColor forState:UIControlStateHighlighted];
                float sum=0;
                if(curTitlesWidthSum.count>0){
                    sum=[[curTitlesWidthSum objectAtIndex:i-1] floatValue];
                }
                [curTitlesWidthSum addObject:[NSNumber numberWithFloat:sum+btn.bounds.size.width/2+last.bounds.size.width/2]];
                [curTitlesWidth addObject:@(btn.bounds.size.width/2+last.bounds.size.width/2)];
            }else{
                [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
                [btn setTitleColor:highlightedColor forState:UIControlStateNormal];
                [btn setTitleColor:normalColor forState:UIControlStateHighlighted];
                curIndicator.leLeft(btn.bounds.size.width/2-curIndicator.bounds.size.width/2);
                [curTitlesWidthSum addObject:[NSNumber numberWithFloat:btn.bounds.size.width/2]];
            }
            last=btn;
        }else{
            if(last){
                btn=[UIButton new].leAddTo(curSegmentContainer).leAnchor(LEOutsideRightCenter).leRelativeTo(last).leFont(LEFont(LEFontMS)).leBtnColorN(normalColor).leBtnColorH(highlightedColor).leTouchEvent(@selector(onTitleTapped:),self).leBtnHInsect(margin).leText([titles objectAtIndex:i]);
                float sum=0;
                if(curTitlesWidthSum.count>0){
                    sum=[[curTitlesWidthSum objectAtIndex:i-1] floatValue];
                }
                [curTitlesWidthSum addObject:[NSNumber numberWithFloat:sum+btn.bounds.size.width/2+last.bounds.size.width/2]];
                [curTitlesWidth addObject:@(btn.bounds.size.width/2+last.bounds.size.width/2)];
            }else{
                btn=[UIButton new].leAddTo(curSegmentContainer).leAnchor(LEInsideLeftCenter).leFont(LEFont(LEFontMS)).leBtnColorN(normalColor).leBtnColorH(highlightedColor).leTouchEvent(@selector(onTitleTapped:),self).leBtnHInsect(margin).leText([titles objectAtIndex:i]);
                curIndicator.leLeft(btn.bounds.size.width/2-curIndicator.bounds.size.width/2);
                [curTitlesWidthSum addObject:[NSNumber numberWithFloat:btn.bounds.size.width/2]];
            }
            last=btn;
            [curTitlesCache addObject:btn]; 
        }
        maxWidth=MAX(maxWidth, btn.bounds.size.width);
    }
    for (NSInteger i=titles.count; i<curTitlesCache.count; i++) {
        [[curTitlesCache objectAtIndex:i] setHidden:YES];
    }
    //EqualWidth
    if(equalWidth){
        curIndicator.leSize(CGSizeMake(maxWidth-margin, curIndicator.bounds.size.height));
        last=nil;
        for (int i=0; i<titles.count; i++) {
            UIButton *btn=[curTitlesCache objectAtIndex:i];
            btn.leSize(CGSizeMake(maxWidth, btn.bounds.size.height));
            last=btn;
        }
        float widthSum=last.frame.origin.x+last.frame.size.width;
        float gap=0;
        if(widthSum<LESCREEN_WIDTH&&titles.count>1){
            gap=(LESCREEN_WIDTH-widthSum)/2.0;
        }
        last=nil;
        UIButton *btn=nil;
        int size=maxWidth;
        [curTitlesWidth removeAllObjects];
        [curTitlesWidthSum removeAllObjects];
        for (int i=0; i<curTitlesCache.count; i++) {
            btn=[curTitlesCache objectAtIndex:i];
            btn.leSize(CGSizeMake(size, height));
            if(last){
                float sum=0;
                if(curTitlesWidthSum.count>0){
                    sum=[[curTitlesWidthSum objectAtIndex:i-1] floatValue];
                }
                [curTitlesWidthSum addObject:[NSNumber numberWithFloat:sum+btn.bounds.size.width/2+last.bounds.size.width/2]];
                [curTitlesWidth addObject:@(btn.bounds.size.width/2+last.bounds.size.width/2)];
            }else{
                btn.leLeft(gap);
                curIndicator.leLeft(gap+maxWidth/2-curIndicator.bounds.size.width/2);
                [curTitlesWidthSum addObject:[NSNumber numberWithFloat:gap+btn.bounds.size.width/2]];
            }
            last=btn;
        }
        [curTitlesWidth addObject:@(gap)];
        segmentSpeed=(widthSum-LESCREEN_WIDTH)*1.0/(LESCREEN_WIDTH*(titles.count-1));
        [curSegmentContainer setContentSize:CGSizeMake(widthSum+gap*2.0, curSegmentContainer.bounds.size.height)];
    }else{
        //
        float finalWidth=last.frame.origin.x+last.frame.size.width;
        if(finalWidth<LESCREEN_WIDTH&&titles.count>1){
            last=nil;
            UIButton *btn=nil;
            int size=LESCREEN_WIDTH*1.0/titles.count;
            [curTitlesWidth removeAllObjects];
            [curTitlesWidthSum removeAllObjects];
            for (int i=0; i<curTitlesCache.count; i++) {
                btn=[curTitlesCache objectAtIndex:i];
                btn.leSize(CGSizeMake(size, height));
                if(last){
                    float sum=0;
                    if(curTitlesWidthSum.count>0){
                        sum=[[curTitlesWidthSum objectAtIndex:i-1] floatValue];
                    }
                    [curTitlesWidthSum addObject:[NSNumber numberWithFloat:sum+btn.bounds.size.width/2+last.bounds.size.width/2]];
                    [curTitlesWidth addObject:@(btn.bounds.size.width/2+last.bounds.size.width/2)];
                }else{
                    curIndicator.leLeft(btn.bounds.size.width/2-curIndicator.bounds.size.width/2);
                    [curTitlesWidthSum addObject:[NSNumber numberWithFloat:btn.bounds.size.width/2]];
                }
                last=btn;
            }
            finalWidth=LESCREEN_WIDTH;
        }
        [curTitlesWidth addObject:@(0)];
        segmentSpeed=(finalWidth-LESCREEN_WIDTH)*1.0/(LESCREEN_WIDTH*(titles.count-1));
        [curSegmentContainer setContentSize:CGSizeMake(finalWidth, curSegmentContainer.bounds.size.height)];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index=scrollView.contentOffset.x/LESCREEN_WIDTH;
    float widthSum=[[curTitlesWidthSum objectAtIndex:index] floatValue];
    float width=[[curTitlesWidth objectAtIndex:index] floatValue];
    float indicatorOffset=widthSum+(scrollView.contentOffset.x/LESCREEN_WIDTH-index)*width-curIndicator.bounds.size.width/2;
    curIndicator.leLeft(indicatorOffset);
    //
    index=MIN(index, curSelectedIndex);
    BOOL checkLeft=index<curSelectedIndex;
    float sumW=[[curTitlesWidthSum objectAtIndex:curSelectedIndex] floatValue];
    float curHalfW=[[curTitlesCache objectAtIndex:curSelectedIndex] bounds].size.width/2;
    NSInteger finalIndex=curSelectedIndex;
    if(checkLeft&&curIndicator.frame.origin.x<sumW-curHalfW){
        finalIndex=finalIndex-1;
    }else if(!checkLeft&&curIndicator.frame.origin.x>sumW+curHalfW){
        finalIndex=finalIndex+1;
    }
    finalIndex=MIN(MAX(finalIndex, 0), curTitlesCache.count-1);
    float W=[[curTitlesCache objectAtIndex:curSelectedIndex] bounds].size.width;
    float mid=curIndicator.frame.origin.x+curIndicator.frame.size.width/2-curSegmentContainer.contentOffset.x;
    float segStartX=mid-W/2.0;
    float segEndX=mid+W/2.0-LESCREEN_WIDTH;
    if(segStartX<=0){
        [curSegmentContainer setContentOffset:CGPointMake(curSegmentContainer.contentOffset.x+segStartX, 0)];
    }else if(segEndX>=0){
        [curSegmentContainer setContentOffset:CGPointMake(curSegmentContainer.contentOffset.x+segEndX, 0)];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    curSelectedIndex = scrollView.contentOffset.x/LESCREEN_WIDTH;
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnSegmentSelectedWithIndex:)]){
        [curDelegate leOnSegmentSelectedWithIndex:curSelectedIndex];
    }
    [self onChangeTitleState];
    float segStartX=[[curTitlesCache objectAtIndex:curSelectedIndex] frame].origin.x;
    float segEndX=segStartX+[[curTitlesCache objectAtIndex:curSelectedIndex] bounds].size.width;
    float segOffset=curSegmentContainer.contentOffset.x;
    float leftSpace=segStartX-segOffset;
    float rightSpace=(segEndX-segOffset)-LESCREEN_WIDTH;
    if(leftSpace<0){
        [curSegmentContainer setContentOffset:CGPointMake(curSegmentContainer.contentOffset.x+leftSpace, 0) animated:YES ];
    }else if(rightSpace>0){
        [curSegmentContainer setContentOffset:CGPointMake(curSegmentContainer.contentOffset.x+rightSpace, 0) animated:YES ];
    }
}
-(void) onTitleTapped:(UIButton *) button{
    curSelectedIndex=[curTitlesCache indexOfObject:button];
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnSegmentSelectedWithIndex:)]){
        [curDelegate leOnSegmentSelectedWithIndex:curSelectedIndex];
    }
    [curPageContainer setContentOffset:CGPointMake(LESCREEN_WIDTH*curSelectedIndex, 0)];
    [self onChangeTitleState];
}
-(void) onChangeTitleState{
    for (int i=0; i<curTitlesCache.count; i++) {
        UIButton *btn=[curTitlesCache objectAtIndex:i];
        [btn setTitleColor:i==curSelectedIndex?normalColor:highlightedColor forState:UIControlStateHighlighted];
        [btn setTitleColor:i==curSelectedIndex?highlightedColor:normalColor forState:UIControlStateNormal];
    }
}
-(void) leOnSetPages:(NSArray *) pages{ 
    for (int i=0; i<pages.count; i++) {
        NSString *classname=[pages objectAtIndex:i];
        NSAssert([classname isKindOfClass:[NSString class]], @"leOnSetPages传参为page的类名，请检查");
        id obj=[classname leGetInstanceFromClassName];
        NSAssert([obj isKindOfClass:[UIView class]],@"leOnSetPages传参为view的类名");
        UIView *view=[obj init];
        view.leSize(curPageContainer.bounds.size);
        [curPageContainer lePushToStack:view,nil];
        [curPages addObject:view];
    }
}

-(void) leDidRotateFrom:(UIInterfaceOrientation)from{
    UIButton *last=nil;
    float maxWidth;
    int titlesCount=0;
    for (NSInteger i=0; i<curTitlesCache.count; i++) {
        if(![[curTitlesCache objectAtIndex:i] isHidden]){
            maxWidth=MAX(maxWidth, [[curTitlesCache objectAtIndex:i] bounds].size.width);
            titlesCount++;
        }
    }
    if(equalWidth){
        curIndicator.leSize(CGSizeMake(maxWidth-margin, curIndicator.bounds.size.height));
        last=nil;
        for (int i=0; i<titlesCount; i++) {
            UIButton *btn=[curTitlesCache objectAtIndex:i];
            btn.leSize(CGSizeMake(maxWidth, btn.bounds.size.height));
            last=btn;
        }
        float widthSum=last.frame.origin.x+last.frame.size.width;
        float gap=0;
        if(widthSum<LESCREEN_WIDTH&&titlesCount>1){
            gap=(LESCREEN_WIDTH-widthSum)/2.0;
        }
        last=nil;
        UIButton *btn=nil;
        int size=maxWidth;
        [curTitlesWidth removeAllObjects];
        [curTitlesWidthSum removeAllObjects];
        for (int i=0; i<curTitlesCache.count; i++) {
            btn=[curTitlesCache objectAtIndex:i];
            btn.leSize(CGSizeMake(size, height));
            if(last){
                float sum=0;
                if(curTitlesWidthSum.count>0){
                    sum=[[curTitlesWidthSum objectAtIndex:i-1] floatValue];
                }
                [curTitlesWidthSum addObject:[NSNumber numberWithFloat:sum+btn.bounds.size.width/2+last.bounds.size.width/2]];
                [curTitlesWidth addObject:@(btn.bounds.size.width/2+last.bounds.size.width/2)];
            }else{
                btn.leLeft(gap);
                curIndicator.leLeft(gap+maxWidth/2-curIndicator.bounds.size.width/2);
                [curTitlesWidthSum addObject:[NSNumber numberWithFloat:gap+btn.bounds.size.width/2]];
            }
            last=btn;
        }
        [curTitlesWidth addObject:@(gap)];
        segmentSpeed=(widthSum-LESCREEN_WIDTH)*1.0/(LESCREEN_WIDTH*(titlesCount-1));
        [curSegmentContainer setContentSize:CGSizeMake(widthSum+gap*2.0, curSegmentContainer.bounds.size.height)];
    }else{
        //
        float finalWidth=last.frame.origin.x+last.frame.size.width;
        if(finalWidth<LESCREEN_WIDTH&&titlesCount>1){
            last=nil;
            UIButton *btn=nil;
            int size=LESCREEN_WIDTH*1.0/titlesCount;
            [curTitlesWidth removeAllObjects];
            [curTitlesWidthSum removeAllObjects];
            for (int i=0; i<curTitlesCache.count; i++) {
                btn=[curTitlesCache objectAtIndex:i];
                btn.leSize(CGSizeMake(size, height));
                if(last){
                    float sum=0;
                    if(curTitlesWidthSum.count>0){
                        sum=[[curTitlesWidthSum objectAtIndex:i-1] floatValue];
                    }
                    [curTitlesWidthSum addObject:[NSNumber numberWithFloat:sum+btn.bounds.size.width/2+last.bounds.size.width/2]];
                    [curTitlesWidth addObject:@(btn.bounds.size.width/2+last.bounds.size.width/2)];
                }else{
                    curIndicator.leLeft(btn.bounds.size.width/2-curIndicator.bounds.size.width/2);
                    [curTitlesWidthSum addObject:[NSNumber numberWithFloat:btn.bounds.size.width/2]];
                }
                last=btn;
            }
            finalWidth=LESCREEN_WIDTH;
        }
        [curTitlesWidth addObject:@(0)];
        segmentSpeed=(finalWidth-LESCREEN_WIDTH)*1.0/(LESCREEN_WIDTH*(titlesCount-1));
        [curSegmentContainer setContentSize:CGSizeMake(finalWidth, curSegmentContainer.bounds.size.height)];
    }

    //
    curPageContainer.leSize(CGSizeMake(LESCREEN_WIDTH, self.bounds.size.height-curSegmentContainer.bounds.size.height));
    for (UIView *view in curPages) {
        view.leSize(curPageContainer.bounds.size);
    }
    [curPageContainer setContentOffset:CGPointMake(curSelectedIndex*LESCREEN_WIDTH, 0)];
    [self scrollViewDidScroll:curPageContainer];
}
@end



