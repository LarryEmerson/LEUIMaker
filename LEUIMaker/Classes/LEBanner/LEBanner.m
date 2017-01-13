//
//  LEBanner.m
//  Pods
//
//  Created by emerson larry on 2017/1/11.
//
//

#import "LEBanner.h"

@implementation LEBannerView
-(id) init{
    self=[super init];
    [self leExtraInits];
    return self;
}
-(void) leExtraInits{}
-(void) leSetData:(id) data{}
@end

@implementation LEBanner{
    __weak id<LEBannerDelegate> curDelegate;
    NSString *curClassname;
    LEBannerDirection curDirection;
    LEBannerIndicatorStyle curStyle;
    NSTimeInterval curDelay;
    NSArray *curData;
    UIPageControl *curPageControl;
    BOOL isScrolling;
    NSInteger totalCount;
    UIEdgeInsets curIndicatorMargins;
    //
    NSMutableArray *curViewsCache;
}
/** UIView *superView, NSString *classname, LEBannerDirection direction, id<LEBannerDelegate> delegate */
-(__kindof LEBanner *(^)(UIView *superView, NSString *classname, LEBannerDirection direction, id<LEBannerDelegate> delegate)) leSuperview{
    return ^id(UIView *superView, NSString *classname, LEBannerDirection direction, id<LEBannerDelegate> delegate){
        self.leAddTo(superView).leMargins(UIEdgeInsetsZero);
        curClassname=classname?:@"LEBannerView";
        curDirection=direction;
        curDelegate=delegate;
        curDelay=4;
        curStyle=LEBannerIndicator_Center;
        if(!leScrollView){
            leScrollView=[UIScrollView new].leAddTo(self).leMargins(UIEdgeInsetsZero).leBgColor(LEColorClear).leAutoResizeContentView();
            leScrollView.showsHorizontalScrollIndicator=NO;
            leScrollView.showsVerticalScrollIndicator=NO;
            leScrollView.pagingEnabled=YES;
            leScrollView.delegate=self;
            leCurrentPage=1;
            curViewsCache=[NSMutableArray new];
            for (NSInteger i=0; i<3; i++) {
                LEBannerView *view=[[curClassname leGetInstanceFromClassName] init];
                view.leAddTo(leScrollView).leAnchor(LEI_LC).leEqualSuperViewWidth(1).leEqualSuperViewHeight(1);
                view.userInteractionEnabled=YES;
                [curViewsCache addObject:view];
                if(direction==LEBannerLandscape){
                    view.leLeft(i*LESCREEN_WIDTH);
                }else {
                    view.leTop(i*leScrollView.bounds.size.height);
                }
                view.leTouchEvent(@selector(onTap:),self);
            }
            curPageControl=[UIPageControl new];
            curPageControl.leAddTo(self).leAnchor(LEI_BC).leBottom(LEBannerOffset).leEnableTouch(NO).leWidth(LEBannerSize).leHeight(LEBannerOffset);
        }
        return self;
    };
}
-(void) leDidRotateFrom:(UIInterfaceOrientation)from{
    BOOL scroll=isScrolling;
    if(scroll){
        [self leStop];
    }
    for (NSInteger i=0; i<curViewsCache.count; i++) {
        LEBannerView *view=[curViewsCache objectAtIndex:i];
        view.leLeft(LESCREEN_WIDTH*i);
    }
    if(scroll){ 
        [self leScroll];
    }
}
-(void) dealloc{
    curDelegate=nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollLogic) object:nil];
}
//
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView{
    NSInteger x = aScrollView.contentOffset.x;
    NSInteger y = aScrollView.contentOffset.y;
    if (isScrolling){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollLogic) object:nil];
    }
    if(curDirection == LEBannerLandscape){
        if (x >= 2 * leScrollView.frame.size.width){
            leCurrentPage = [self getPageIndex:leCurrentPage+1];
            [self onRefresh];
        }
        if (x <= 0){
            leCurrentPage = [self getPageIndex:leCurrentPage-1];
            [self onRefresh];
        }
    }else if(curDirection == LEBannerPortrait){
        if (y >= 2 * leScrollView.frame.size.height){
            leCurrentPage = [self getPageIndex:leCurrentPage+1];
            [self onRefresh];
        }
        if (y <= 0){
            leCurrentPage = [self getPageIndex:leCurrentPage-1];
            [self onRefresh];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView{
    if (curDirection == LEBannerLandscape){
        leScrollView.contentOffset = CGPointMake(leScrollView.frame.size.width, 0);
    }else if (curDirection == LEBannerPortrait){
        leScrollView.contentOffset = CGPointMake(0, leScrollView.frame.size.height);
    }
    if (isScrolling){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollLogic) object:nil];
        [self performSelector:@selector(scrollLogic) withObject:nil afterDelay:curDelay inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}
- (void)leScroll{
    if (!curData||curData.count==0){
        return;
    }
    [self leStop];
    isScrolling = YES;
    [self onRefresh];
    [self performSelector:@selector(scrollLogic) withObject:nil afterDelay:curDelay];
}
- (void)leStop{
    isScrolling = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollLogic) object:nil];
}
- (void)scrollLogic{
    [UIView animateWithDuration:0.25 animations:^{
        if(curDirection == LEBannerLandscape){
            leScrollView.contentOffset = CGPointMake(1.99*leScrollView.frame.size.width, 0);
        }else if(curDirection == LEBannerPortrait){
            leScrollView.contentOffset = CGPointMake(0, 1.99*leScrollView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (finished){
            leCurrentPage = [self getPageIndex:leCurrentPage+1];
            [self onRefresh];
            if (isScrolling){
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollLogic) object:nil];
                [self performSelector:@selector(scrollLogic) withObject:nil afterDelay:curDelay inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            }
        }
    }];
}
-(void) onTap:(UITapGestureRecognizer *) tap{
    if ([curDelegate respondsToSelector:@selector(leDidTapBanner:Index:Data:)]){
        if(curData.count>leCurrentPage-1){
            [curDelegate leDidTapBanner:self Index:leCurrentPage-1 Data:[curData objectAtIndex:leCurrentPage-1]];
        }
    }
}
-(void) onRefresh{
    NSArray *viewData=[self getDataForDisplayWithIndex:leCurrentPage];
    for (NSInteger i=0; i<3&&i<viewData.count; i++) {
        LEBannerView *view=[curViewsCache objectAtIndex:i];
        [view leSetData:[viewData objectAtIndex:i]];
    }
    if(curDirection==LEBannerLandscape){
        leScrollView.contentOffset=CGPointMake(LESCREEN_WIDTH, 0);
    }else if(curDirection==LEBannerPortrait){
        leScrollView.contentOffset=CGPointMake(0, leScrollView.bounds.size.height);
    }
    curPageControl.currentPage=leCurrentPage-1;
}
-(NSArray *) getDataForDisplayWithIndex:(NSInteger) page{
    NSInteger pre=[self getPageIndex:leCurrentPage-1];
    NSInteger last=[self getPageIndex:leCurrentPage+1];
    NSMutableArray *muta=[NSMutableArray new];
    if(curData.count>pre-1){
        [muta addObject:[curData objectAtIndex:pre-1]];
    }
    if(curData.count>leCurrentPage-1){
        [muta addObject:[curData objectAtIndex:leCurrentPage-1]];
    }
    if(curData.count>last-1){
        [muta addObject:[curData objectAtIndex:last-1]];
    }
    return muta;
}
-(NSInteger) getPageIndex:(NSInteger) index{
    if(index==0){
        index=leTotalPages;
    }
    if(index==leTotalPages+1){
        index=1;
    }
    return index;
}
-(__kindof LEBanner *(^)(id<LEBannerDelegate> delegate)) leDelegate{
    return ^id(id<LEBannerDelegate> delegae){
        curDelegate=delegae;
        return self;
    };
}
-(__kindof LEBanner *(^)(LEBannerIndicatorStyle style)) leIndicatorStyle{
    return ^id(LEBannerIndicatorStyle style){
        curStyle=style;
        [self resetIndicatorStyle:curStyle];
        return self;
    };
}
-(__kindof LEBanner *(^)(UIEdgeInsets insets)) leIndicatorMargins{
    return ^id(UIEdgeInsets insets){
        curIndicatorMargins=insets;
        curPageControl.leMargins(insets);
        return self;
    };
}
-(__kindof LEBanner *(^)(NSTimeInterval time)) leDelay{
    return ^id(NSTimeInterval time){
        curDelay=time;
        return self;
    };
}
-(void) leReloadBannerWithData:(NSArray *) data{
    if(isScrolling){
        [self leStop];
    }
    curData=data;
    leTotalPages=curData.count;
    totalCount=leTotalPages;
    if(curData.count==0){
        leCurrentPage=1;
    }else if(leCurrentPage-1>=curData.count){
        leCurrentPage=curData.count;
    }
    curPageControl.numberOfPages=leTotalPages;
    curPageControl.currentPage=leCurrentPage-1;
    [self resetIndicatorStyle:curStyle];

    
}
-(void) resetIndicatorStyle:(LEBannerIndicatorStyle) style{
    curStyle=style;
    float w=curData.count*LEBannerSize;
    w=MAX(LEBannerSize, w);
    if(style==LEBannerIndicator_None){
        curPageControl.hidden=YES;
    }else{
        curPageControl.hidden=NO;
        curPageControl.leWidth(w);
        if(UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, curIndicatorMargins)){
            curPageControl.leMargins(curIndicatorMargins);
        }else{
            if(style==LEBannerIndicator_Left){
                curPageControl.leAnchor(LEI_BL).leLeft(LESideSpace).leRight(0).leWidth(w);
            }else if(style==LEBannerIndicator_Right){
                curPageControl.leAnchor(LEI_BR).leLeft(0).leRight(LESideSpace).leWidth(w);
            }else if(style==LEBannerIndicator_Center){
                curPageControl.leAnchor(LEI_BC).leLeft(0).leRight(0).leWidth(w);
            }
        }
    }
}

@end
