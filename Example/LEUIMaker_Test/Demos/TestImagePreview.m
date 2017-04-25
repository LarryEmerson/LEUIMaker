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

-(void) leAdditionalInits{
    [LENavigation new].leSuperView(self).leTitle(@"TestImagePreview").leDelegate(self).leRightItemText(@"删除");
    preview=[LEImagePreview new].leSuperview(self.leSubViewContainer,nil,nil).leDelegate(self);
    
    preview.leData(@[
                     [LEColorBlue               leImageWithSize:CGSizeMake(LESCREEN_WIDTH/2, LESCREEN_HEIGHT/2)],
                     [LEColorRed                leImageWithSize:CGSizeMake(LESCREEN_WIDTH/3, LESCREEN_HEIGHT/3)],
                     [[UIColor yellowColor]     leImageWithSize:CGSizeMake(LESCREEN_WIDTH*2, LESCREEN_HEIGHT*2)],
                     [[UIColor greenColor]      leImageWithSize:CGSizeMake(LESCREEN_WIDTH*3, LESCREEN_HEIGHT*3)],
                     [[UIColor magentaColor]    leImageWithSize:CGSizeMake(LESCREEN_WIDTH*2, LESCREEN_HEIGHT/2)],
                     [[UIColor purpleColor]     leImageWithSize:CGSizeMake(LESCREEN_WIDTH/2, LESCREEN_HEIGHT*3)]
                     ]);
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
