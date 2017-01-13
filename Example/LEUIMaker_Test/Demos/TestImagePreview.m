//
//  TestImagePreview.m
//  LEUIMaker
//
//  Created by emerson larry on 2017/1/12.
//  Copyright © 2017年 LarryEmerson. All rights reserved.
//

#import "TestImagePreview.h"



@interface TestImagePreviewPage : LEView<LENavigationDelegate,LEImagePreviewDelegate>
@end
@implementation TestImagePreviewPage{
    LEImagePreview *preview;
}

-(void) leExtraInits{
    [LENavigation new].leSuperView(self).leTitle(@"TestImagePreview").leDelegate(self).leRightItemText(@"删除");
    preview=[LEImagePreview new].leSuperview(self.leSubViewContainer,nil,nil).leDelegate(self);
    
    preview.leData(@[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"]]);
}
-(void) leNavigationRightButtonTapped{
    [preview leOnDeleteCurrent];
}
-(void) leOnScrollTo:(NSInteger) index Total:(NSInteger) total Data:(id) data{
    [LEHUD leShowHud:[NSString stringWithFormat:@"%zd/%zd",index+1,total]];
}
-(void) leOnTapped  :(NSInteger) index Total:(NSInteger) total Data:(id) data{
    [LEHUD leShowHud:[NSString stringWithFormat:@"%zd/%zd",index+1,total]];
}
@end


@implementation TestImagePreview

@end
