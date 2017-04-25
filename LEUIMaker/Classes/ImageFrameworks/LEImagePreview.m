//
//  LEImagePreview.m
//  Pods
//
//  Created by emerson larry on 2017/1/12.
//
//

#import "LEImagePreview.h"

@implementation LEImagePreviewItem
-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self leAdditionalInits];
    return self;
}
-(void) leAdditionalInits{
    [self setDelegate:self];
    [self setMinimumZoomScale:1];
    [self setMaximumZoomScale:2];
}
-(UIImageView *) curImage{
    if(!_curImage){
        _curImage=[UIImageView new].leAddTo(self).leAnchor(LEI_TL).leSize(self.bounds.size);
    }
    return _curImage;
}
-(void) resetZoomScale{
    UIImage *img=self.curImage.image;
    if(img){
        float value=MAX(img.size.width/LESCREEN_WIDTH, img.size.height/self.bounds.size.height);
        if(value>1){
            self.curImage.leSize(CGSizeMake(self.curImage.bounds.size.width/value, self.curImage.bounds.size.height/value));
        }
        [self setMinimumZoomScale:1];
        [self setMaximumZoomScale:MAX(value<1?1/value:value*2, 2)];
        [self setZoomScale:self.minimumZoomScale];
    }
}
-(void) leSetData:(id) data{
    if([data isKindOfClass:[UIImage class]]){
        self.curImage.leImage(data);
    }else if([data isKindOfClass:[NSString class]]){
        self.curImage.leDownloadWithURL(data);
    }
    [self resetZoomScale];
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.curImage;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect center=self.curImage.frame;
    center.origin.x=center.size.width<LESCREEN_WIDTH?(LESCREEN_WIDTH-center.size.width)*0.5:0;
    center.origin.y=center.size.height<self.bounds.size.height?(self.bounds.size.height-center.size.height)*0.5:0;
    self.curImage.frame=center;
    self.contentOffset=CGPointMake(center.origin.x!=0?0:self.contentOffset.x, center.origin.y!=0?0:self.contentOffset.y);
    self.contentInset = UIEdgeInsetsZero;
}
@end

@implementation LEImagePreview{
    NSString *curItemClassname;
    __weak id<LEImagePreviewDelegate> curDelegate;
    NSMutableArray *curItemCahce;
}
-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    self.pagingEnabled=YES;
    self.showsVerticalScrollIndicator=NO;
    self.showsHorizontalScrollIndicator=NO;
    self.delegate=self;
    curItemCahce=[NSMutableArray new];
    [self leAdditionalInits];
    return self;
}
-(__kindof LEImagePreview *(^)(UIView *superview, NSString *itemClassname, NSArray *data)) leSuperview{
    return ^id(UIView *superview, NSString *itemClassname, NSArray *data){
        self.leAddTo(superview).leMargins(UIEdgeInsetsZero);
        curItemClassname=itemClassname?:@"LEImagePreviewItem";
        self.curData=data.mutableCopy;
        [self onRefresh];
        return self;
    };
}
-(__kindof LEImagePreview *(^)(id<LEImagePreviewDelegate> delegate)) leDelegate{
    return ^id(id<LEImagePreviewDelegate> delegate){
        curDelegate=delegate;
        return self;
    };
}
-(__kindof LEImagePreview *(^)(NSArray *data)) leData{
    return ^id(NSArray *data){
        self.curData=data.mutableCopy;
        [self onRefresh];
        return self;
    };
}
-(void) onRefresh{
    if(self.curData){
        for (NSInteger i=0; i<MAX(self.curData.count, curItemCahce.count); i++) {
            LEImagePreviewItem *item=nil;
            if(i<self.curData.count){
                if(i<curItemCahce.count){
                    item=[curItemCahce objectAtIndex:i];
                    item.hidden=NO;
                }else{
                    item=(LEImagePreviewItem *)[[curItemClassname leGetInstanceFromClassName] init];
                    item.leAddTo(self).leAnchor(LEI_LC).leLeft(i*LESCREEN_WIDTH).leEqualSuperViewWidth(1).leEqualSuperViewHeight(1).leTouchEvent(@selector(onTap),self);
                    [curItemCahce addObject:item];
                }
                [item leSetData:[self.curData objectAtIndex:i]];
            }else if(i<curItemCahce.count){
                [[curItemCahce objectAtIndex:i] setHidden:YES];
            }
        }
        [self setContentSize:CGSizeMake(LESCREEN_WIDTH*self.curData.count, self.bounds.size.height)];
    }
}
-(void) onTap{
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnTapped:Total:Data:)]&&self.curIndex<self.curData.count){
        [curDelegate leOnTapped:self.curIndex Total:self.curData.count Data:[self.curData objectAtIndex:self.curIndex]];
    }
}
-(void) leDidRotateFrom:(UIInterfaceOrientation)from{
    for (NSInteger i=0; i<curItemCahce.count; i++) {
        LEImagePreviewItem *item=[curItemCahce objectAtIndex:i];
        item.leLeft(LESCREEN_WIDTH*i);
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.curIndex = scrollView.contentOffset.x/scrollView.bounds.size.width;
    for (NSInteger i=0; i<curItemCahce.count; i++) {
        if(i!=self.curIndex){
            LEImagePreviewItem *item=[curItemCahce objectAtIndex:i];
            [item setZoomScale:1];
            [item setNeedsDisplay];
        }
    }
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnScrollTo:Total:Data:)]&&self.curIndex<self.curData.count){
        [curDelegate leOnScrollTo:self.curIndex Total:self.curData.count Data:[self.curData objectAtIndex:self.curIndex]];
    }
}
-(void) leOnDeleteCurrent{
    if(self.curIndex<self.curData.count){
        [self.curData removeObjectAtIndex:self.curIndex];
        LEImagePreviewItem *item=[curItemCahce objectAtIndex:self.curIndex];
        if(item){
            [curItemCahce removeObjectAtIndex:self.curIndex];
            [item removeFromSuperview];
        }
        [self setContentSize:CGSizeMake(LESCREEN_WIDTH*self.curData.count, self.bounds.size.height)];
        for (NSInteger i=0; i<curItemCahce.count; i++) {
            LEImagePreviewItem *item=[curItemCahce objectAtIndex:i];
            item.leLeft(i*LESCREEN_WIDTH);
            [item setZoomScale:1];
            [item setNeedsLayout];
        }
    }
    self.curIndex=self.curIndex<self.curData.count?self.curIndex:(MAX(0, self.curIndex-1));
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnScrollTo:Total:Data:)]&&self.curIndex<self.curData.count){
        [curDelegate leOnScrollTo:self.curIndex Total:self.curData.count Data:[self.curData objectAtIndex:self.curIndex]];
    }
} 
@end
