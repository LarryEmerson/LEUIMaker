//
//  LERequest.h
//  Pods
//
//  Created by emerson larry on 2017/4/19.
//
//

#import <Foundation/Foundation.h>
#import <LEFoundation/LEFoundation.h>
#import <AFNetworking/AFNetworking.h>
#import "LEDataManager.h"

typedef NS_ENUM(NSInteger, LERequestType) {
    LERequestTypeGet      = 0,
    LERequestTypePost     = 1,
    LERequestTypeHead     = 2,
    LERequestTypePut      = 3,
    LERequestTypePatch    = 4,
    LERequestTypeDelete   = 5
};
static int networkCounter=0;
#define LECacheTable                @"caches"
#define LECacheKey                  @"cachekey"
#define LECacheValue                @"cachevalue"

#define LEKeyOfResponseCount        @"Count"
#define LEKeyOfResponseStatusCode   @"statuscode"
#define LEKeyOfResponseErrormsg     @"errormsg"
#define LEKeyOfResponseErrorno      @"errorno"
#define LEKeyOfResponseArray        @"arraycontent"
#define LEKeyOfResponseAsJSON       @"LEKeyOfResponseAsJSON"
#define LEStatusCode200             200

@class LERequest;

typedef void(^LEServerIdentifierCheckHandler)();
typedef void(^LERequestHandler)(LERequest *request, NSDictionary *response, int statusCode, NSString *message);

@interface LERequestSettings : NSObject
#pragma mark Sets
-(LERequestSettings *(^)(NSString *))       leHost;
-(LERequestSettings *(^)(NSString *))       leApi;
-(LERequestSettings *(^)(NSString *))       leUri;
-(LERequestSettings *(^)(NSDictionary *))   leHead;
-(LERequestSettings *(^)(LERequestType))    leType;
-(LERequestSettings *(^)(id))               leParameter;

-(LERequestSettings *(^)(float))            leDuration;
-(LERequestSettings *(^)(id))               leAddition;
-(LERequestSettings *(^)(BOOL))             leStoreToDisk;
#pragma mark Gets
-(NSString *)           leGetHost;
-(NSString *)           leGetApi;
-(NSString *)           leGetUri;
-(NSDictionary *)       leGetHead;
-(LERequestType)        leGetType;
-(id)                   leGetParameter;
-(id)                   leGetAddition;
-(NSString *)           leGetKey;
-(NSString *)           leGetURL;
@end

#ifdef DEBUG
static int requestCounter=0;
#endif
@interface LERequest : NSObject
#ifdef DEBUG
@property (nonatomic) int tag;
#endif
@property (nonatomic,readonly) NSTimeInterval timestamp;
@property (nonatomic) LERequestSettings *leSettings;
+(LERequest *(^)(LERequestSettings *)) leGetRequest;
-(LERequest *) leRequest:(LERequestHandler) handler;
-(LERequest *) leRequestFromMemory:(LERequestHandler) handler;
-(LERequest *) leRequestFromDiskIfExist:(LERequestHandler) handler;
-(LERequest *) leCancleRequest;
@end


@interface LERequestManager : NSObject
+ (instancetype) sharedInstance;
#pragma mark settings b4 using LERequest
-(LERequestManager *(^)(BOOL)) leEnableDebug;
-(LERequestManager *(^)(BOOL)) leEnableResponseDebug;
-(LERequestManager *(^)(BOOL)) leEnableResponseWithJsonString;
-(LERequestManager *(^)(NSString *)) leServerHost;
-(LERequestManager *(^)(NSString *)) leMD5Salt;
-(LERequestManager *(^)(id<LEAppMessageDelegate>)) leMessageDelegate;
-(LERequestManager *(^)(NSSet *)) leContentType;
-(LERequestManager *(^)(NSIndexSet *)) leStatusCode;
-(LERequestManager *(^)(NSString *)) leServerIdentifierKey;
-(LERequestManager *(^)(NSString *)) leServerIdentifier;
-(LERequestManager *(^)(LEServerIdentifierCheckHandler)) leServerIdentifierCheckHandler;
-(void) leServerIdentifierCheckFailed:(LEServerIdentifierCheckHandler) handler;
#pragma mark getters
- (LERequest *(^)(LERequestSettings *)) leGetRequest;
- (BOOL)         leDebugEnabled;
- (BOOL)         leResponseDebugEnabled;
- (BOOL)         leResponseWithJsonStringEnabled;
- (NSIndexSet *) leGetStatusCode;
- (NSSet *)      leGetContentType;
- (NSString *)   leGetMD5Salt;
- (NSString *)   leGetServerHost;
- (NSString *)   leGetServerIdentifierKey;
- (NSString *)   leGetServerIdentifier;
- (LERequest *(^)(NSString *)) leGetRequestFromCache;
+ (NSString *(^)(NSString *)) leGetMd5;

#pragma mark others
- (void) leFailedCheckingServerIdentifier;
- (void(^)(NSString *)) leOnShowAppMessage;
@end

@interface NSObject (LERequest)
-(void (^)(NSDictionary *)) leSetEntity;
-(NSDictionary *(^)()) leGetDataFromEntity;
@end
