//
//  TestPopup.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/12/14.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "TestPopup.h"
#import "LEPopup.h"

@interface TestPopupCell : LETableViewCell
@end
@implementation TestPopupCell{
    UILabel *label;
}
-(void) leExtraInits{
    [super leExtraInits];
    self.leArrowEnabled(YES);
    label=[UILabel new].leAddTo(self).leAnchor(LEInsideTopLeft).leLeft(LESideSpace).leTop(LESideSpace).leMaxWidth(self.leArrow.frame.origin.x-LESideSpace ).leLine(0).leLineSpace(10).leColor(LERandomColor).leFont(LEFontML).leBottom(LESideSpace);
    self.leBottomView(label);
}
-(void) leSetData:(id)data  {
    [self.leArrow leUpdateLayout];
    label.leMaxWidth(self.leArrow.frame.origin.x-LESideSpace ).leText([NSString stringWithFormat:@"%zd-%@",self.leIndexPath.row+1,data]);
}
@end

@interface TestPopupPage : LEView<LETableViewDelegate,LEPopupDelegate>
@end
@implementation TestPopupPage{
    LETableView *tableView;
}
-(void) leExtraInits{
    [LENavigation new].leSuperView(self).leTitle(@"测试LEPopup");
    tableView=[LETableView new].leSuperView(self.leSubViewContainer).leDelegate(self).leCellClassname(@"TestPopupCell").leTouchEnabled(YES);
    [tableView leOnRefreshedWithData:
     @[
       @"选择性弹窗：仅有副标题（默认居中对齐）、默认取消及确定按钮",
       @"选择性弹窗：标题、分割线、副标题（自定义左对齐）、默认取消及确定按钮",
       @"选择性弹窗：标题、分割线、副标题（自定义居中对齐）、自定义取消及确定按钮",
       @"提示性弹窗：标题、分割线、副标题（默认居中对齐）、默认确定确定",
       @"提示性弹窗：标题、分割线、副标题（自定义左对齐）、默认确定按钮",
       @"提示性弹窗：标题、分割线、副标题（自定义居中对齐）、自定义确定按钮"
       ].mutableCopy
     ];
}
-(void) leOnPopupBackgroundClicked{
    LELogFunc
}
-(void) leOnPopupLeftButtonClicked{
    LELogFunc
}
-(void) leOnPopupRightButtonClicked{
    LELogFunc
}
-(void) leOnPopupCenterButtonClicked{
    LELogFunc
}
-(void) leOnPopupBackgroundClickedWith:(NSString *)identification{
    LELogObject(identification)
}
-(void) leOnPopupLeftButtonClickedWith:(NSString *)identification{
    LELogObject(identification)
}
-(void) leOnPopupRightButtonClickedWith:(NSString *)identification{
    LELogObject(identification)
}
-(void) leOnPopupCenterButtonClickedWith:(NSString *)identification{
    LELogObject(identification)
}
-(void) leOnCellEventWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:LEKeyIndex];
    switch (index.row) {
        case 0:
            [LEPopup leShowQuestionPopupWithDelegate:self Subtitle:@"仅仅只有Subtitle的选择性弹窗，默认取消及确定按钮" Identifier:@"Identifier0"];
            break;
        case 1:
            [LEPopup leShowQuestionPopupWithDelegate:self Title:@"选择性弹窗" Subtitle:@"包括标题、分割线、副标题左对齐，默认取消确定按钮" Alignment:NSTextAlignmentLeft Identifier:@"Identifier1"];
            break;
        case 2:
            [LEPopup leShowQuestionPopupWithDelegate:self Title:@"选择性弹窗+自定义取消确定按钮" Subtitle:@"包括标题、分割线、副标题居中对齐，自定义取消确定按钮" Alignment:NSTextAlignmentCenter LeftButtonText:@"自定义左侧" RightButtonText:@"自定义右侧" Identifier:@"Identifier2"];
            break;
        case 3:
            [LEPopup leShowTipPopupWithDelegate:self Title:@"提示性弹窗" Subtitle:@"这是副标题，按钮使用的是默认的配置" Identifier:@"Identifier3"];
            break;
        case 4:
            [LEPopup leShowTipPopupWithDelegate:self Title:@"提示性弹窗" Subtitle:@"这是副标题，自定义副标题左侧按钮、默认确认按钮" Aligment:NSTextAlignmentLeft Identifier:@"Identifier4"];
            break;
        case 5:
            [LEPopup leShowTipPopupWithDelegate:self Title:@"提示性弹窗" Subtitle:@"这是副标题，自定义副标题为居中显示。可以自定义按钮" Aligment:NSTextAlignmentCenter ButtonText:@"自定义确定按钮" Identifier:@"Identifier5"];
            
            break;
            
        default:
            break;
    }
}
@end

@implementation TestPopup
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self leDidRotateFrom:fromInterfaceOrientation];
}
@end
