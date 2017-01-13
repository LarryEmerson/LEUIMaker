//
//  TestConfigurableList.m
//  LEUIMaker
//
//  Created by emerson larry on 2017/1/9.
//  Copyright © 2017年 LarryEmerson. All rights reserved.
//

#import "TestConfigurableList.h"
#import "LEHUD.h"


@interface LEConfigurableCell_Customized : LEConfigurableCell
@end
@implementation LEConfigurableCell_Customized{
    UILabel *label;
    UILabel *subLabel;
    UIImageView *icon;
    UIView *container;
}
-(void) leExtraInits{
    [super leExtraInits];
    self.curContainer.leHorizontalStack();
    icon=[UIImageView new].leLeft(LESideSpace).leSize(LESquareSize(LEAvatarSize));
    float labelW=LESCREEN_WIDTH-LESideSpace*3-LEAvatarSize;
    container=[UIView new].leLeft(LESideSpace).leWidth(labelW).leHeight(LECellH).leVerticalStack().leStackAlignmnet(LELeftAlign);
    label=[UILabel new].leTop(LESideSpace).leLine(2).leMaxWidth(labelW).leFont(LEBoldFontML).leColor(LEColorRed).leLineSpace(4);
    subLabel=[UILabel new].leTop(6).leBottom(LESideSpace).leLine(1).leMaxWidth(labelW).leFont(LEFontSS).leColor(LEColorBlue);
    [container lePushToStack:label,subLabel,nil];
    [self.curContainer lePushToStack:icon,container,nil];
    self.leBottomView(self.curContainer);
}
-(void) leSetData:(id) data{
    float labelW=LESCREEN_WIDTH-LESideSpace*3-LEAvatarSize;
    icon.leImage([data objectForKey:LEConfigurableCellKey_LocalImage]);
    label.leMaxWidth(labelW).leText([data objectForKey:LEConfigurableCellKey_Title]);
    subLabel.leText([data objectForKey:LEConfigurableCellKey_Subtitle]);
    [super leSetData:data];
}
-(void) leDidRotateFrom:(UIInterfaceOrientation)from{
    [super leDidRotateFrom:from];
    float labelW=LESCREEN_WIDTH-LESideSpace*3-LEAvatarSize;
    [label.leMaxWidth(labelW) leUpdateLayout];
    [subLabel.leMaxWidth(labelW) leUpdateLayout];
}
@end
@interface TestConfigurableList ()<LETableViewDelegate,LETableViewDataSource> @end
@implementation TestConfigurableList{
    LEConfigurableListWithRefresh  *list;
}
-(void) leExtraInits{
    [[LEUICommon sharedInstance] leSetViewBGColor:LEColorBG9];
    LEView *view=[LEView new].leSuperViewcontroller(self);
    [LENavigation new].leSuperView(view).leTitle(@"测试ConfigurableList");
    view.leSubViewContainer.leBgColor(LEColorText9);
    [[LEConfigurableCellManager sharedInstance] leRegisterItemWithClassName:@"LEConfigurableCell_Customized" Type:100];
    list=[LEConfigurableListWithRefresh new].leSuperView(view.leSubViewContainer).leDelegate(self).leDataSource(self);
    list.backgroundColor=[LEUICommon sharedInstance].leViewBGColor;
    [self leOnRefreshData];
}
-(void) leOnRefreshData{
    NSMutableArray *curData=[NSMutableArray new];
    
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:100],
                         LEConfigurableCellKey_Title:@"LEConfigurableCell_Customized这是自定义Cell的title部分，最多允许显示2行内容，超出的内容则会被符合“...”所替代",
                         LEConfigurableCellKey_Subtitle:@"这是自定义Item的subtitle，只能显示1行，超过的内容则会被符合“...”所替代",
                         LEConfigurableCellKey_LocalImage:[LEColorBlue leImageWithSize:LESquareSize(LEAvatarSize)],
                         LEConfigurableCellKey_Function:@"LEConfigurableCell_Customized"
                         }];
    
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Icon_Title_R_Arrow],
                         LEConfigurableCellKey_Title:@"L_Icon_Title_R_Arrow. Icon's round corner is configurable  可设定图标圆角",
                         LEConfigurableCellKey_Color:LEColorBlue,
                         LEConfigurableCellKey_TitleFontsize:[NSNumber numberWithInt:20],
                         LEConfigurableCellKey_IconPlaceHolder:[LEColorMask leImageWithSize:LESquareSize(LEAvatarSize)],
                         LEConfigurableCellKey_LocalImage:[LEColorBlue leImageWithSize:LESquareSize(LEAvatarSize)],
                         LEConfigurableCellKey_Function:@"L_Icon_Title_R_Arrow"
                         }];
    
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Subtitle],
                         LEConfigurableCellKey_Title:@"L_Title_R_Subtitle",
                         LEConfigurableCellKey_Color:LEColorRed,
                         LEConfigurableCellKey_Subtitle:@"blue subtitle wraps automatically with line spacing assigned as 20 and right margin as 30\n蓝色的副标题当前行间距设定为20、右边距设定为30且自动换行",
                         LEConfigurableCellKey_SubTitleFontsize:[NSNumber numberWithInt:8],
                         LEConfigurableCellKey_SubTitleColor:LEColorBlue,
                         LEConfigurableCellKey_Linespace:[NSNumber numberWithInt:20],
                         LEConfigurableCellKey_RightEdgeKey:[NSNumber numberWithInt:LESideSpace*3],
                         LEConfigurableCellKey_Function:@"L_Title_R_Subtitle"
                         }];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Icon_Arrow],
                         LEConfigurableCellKey_Title:@"L_Title_R_Icon_Arrow.可设定图标圆角 Icon's round corner is configurable",
                         LEConfigurableCellKey_IconPlaceHolder:[LEColorMask leImageWithSize:LESquareSize(LEAvatarSize)],
                         LEConfigurableCellKey_LocalImage:[LEColorBlue leImageWithSize:LESquareSize(LEAvatarSize)],
                         LEConfigurableCellKey_ImageCorner:[NSNumber numberWithInt:6],
                         LEConfigurableCellKey_Function:@"L_Title_R_Icon_Arrow"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Arrow],
                         LEConfigurableCellKey_Title:@"L_Title_R_Arrow",
                         LEConfigurableCellKey_Function:@"L_Title_R_Arrow"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:M_Submit],
                         LEConfigurableCellKey_LocalImage:[LEColorRed leImage],
                         LEConfigurableCellKey_ImageCorner:[NSNumber numberWithInt:8],
                         LEConfigurableCellKey_Color:LEColorWhite,
                         LEConfigurableCellKey_TitleFontsize:[NSNumber numberWithInt:20],
                         LEConfigurableCellKey_Title:@"M_Submit.可设定按钮圆角 ",
                         LEConfigurableCellKey_Function:@"M_Submit"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Switch],
                         LEConfigurableCellKey_Title:@"L_Title_R_Switch",
                         LEConfigurableCellKey_Switch:[NSNumber numberWithBool:YES],
                         LEConfigurableCellKey_Function:@"L_Title_R_Switch"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Subtitle_Arrow],
                         LEConfigurableCellKey_Title:@"L_Title_R_Subtitle_Arrow",
                         LEConfigurableCellKey_Subtitle:@"下面是分割线 next comes the split line 下面是分割线 next comes the split line下面是分割线 next comes the split line",
                         LEConfigurableCellKey_Function:@"L_Title_R_Subtitle_Arrow"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:F_SectionSolid],
                         LEConfigurableCellKey_Color:LEColorTest,
                         LEConfigurableCellKey_Function:@"F_SectionSolid"}];
    [list leOnRefreshedWithData:curData];
}
-(void) leOnCellEventWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:LEKeyIndex];
    NSString *func=[[list.leItemsArray objectAtIndex:index.row] objectForKey:LEConfigurableCellKey_Function];
    [LEHUD leShowHud:[NSString stringWithFormat:@"未找到方法%@，走回调leOnTableViewCellSelectedWithInfo", func]];
}
-(void) leOnLoadMore{
    [list leOnLoadedMoreWithData:[@[@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:F_SectionSolid],
                                    LEConfigurableCellKey_Color:LERandomColor}] mutableCopy]];
}
-(void) L_Icon_Title_R_Arrow{
    LELogFunc
    [LEHUD leShowHud:@"根据方法名称，找到已经实现的方法L_Icon_Title_R_Arrow"];
}
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

-(void) leDidRotateFrom:(UIInterfaceOrientation)from{
    [super leDidRotateFrom:from];
    [list leDidRotateFrom:from];
}
@end
