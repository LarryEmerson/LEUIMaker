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

-(void) leAdditionalInits{
    [LENavigation new].leSuperView(self).leTitle(@"测试WKWebview");
    webview=[WKWebView new].leAddTo(self.leSubViewContainer).leMargins(UIEdgeInsetsZero);
    NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://192.168.58.101:82/null.html?cbswidth=%d&cbsratio=%d&cbszoom=1",(int)(LESCREEN_WIDTH*LESCREEN_SCALE),LESCREEN_SCALE_INT]];
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [webview loadRequest:urlRequest];
    
    [UIButton new].leAddTo(self.leSubViewContainer).leAnchor(LEI_TL).leSize(LESquareSize(100)).leBgColor(LEColorMask2).leBtnBGImgH([LEColorBlue leImage]).leText(@"L").leTouchEvent(@selector(removeWebCache),self);
    [UIButton new].leAddTo(self.leSubViewContainer).leAnchor(LEI_TC).leSize(LESquareSize(100)).leBgColor(LEColorMask2).leBtnBGImgH([LEColorBlue leImage]).leText(@"C").leTouchEvent(@selector(remove),self);
    [UIButton new].leAddTo(self.leSubViewContainer).leAnchor(LEI_TR).leSize(LESquareSize(100)).leBgColor(LEColorMask2).leBtnBGImgH([LEColorBlue leImage]).leText(@"R").leTouchEvent(@selector(deleteWebCache),self);
}
-(void) remove{
    NSInteger size=[[NSURLCache sharedURLCache] currentDiskUsage];
    LELog(@"1=%zd",size)
    size+=[[NSURLCache sharedURLCache] currentMemoryUsage];
    LELog(@"2=%zd",size)
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    size=[[NSURLCache sharedURLCache] currentDiskUsage];
    LELog(@"3=%zd",size)
    size+=[[NSURLCache sharedURLCache] currentMemoryUsage];
    LELog(@"4=%zd",size)
}
-(void) removeWebCache{
    NSInteger size=[[NSURLCache sharedURLCache] currentDiskUsage];
    LELog(@"1=%zd",size)
    size+=[[NSURLCache sharedURLCache] currentMemoryUsage];
    LELog(@"2=%zd",size)
    

    NSString *libraryDir             = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *bundleId               = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *webkitFolderInLib      = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
    NSString *webKitFolderInCaches   = [NSString stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
    NSString *webKitFolderInCachesfs = [NSString stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    //    LELogObject(webkitFolderInLib)
    //    LELogObject(webKitFolderInCaches)
    //    LELogObject(webKitFolderInCachesfs)
    NSError *error;
    /* iOS8.0 WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
    /* iOS7.0 WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
    size=[[NSURLCache sharedURLCache] currentDiskUsage];
    LELog(@"3=%zd",size)
    size+=[[NSURLCache sharedURLCache] currentMemoryUsage];
    LELog(@"4=%zd",size)
}
- (void)deleteWebCache {
    NSInteger size=[[NSURLCache sharedURLCache] currentDiskUsage];
    LELog(@"1=%zd",size)
    size+=[[NSURLCache sharedURLCache] currentMemoryUsage];
    LELog(@"2=%zd",size)
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
    /*
     NSSet *websiteDataTypes
     = [NSSet setWithArray:@[
     WKWebsiteDataTypeDiskCache,
     //WKWebsiteDataTypeOfflineWebApplicationCache,
     WKWebsiteDataTypeMemoryCache,
     //WKWebsiteDataTypeLocalStorage,
     //WKWebsiteDataTypeCookies,
     //WKWebsiteDataTypeSessionStorage,
     //WKWebsiteDataTypeIndexedDBDatabases,
     //WKWebsiteDataTypeWebSQLDatabases
     ]];
     //        */
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        LELogObject(@"Done")
    }];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
    NSError *errors;
    [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    
#endif
    
    size=[[NSURLCache sharedURLCache] currentDiskUsage];
    LELog(@"3=%zd",size)
    size+=[[NSURLCache sharedURLCache] currentMemoryUsage];
    LELog(@"4=%zd",size)
}
-(void) dealloc{
    [webview stopLoading];
    webview=nil;
}
@end

@implementation TestWKWebview @end

