//
//  LERefresh.m
//  Pods
//
//  Created by emerson larry on 16/7/11.
//
//

#import "LERefresh.h"

#define LEIndicatorSize 30
@implementation LERefresh
-(void) setIsEnabled:(BOOL)isEnabled{
    _isEnabled=isEnabled;
    [self.refreshContainer setUserInteractionEnabled:isEnabled];
    [self.refreshContainer setHidden:!isEnabled];
}
-(void) setCurScrollView:(UIScrollView *)curScrollView{
    _curScrollView=curScrollView;
    [_curScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}
-(void) dealloc{
    [self leRelease];
}
-(void) leRelease{
    self.refreshBlock=nil;
    [self.refreshContainer removeFromSuperview];
    [self.curRefreshLabel removeFromSuperview];
    [self.curIndicator removeFromSuperview];
    [self.curScrollView removeObserver:self forKeyPath:@"contentOffset"];
}
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([@"contentOffset" isEqualToString:keyPath]){ 
        [self onScrolling];
    }
}
-(void) onScrolling{}
-(void) onBeginRefresh{}
-(void) onEndRefresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.curScrollView.contentInset=UIEdgeInsetsZero;
        }];
        self.curRefreshState=LERefreshBegin;
        [self.curIndicator stopAnimating];
    });
}
-(instancetype) initWithTarget:(UIScrollView *) scrollview{
    self=[super init];
    self.curScrollView=scrollview;
    self.curIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self initRefreshView];
    self.curRefreshState=LERefreshBegin;
    return self;
}
-(void) initRefreshView{}
-(void) setCurRefreshState:(LERefreshState)curRefreshState{
    _curRefreshState=curRefreshState;
    [self onResetRefreshString];
}
-(void) onResetRefreshString{
    switch (self.curRefreshState) {
        case LERefreshBegin:
            self.curIndicator.leSize(CGSizeZero).leMargins(UIEdgeInsetsZero);
            self.curRefreshLabel.leMargins(UIEdgeInsetsZero).leText(self.beginRefreshString);
            break;
        case LERefreshRelease:
            self.curIndicator.leSize(CGSizeZero).leMargins(UIEdgeInsetsZero);
            self.curRefreshLabel.leMargins(UIEdgeInsetsZero).leText(self.refreshReleaseString);
            break;
        case LERefreshLoading:
            self.curIndicator.leSize(LESquareSize(LEIndicatorSize)).leRight(LESideSpace);
            self.curRefreshLabel.leLeft(LESideSpace).leText(self.loadingString);
            [self.curIndicator startAnimating];
            break;
        default:
            break;
    }
}
@end

@implementation LERefreshHeader{
    float topRefreshHeight;
}
-(void) initRefreshView{
    self.beginRefreshString=LERefreshStringPullDown;
    self.loadingString=LERefreshStringLoading;
    self.refreshReleaseString=LERefreshStringRelease;
    topRefreshHeight=LENavigationBarHeight;
    self.refreshContainer=[UIView new].leAddTo(self.curScrollView).leAnchor(LEOutsideTopCenter).leWidth(LESCREEN_WIDTH).leHeight(topRefreshHeight);
    UIView *wrapper=[UIView new].leAddTo(self.refreshContainer).leAnchor(LEInsideCenter).leWrapper();
    self.curRefreshLabel=[UILabel new].leAddTo(wrapper).leAnchor(LEInsideRightCenter).leFont(LEFontSL).leAlignment(NSTextAlignmentCenter).leText(self.beginRefreshString);
    self.curIndicator.leAddTo(wrapper).leAnchor(LEOutsideLeftCenter).leRelativeTo(self.curRefreshLabel).leRight(LESideSpace).leSize(LESquareSize(LEIndicatorSize));
    [self setIsEnabled:YES];
}
-(void) onScrolling{
    [super onScrolling];
    if(self.isEnabled){
        float offsetY=self.curScrollView.contentOffset.y;
        if(offsetY<=0){
            if(self.curScrollView.dragging){
                if(self.curRefreshState!=LERefreshLoading){
                    if(offsetY<-topRefreshHeight){
                        if(self.curRefreshState!=LERefreshRelease){
                            self.curRefreshState=LERefreshRelease;
                        }
                    }else{
                        if(self.curRefreshState!=LERefreshLoading){
                            self.curRefreshState=LERefreshBegin;
                        }
                    }
                }
            }else{
                if(offsetY<-topRefreshHeight){
                    if(self.curRefreshState==LERefreshRelease){
                        [self onBeginRefresh];
                    }
                } 
            }
        }
    }
}
-(void) onBeginRefresh{
    if(self.curRefreshState!=LERefreshLoading){
        self.curRefreshState=LERefreshLoading;
        [UIView animateWithDuration:0.3 animations:^{
            float offsetY=self.curScrollView.contentOffset.y;
            if(offsetY<-topRefreshHeight){
                self.curScrollView.contentOffset=CGPointMake(0, offsetY-topRefreshHeight);
            }
            self.curScrollView.contentInset=UIEdgeInsetsMake(topRefreshHeight, 0, 0, 0);
        }];
        self.refreshBlock();
    }
}
@end
@implementation LERefreshFooter{
    float topRefreshHeight;
    float offset;
}
-(void) onSetCollectionViewContentInsects:(UIEdgeInsets ) insects{
    offset=insects.top+insects.bottom;
}
-(void) initRefreshView{
    self.beginRefreshString=LERefreshStringPullUp;
    self.loadingString=LERefreshStringLoading;
    self.refreshReleaseString=LERefreshStringRelease;
    topRefreshHeight=LENavigationBarHeight;
    self.refreshContainer=[UIView new].leAddTo(self.curScrollView).leAnchor(LEOutsideBottomCenter).leWidth(LESCREEN_WIDTH).leHeight(topRefreshHeight);
    UIView *wrapper=[UIView new].leAddTo(self.refreshContainer).leAnchor(LEInsideCenter).leWrapper();
    self.curRefreshLabel=[UILabel new].leAddTo(wrapper).leAnchor(LEInsideRightCenter).leFont(LEFontSL).leAlignment(NSTextAlignmentCenter).leText(self.beginRefreshString);
    self.curIndicator.leAddTo(wrapper).leAnchor(LEOutsideLeftCenter).leRelativeTo(self.curRefreshLabel).leRight(LESideSpace).leSize(LESquareSize(LEIndicatorSize));
    [self setIsEnabled:YES];
}
-(void) onScrolling{
    [super onScrolling];
    if(self.isEnabled){
        float offsetY=self.curScrollView.contentOffset.y;
        if(offsetY>=0){
            CGSize size=self.curScrollView.contentSize;
            size.height=MAX(size.height, self.curScrollView.bounds.size.height);
            if(CGSizeEqualToSize(size, self.curScrollView.contentSize)){
                [self.curScrollView setContentSize:size];
            }
            float gap=self.curScrollView.contentSize.height-self.curScrollView.bounds.size.height;
            float maxOffset=MAX(topRefreshHeight, topRefreshHeight+gap);
            self.refreshContainer.leTop(gap>0?gap:-self.curScrollView.contentInset.top-self.curScrollView.contentInset.bottom+offset);
            if(self.curScrollView.dragging){
                if(self.curRefreshState!=LERefreshLoading){
                    if(offsetY>maxOffset){
                        if(self.curRefreshState!=LERefreshRelease){
                            self.curRefreshState=LERefreshRelease;
                        }
                    }else{
                        if(self.curRefreshState!=LERefreshLoading){
                            self.curRefreshState=LERefreshBegin;
                        }
                    }
                }
            }else{
                if(offsetY>maxOffset){
                    if(self.curRefreshState==LERefreshRelease){
                        [self onBeginRefresh];
                    }
                }
            }
        }
    }
}
-(void) onBeginRefresh{
    if(self.curRefreshState!=LERefreshLoading){
        self.curRefreshState=LERefreshLoading;
        [UIView animateWithDuration:0.3 animations:^{
            self.curScrollView.contentInset=UIEdgeInsetsMake(0, 0, topRefreshHeight, 0);
        }];
        self.refreshBlock();
    }
}
@end
