//
//  LEConfigurableList.m
//  Pods
//
//  Created by emerson larry on 2017/1/7.
//
//

#import "LEConfigurableList.h"



@interface LEConfigurableCellManager ()
@property (nonatomic) NSMutableDictionary *registedItems;
@property (nonatomic) UIImage *arrowImage;
-(NSString *) getClassWithType:(LEConfigurableCellType) type;
@end

#pragma Cell
@implementation LEConfigurableCell
-(void) leAdditionalInits{
    self.curContainer=[UIView new].leAddTo(self).leAnchor(LEI_TL).leWidth(LESCREEN_WIDTH).leHeight(LECellH);
    self.leBottomView(self.curContainer);
}
-(void) leDidRotateFrom:(UIInterfaceOrientation)from{
    [super leDidRotateFrom:from];
    [self.contentView.leWidth(LESCREEN_WIDTH) leUpdateLayout];
    [self.curContainer.leWidth(LESCREEN_WIDTH) leUpdateLayout];
}
-(void) leSetData:(id)data{
    if([data isKindOfClass:[NSDictionary class]]){
        if([data objectForKey:LEConfigurableCellKey_Function]){
            self.leTouchEnabled(YES);
        }else{
            self.leTouchEnabled(NO);
        }
    }
    [super leSetData:data];
}
-(void) onTapped{
    [self leOnCellEventWithInfo:nil];
}
@end
#pragma
@interface LEItem_L_Title_R_Arrow : LEConfigurableCell
@end
@implementation LEItem_L_Title_R_Arrow{
    UILabel *label;
    UIImageView *arrow;
}
-(void)leAdditionalInits{
    [super leAdditionalInits];
    label=[UILabel new].leAddTo(self.curContainer).leAnchor(LEI_LC).leLeft(LESideSpace);
    arrow=[UIImageView new].leAddTo(self.curContainer).leAnchor(LEI_RC).leRight(LESideSpace).leSize(LESquareSize(LEAvatarSize));
    [arrow setContentMode:UIViewContentModeCenter];
    arrow.leImage([LEUICommon sharedInstance].leListRightArrow);
    label.leMarginForMaxWidth(LESideSpace+LEAvatarSize).leFont(LEFontML).leLine(1);
}
-(void) leSetData:(id) data{
    id value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [label setTextColor:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [label setFont:LEFont([value intValue])];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        label.leText(value);
    }
    [super leSetData:data];
}
@end
@interface LEItem_L_Title_R_Switch : LEConfigurableCell
@end
@implementation LEItem_L_Title_R_Switch{
    UISwitch *curSwitch;
    UILabel *label;
}
-(void)leAdditionalInits{
    [super leAdditionalInits];
    curSwitch=[UISwitch new];
    curSwitch.leAddTo(self.curContainer).leAnchor(LEI_RC).leRight(LESideSpace).leSize(curSwitch.bounds.size).leTouchEvent(@selector(onTapped),self);
    label=[UILabel new].leAddTo(self.curContainer).leAnchor(LEI_LC).leLeft(LESideSpace).leFont(LEFontML).leLine(1).leMarginForMaxWidth(LESideSpace*3+curSwitch.bounds.size.width);
}
-(void) leSetData:(id) data{
    id value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [label setTextColor:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [label setFont:LEFont([value intValue])];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        label.leText(value);
    }
    value=[data objectForKey:LEConfigurableCellKey_Switch];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [curSwitch setOn:[value boolValue]];
    }
    [super leSetData:data];
    self.leTouchEnabled(NO);
}
@end
//
@interface LEItem_L_Title_R_Subtitle : LEConfigurableCell
@end
@implementation LEItem_L_Title_R_Subtitle{
    UILabel *label;
    UILabel *labelSub;
}
-(void)leAdditionalInits{
    [super leAdditionalInits];
    UIView *anchor=[UIView new].leAddTo(self.curContainer).leSize(CGSizeMake(1, LECellH));
    label=[UILabel new].leAddTo(self.curContainer).leRelativeTo(anchor).leAnchor(LEO_RC).leLeft(LESideSpace-1).leFont(LEFontML).leLine(1).leColor(LEColorBlack).leMarginForMaxWidth(LESideSpace*2);
    labelSub=[UILabel new].leAddTo(self.curContainer).leAnchor(LEI_TR).leTop((LECellH-LEFontSizeSL)*0.5).leRight(LESideSpace).leFont(LEFontSL).leColor(LEColorText3).leAlignment(NSTextAlignmentRight).leLine(0);
}
-(void) leSetData:(id) data{
    int fontsize=LEFontSizeML;
    int subfontsize=LEFontSizeSL;
    int edge=LESideSpace;
    id value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [label setTextColor:value];
    }else{
        [label setTextColor:LEColorBlack];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        label.leText(value);
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        label.leFont(LEFont(fontsize=[value intValue]));
    }
    value=[data objectForKey:LEConfigurableCellKey_RightEdgeKey];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        edge=abs([value intValue]);
        labelSub.leTop((LECellH-subfontsize)*0.5).leRight(edge);
    }
    value=[data objectForKey:LEConfigurableCellKey_SubTitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        subfontsize=[value intValue];
        labelSub.leFont(LEFont(subfontsize));
    }
    value=[data objectForKey:LEConfigurableCellKey_SubTitleColor];
    if(value&&[value isKindOfClass:[UIColor class]]){
        labelSub.leColor(value);
    }else{
        labelSub.leColor(LEColorText3);
    }
    value=[data objectForKey:LEConfigurableCellKey_Linespace];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        labelSub.leLineSpace([value floatValue]);
    }
    value=[data objectForKey:LEConfigurableCellKey_Subtitle];
    if(value&&[value isKindOfClass:[NSString class]]){
        labelSub.leMaxWidth(LESCREEN_WIDTH-LESideSpace*2-label.bounds.size.width-edge).leText(value);
    }
    self.curContainer.leHeight(MAX((LECellH-subfontsize)*0.5+(int)labelSub.bounds.size.height+LESideSpace, LECellH));
    [super leSetData:data];
}
@end
@interface LEItem_L_Title_R_Subtitle_Arrow : LEConfigurableCell
@end
@implementation LEItem_L_Title_R_Subtitle_Arrow{
    UILabel *label;
    UILabel *labelSub;
}
-(void) leAdditionalInits{
    [super leAdditionalInits];
    label=[UILabel new].leAddTo(self.curContainer).leAnchor(LEI_LC).leLeft(LESideSpace).leFont(LEFontML).leLine(1);
    UIImageView *arrow= [UIImageView new].leAddTo(self.curContainer).leAnchor(LEI_RC).leRight(LESideSpace).leSize(LESquareSize(LEAvatarSize));
    [arrow setContentMode:UIViewContentModeCenter];
    arrow.leImage([LEUICommon sharedInstance].leListRightArrow);
    labelSub=[UILabel new].leAddTo(self.curContainer).leAnchor(LEI_RC).leRight(LEAvatarSize).leFont(LEFontSL).leColor(LEColorText3).leLine(1).leAlignment(NSTextAlignmentRight);
}
-(void) leSetData:(id) data{
    int subfontsize=LEFontSizeSL;
    id value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [label setTextColor:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [label setFont:LEFont([value intValue])];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        label.leText(value);
    }
    value=[data objectForKey:LEConfigurableCellKey_SubTitleColor];
    if(value&&[value isKindOfClass:[UIColor class]]){
        labelSub.leColor(value);
    }else{
        labelSub.leColor(LEColorText3);
    }
    value=[data objectForKey:LEConfigurableCellKey_SubTitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        subfontsize=[value intValue];
        labelSub.leFont(LEFont(subfontsize));
    }
    value=[data objectForKey:LEConfigurableCellKey_Subtitle];
    if(value&&[value isKindOfClass:[NSString class]]){
        labelSub.leMaxWidth(LESCREEN_WIDTH-LESideSpace*2-LEAvatarSize-label.bounds.size.width).leText(value);
    }
    [super leSetData:data];
}
@end
//
@interface LEItem_L_Icon_Title_R_Arrow : LEConfigurableCell
@end
@implementation LEItem_L_Icon_Title_R_Arrow{
    UIImageView *icon;
    UILabel *label;
    UIImageView *arrow;
}
-(void) leAdditionalInits{
    [super leAdditionalInits];
    icon=[UIImageView new].leAddTo(self.curContainer).leAnchor(LEI_LC).leLeft(LESideSpace).leSize(LESquareSize(LEAvatarSize)).leCorner(LEAvatarSize/2);
    label=[UILabel new].leAddTo(self.curContainer).leRelativeTo(icon).leAnchor(LEO_RC).leLeft(LESideSpace).leFont(LEFontML).leLine(1).leMarginForMaxWidth(LESideSpace*3+LEAvatarSize*2);
    arrow= [UIImageView new].leAddTo(self.curContainer).leAnchor(LEI_RC).leRight(LESideSpace).leSize(LESquareSize(LEAvatarSize)).leImage([LEUICommon sharedInstance].leListRightArrow);
    [arrow setContentMode:UIViewContentModeCenter];
}
-(void) leSetData:(id) data{
    id value=[data objectForKey:LEConfigurableCellKey_IconPlaceHolder];
    if(value&&[value isKindOfClass:[UIImage class]]){
        icon.lePlaceholder(value);
        if(icon.image==nil){
            icon.leImage(value);
        }
    }
    value=[data objectForKey:LEConfigurableCellKey_LocalImage];
    if(value&&[value isKindOfClass:[UIImage class]]){
        icon.leImage(value);
    }
    value=[data objectForKey:LEConfigurableCellKey_ImageURL];
    if(value&&[value isKindOfClass:[NSString class]]&&[value length]>0){
        icon.leDownloadWithURL(value);
    }
    value=[data objectForKey:LEConfigurableCellKey_ImageCorner];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        icon.leCorner([value intValue]);
    }
    value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [label setTextColor:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [label setFont:LEFont([value intValue])];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        label.leText(value);
    }
    [super leSetData:data];
}
@end
@interface LEItem_L_Title_R_Icon_Arrow : LEConfigurableCell
@end
@implementation LEItem_L_Title_R_Icon_Arrow{
    UIImageView *icon;
    UILabel *label;
}
-(void) leAdditionalInits{
    [super leAdditionalInits];
    label=[UILabel new].leAddTo(self.curContainer).leAnchor(LEI_LC).leLeft(LESideSpace).leFont(LEFontML).leLine(1).leMarginForMaxWidth(LESideSpace+LEAvatarSize*2);
    UIImageView *arrow= [UIImageView new].leAddTo(self.contentView).leAnchor(LEI_RC).leRight(LESideSpace).leSize(LESquareSize(LEAvatarSize));
    arrow.leImage([LEUICommon sharedInstance].leListRightArrow);
    [arrow setContentMode:UIViewContentModeCenter];
    icon=[UIImageView new].leAddTo(self.curContainer).leAnchor(LEI_RC).leRight(LEAvatarSize).leSize(LESquareSize(LEAvatarSize)).leCorner(LEAvatarSize/2);
}
-(void) leSetData:(id) data{
    id value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [label setTextColor:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [label setFont:LEFont([value intValue])];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        label.leText(value);
    }
    value=[data objectForKey:LEConfigurableCellKey_IconPlaceHolder];
    if(value&&[value isKindOfClass:[UIImage class]]){
        icon.lePlaceholder(value);
        if(!icon.image){
            icon.leImage(value);
        }
    }
    value=[data objectForKey:LEConfigurableCellKey_ImageCorner];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        icon.leCorner([value intValue]);
    }
    value=[data objectForKey:LEConfigurableCellKey_LocalImage];
    if(value&&[value isKindOfClass:[UIImage class]]){
        icon.leImage(value);
    }
    value=[data objectForKey:LEConfigurableCellKey_ImageURL];
    if(value&&[value isKindOfClass:[NSString class]]){
        icon.leQiniuImageWithURLAndSize(value, LEAvatarSize, LEAvatarSize);
    }
    [super leSetData:data];
}

@end
@interface LEItem_M_Submit : LEConfigurableCell
@end
@implementation LEItem_M_Submit{
    UIButton *btn;
}
-(void) leAdditionalInits{
    [super leAdditionalInits];
    self.curContainer.backgroundColor=[LEUICommon sharedInstance].leViewBGColor;
    btn=[UIButton new].leAddTo(self.curContainer).leAnchor(LEI_C).leEqualSuperViewWidth(1-LESideSpace*1.0/LESCREEN_WIDTH).leBtnFixedHeight(LECellH-LESideSpace).leFont(LEFontSL).leTouchEvent(@selector(onTapped),self);
}
-(void) leSetData:(id) data{
    id value=[data objectForKey:LEConfigurableCellKey_LocalImage];
    if(value&&[value isKindOfClass:[UIImage class]]){
        btn.leBtnBGImgN([value leStreched]);
    }
    value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        btn.leBtnColorN(value);
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [btn.titleLabel setFont:LEFont([value intValue])];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        btn.leText(value);
    }
    value=[data objectForKey:LEConfigurableCellKey_ImageCorner];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        btn.leCorner([value intValue]);
    }
    [super leSetData:data];
    self.leTouchEnabled(NO);
}
@end
@interface LEItem_F_SectionSolid : LEConfigurableCell
@end
@implementation LEItem_F_SectionSolid
-(void) leAdditionalInits{
    [super leAdditionalInits];
    self.curContainer.leHeight(LESectionHM);
}
-(void) leSetData:(id) data{
    id value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        self.curContainer.backgroundColor=value;
    }
    value=[data objectForKey:LEConfigurableCellKey_Height];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        self.curContainer.leHeight([value floatValue]);
    }
    [super leSetData:data];
}
@end

@interface LEConfigurableList ()<LETableViewDelegate>
@end
@implementation LEConfigurableList{
    __weak id<LETableViewDelegate> linkedDelegate;
}
-(void) leOnDelegateSet:(id<LETableViewDelegate>)delegate{
    if(!linkedDelegate){
        linkedDelegate=delegate;
        self.leDelegate(self);
    }
}
-(void) leAdditionalInits{
    [super leAdditionalInits];
    [self leRegisterCellWith:
        [[LEConfigurableCellManager sharedInstance] getClassWithType:L_Title_R_Arrow],
        [[LEConfigurableCellManager sharedInstance] getClassWithType:L_Title_R_Switch],
        [[LEConfigurableCellManager sharedInstance] getClassWithType:L_Title_R_Subtitle],
        [[LEConfigurableCellManager sharedInstance] getClassWithType:L_Title_R_Subtitle_Arrow],
        [[LEConfigurableCellManager sharedInstance] getClassWithType:L_Icon_Title_R_Arrow],
        [[LEConfigurableCellManager sharedInstance] getClassWithType:L_Title_R_Icon_Arrow],
        [[LEConfigurableCellManager sharedInstance] getClassWithType:M_Submit],
        [[LEConfigurableCellManager sharedInstance] getClassWithType:F_SectionSolid],
    nil];
    for (NSString *classname  in [LEConfigurableCellManager sharedInstance].registedItems.allValues) {
        [self leRegisterCellWith:classname,nil];
    }
}
-(NSString *) getCellClassnameWithIndex:(NSIndexPath *) index{
    return [[LEConfigurableCellManager sharedInstance] getClassWithType:[[[self.leItemsArray objectAtIndex:index.row] objectForKey:LEConfigurableCellKey_Type] intValue]];
}
-(void) leOnCellEventWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:LEKeyIndex];
    if(index.row<self.leItemsArray.count){
        BOOL noti=NO;
        NSString *func=[[self.leItemsArray objectAtIndex:index.row] objectForKey:LEConfigurableCellKey_Function];
        if(func&&func.length>0&&[linkedDelegate respondsToSelector:NSSelectorFromString(func)]){
            LESuppressPerformSelectorLeakWarning(
                                                 noti=YES;
                                                 [linkedDelegate performSelector:NSSelectorFromString(func)];
                                                 );
        }
        if(!noti){
            if(linkedDelegate&&[linkedDelegate respondsToSelector:@selector(leOnCellEventWithInfo:)]){
                [linkedDelegate leOnCellEventWithInfo:info];
            }
        }
    }
}
@end
@interface LEConfigurableListWithRefresh ()<LETableViewDelegate>
@end
@implementation LEConfigurableListWithRefresh{
    __weak id<LETableViewDelegate> linkedDelegate;
}
-(void) leOnDelegateSet:(id<LETableViewDelegate>)delegate{
    if(!linkedDelegate){
        linkedDelegate=delegate;
        self.leDelegate(self);
    }
}
-(void) leAdditionalInits{
    [super leAdditionalInits];
    [self leRegisterCellWith:
     [[LEConfigurableCellManager sharedInstance] getClassWithType:L_Title_R_Arrow],
     [[LEConfigurableCellManager sharedInstance] getClassWithType:L_Title_R_Switch],
     [[LEConfigurableCellManager sharedInstance] getClassWithType:L_Title_R_Subtitle],
     [[LEConfigurableCellManager sharedInstance] getClassWithType:L_Title_R_Subtitle_Arrow],
     [[LEConfigurableCellManager sharedInstance] getClassWithType:L_Icon_Title_R_Arrow],
     [[LEConfigurableCellManager sharedInstance] getClassWithType:L_Title_R_Icon_Arrow],
     [[LEConfigurableCellManager sharedInstance] getClassWithType:M_Submit],
     [[LEConfigurableCellManager sharedInstance] getClassWithType:F_SectionSolid],
     nil];
    for (NSString *classname  in [LEConfigurableCellManager sharedInstance].registedItems.allValues) {
        [self leRegisterCellWith:classname,nil];
    }
}
-(NSString *) getCellClassnameWithIndex:(NSIndexPath *) index{
    return [[LEConfigurableCellManager sharedInstance] getClassWithType:[[[self.leItemsArray objectAtIndex:index.row] objectForKey:LEConfigurableCellKey_Type] intValue]];
}
-(void) leOnCellEventWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:LEKeyIndex];
    if(index.row<self.leItemsArray.count){
        BOOL noti=NO;
        NSString *func=[[self.leItemsArray objectAtIndex:index.row] objectForKey:LEConfigurableCellKey_Function];
        if(func&&func.length>0&&[linkedDelegate respondsToSelector:NSSelectorFromString(func)]){
            LESuppressPerformSelectorLeakWarning(
                                                 noti=YES;
                                                 [linkedDelegate performSelector:NSSelectorFromString(func)];
                                                 );
        }
        if(!noti){
            if(linkedDelegate&&[linkedDelegate respondsToSelector:@selector(leOnCellEventWithInfo:)]){
                [linkedDelegate leOnCellEventWithInfo:info];
            }
        }
    }
}
@end
@implementation LEConfigurableCellManager
LESingleton_implementation(LEConfigurableCellManager)
-(void) leAdditionalInits{
    self.registedItems=[NSMutableDictionary new];
}
-(void) leRegisterItemWithClassName:(NSString *) className Type:(int) type{
    [self.registedItems setObject:className forKey:[NSNumber numberWithInt:type]];
}
-(NSString *) getClassWithType:(LEConfigurableCellType) type{
    NSString *className=[[LEConfigurableCellManager sharedInstance].registedItems objectForKey:[NSNumber numberWithInt:type]];
    if(!className){
        switch (type) {
            case L_Title_R_Arrow:
                return NSStringFromClass([LEItem_L_Title_R_Arrow class]);
                break;
            case L_Title_R_Switch:
                return NSStringFromClass([LEItem_L_Title_R_Switch class]);
                break;
            case L_Title_R_Subtitle:
                return NSStringFromClass([LEItem_L_Title_R_Subtitle class]);
                break;
            case L_Icon_Title_R_Arrow:
                return NSStringFromClass([LEItem_L_Icon_Title_R_Arrow class]);
                break;
            case L_Title_R_Icon_Arrow:
                return NSStringFromClass([LEItem_L_Title_R_Icon_Arrow class]);
                break;
            case L_Title_R_Subtitle_Arrow:
                return NSStringFromClass([LEItem_L_Title_R_Subtitle_Arrow class]);
                break;
            case M_Submit:
                return NSStringFromClass([LEItem_M_Submit class]);
                break;
            case F_SectionSolid:
                return NSStringFromClass([LEItem_F_SectionSolid class]);
                break;
            default:
                break;
        }
    }
    return className;
}
@end
