//
//  LERequest.m
//  Pods
//
//  Created by emerson larry on 2017/4/19.
//
//

#import "LERequest.h"

@interface LERequestSettings()
@property (nonatomic) NSString          *host;
@property (nonatomic) NSString          *api;
@property (nonatomic) NSString          *uri;
@property (nonatomic) NSDictionary      *head;
@property (nonatomic) LERequestType     type;
@property (nonatomic) NSObject          *parameter;
@property (nonatomic) NSObject          *addition;
@property (nonatomic) float             duration;
@property (nonatomic) BOOL              storeToDisk;
@end
@implementation LERequestSettings
#pragma mark Sets
-(instancetype) init{
    self=[super init];
    self.host=[[LERequestManager sharedInstance] leGetServerHost];
    self.type=LERequestTypeGet;
    self.storeToDisk=YES;
    return self;
}
-(LERequestSettings *(^)(NSString *)) leHost{
    return ^id(NSString *value){
        self.host = value;
        return self;
    };
}
-(LERequestSettings *(^)(NSString *)) leApi{
    return ^id(NSString *value){
        self.api = value;
        return self;
    };
}
-(LERequestSettings *(^)(NSString *)) leUri{
    return ^id(NSString *value){
        self.uri = value;
        return self;
    };
}
-(LERequestSettings *(^)(NSDictionary *)) leHead{
    return ^id(NSDictionary *value){
        self.head = value;
        return self;
    };
}
-(LERequestSettings *(^)(LERequestType)) leType{
    return ^id(LERequestType value){
        self.type = value;
        return self;
    };
}
-(LERequestSettings *(^)(id)) leParameter{
    return ^id(id value){
        self.parameter = value;
        return self;
    };
}
-(LERequestSettings *(^)(float)) leDuration{
    return ^id(float value){
        self.duration = value;
        return self;
    };
}
-(LERequestSettings *(^)(id)) leAddition{
    return ^id(id value){
        self.addition = value;
        return self;
    };
}
-(LERequestSettings *(^)(BOOL)) leStoreToDisk{
    return ^id(BOOL value){
        self.storeToDisk = value;
        return self;
    };
}
#pragma mark Gets
-(NSString *) leGetHost{
    return self.host;
}
-(NSString *) leGetApi{
    return self.api;
}
-(NSString *) leGetUri{
    return self.uri;
}
-(NSDictionary *) leGetHead{
    return self.head;
}
-(LERequestType) leGetType{
    return self.type;
}
-(id) leGetParameter{
    return self.parameter;
}
-(id) leGetAddition{
    return self.addition;
}
-(NSString *) leGetURL{
    return [NSString stringWithFormat:@"%@%@/%@",self.host, self.api, self.uri];
}
-(NSString *) leGetKey{
    NSString *key = nil;
    if(self.type == LERequestTypeGet || self.type == LERequestTypeHead){
        key = @"";
        if(self.parameter&&![self.parameter isKindOfClass:[NSString class]]){
            key=[self.parameter leObjToJSONString];
        }
        key = [NSString stringWithFormat:@"%@%@",self.leGetURL,key];
        key = LERequestManager.leGetMd5(key);
    }
    return key;
}
@end

@interface LERequest ()
@property (nonatomic,readwrite) NSTimeInterval timestamp;
@end
@implementation LERequest{
    NSTimer *timer;
    AFHTTPSessionManager *manager;
    NSDictionary *responseObjectCache;
    LERequestHandler requestResponse;
}
-(id) init{
    self=[super init];
    self.timestamp=[[NSDate date] timeIntervalSince1970];
    #ifdef DEBUG
    self.tag=++requestCounter;
    #endif
    return self;
}

+(LERequest *(^)(LERequestSettings *)) leGetRequest{
    return ^id(LERequestSettings *value){
        return LERequestManager.sharedInstance.leGetRequest(value);
    };
}
-(LERequest *) leRequest:(LERequestHandler) handler{
    requestResponse=handler;
    if(LERequestManager.sharedInstance.leDebugEnabled){
        LELog(@"=========>")
        LELog(@"URL------> %@",self.leSettings.leGetURL)
        LELog(@"Head-----> %@",self.leSettings.head.leObjToJSONString)
        LELog(@"Type-----> %@",self.leSettings.type==0?@"Get":(self.leSettings.type==1?@"Post":(self.leSettings.type==2?@"Head":(self.leSettings.type==3?@"Put":(self.leSettings.type==4?@"Patch":@"Delete")))))
        LELog(@"Param----> %@",self.leSettings.parameter.leObjToJSONString)
        LELog(@"Addition-> %@",[self.leSettings.addition isKindOfClass:[NSString class]]?self.leSettings.addition:self.leSettings.addition.leObjToJSONString)
    }
    if(self.leSettings.duration>0){
        [timer invalidate];
        timer=[NSTimer scheduledTimerWithTimeInterval:self.leSettings.duration target:self selector:@selector(onTimerCheck) userInfo:nil repeats:NO];
    }
    manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer setAcceptableStatusCodes:LERequestManager.sharedInstance.leGetStatusCode];
    [manager.responseSerializer setAcceptableContentTypes:LERequestManager.sharedInstance.leGetContentType];
    if(self.leSettings.head&&self.leSettings.head.count>0){//HTTPHEAD
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        for (NSString *key in self.leSettings.head.allKeys) {
            [manager.requestSerializer setValue:[self.leSettings.head objectForKey:key] forHTTPHeaderField:key];
        }
    }
    LERequest *weakSelf=self;
    switch (self.leSettings.type) {
        case 0://Get
        {
            [manager GET:self.leSettings.leGetURL parameters:self.leSettings.parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [weakSelf onRespondedWithRequest:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakSelf onRespondedWithRequest:task responseObject:nil error:error];
            }];
        }
            break;
        case 1://Post
        {
            [manager POST:self.leSettings.leGetURL parameters:self.leSettings.parameter progress:^(NSProgress * _Nonnull downloadProgress){
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [weakSelf onRespondedWithRequest:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakSelf onRespondedWithRequest:task responseObject:nil error:error];
            }];
        }
            break;
        case 2://Head
        {
            [manager HEAD:self.leSettings.leGetURL parameters:self.leSettings.parameter success:^(NSURLSessionDataTask * _Nonnull task) {
                [weakSelf onRespondedWithRequest:task responseObject:task];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakSelf onRespondedWithRequest:task responseObject:nil error:error];
            }];
        }
            break;
        case 3://Put
        {
            [manager PUT:self.leSettings.leGetURL parameters:self.leSettings.parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [weakSelf onRespondedWithRequest:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakSelf onRespondedWithRequest:task responseObject:nil error:error];
            }];
        }
            break;
        case 4://Patch
        {
            [manager PATCH:self.leSettings.leGetURL parameters:self.leSettings.parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [weakSelf onRespondedWithRequest:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakSelf onRespondedWithRequest:task responseObject:nil error:error];
            }];
            
        }
            break;
        case 5://Delete
        {
            [manager DELETE:self.leSettings.leGetURL parameters:self.leSettings.parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                [weakSelf onRespondedWithRequest:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)  {
                [weakSelf onRespondedWithRequest:task responseObject:nil error:error];
            }];
        }
            break;
        default:
            break;
    }
    return self;
}
- (void) onRespondedWithRequest:(NSURLSessionDataTask *) operation responseObject:(id) responseObject {
    [self onRespondedWithRequest:operation responseObject:responseObject error:nil];
}
- (void) onRespondedWithRequest:(NSURLSessionDataTask *) operation responseObject:(id) responseObject error:(NSError *) error {
    [manager invalidateSessionCancelingTasks:YES];
    manager=nil;
    [timer invalidate];
    if(error||!responseObject){
        if(error.code==-1001){
            LERequestManager.sharedInstance.leOnShowAppMessage(@"网络请求超时");
        }
        if(self.leSettings.type==LERequestTypeGet&&self.leSettings.storeToDisk){
            NSString *json=[[LEDataManager sharedInstance] leSelectRecordFromTable:LECacheTable WithKey:self.leSettings.leGetKey];
            if(json){
                NSDictionary *response=[json leJSONValue];
                responseObjectCache=response;
                if(response&&requestResponse){
                    [self onRespondWithResponse:responseObjectCache];
                }
            }
        }else if(self.leSettings.type==LERequestTypeHead){
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)operation.response;
            id obj=[[res allHeaderFields] objectForKey:LEKeyOfResponseCount];
            if(requestResponse){
                NSMutableDictionary *muta=[[NSMutableDictionary alloc] init];
                if(obj){
                    [muta setObject:obj forKey:LEKeyOfResponseCount];
                }else{
                    [muta setObject:@"0" forKey:LEKeyOfResponseCount];
                }
                responseObjectCache=muta;
                [self onRespondWithResponse:responseObjectCache];
            }
        }
        return;
    }
    NSMutableDictionary *response=[[NSMutableDictionary alloc] init];
    if(responseObject){//成功
        NSString *responseToJSONString=nil;
        if([responseObject respondsToSelector:@selector(length)]){
            NSInteger length=[responseObject length];
            if(length>0){
                responseToJSONString=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            }
        }
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)operation.response;
        if(LERequestManager.sharedInstance.leResponseDebugEnabled){
            LELogTwoObjects(self.leSettings.leGetURL,responseToJSONString);
        }
        id dataToObj=nil;
        if(responseToJSONString){
            dataToObj= [responseToJSONString leJSONValue];
        }
        if([dataToObj isKindOfClass:[NSDictionary class]]){
            response =[dataToObj mutableCopy];
        }else if([dataToObj isKindOfClass:[NSArray class]]){
            [response setObject:dataToObj forKey:LEKeyOfResponseArray];
        }
        if(self.leSettings.type==LERequestTypeHead){
            NSDictionary *header=[res allHeaderFields];
            if(header&&[header objectForKey:LEKeyOfResponseCount]){
                [response setObject:[header objectForKey:LEKeyOfResponseCount] forKey:LEKeyOfResponseCount];
            }else{
                [response setObject:@"0" forKey:LEKeyOfResponseCount];
            }
        }
        if(LERequestManager.sharedInstance.leResponseWithJsonStringEnabled){
            if(responseToJSONString){
                [response setObject:responseToJSONString forKey:LEKeyOfResponseAsJSON];
            }
            [response setObject:self.leSettings.leGetKey forKey:@"URL"];
        }
        [response setObject:[NSNumber numberWithInteger:[res statusCode]] forKey:LEKeyOfResponseStatusCode];
        if(LERequestManager.sharedInstance.leGetServerIdentifierKey&&LERequestManager.sharedInstance.leGetServerIdentifier){
            NSString *objServerIdentifier=[[res allHeaderFields] objectForKey:LERequestManager.sharedInstance.leGetServerIdentifierKey];
            if(!objServerIdentifier||![objServerIdentifier isEqualToString:LERequestManager.sharedInstance.leGetServerIdentifier]){
                [LERequestManager.sharedInstance leFailedCheckingServerIdentifier];
                [response setObject:@"1000000" forKey:LEKeyOfResponseStatusCode];
            }
        }
        if(response&&requestResponse){
            if(self.leSettings.storeToDisk && self.leSettings.type==LERequestTypeGet){
                NSString *json=response.leObjToJSONString;
                if(json){
                    [[LEDataManager sharedInstance] leUpdateRecordInTable:LECacheTable WithKey:self.leSettings.leGetKey Value:json];
                }
            }
            responseObjectCache=response;
            [self onRespondWithResponse:responseObjectCache];
        }
    }
}
- (void) returnCachedResponse{
    if(responseObjectCache&&requestResponse){
        [self onRespondWithResponse:responseObjectCache];
    }
}
-(void) onRespondWithResponse:(NSDictionary *) response{
    int statusCode=[[response objectForKey:LEKeyOfResponseStatusCode] intValue];
    BOOL requestFailed=statusCode/100!=2;
    NSString *errormsg=nil;
    if(requestFailed){
        if(statusCode!=500){
            errormsg=[response objectForKey:LEKeyOfResponseErrormsg];
            LERequestManager.sharedInstance.leOnShowAppMessage(errormsg);
        }
    }
    if(requestResponse){
        requestResponse(self,responseObjectCache,statusCode,errormsg);
    }
}
-(void) onTimerCheck{
    [self leRelease];
}
-(LERequest *) leRequestFromMemory:(LERequestHandler) handler{
    requestResponse=handler;
    if(responseObjectCache&&requestResponse){
        [self onRespondWithResponse:responseObjectCache];
    }
    return self;
}
-(LERequest *) leRequestFromDiskIfExist:(LERequestHandler) handler{
    requestResponse=handler;
    if(self.leSettings.type==LERequestTypeGet){
        NSString *json=[[LEDataManager sharedInstance] leSelectRecordFromTable:LECacheTable WithKey:self.leSettings.leGetKey];
        if(json){
            NSDictionary *response=[json leJSONValue];
            responseObjectCache=response;
            if(response&&requestResponse){
                [self onRespondWithResponse:responseObjectCache];
            }
        }
    }
    return self;
}
-(LERequest *) leCancleRequest{
    [manager invalidateSessionCancelingTasks:YES];
    return self;
}
-(void) leRelease{
    [super leRelease];
    [timer invalidate];
    requestResponse=nil;
    [manager invalidateSessionCancelingTasks:YES];
    manager=nil;
}
@end

@interface LERequestManager ()
@property (nonatomic) NSString *serverHost;
@property (nonatomic) BOOL enableDebug;
@property (nonatomic) BOOL enableResponseDebug;
@property (nonatomic) BOOL enableResponseWithJsonString;
@property (nonatomic) NSString *md5Salt;
@property (nonatomic, weak) id<LEAppMessageDelegate> messageDelegate;
@property (nonatomic, weak) LEServerIdentifierCheckHandler serverIdentifierCheckHandler;
@property (nonatomic) NSString *serverIdentifier;
@property (nonatomic) NSString *serverIdentifierKey;
@property (nonatomic) NSSet *contentType;
@property (nonatomic) NSIndexSet *statusCode;
@end

@implementation LERequestManager{
    NSMutableDictionary *requestCache;
    AFNetworkReachabilityStatus currentNetworkStatus;
}
static LERequestManager *theSharedInstance = nil;
- (LERequest *)  leGetRequestFromCacheWith:(NSString *) key{
    return [requestCache objectForKey:key];
}
- (void) leAddRequestToCache:(LERequest *) request{
    NSString *key=request.leSettings.leGetKey;
    LERequest *old=[requestCache objectForKey:key];
    if(old){
        [old.leCancleRequest leRelease];
    }
    [requestCache setObject:request forKey:key];
}
-(id) init{
    self=[super init];
    requestCache=[NSMutableDictionary new];
    return self;
}
//
static BOOL enableNetWorkAlert;
static AFNetworkReachabilityStatus currentNetworkStatus;
+ (instancetype) sharedInstance { @synchronized(self) { if (theSharedInstance == nil) {
    theSharedInstance = [[self alloc] init];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        currentNetworkStatus=status;
        [NSTimer scheduledTimerWithTimeInterval:1 target:theSharedInstance selector:@selector(onEnableNetworkAlert) userInfo:nil repeats:NO];
        if(enableNetWorkAlert){
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:{
                    theSharedInstance.leOnShowAppMessage(@"当前网络不可用，请检查网络");
                    break;
                }
                    //                case AFNetworkReachabilityStatusReachableViaWiFi:{ break; }
                    //                case AFNetworkReachabilityStatusReachableViaWWAN:{ break; }
                default:
                    break;
            }
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
} } return theSharedInstance; }
- (void) onEnableNetworkAlert{ enableNetWorkAlert=YES; }
#pragma mark settings b4 using LERequest
//SET
-(LERequestManager *(^)(BOOL)) leEnableDebug{
    return ^id(BOOL value){
        self.enableDebug = value;
        return self;
    };
}
-(LERequestManager *(^)(BOOL)) leEnableResponseDebug{
    return ^id(BOOL value){
        self.enableResponseDebug = value;
        return self;
    };
}
-(LERequestManager *(^)(BOOL)) leEnableResponseWithJsonString{
    return ^id(BOOL value){
        self.enableResponseWithJsonString = value;
        return self;
    };
}
-(LERequestManager *(^)(NSString *)) leServerHost{
    return ^id(NSString *value){
        self.serverHost = value;
        return self;
    };
}
-(LERequestManager *(^)(NSString *)) leMD5Salt{
    return ^id(NSString *value){
        self.md5Salt = value;
        return self;
    };
}
-(LERequestManager *(^)(id<LEAppMessageDelegate>)) leMessageDelegate{
    return ^id(id<LEAppMessageDelegate> value){
        self.messageDelegate = value;
        return self;
    };
}
-(LERequestManager *(^)(NSSet *)) leContentType{
    return ^id(NSSet *value){
        self.contentType = value;
        return self;
    };
}
-(LERequestManager *(^)(NSIndexSet *)) leStatusCode{
    return ^id(NSIndexSet *value){
        self.statusCode = value;
        return self;
    };
}
-(LERequestManager *(^)(NSString *)) leServerIdentifierKey{
    return ^id(NSString *value){
        self.serverIdentifierKey = value;
        return self;
    };
}
-(LERequestManager *(^)(NSString *)) leServerIdentifier{
    return ^id(NSString *value){
        self.serverIdentifier = value;
        return self;
    };
}
-(LERequestManager *(^)(LEServerIdentifierCheckHandler)) leServerIdentifierCheckHandler{
    return ^id(LEServerIdentifierCheckHandler value){
        self.serverIdentifierCheckHandler = value;
        return self;
    };
}
-(void) leServerIdentifierCheckFailed:(LEServerIdentifierCheckHandler) handler{
    self.serverIdentifierCheckHandler=handler;
}
//GET
- (LERequest *(^)(LERequestSettings *)) leGetRequest{
    return ^id(LERequestSettings *value){
        LERequest *request=nil;
        NSString *key=value.leGetKey;
        if(value.duration>0){
            request=self.leGetRequestFromCache(key);
            if(request!=nil){
//                LELog(@"%.0f-%@=%.0f -> %d",[[NSDate date] timeIntervalSince1970]-request.timestamp,@(value.duration),[[NSDate date] timeIntervalSince1970]-request.timestamp-value.duration,request.timestamp+value.duration<=[[NSDate date] timeIntervalSince1970])
                if(request.timestamp+value.duration<=[[NSDate date] timeIntervalSince1970]){
                    [request leRelease];
                    request=nil;
                }else{
                    request.timestamp=[[NSDate date] timeIntervalSince1970];
//                    LELogObject(@"---------")
                }
            }
        }
        if(request==nil){
//            LELogObject(@"=========")
            request=[LERequest new];
            request.leSettings=value;
            request.timestamp=[[NSDate date] timeIntervalSince1970];
            [requestCache setObject:request forKey:key];
        }
        return request;
    };
}
-(BOOL) leDebugEnabled{
    return self.enableDebug;
}
-(BOOL) leResponseDebugEnabled{
    return self.enableResponseDebug;
}
-(BOOL) leResponseWithJsonStringEnabled{
    return self.enableResponseWithJsonString;
}
-(NSIndexSet *) leGetStatusCode{
    return self.statusCode;
}
-(NSIndexSet *) statusCode{
    if(_statusCode==nil){
        _statusCode=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 400)];
    }
    return _statusCode;
}
-(NSSet *) leGetContentType{
    return self.contentType;
}
-(NSSet *) contentType{
    if(_contentType==nil){
        _contentType=[[NSSet alloc] initWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain", nil];
    }
    return _contentType;
}
-(NSString *) leGetMD5Salt{
    return self.md5Salt;
}
-(NSString *) leGetServerHost{
    if(self.serverHost){
        return self.serverHost;
    }
    return @"";
}
- (NSString *) leGetServerIdentifierKey{
    return self.serverIdentifierKey;
}
- (NSString *) leGetServerIdentifier{
    return self.serverIdentifier;
}
- (LERequest *(^)(NSString *)) leGetRequestFromCache{
    return ^id(NSString *value){
        return [requestCache objectForKey:value];
    };
}
+ (NSString *(^)(NSString *)) leGetMd5{
    return ^id(NSString *value){
        return [value leMd5WithSalt:[LERequestManager sharedInstance].leGetMD5Salt?[LERequestManager sharedInstance].leGetMD5Salt:@""];
    };
}
- (void(^)(NSString *)) leOnShowAppMessage{
    return ^(NSString *value){
        if(self.messageDelegate&&[self.messageDelegate respondsToSelector:@selector(leOnShowAppMessageWith:)]){
            [self.messageDelegate leOnShowAppMessageWith:value];
        }
        return ;
    };
}
- (void) leFailedCheckingServerIdentifier{
    if(self.serverIdentifierCheckHandler){
        self.serverIdentifierCheckHandler();
    }
}
@end

@implementation NSObject (LERequest) 
-(void (^)(NSDictionary *)) leSetEntity{
    return ^void(NSDictionary *value){
        for (NSString *key in value.allKeys) {//构建出属性的set方法
            SEL destMethodSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:",[key capitalizedString]]);
            if ([self respondsToSelector:destMethodSelector]) {
                LESuppressPerformSelectorLeakWarning(
                                                     [self performSelector:destMethodSelector withObject:[value objectForKey:key]];
                                                     );
            }
        }
        return;
    };
}
-(NSDictionary *(^)()) leGetDataFromEntity{
    return ^id(){
        NSString *className=[NSString stringWithUTF8String:object_getClassName(self)];
        Class clazz =  NSClassFromString(className);
        unsigned int count;
        objc_property_t* properties = class_copyPropertyList(clazz, &count);
        NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
        NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count ; i++){
            objc_property_t prop=properties[i];
            const char* propertyName = property_getName(prop);
            [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
            id value =nil;
            LESuppressPerformSelectorLeakWarning(
                                                 value=[self performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName])];
                                                 );
            if(value ==nil){
                [valueArray addObject:@""];
            }else {
                [valueArray addObject:value];
            }
        }
        free(properties);
        NSDictionary* returnDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
        return returnDic;
    };
}
@end
