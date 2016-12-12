//
//  TestLayoutFramework.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/12/3.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "TestLayoutFramework.h"

@interface TestLayoutFrameworkPage : LEView
@end
@implementation TestLayoutFrameworkPage{
    UIScrollView *scrollView;
    UIView *view;
    float top;
    float left;
    float bottom;
    float right;
    UIView *verticalStack;
    UIButton *pushButton;
    UIButton *popButton;
    UILabel *multiLineLabel;

}
-(void) leExtraInits{
    [LENavigation new].leSuperView(self).leTitle(NSStringFromClass(self.class));
    [self.leSubViewContainer setBackgroundColor:[UIColor redColor]];
#pragma mark 新建一个ScrollView，用于测试自动计算内部组件的排版，设置ContentSize，通过（leAutoResizeContentView）来完成，无需后期再关注Contentsize的计算
    scrollView=[UIScrollView new].leAddTo(self.leSubViewContainer).leEqualSuperViewWidth(1).leEqualSuperViewHeight(1).leAutoResizeContentView().leBgColor([UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1]);
#pragma mark 初始配置
    UIFont *fB14=LEBoldFont(14);
    UIFont *f12=LEFont(12);
    UIColor *blue=[UIColor colorWithRed:24/255.0 green:233/255.0 blue:255/255.0 alpha:1];
    //    UIColor *black=LEColorBlack;
    //    UIColor *red=LEColorRed;
    //    UIColor *yellow=LEColorTest;
    UIColor *black=[UIColor blackColor];
    UIColor *red=[UIColor redColor];
    UIColor *yellow=[UIColor yellowColor];
    //    UIColor *LEColorMask2=nil;
    //    UIColor *LEColorBlue=nil;
    //    UIColor *LEColorRed=nil;
    //    UIColor *LEColorMask=nil;
    
    //
    top=20;
    left=20;
    bottom=20;
    right=20;
#pragma mark 红色外边框
    view=[UIView new].leAddTo(scrollView).leAnchor(LEI_TL).leTop(top).leLeft(left).leRight(right).leWidth(300).leHeightEqualWidth(1).leBoard(2,red) ;
#pragma mark 黑色底板
    UIView *centerView=[UIView new].leAddTo(view).leAnchor(LEI_C).leHeightEqualSuperViewWidth(3.0/5.0).leWidthEqualHeight(1).leBgColor(black);
#pragma mark 红色横向分割线
    [UIView new].leAddTo(view).leAnchor(LEI_TC).leEqualSuperViewWidth(1).leTopEqualHeight(1.0/5.0).leHeight(1/LESCREEN_SCALE).leBgColor(red);
    [UIView new].leAddTo(view).leAnchor(LEI_TC).leEqualSuperViewWidth(1).leTopEqualHeight(2.0/5.0).leHeight(1/LESCREEN_SCALE).leBgColor(red);
    [UIView new].leAddTo(view).leAnchor(LEI_TC).leEqualSuperViewWidth(1).leTopEqualHeight(3.0/5.0).leHeight(1/LESCREEN_SCALE).leBgColor(red);
    [UIView new].leAddTo(view).leAnchor(LEI_TC).leEqualSuperViewWidth(1).leTopEqualHeight(4.0/5.0).leHeight(1/LESCREEN_SCALE).leBgColor(red);
#pragma mark 红色纵向分割线
    [UIView new].leAddTo(view).leAnchor(LEI_LC).leEqualSuperViewHeight(1).leLeftEqualWidth(1.0/5.0).leWidth(1/LESCREEN_SCALE).leBgColor(red);
    [UIView new].leAddTo(view).leAnchor(LEI_LC).leEqualSuperViewHeight(1).leLeftEqualWidth(2.0/5.0).leWidth(1/LESCREEN_SCALE).leBgColor(red);
    [UIView new].leAddTo(view).leAnchor(LEI_LC).leEqualSuperViewHeight(1).leLeftEqualWidth(3.0/5.0).leWidth(1/LESCREEN_SCALE).leBgColor(red);
    [UIView new].leAddTo(view).leAnchor(LEI_LC).leEqualSuperViewHeight(1).leLeftEqualWidth(4.0/5.0).leWidth(1/LESCREEN_SCALE).leBgColor(red);
#pragma mark 蓝色字体部分、内部排版：九宫格划分的第一行（顶部）
    UILabel *label_I_TL=[UILabel new].leAddTo(centerView).leAnchor(LEI_TL).leLeftAlign.leColor(blue).leFont(fB14).leText(@"上左");
    [UILabel new].leAddTo(centerView).leRelativeTo(label_I_TL).leAnchor(LEO_BL).leLeftAlign.leColor(blue).leFont(f12).leText(@"Inside\nTop\nLeft").leLine(0);
    UILabel *label_I_TC=[UILabel new].leAddTo(centerView).leAnchor(LEI_TC).leCenterAlign.leColor(blue).leFont(fB14).leText(@"上中");
    [UILabel new].leAddTo(centerView).leRelativeTo(label_I_TC).leAnchor(LEO_BC).leCenterAlign.leColor(blue).leFont(f12).leText(@"Inside\nTop\nCenter").leLine(0);
    UILabel *label_I_TR=[UILabel new].leAddTo(centerView).leAnchor(LEI_TR).leRightAlign.leColor(blue).leFont(fB14).leText(@"上右");
    [UILabel new].leAddTo(centerView).leRelativeTo(label_I_TR).leAnchor(LEO_BR).leRightAlign.leColor(blue).leFont(f12).leText(@"Inside\nTop\nRight").leLine(0);
#pragma mark 蓝色字体部分、内部排版：九宫格划分的第二行（中间）
    UILabel *label_I_LC=[UILabel new].leAddTo(centerView).leAnchor(LEI_LC).leLeftAlign.leColor(blue).leFont(fB14).leText(@"左中");
    [UILabel new].leAddTo(centerView).leRelativeTo(label_I_LC).leAnchor(LEO_BL).leCenterAlign.leColor(blue).leFont(f12).leText(@"Inside\nLeftCenter").leLine(0);
    UILabel *label_I_C=[UILabel new].leAddTo(centerView).leAnchor(LEI_C).leCenterAlign.leColor(blue).leFont(fB14).leText(@"中");
    [UILabel new].leAddTo(centerView).leRelativeTo(label_I_C).leAnchor(LEO_BC).leCenterAlign.leColor(blue).leFont(f12).leText(@"Inside\nCenter").leLine(0);
    UILabel *label_I_RC=[UILabel new].leAddTo(centerView).leAnchor(LEI_RC).leRightAlign.leColor(blue).leFont(fB14).leText(@"右中");
    [UILabel new].leAddTo(centerView).leRelativeTo(label_I_RC).leAnchor(LEO_BR).leRightAlign.leColor(blue).leFont(f12).leText(@"Inside\nRightCenter").leLine(0);
#pragma mark 蓝色字体部分、内部排版：九宫格划分的第三行（底部）
    UILabel *label_I_BL=[UILabel new].leAddTo(centerView).leAnchor(LEI_BL).leLeftAlign.leColor(blue).leFont(fB14).leText(@"下左");
    [UILabel new].leAddTo(centerView).leRelativeTo(label_I_BL).leAnchor(LEO_TL).leCenterAlign.leColor(blue).leFont(f12).leText(@"Inside\nBottom\nLeft").leLine(0);
    UILabel *label_I_BC=[UILabel new].leAddTo(centerView).leAnchor(LEI_BC).leCenterAlign.leColor(blue).leFont(fB14).leText(@"下中");
    [UILabel new].leAddTo(centerView).leRelativeTo(label_I_BC).leAnchor(LEO_TC).leCenterAlign.leColor(blue).leFont(f12).leText(@"Inside\nBottom\nCenter").leLine(0);
    UILabel *label_I_BR=[UILabel new].leAddTo(centerView).leAnchor(LEI_BR).leRightAlign.leColor(blue).leFont(fB14).leText(@"下右");
    [UILabel new].leAddTo(centerView).leRelativeTo(label_I_BR).leAnchor(LEO_TR).leRightAlign.leColor(blue).leFont(f12).leText(@"Inside\nBottom\nRight").leLine(0);
#pragma mark 黑色字体部分、外部排版、参考view与自身拥有相同的superView的情况：顶部一行
    UILabel *label_O_TL=[UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_TL).leLeftAlign.leColor(black).leFont(fB14).leText(@"上左");
    [UILabel new].leAddTo(view).leRelativeTo(label_O_TL).leAnchor(LEO_TL).leLeftAlign.leColor(black).leFont(f12).leText(@"Outside\nTop\nLeft").leLine(0);
    UILabel *label_O_TC=[UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_TC).leCenterAlign.leColor(black).leFont(fB14).leText(@"上中");
    [UILabel new].leAddTo(view).leRelativeTo(label_O_TC).leAnchor(LEO_TC).leCenterAlign.leColor(black).leFont(f12).leText(@"Outside\nTop\nCenter").leLine(0);
    UILabel *label_O_TR=[UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_TR).leRightAlign.leColor(black).leFont(fB14).leText(@"上右");
    [UILabel new].leAddTo(view).leRelativeTo(label_O_TR).leAnchor(LEO_TR).leRightAlign.leColor(black).leFont(f12).leText(@"Outside\nTop\nRight").leLine(0);
#pragma mark 黑色字体部分、外部排版、参考view与自身拥有相同的superView的情况：左侧一行
    UILabel *label_O_LT=[UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_LT).leLeftAlign.leColor(black).leFont(fB14).leText(@"左上");
    [UILabel new].leAddTo(view).leRelativeTo(label_O_LT).leAnchor(LEO_BR).leRightAlign.leColor(black).leFont(f12).leText(@"Outside\nLeft\nTop").leLine(0);
    UILabel *label_O_LC=[UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_LC).leCenterAlign.leColor(black).leFont(fB14).leText(@"左中");
    [UILabel new].leAddTo(view).leRelativeTo(label_O_LC).leAnchor(LEO_BR).leRightAlign.leColor(black).leFont(f12).leText(@"Outside\nLeftCenter").leLine(0);
    UILabel *label_O_LB=[UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_LB).leRightAlign.leColor(black).leFont(fB14).leText(@"左下");
    [UILabel new].leAddTo(view).leRelativeTo(label_O_LB).leAnchor(LEO_TR).leRightAlign.leColor(black).leFont(f12).leText(@"Outside\nLeft\nBottom").leLine(0);
#pragma mark 黑色字体部分、外部排版、参考view与自身拥有相同的superView的情况：右侧一行
    UILabel *label_O_RT=[UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_RT).leLeftAlign.leColor(black).leFont(fB14).leText(@"右上");
    [UILabel new].leAddTo(view).leRelativeTo(label_O_RT).leAnchor(LEO_BL).leLeftAlign.leColor(black).leFont(f12).leText(@"Outside\nRight\nTop").leLine(0);
    UILabel *label_O_RC=[UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_RC).leCenterAlign.leColor(black).leFont(fB14).leText(@"右中");
    [UILabel new].leAddTo(view).leRelativeTo(label_O_RC).leAnchor(LEO_BL).leLeftAlign.leColor(black).leFont(f12).leText(@"Outside\nRightCenter").leLine(0);
    UILabel *label_O_RB=[UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_RB).leRightAlign.leColor(black).leFont(fB14).leText(@"右下");
    [UILabel new].leAddTo(view).leRelativeTo(label_O_RB).leAnchor(LEO_TL).leLeftAlign.leColor(black).leFont(f12).leText(@"Outside\nRight\nBottom").leLine(0);
#pragma mark 黑色字体部分、外部排版、参考view与自身拥有相同的superView的情况：底部一行
    UILabel *label_O_BL=[UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_BL).leLeftAlign.leColor(black).leFont(fB14).leText(@"下左");
    [UILabel new].leAddTo(view).leRelativeTo(label_O_BL).leAnchor(LEO_BL).leLeftAlign.leColor(black).leFont(f12).leText(@"Outside\nBottom\nLeft").leLine(0);
    UILabel *label_O_BC=[UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_BC).leCenterAlign.leColor(black).leFont(fB14).leText(@"下中");
    [UILabel new].leAddTo(view).leRelativeTo(label_O_BC).leAnchor(LEO_BC).leCenterAlign.leColor(black).leFont(f12).leText(@"Outside\nBottom\nCenter").leLine(0);
    UILabel *label_O_BR=[UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_BR).leRightAlign.leColor(black).leFont(fB14).leText(@"下右");
    [UILabel new].leAddTo(view).leRelativeTo(label_O_BR).leAnchor(LEO_BR).leRightAlign.leColor(black).leFont(f12).leText(@"Outside\nBottom\nRight").leLine(0);
#pragma mark 黑色字体部分、外部排版、参考view与自身拥有相同的superView的情况：4个外角
    [UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_1).leCenterAlign.leColor(black).leFont(fB14).leText(@"Out\nside1").leLine(0).leBgColor(LEColorMask2).leMargins(UIEdgeInsetsMake(4, 4, 4, 4));
    [UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_2).leCenterAlign.leColor(black).leFont(fB14).leText(@"Out\nside2").leLine(0).leBgColor(LEColorMask2).leMargins(UIEdgeInsetsMake(4, 4, 4, 4));
    [UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_3).leCenterAlign.leColor(black).leFont(fB14).leText(@"Out\nside3").leLine(0).leBgColor(LEColorMask2).leMargins(UIEdgeInsetsMake(4, 4, 4, 4));
    [UILabel new].leAddTo(view).leRelativeTo(centerView).leAnchor(LEO_4).leCenterAlign.leColor(black).leFont(fB14).leText(@"Out\nside4").leLine(0).leBgColor(LEColorMask2).leMargins(UIEdgeInsetsMake(4, 4, 4, 4));
#pragma mark 黄色字体部分、参考view为superView且在superView外部排版的情况：顶部一行
    [UILabel new].leAddTo(view).leAnchor(LEO_TL).leLeftAlign.leColor(yellow).leFont(fB14).leText(@"上左").leBgColor(LEColorMask2);
    [UILabel new].leAddTo(view).leAnchor(LEO_TC).leCenterAlign.leColor(yellow).leFont(fB14).leText(@"上中").leBgColor(LEColorMask2);
    [UILabel new].leAddTo(view).leAnchor(LEO_TR).leRightAlign.leColor(yellow).leFont(fB14).leText(@"上右").leBgColor(LEColorMask2);
#pragma mark 黄色字体部分、参考view为superView且在superView外部排版的情况：左侧一行
    [UILabel new].leAddTo(view).leAnchor(LEO_LT).leLeftAlign.leColor(yellow).leFont(fB14).leText(@"左上").leBgColor(LEColorMask2);
    [UILabel new].leAddTo(view).leAnchor(LEO_LC).leCenterAlign.leColor(yellow).leFont(fB14).leText(@"左中").leBgColor(LEColorMask2);
    [UILabel new].leAddTo(view).leAnchor(LEO_LB).leRightAlign.leColor(yellow).leFont(fB14).leText(@"左下").leBgColor(LEColorMask2);
#pragma mark 黄色字体部分、参考view为superView且在superView外部排版的情况：右侧一行
    [UILabel new].leAddTo(view).leAnchor(LEO_RT).leLeftAlign.leColor(yellow).leFont(fB14).leText(@"右上").leBgColor(LEColorMask2);
    [UILabel new].leAddTo(view).leAnchor(LEO_RC).leCenterAlign.leColor(yellow).leFont(fB14).leText(@"右中").leBgColor(LEColorMask2);
    [UILabel new].leAddTo(view).leAnchor(LEO_RB).leRightAlign.leColor(yellow).leFont(fB14).leText(@"右下").leBgColor(LEColorMask2);
#pragma mark 黄色字体部分、参考view为superView且在superView外部排版的情况：底部一行
    [UILabel new].leAddTo(view).leAnchor(LEO_BL).leLeftAlign.leColor(yellow).leFont(fB14).leText(@"下左").leBgColor(LEColorMask2);
    [UILabel new].leAddTo(view).leAnchor(LEO_BC).leCenterAlign.leColor(yellow).leFont(fB14).leText(@"下中").leBgColor(LEColorMask2);
    [UILabel new].leAddTo(view).leAnchor(LEO_BR).leRightAlign.leColor(yellow).leFont(fB14).leText(@"下右").leBgColor(LEColorMask2);
#pragma mark 黄色字体部分、参考view为superView且在superView外部排版的情况：4个外角
    [UILabel new].leAddTo(view).leAnchor(LEO_1).leCenterAlign.leColor(yellow).leFont(fB14).leText(@"O1").leLine(0).leBgColor(LEColorMask2).leMargins(UIEdgeInsetsMake(4, 4, 4, 4));
    [UILabel new].leAddTo(view).leAnchor(LEO_2).leCenterAlign.leColor(yellow).leFont(fB14).leText(@"O2").leLine(0).leBgColor(LEColorMask2).leMargins(UIEdgeInsetsMake(4, 4, 4, 4));
    [UILabel new].leAddTo(view).leAnchor(LEO_3).leCenterAlign.leColor(yellow).leFont(fB14).leText(@"O3").leLine(0).leBgColor(LEColorMask2).leMargins(UIEdgeInsetsMake(4, 4, 4, 4));
    [UILabel new].leAddTo(view).leAnchor(LEO_4).leCenterAlign.leColor(yellow).leFont(fB14).leText(@"O4").leLine(0).leBgColor(LEColorMask2).leMargins(UIEdgeInsetsMake(4, 4, 4, 4));
#pragma mark 多行文本的背景框
    UIView *multiLineLabelBG=[UIView new].leAddTo(scrollView).leRelativeTo(view).leAnchor(LEOutsideBottomLeft).leTop(30).leWrapper().leBoard(2,LEColorRed).leBgColor(LEColorBlue);
    multiLineLabel=[UILabel new].leAddTo(multiLineLabelBG).leAnchor(LEInsideCenter).leMargins(UIEdgeInsetsMake(20, 20, 20, 20)).leMaxWidth(300).leLine(0).leCenterAlign.leBgColor(LEColorWhite).leFont(LEFont(12)).leLineSpace(10).leText(@"蓝色矩形自动根据label大小进行拉伸");
#pragma mark 下面主要是测试位移，缩放及最重要的入栈出栈的功能。下面首先是一个横向的栈（leHorizontalStack），用于放置按钮模块及尚未显示的竖向栈2个view
    UIView *horizontalStack=[UIView new].leAddTo(scrollView).leRelativeTo(multiLineLabelBG).leAnchor(LEO_BL).leTop(40).leHorizontalStack().leBoard(1,LEColorBlue).leStackAlignmnet(LEBottomAlign);
#pragma mark 这是按钮组（leWrapper）
    UIView *btnGroup=[UIView new].leWrapper().leBgColor(LEColorMask);
    btnGroup.tag=111;
#pragma mark 上下左右四个按钮
    UIButton *btnL=[UIButton new].leAddTo(btnGroup).leAnchor(LEI_LC).leMargins(UIEdgeInsetsMake(4, 4, 4, 4)).leCorner(6).leText(@"L").leTouchEvent(@selector(onLeft),self).leBtnColor(red,UIControlStateNormal).leBtnBGImg([LEColorBlue leImage],UIControlStateNormal);
    UIButton *btnT=[UIButton new].leAddTo(btnGroup).leRelativeTo(btnL).leAnchor(LEO_2).leMargins(UIEdgeInsetsMake(4, 4, 4, 4)).leCorner(6).leText(@"T").leTouchEvent(@selector(onTop),self).leBtnColor(red,UIControlStateNormal).leBtnBGImg([LEColorBlue leImage],UIControlStateNormal);
    UIButton *btnR=[UIButton new].leAddTo(btnGroup).leRelativeTo(btnT).leAnchor(LEO_4).leMargins(UIEdgeInsetsMake(4, 4, 4, 4)).leCorner(6).leText(@"R").leTouchEvent(@selector(onRight),self).leBtnColor(red,UIControlStateNormal).leBtnBGImg([LEColorBlue leImage],UIControlStateNormal);
    [UIButton new].leAddTo(btnGroup).leRelativeTo(btnR).leAnchor(LEO_3).leMargins(UIEdgeInsetsMake(4, 4, 4, 4)).leCorner(6).leText(@"B").leTouchEvent(@selector(onBottom),self).leBtnColor(red,UIControlStateNormal).leBtnBGImg([LEColorBlue leImage],UIControlStateNormal);
#pragma mark 放大缩小2个按钮
    UIButton *btnScaleUp=[UIButton new].leAddTo(btnGroup).leRelativeTo(btnR).leAnchor(LEO_RC).leMargins(UIEdgeInsetsMake(4, 10, 4, 4)).leCorner(6).leText(@"-").leTouchEvent(@selector(onScaleDown),self).leBtnColor(red,UIControlStateNormal).leBtnBGImg([LEColorBlue leImage],UIControlStateNormal);
    UIButton *btnScaleDown=[UIButton new].leAddTo(btnGroup).leRelativeTo(btnScaleUp).leAnchor(LEO_RC).leMargins(UIEdgeInsetsMake(4, 4, 4, 4)).leCorner(6).leText(@"+").leTouchEvent(@selector(onScaleUp),self).leBtnColor(red,UIControlStateNormal).leBtnBGImg([LEColorBlue leImage],UIControlStateNormal);
#pragma mark 入栈出栈2个按钮
    pushButton=[UIButton new].leAddTo(btnGroup).leRelativeTo(btnScaleDown).leAnchor(LEO_2).leMargins(UIEdgeInsetsMake(4, 4, 4, 4)).leCorner(6).leLine(0).leBtnFixedWidth(80).leTouchEvent(@selector(onPush),self).leBtnColor(red,UIControlStateNormal).leBtnBGImg([LEColorBlue leImage],UIControlStateNormal).leBtnVerticalLayout(YES).leBtnImg_N([LEColorRed leImageWithSize:LESquareSize(35)]).leText(@"Testing Push To Stack ");
    popButton=[UIButton new].leAddTo(btnGroup).leRelativeTo(btnScaleDown).leAnchor(LEO_4).leMargins(UIEdgeInsetsMake(4, 4, 4, 4)).leCorner(6).leTouchEvent(@selector(onPop),self).leBtnColor(red,UIControlStateNormal).leBtnBGImg([LEColorBlue leImage],UIControlStateNormal).leBtnImg_N([LEColorRed leImageWithSize:LESquareSize(35)]).leText(@"Pop from Stack" );
#pragma mark 下面是一个纵向的栈（leVerticalStack），点击按钮Push，Pop会实现入栈及出栈
    verticalStack=[UIView new].leVerticalStack().leBoard(3,LEColorRed).leStackAlignmnet(LERightAlign);
#pragma mark 横向入栈 按钮组+纵向栈
    [horizontalStack lePushToStack:btnGroup,verticalStack,nil];
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
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [UIView animateWithDuration:0.25 animations:^(void){
        [scrollView leUpdateLayout];
    }];
}
#pragma mark 入栈方法
-(void) onPush{
    int ran=rand()%100;
    ran*=ran;
    UILabel *v=[UILabel new].leAlignment(NSTextAlignmentCenter).leMargins(UIEdgeInsetsMake(4, 4, 4, 4)).leBgColor(LERandomColor).leText([NSString stringWithFormat:@"%d",ran]);
    [UIView animateWithDuration:0.2 animations:^{
        [verticalStack lePushToStack:v,nil];
    }];
    pushButton=pushButton.leBtnImg_N([LEColorRed leImageWithSize:LESquareSize(pushButton.imageView.bounds.size.width+10)]);
    popButton=popButton.leBtnImg_N([LEColorRed leImageWithSize:LESquareSize(popButton.imageView.bounds.size.width+10)]);
    multiLineLabel.leText([multiLineLabel.text stringByAppendingPathComponent:@"追加文字"]);
}
#pragma mark 出栈方法
-(void) onPop {
    float size=pushButton.imageView.bounds.size.width-10;
    pushButton=pushButton.leBtnImg_N(size>0?[LEColorRed leImageWithSize:LESquareSize(size)]:nil);
    popButton=popButton.leBtnImg_N(size>0?[LEColorRed leImageWithSize:LESquareSize(size)]:nil);
    [UIView animateWithDuration:0.2 animations:^{
        [verticalStack lePopFromStack];
    }];
    multiLineLabel.leText([multiLineLabel.text stringByDeletingLastPathComponent]);
}
#pragma mark 上移方法
-(void) onTop{
    top-=20;
    bottom+=20;
    [UIView animateWithDuration:0.2 animations:^{
        view.leTop(top).leBottom(bottom);
    }];
}
#pragma mark 左移方法
-(void) onLeft{
    left-=20;
    right+=20;
    [UIView animateWithDuration:0.2 animations:^{
        view.leLeft(left).leRight(right);
    }];
}
#pragma mark 下移方法
-(void) onBottom{
    bottom-=20;
    top+=20;
    [UIView animateWithDuration:0.2 animations:^{
        view.leTop(top).leBottom(bottom);
    }];
}
#pragma mark 右移方法
-(void) onRight{
    right-=20;
    left+=20;
    [UIView animateWithDuration:0.2 animations:^{
        view.leLeft(left).leRight(right);
    }];
}
#pragma mark 放大方法
-(void) onScaleUp{
    CGSize size=view.bounds.size;
    size.width+=50;
    size.height+=50;
    [UIView animateWithDuration:0.2 animations:^{
        view.leWidth(size.width).leHeight(size.height);
    }];
}
#pragma mark 缩小方法
-(void) onScaleDown{
    CGSize size=view.bounds.size;
    size.width-=50;
    size.height-=50;
    [UIView animateWithDuration:0.5 animations:^{
        view.leWidth(size.width).leHeight(size.height);
    }];
}
@end
@implementation TestLayoutFramework @end
