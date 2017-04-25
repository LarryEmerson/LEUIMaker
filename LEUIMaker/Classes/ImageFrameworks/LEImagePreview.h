//
//  LEImagePreview.h
//  Pods
//
//  Created by emerson larry on 2017/1/12.
//
//

#import <Foundation/Foundation.h>
#import "LEViewAdditions.h"
#import "LEUICommon.h"
#import "LEImageFrameworks.h"
@protocol LEImagePreviewDelegate <NSObject>
-(void) leOnScrollTo:(NSInteger) index Total:(NSInteger) total Data:(id) data;
-(void) leOnTapped  :(NSInteger) index Total:(NSInteger) total Data:(id) data;
@end

@interface LEImagePreviewItem : UIScrollView<UIScrollViewDelegate>
@property (nonatomic) UIImageView *curImage;
@property (nonatomic) id curData;

-(void) leAdditionalInits NS_REQUIRES_SUPER;
-(void) leSetData:(id) data;
-(void) resetZoomScale;
@end

@interface LEImagePreview : UIScrollView<UIScrollViewDelegate>
@property (nonatomic) NSMutableArray *curData;
@property (nonatomic) NSInteger curIndex;
-(__kindof LEImagePreview *(^)(UIView *superview, NSString *itemClassname, NSArray *data)) leSuperview;
-(__kindof LEImagePreview *(^)(id<LEImagePreviewDelegate> delegate)) leDelegate;
-(__kindof LEImagePreview *(^)(NSArray *data)) leData;
-(void) leOnDeleteCurrent;
@end
