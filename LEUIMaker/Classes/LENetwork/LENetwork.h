//
//  LENetwork.h
//  Pods
//
//  Created by emerson larry on 2017/2/6.
//
//

#import <Foundation/Foundation.h>
#import <LEFoundation/LEFoundation.h>
#import <objc/runtime.h>


// 数据模型
// id key value
@protocol LEDataManagerDelegate <NSObject>
-(id) leInitDataBase;
-(id) leReloadWithNewPath:(NSString *) path LastDataBase:(id) dataBase;
-(void) leOpen:(id) dataBase;
-(void) leClose:(id) dataBase;
-(void) leRunSql:(NSString *) sql DataBase:(id) dataBase;
-(void) leBatchSqls:(NSArray *) sqls DataBase:(id) dataBase;
-(NSArray *) leSelect:(NSString *) sql OnlyFirstRecord:(BOOL) first DataBase:(id) dataBase;
@end

@interface LEDataManager : NSObject
LESingleton_interface(LEDataManager)
@property (nonatomic, weak) id leDataBase;
-(void) leEnableDebug:(BOOL) enable;
-(void) leSetDelegate:(id<LEDataManagerDelegate>) delegate;
-(void) leReloadWithNewPath:(NSString *) path;

-(void) leCreateTable:(NSString *) table;
-(void) leRemoveTable:(NSString *) table;
-(void) leClearTable: (NSString *) table;
-(void) leRemoveRecordFromTable:(NSString *) table WithKey:(NSString *) key;

-(void) leUpdateRecordInTable:(NSString *) table WithKey:(NSString *) key Value:(NSString *) value;
-(void) leInsertRecordToTable:(NSString *) table WithKey:(NSString *) key Value:(NSString *) value;

-(NSArray *) leSelectRecordsFromTable:(NSString *) table;
-(id) leSelectRecordFromTable:(NSString *) table WithKey:(NSString *) key;

-(void) leBatchImportToTable:(NSString *) table WithData:(NSArray *) data;
@end


//typedef NS_ENUM(NSInteger, LERequestType) {
//    LERequestTypeGet      = 0,
//    LERequestTypePost     = 1,
//    LERequestTypeHead     = 2,
//    LERequestTypePut      = 3,
//    LERequestTypePatch    = 4,
//    LERequestTypeDelete   = 5
//};
//#define LECacheTable                @"caches"
//#define LECacheKey                  @"cachekey"
//#define LECacheValue                @"cachevalue"
//
//#define LEKeyOfResponseCount        @"Count"
//#define LEKeyOfResponseStatusCode   @"statuscode"
//#define LEKeyOfResponseErrormsg     @"errormsg"
//#define LEKeyOfResponseErrorno      @"errorno"
//#define LEKeyOfResponseArray        @"arraycontent"
//#define LEKeyOfResponseAsJSON       @"LEKeyOfResponseAsJSON"
//#define LEStatusCode200             200
//
//@class LENetworkRequestObject;
//@protocol LENetworkDelegate <NSObject>
//@optional
//- (void) leRequest:(LENetworkRequestObject *) request ResponedWith:(NSDictionary *) response;
//- (void) leRequest:(LENetworkRequestObject *) request FailedWithStatusCode:(int) statusCode Message:(NSString *)message;
//@end
//
//@protocol LENetworkServerIdentifierCheckDelegate <NSObject>
//- (void) leFailedCheckingServerIdentifier;
//@end
//
//@interface LENetworkSettings : NSObject
//@property (nonatomic, readonly) int               leRequestCounter;
//@property (nonatomic, readonly) NSString          *leApi;
//@property (nonatomic, readonly) NSString          *leUri;
//@property (nonatomic, readonly) NSDictionary      *leHttpHead;
//@property (nonatomic, readonly) LERequestType     leRequestType;
//@property (nonatomic, readonly) id                leParameter;
//@property (nonatomic, readonly) BOOL              leUseCache;
//@property (nonatomic, readonly) int               leDuration;
//@property (nonatomic, readonly) NSString          *leIdentification;//用于给请求加标签
//@property (nonatomic, readonly) int               leCreateTimestamp;
//@property (nonatomic) NSMutableArray    *leCurDelegateArray;
////
//@property (nonatomic) id                leExtraObj;
////
//-(void) leSetRequestCount:(int) requestCount;
//-(void) leSetApi:(NSString *) api;
//-(void) leSetUri:(NSString *) uri;
//-(void) leSetHttpHead:(NSDictionary *) httpHead;
//-(void) leSetRequestType:(LERequestType) requestType;
//-(void) leSetParameter:(id) parameter;
//-(void) leSetUseCache:(BOOL) useCache;
//-(void) leSetDuration:(int) duration;
//-(void) leSetIdentification:(NSString *) identification;
//-(void) leSetCreateTimeStamp:(int) createTimestamp;
//-(void) leSetDelegateArray:(NSMutableArray *) delegateArray;
//-(void) leSetExtraObj:(id) extraObj;
////
//- (id) initWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter useCache:(BOOL) useCache duration:(int) duration delegate:(id<LENetworkDelegate>)delegate;
//- (id) initWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter useCache:(BOOL) useCache duration:(int) duration delegate:(id<LENetworkDelegate>)delegate Identification:(NSString *) identification;
//- (NSString *)  leGetURL;
//- (NSString *)  leGetKey;
//- (NSString *)  leGetRequestType;
//+ (NSString *)  leGetKeyWithApi:(NSString *) api uri:(NSString *) uri parameter:(id) parameter;
//- (void)        leAddUniqueDelegate:(id<LENetworkDelegate>) delegate;
//@end
//
//@interface LENetworkRequestObject : NSObject
//@property (nonatomic) LENetworkSettings               *leAfnetworkingSettings;
//- (id)      initWithSettings:(LENetworkSettings *)    settings;
//- (void)    leExecRequest:(BOOL)                            requestOrNot;
//@end
//
//@interface LENetwork : NSObject{
//    NSString *serverHost;
//}
//#pragma mark settings b4 using LE_Afnetwoking
////SET
//- (void)         leSetEnableDebug:(BOOL) enable;
//- (void)         leSetEnableResponseDebug:(BOOL) enable;
//- (void)         leSetEnableResponseWithJsonString:(BOOL) enable;
//- (void)         leSetServerHost:(NSString *) host;
//- (void)         leSetMD5Salt:(NSString *) salt;
//- (void)         leSetMessageDelegate:(id<LEAppMessageDelegate>) delegate;
//- (void)         leOnShowAppMessageWith:(NSString *) message;
//- (void)         leSetContentType:(NSSet *) type;
//- (void)         leSetStatusCode:(NSIndexSet *) status;
//- (void)         leSetServerIdentifierKey:(NSString *) identifierKey;
//- (void)         leSetServerIdentifier:(NSString *) identifier;
//- (void)         leSetServerIdentifierDelegate:(id<LENetworkServerIdentifierCheckDelegate>) serverIdentifierDelegate;
////GET
//- (BOOL)         leEnableDebug;
//- (BOOL)         leEnableResponseDebug;
//- (BOOL)         leEnableResponseWithJsonString;
//- (NSIndexSet *) leStatusCode;
//- (NSSet *)      leContentType;
//- (NSString *)   leMd5Salt;
//- (NSString *)   leGetServerHost;
//
//+ (instancetype) sharedInstance;
////
//- (LENetworkRequestObject *) leRequestWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter delegate:(id<LENetworkDelegate>)delegate;
//- (LENetworkRequestObject *) leRequestWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter delegate:(id<LENetworkDelegate>)delegate Identification:(NSString *) identification;
//- (LENetworkRequestObject *) leRequestWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter useCache:(BOOL) useCache duration:(int) duration delegate:(id<LENetworkDelegate>)delegate;
//- (LENetworkRequestObject *) leRequestWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter useCache:(BOOL) useCache duration:(int) duration delegate:(id<LENetworkDelegate>)delegate Identification:(NSString *) identification;
//- (LENetworkRequestObject *) leRequestWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter useCache:(BOOL) useCache duration:(int) duration delegate:(id<LENetworkDelegate>)delegate  AutoRequest:(BOOL) autoRequest;
//- (LENetworkRequestObject *) leRequestWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter useCache:(BOOL) useCache duration:(int) duration delegate:(id<LENetworkDelegate>)delegate  AutoRequest:(BOOL) autoRequest Identification:(NSString *) identification;
////
//- (NSDictionary *)  leGetLocalCacheWithApi:(NSString *) api uri:(NSString *) uri parameter:(id) parameter;
//- (void)            leSave:(NSString *) value WithKey:(NSString *) key;
//- (NSString *)      leGetValueWithKey:(NSString *) key;
//+ (NSString *)      leMd5:(NSString *) str;
//- (void)            leRemoveDelegate:(id) delegate;
//- (void)            leRemoveDelegateWithKey:(NSString *) key Value:(id) value;
//+ (int)             leGetTimeStamp ;
//+ (NSString *)      leJSONStringWithObject:(NSObject *) obj;
////字典对象转为实体对象
//+ (void)            leDictionaryToEntity:(NSDictionary *)dict entity:(NSObject*)entity;
////实体对象转为字典对象
//+ (NSDictionary *)  leEntityToDictionary:(id)entity;
//@end


@interface LEDataModel : NSObject
@property (nonatomic)          NSDictionary          * dataSource;
@property (nonatomic , strong) NSNumber              * id;
-(id) initWithDataSource:(NSDictionary *) data;
+(NSMutableArray *) initWithDataSources:(NSArray *) dataArray ClassName:(NSString *) className;
@end


