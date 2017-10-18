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
@property (nonatomic) AVCaptureSession * session;
/** 扫描支持的编码格式的数组 */
@property (nonatomic, strong) NSMutableArray * metadataObjectTypes;
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
    
    AVCaptureVideoPreviewLayer * preview;
    NSTimer *curTimer;
    
    float scanSpaceW;
    float scanSpaceH;
    
    float defaultScanSize;
    //
    UIView *curResultView;
    UILabel *curHelper;
}
- (NSMutableArray *)metadataObjectTypes{
    if (!_metadataObjectTypes) {
        _metadataObjectTypes = @[
                                 AVMetadataObjectTypeQRCode,
                                 AVMetadataObjectTypeEAN13Code,
                                 AVMetadataObjectTypeEAN8Code,
                                 AVMetadataObjectTypeCode128Code,
                                 AVMetadataObjectTypeCode39Code,
                                 AVMetadataObjectTypeCode93Code,
                                 AVMetadataObjectTypeCode39Mod43Code,
                                 AVMetadataObjectTypePDF417Code,
                                 AVMetadataObjectTypeAztecCode,
                                 AVMetadataObjectTypeUPCECode,
                                 ] ;
        
        // >= iOS 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [_metadataObjectTypes addObjectsFromArray:
                 @[
                   AVMetadataObjectTypeInterleaved2of5Code,
                   AVMetadataObjectTypeITF14Code,
                   AVMetadataObjectTypeDataMatrixCode
                   ]
             ];
        }
    }
    
    return _metadataObjectTypes;
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
    [self.session stopRunning];
    device=nil;
    input=nil;
    output=nil;
    [preview removeFromSuperlayer];
    self.session=nil;
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
        BOOL found=NO;
        for (NSInteger i=0; i<self.metadataObjectTypes.count; i++) {
            AVMetadataObjectType type=[self.metadataObjectTypes objectAtIndex:i];
            if([metadataObject type] == type){
                found=YES;
                break;
            }
        }
        if(found){
            stringValue = metadataObject.stringValue;
        }
    }
    [self switchScanLine:NO];
    [self.session stopRunning];
    device=nil;
    input=nil;
    output=nil;
    self.session=nil;
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
-(void) leAdditionalInits {
    defaultScanSize=LESCREEN_MIN_LENGTH*2/3;
    scanSpaceH=LENavigationBarHeight+LEStatusBarHeight;
    scanSpaceH*=2;
    scanSpaceW=(LESCREEN_MIN_LENGTH-defaultScanSize)/2;
    //
    UIColor *bgColor=[UIColor colorWithWhite:0.000 alpha:0.500];
    
    UIView *viewTop     =[UIView new].leAddTo(curView).leAnchor(LEI_TC).leEqualSuperViewWidth(1).leTop(scanSpaceH/2).leHeight(scanSpaceH/2).leBgColor(bgColor);
    [UIView new].leAddTo(curView).leAnchor(LEO_BL).leRelativeTo(viewTop).leWidth(scanSpaceW).leHeight(defaultScanSize).leBgColor(bgColor);
    [UIView new].leAddTo(curView).leAnchor(LEO_BR).leRelativeTo(viewTop).leWidth(scanSpaceW).leHeight(defaultScanSize).leBgColor(bgColor);
    UIView *viewBottom  =[UIView new].leAddTo(curView).leAnchor(LEI_BC).leEqualSuperViewWidth(1).leHeight(LESCREEN_HEIGHT-defaultScanSize-scanSpaceH).leBgColor(bgColor);
    
    [UIImageView new].leAddTo(curView).leAnchor(LEI_TC).leTop(scanSpaceH-1).leBgColor(LEColorClear).leImage([[LEUICommon sharedInstance].leQRCodeScanRect leStreched]).leWidth(defaultScanSize+3).leHeight(defaultScanSize+3);
    scanLine=[UIImageView new].leAddTo(curView).leAnchor(LEI_TC).leTop(scanSpaceH).leImage([LEUICommon sharedInstance].leQRCodeScanLine).leWidth(defaultScanSize-8);
    
    curHelper=[UILabel new].leAddTo(viewBottom).leAnchor(LEI_TC).leTop(LENavigationBarHeight).leMaxWidth(LESCREEN_WIDTH-LENavigationBarHeight).leFont(LEFontML).leColor(LEColorWhite).leLine(0).leAlignment(NSTextAlignmentCenter).leText(@"将扫码框对准二维码，即可自动完成扫描");
    if (TARGET_IPHONE_SIMULATOR) {
        return;
    }
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if(input){
        output = [[AVCaptureMetadataOutput alloc]init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        self.session = [[AVCaptureSession alloc]init];
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([self.session canAddInput:input]) {
            [self.session addInput:input];
        }
        if ([self.session canAddOutput:output]) {
            [self.session addOutput:output];
        }
        CGRect scanCrop= CGRectMake(scanSpaceH/LESCREEN_HEIGHT, scanSpaceW/LESCREEN_WIDTH, defaultScanSize/LESCREEN_HEIGHT, defaultScanSize/LESCREEN_WIDTH);
        output.rectOfInterest = scanCrop;
        output.metadataObjectTypes =self.metadataObjectTypes;
//        output.rectOfInterest = LESCREEN_BOUNDS;
        preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [preview setFrame:curView.bounds];
        [curView.layer insertSublayer: preview atIndex:0];
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus ==AVAuthorizationStatusRestricted|| authStatus ==AVAuthorizationStatusDenied){
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.session startRunning];
                    });
                } else {
                    NSLog(@"无权限访问相机");
                }
            }];
        }else{
            [self.session startRunning];
        }
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
        [self.session startRunning];
    }else{
        [curTimer invalidate];
        [self.session stopRunning];
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
    [self.session stopRunning];
    device=nil;
    input=nil;
    output=nil;
    [preview removeFromSuperlayer];
    preview=nil;
    self.session=nil;
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if(input){
        output = [[AVCaptureMetadataOutput alloc]init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        self.session = [[AVCaptureSession alloc]init];
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([self.session canAddInput:input]) {
            [self.session addInput:input];
        }
        if ([self.session canAddOutput:output]) {
            [self.session addOutput:output];
        }
        preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        preview.frame =curView.bounds;
        [curView.layer insertSublayer: preview atIndex:0];
         
        output.metadataObjectTypes =self.metadataObjectTypes;
        
        CGRect scanCrop=CGRectMake(scanSpaceH/LESCREEN_HEIGHT, scanSpaceW/LESCREEN_WIDTH, defaultScanSize/LESCREEN_HEIGHT, defaultScanSize/LESCREEN_WIDTH);
        output.rectOfInterest = scanCrop;
//        output.rectOfInterest = LESCREEN_BOUNDS;
        [self.session startRunning];
    }
}
-(__kindof LEScanQRCode *(^)(id<LEScanQRCodeDelegate> delegate)) leDelegate{
    return ^id(id<LEScanQRCodeDelegate> delegate){
        curDelegate=delegate;
        curView=[LEView new].leSuperViewcontroller(self);
//        curView.leViewContainer.leBgColor(LEColorClear);
//        curView.leSubViewContainer.leBgColor(LEColorClear);
        curNavi=[LENavigation new].leSuperView(curView).leTitle(@"扫一扫");
        [self leAdditionalInits];
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
