//
//  TestWKWebview.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/12/14.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "TestWKWebview.h"
#import <WebKit/WebKit.h>
@interface TestWKWebviewPage : LEView
@end
@implementation TestWKWebviewPage{
    WKWebView *webview;
}

-(void) leExtraInits{
    [LENavigation new].leSuperView(self).leTitle(@"测试WKWebview");
    webview=[WKWebView new].leAddTo(self.leSubViewContainer).leMargins(UIEdgeInsetsZero);
    NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://192.168.58.102:82/null.html?cbswidth=%d&cbsratio=%d&cbszoom=1",(int)(LESCREEN_WIDTH*LESCREEN_SCALE),LESCREEN_SCALE_INT]];
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600*24];
    [webview loadRequest:urlRequest];
}
-(void) dealloc{
    [webview stopLoading];
    webview=nil;
}
@end

@implementation TestWKWebview @end
 
