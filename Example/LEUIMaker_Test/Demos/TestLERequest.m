//
//  TestLERequest.m
//  LEUIMaker
//
//  Created by emerson larry on 2017/4/21.
//  Copyright © 2017年 LarryEmerson. All rights reserved.
//

#import "TestLERequest.h"

@interface TestLERequest ()<LEAppMessageDelegate,LENavigationDelegate>
@end
@implementation TestLERequest{
    LERequest *requestTest;
}
-(void) leNavigationRightButtonTapped{
    [requestTest leRequestFromMemory:^(LERequest *request, NSDictionary *response, int statusCode, NSString *message) {
        LELog(@"Memory statusCode=%d message=%@ %d",statusCode,message,request.tag)
    }];
    [requestTest leRequestFromDiskIfExist:^(LERequest *request, NSDictionary *response, int statusCode, NSString *message) {
        LELog(@"Cache  statusCode=%d message=%@ %d",statusCode,message,request.tag)
    }];
}
-(void) leAdditionalInits{
    [[LEUICommon sharedInstance] leSetViewBGColor:LEColorBG9];
    LEView *view=[LEView new].leSuperViewcontroller(self);
    [LENavigation new].leSuperView(view).leDelegate(self).leTitle(@"测试LERequest 网络请求").leRightItemText(@"Disk记录");
    view.leSubViewContainer.leBgColor(LEColorText9);
//    [[LEDataManager sharedInstance] leEnableDebug:YES]; 
    
    LERequestManager.sharedInstance
//    .leEnableDebug(YES)
//    .leEnableResponseDebug(YES)
//    .leEnableResponseWithJsonString(YES)
    .leServerHost(@"http://www.bejson.com/")
    .leMessageDelegate(self)
//    .leServerIdentifierKey(@"key")
//    .leServerIdentifier(@"value")
//    .leMD5Salt(@"salt")
    .leServerHost(@"http://115.29.238.177:91/")
    .leServerIdentifierKey(@"CBS-Service-Identifier")
    .leServerIdentifier(@"com.guyou.guguxinge")
    .leMD5Salt(@"cbsapp")
    .leServerIdentifierCheckHandler(^{
        
    })
    ;
    
    [requestTest=LERequest.leGetRequest(
                                        LERequestSettings
                                        .leNew
                                        .leApi(@"jsonviewernew")
                                        .leUri(@"")
                                        .leHead(@{})
                                        .leParameter(@{})
                                        .leDuration(rand()%5)
                                        .leType(LERequestTypeGet)
                                        //.leAddition(@{@"key":@"value"})
                                        .leAddition(@"key:value")
                                          
                                        .leApi(@"shit/api/v1")
                                        .leUri(@"users/787/shits")
                                        .leHead(@{@"CBSAPPID":@"1",@"CBSAuthorization":@"7229601c8329b9e41d025373d8554465",@"USER-ID":@"787",@"VERSIONID":@"1"})
                                        .leDuration(0)
//                                        .leStoreToDisk(NO)
                                        )
     leRequest:^(LERequest *request, NSDictionary *response, int statusCode, NSString *message) {
//         LELog(@"statusCode=%d message=%@ %d",statusCode,message,request.tag)
    }];
    [NSTimer scheduledTimerWithTimeInterval: rand()%5 target:self selector:@selector(debugRequest) userInfo:nil repeats:NO];
}
-(void) leOnShowAppMessageWith:(NSString *)message{
    LELogObject(message)
}
-(void) debugRequest{
    [requestTest=LERequest.leGetRequest(
                            LERequestSettings
                            .leNew
                            .leApi(@"s")
                            .leUri(@"")
                            .leHead(@{})
                            .leParameter(@{})
                            .leDuration(rand()%5)
                            .leType(LERequestTypeGet)
                            //.leAddition(@{@"key":@"value"})
                            .leAddition(@"key:value")
                            
                            .leApi(@"shit/api/v1")
                            .leUri(@"users/787/shits")
                            .leHead(@{@"CBSAPPID":@"1",@"CBSAuthorization":@"7229601c8329b9e41d025373d8554465",@"USER-ID":@"787",@"VERSIONID":@"1"})
                            .leDuration(0)
//                            .leStoreToDisk(YES)
                                            )
     leRequest:^(LERequest *request, NSDictionary *response, int statusCode, NSString *message) {
//        LELog(@"statusCode=%d message=%@ %d",statusCode,message,request.tag)
    }];
    [NSTimer scheduledTimerWithTimeInterval: rand()%5 target:self selector:@selector(debugRequest) userInfo:nil repeats:NO];
}
@end
