//
//  LEScanQRCode.m
//  Pods
//
//  Created by emerson larry on 2016/12/22.
//
//

#import "LEScanQRCode.h"
#import <AVFoundation/AVFoundation.h>
@interface LEScanQRCode() <AVCaptureMetadataOutputObjectsDelegate>
@end

@implementation LEScanQRCode{
    __weak id<LEScanQRCodeDelegate> curDelegate;
    LENavigation *curNavi;
    LEView *curView;
    //
    UIImageView *scanLine;
    int curLineOffset;
    BOOL isLineUp;
    
    AVCaptureDevice * device;
    AVCaptureDeviceInput * input;
    AVCaptureMetadataOutput * output;
    AVCaptureSession * session;
    AVCaptureVideoPreviewLayer * preview;
    NSTimer *curTimer;
    
    float scanSpaceW;
    float scanSpaceH;
    
    float defaultScanSize;
    //
    UIView *curResultView;
    UILabel *curHelper;
}
-(void) leSetCustomizedResultView:(UIView *) view{
    if(curResultView){
        [curResultView removeFromSuperview];
    }
    curResultView=view;
    [curView.leSubViewContainer addSubview:curResultView];
    [curResultView setHidden:YES];
}
-(void) dealloc{
    [session stopRunning];
    device=nil;
    input=nil;
    output=nil;
    [preview removeFromSuperlayer];
    session=nil;
}
-(void) leShowOrHideResultView:(BOOL) show{
    if(curResultView){
        [curResultView setHidden:NO];
    }
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    if (metadataObjects && [metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        if([[metadataObject type] isEqualToString:AVMetadataObjectTypeQRCode]
           ||[[metadataObject type] isEqualToString:AVMetadataObjectTypeEAN13Code]
           ||[[metadataObject type] isEqualToString:AVMetadataObjectTypeEAN8Code]
           ||[[metadataObject type] isEqualToString:AVMetadataObjectTypeCode128Code]
           ){
            stringValue = metadataObject.stringValue;
        }
    }
    [self switchScanLine:NO];
    [session stopRunning];
    device=nil;
    input=nil;
    output=nil;
    session=nil;
    if(stringValue){
        if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnScannedQRCodeWithResult:)]){
            [curDelegate leOnScannedQRCodeWithResult:stringValue];
        }
        if(!curResultView){
            [self lePop];
        }
    }else{
        
    }
}
-(void) leExtraInits {
    defaultScanSize=LESCREEN_MIN_LENGTH*2.0/3;
    scanSpaceH=LENavigationBarHeight*1.5;
    scanSpaceW=(LESCREEN_MIN_LENGTH-defaultScanSize)/2;
    //
    UIColor *bgColor=[UIColor colorWithWhite:0.000 alpha:0.500];
    
    UIView *viewTop     =[UIView new].leAddTo(curView.leSubViewContainer).leAnchor(LEI_TC).leEqualSuperViewWidth(1).leHeight(scanSpaceH).leBgColor(bgColor);
    [UIView new].leAddTo(curView.leSubViewContainer).leAnchor(LEO_BL).leRelativeTo(viewTop).leWidth(scanSpaceW).leHeight(defaultScanSize).leBgColor(bgColor);
    [UIView new].leAddTo(curView.leSubViewContainer).leAnchor(LEO_BR).leRelativeTo(viewTop).leWidth(scanSpaceW).leHeight(defaultScanSize).leBgColor(bgColor);
    UIView *viewBottom  =[UIView new].leAddTo(curView.leSubViewContainer).leAnchor(LEI_BC).leEqualSuperViewWidth(1).leHeight(curView.leSubContainerH-defaultScanSize-scanSpaceH).leBgColor(bgColor);
    
    [UIImageView new].leAddTo(curView.leSubViewContainer).leAnchor(LEI_TC).leTop(scanSpaceH-1).leBgColor(LEColorClear).leImage([[LEUICommon sharedInstance].leQRCodeScanRect leStreched]).leWidth(defaultScanSize+3).leHeight(defaultScanSize+3);
    scanLine=[UIImageView new].leAddTo(curView.leSubViewContainer).leAnchor(LEI_TC).leTop(scanSpaceH).leImage([LEUICommon sharedInstance].leQRCodeScanLine).leWidth(defaultScanSize-8);
    
    curHelper=[UILabel new].leAddTo(viewBottom).leAnchor(LEI_TC).leTop(LENavigationBarHeight).leMaxWidth(LESCREEN_WIDTH-LENavigationBarHeight).leFont(LEFontML).leColor(LEColorWhite).leLine(0).leAlignment(NSTextAlignmentCenter).leText(@"将扫码框对准二维码，即可自动完成扫描");
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if(input){
        output = [[AVCaptureMetadataOutput alloc]init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        session = [[AVCaptureSession alloc]init];
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([session canAddInput:input]) {
            [session addInput:input];
        }
        if ([session canAddOutput:output]) {
            [session addOutput:output];
        }
        output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        preview =[AVCaptureVideoPreviewLayer layerWithSession:session];
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [preview setFrame:curView.leSubViewContainer.bounds];
        [curView.leSubViewContainer.layer insertSublayer: preview atIndex:0];
        [session startRunning];
    }
    [self switchScanLine:YES];
}

-(void) leSetCustomizedTip:(NSString *) tip{
    curHelper.leText(tip);
}
-(void) switchScanLine:(BOOL) isON{
    if(isON){
        if(curTimer){
            [curTimer invalidate];
        }
        curTimer=[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onScanLineLogic) userInfo:nil repeats:YES];
        [session startRunning];
    }else{
        [curTimer invalidate];
        [session stopRunning];
    }
}
-(void) onScanLineLogic {
    curLineOffset+=(isLineUp?-2:2);
    if(curLineOffset<10){
        isLineUp=NO;
    }else if(curLineOffset>defaultScanSize-15){
        isLineUp=YES;
    }
    scanLine.leTop(scanSpaceH+curLineOffset); 
}
-(void) leShowScanView{
    [self switchScanLine:YES];
    [session stopRunning];
    device=nil;
    input=nil;
    output=nil;
    [preview removeFromSuperlayer];
    preview=nil;
    session=nil;
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if(input){
        output = [[AVCaptureMetadataOutput alloc]init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        session = [[AVCaptureSession alloc]init];
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([session canAddInput:input]) {
            [session addInput:input];
        }
        if ([session canAddOutput:output]) {
            [session addOutput:output];
        }
        output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        preview =[AVCaptureVideoPreviewLayer layerWithSession:session];
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        preview.frame =curView.leSubViewContainer.bounds;
        [curView.leSubViewContainer.layer insertSublayer: preview atIndex:0];
        [session startRunning];
    }
}

-(__kindof LEScanQRCode *(^)(id<LEScanQRCodeDelegate> delegate)) leDelegate{
    return ^id(id<LEScanQRCodeDelegate> delegate){
        curDelegate=delegate;
        curView=[LEView new].leSuperViewcontroller(self);
//        curView.leViewContainer.leBgColor(LEColorClear);
//        curView.leSubViewContainer.leBgColor(LEColorClear);
        curNavi=[LENavigation new].leSuperView(curView).leTitle(@"扫一扫");
        [self leExtraInits];
        return self;
    };
}
-(__kindof LEScanQRCode *(^)(NSString *title)) leTitle{
    return ^id(NSString *title){
        curNavi.leTitle(title);
        return self;
    };
}
-(void) leRescanWithDelay:(NSTimeInterval) seconds{
    LEWeakSelf(self)
    [weakself performSelector:@selector(leShowScanView) withObject:nil afterDelay:seconds];
}
@end
