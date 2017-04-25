//
//  LETableViewOptimized.h
//  Pods
//
//  Created by emerson larry on 2016/12/1.
//
//

#import "LETableView.h"
/** not suggested to use 不建议使用 */
@interface LETableViewCellOptimized : UIView
@property (nonatomic) id leData; 
@property (nonatomic) NSIndexPath *leIndexPath;
-(id<LETableViewDelegate>) leDelegate;
-(void) leSetData:(id)data NS_REQUIRES_SUPER;
-(void) leSetIndex:(NSIndexPath *)index;
-(void) leOnIndexSet;
-(void) leOnCellEventWithInfo:(NSDictionary *) info;
-(void) leOnCellEventWithIndex:(int) index; 
-(CGFloat) leGetHeight;
@end

@interface LETableViewOptimized : LETableView
@property (nonatomic) NSMutableArray *leDisplayCellCache;
-(void) leAdditionalInits NS_REQUIRES_SUPER;
@end

@interface LETableViewOptimizedWithRefresh : LETableViewOptimized
@end
