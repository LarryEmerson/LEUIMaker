//
//  LENetwork.m
//  Pods
//
//  Created by emerson larry on 2017/2/6.
//
//

#import "LENetwork.h"

@interface LEDataManager ()
@property (nonatomic, weak) id<LEDataManagerDelegate> leDelegate;
@end
@implementation LEDataManager{
    BOOL isDebugEnabled;
}
LESingleton_implementation(LEDataManager)
-(void) leEnableDebug:(BOOL) enable{
    isDebugEnabled=enable;
}
-(void) leSetDelegate:(id<LEDataManagerDelegate>)delegate{
    self.leDelegate=delegate;
    if([self.leDelegate respondsToSelector:@selector(leInitDataBase)]){
        if(self.leDataBase&&[self.leDelegate respondsToSelector:@selector(leClose:)]){
            [self.leDelegate leClose:self.leDataBase];
        }
        self.leDataBase=nil;
        self.leDataBase=[self.leDelegate leInitDataBase];
        if(self.leDataBase&&[self.leDelegate respondsToSelector:@selector(leOpen:)]){
            [self.leDelegate leOpen:self.leDataBase];
        }
    }
}
-(void) leReloadWithNewPath:(NSString *) path{
    if([self.leDelegate respondsToSelector:@selector(leReloadWithNewPath:LastDataBase:)]){
        if(self.leDataBase&&[self.leDelegate respondsToSelector:@selector(leClose:)]){
            [self.leDelegate leClose:self.leDataBase];
        }
        self.leDataBase=nil;
        self.leDataBase=[self.leDelegate leReloadWithNewPath:path LastDataBase:self.leDataBase];
        if(self.leDataBase&&[self.leDelegate respondsToSelector:@selector(leOpen:)]){
            [self.leDelegate leOpen:self.leDataBase];
        }
    }
}
-(void) runSql:(NSString *) sql{
    if(isDebugEnabled){
        LELogObject(sql)
    }
    if(self.leDataBase&&[self.leDelegate respondsToSelector:@selector(leRunSql:DataBase:)]){
        [self.leDelegate leRunSql:sql DataBase:self.leDataBase];
    }
}
-(void) leCreateTable:(NSString *) table{
    NSString *sql=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS \"%@\" (\n\"key\" Text NOT NULL PRIMARY KEY,\n\"value\" Text NOT NULL )",table];
    [self runSql:sql];
}

-(void) leClearTable:(NSString *) table{
    NSString *sql=[NSString stringWithFormat:@"delete from %@",table];
    [self runSql:sql];
}
-(void) leRemoveRecordFromTable:(NSString *) table WithKey:(NSString *) key{
    NSString *sql=[NSString stringWithFormat:@"delete from %@ where key='%@'",table,key];
    [self runSql:sql];
}
-(void) leRemoveTable:(NSString *) table{
    NSString *sql=[NSString stringWithFormat:@"drop table %@",table];
    [self runSql:sql];
}
-(void) leUpdateRecordInTable:(NSString *) table WithKey:(NSString *) key Value:(NSString *) value{
    [self leCreateTable:table];
    [self leRemoveRecordFromTable:table WithKey:key];
    NSString *sql=[NSString stringWithFormat:@"insert into %@ (key,value) values ('%@', '%@')",table,key,value];
    [self runSql:sql];
}
-(void) leInsertRecordToTable:(NSString *) table WithKey:(NSString *) key Value:(NSString *) value{
    [self leCreateTable:table];
    NSString *sql=[NSString stringWithFormat:@"insert into %@ (key,value) values ('%@', '%@')",table,key,value];
    [self runSql:sql];
}

-(NSArray *) leSelectRecordsFromTable:(NSString *) table{
    if(self.leDataBase&&[self.leDelegate respondsToSelector:@selector(leSelect:OnlyFirstRecord:DataBase:)]){
       return [self.leDelegate leSelect:[NSString stringWithFormat:@"select * from %@",table] OnlyFirstRecord:NO DataBase:self.leDataBase];
    }
    return nil;
}
-(id) leSelectRecordFromTable:(NSString *) table WithKey:(NSString *) key{
    if(self.leDataBase&&[self.leDelegate respondsToSelector:@selector(leSelect:OnlyFirstRecord:DataBase:)]){
        return [self.leDelegate leSelect:[NSString stringWithFormat:@"select * from %@ where key='%@'",table,key] OnlyFirstRecord:YES DataBase:self.leDataBase];
    }
    return nil;
}

-(void) leBatchImportToTable:(NSString *) table WithData:(NSArray *) data{
    if(self.leDataBase&&[self.leDelegate respondsToSelector:@selector(leBatchSqls:DataBase:)]){
        [self.leDelegate leBatchSqls:data DataBase:self.leDataBase];
    }
}
@end
 
//@interface LENetwork ()
//-(int) getNetworkCounter;
//@property (nonatomic) BOOL enableDebug;
//@property (nonatomic) BOOL enableResponseDebug;
//@property (nonatomic) BOOL enableResponseWithJsonString;
//@property (nonatomic) NSString *md5Salt;
//@property (nonatomic, weak) id<LEAppMessageDelegate> messageDelegate;
//@property (nonatomic, weak) id<LENetworkServerIdentifierCheckDelegate> serverIdentifierDelegate;
//@property (nonatomic) NSString *serverIdentifier;
//@property (nonatomic) NSString *serverIdentifierKey;
//@property (nonatomic) NSSet *contentType;
//@property (nonatomic) NSIndexSet *statusCode;
//@end
//
//@interface LENetworkSettings ()
//@property (nonatomic, readwrite) int               leRequestCounter;
//@property (nonatomic, readwrite) NSString          *leApi;
//@property (nonatomic, readwrite) NSString          *leUri;
//@property (nonatomic, readwrite) NSDictionary      *leHttpHead;
//@property (nonatomic, readwrite) LERequestType     leRequestType;
//@property (nonatomic, readwrite) id                leParameter;
//@property (nonatomic, readwrite) BOOL              leUseCache;
//@property (nonatomic, readwrite) int               leDuration;
//@property (nonatomic, readwrite) NSString          *leIdentification;//用于给请求加标签
//@property (nonatomic, readwrite) int               leCreateTimestamp;
//@end
//@implementation LENetworkSettings
//-(void) leSetRequestCount:(int) requestCount{
//    self.leRequestCounter=requestCount;
//}
//-(void) leSetApi:(NSString *) api{
//    self.leApi=api;
//}
//-(void) leSetUri:(NSString *) uri{
//    self.leUri=uri;
//}
//-(void) leSetHttpHead:(NSDictionary *) httpHead{
//    self.leHttpHead=httpHead;
//}
//-(void) leSetRequestType:(LERequestType) requestType{
//    self.leRequestType=requestType;
//}
//-(void) leSetParameter:(id) parameter{
//    self.leParameter=parameter;
//}
//-(void) leSetUseCache:(BOOL) useCache{
//    self.leUseCache=useCache;
//}
//-(void) leSetDuration:(int) duration{
//    self.leDuration=duration;
//}
//-(void) leSetIdentification:(NSString *) identification{
//    self.leIdentification=identification;
//}
//-(void) leSetCreateTimeStamp:(int) createTimestamp{
//    self.leCreateTimestamp=createTimestamp;
//}
//-(void) leSetDelegateArray:(NSMutableArray *) delegateArray{
//    self.leCurDelegateArray=delegateArray;
//}
//-(void) leSetExtraObj:(id) extraObj{
//    self.leExtraObj=extraObj;
//}
////
//- (id) initWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter useCache:(BOOL) useCache duration:(int) duration delegate:(id<LENetworkDelegate>)delegate{
//    return [self initWithApi:api uri:uri httpHead:httpHead requestType:requestType parameter:parameter useCache:useCache duration:duration delegate:delegate Identification:nil];
//}
//- (id) initWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter useCache:(BOOL) useCache duration:(int) duration delegate:(id<LENetworkDelegate>)delegate Identification:(NSString *) identification{
//    self.leCurDelegateArray=[[NSMutableArray alloc] init];
//    self=[super init];
//    self.leApi=api;
//    self.leUri=uri;
//    self.leHttpHead=httpHead;
//    self.leRequestType=requestType;
//    self.leParameter=parameter;
//    self.leUseCache=useCache;
//    self.leDuration=duration;
//    self.leIdentification=identification;
//    self.leRequestCounter=[[LENetwork sharedInstance] getNetworkCounter];
//    if(delegate){
//        [self.leCurDelegateArray addObject:delegate];
//    }
//    return self;
//}
//-(void) leAddUniqueDelegate:(id<LENetworkDelegate>) delegate{
//    BOOL found=NO;
//    for (id<LENetworkDelegate> del in self.leCurDelegateArray) {
//        if([del isEqual:delegate]){
//            found=YES;
//            break;
//        }
//    }
//    if(!found){
//        [self.leCurDelegateArray addObject:delegate];
//    }
//}
//- (NSString *) leGetURL{
//    return [NSString stringWithFormat:@"%@%@/%@",[[LENetwork sharedInstance] leGetServerHost],self.leApi,self.leUri];
//}
//- (NSString *) leGetKey{
//    NSString *jsonString=@"";
//    if(self.leParameter&&![self.leParameter isKindOfClass:[NSString class]]){
//        jsonString=[self.leParameter leObjToJSONString];
//    }
//    return [[self leGetURL] stringByAppendingString:jsonString];
//}
//- (NSString *) leGetRequestType{
//    return self.leRequestType==0?@"Get":(self.leRequestType==1?@"Post":(self.leRequestType==2?@"Head":(self.leRequestType==3?@"Put":(self.leRequestType==4?@"Patch":@"Delete"))));
//}
//+ (NSString *) leGetKeyWithApi:(NSString *) api uri:(NSString *) uri parameter:(id) parameter{
//    return [[NSString stringWithFormat:@"%@%@/%@",[[LENetwork sharedInstance] leGetServerHost],api,uri] stringByAppendingString:parameter?[parameter leObjToJSONString]:@""];
//}
//@end
//
//@implementation LENetworkRequestObject{
//    NSDictionary *responseObjectCache;
//    AFHTTPSessionManager *manager;
//}
//- (id) initWithSettings:(LENetworkSettings *) settings{
//    if([LENetwork sharedInstance].leEnableDebug){
//        LELogObject(@"===============================>");
//        LELog(@"URL=%@",settings.leGetURL);
//        LELog(@"Head=%@",settings.leHttpHead);
//        LELog(@"Type=%@",settings.leGetRequestType);
//        LELog(@"Param=%@",settings.leParameter);
//    }
//    self=[super init];
//    self.leAfnetworkingSettings=settings;
//    return self;
//}
//-(void) dealloc{
//    [self.leAfnetworkingSettings.leCurDelegateArray removeAllObjects];
//    self.leAfnetworkingSettings=nil;
//    responseObjectCache=nil;
//    manager=nil;
//}
//- (void) leExecRequest:(BOOL) requestOrNot{
//    if(!requestOrNot){
//        return;
//    }
//    LENetworkSettings *settings=self.leAfnetworkingSettings;
//    manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    //
//    [manager.responseSerializer setAcceptableStatusCodes:[[LENetwork sharedInstance] leStatusCode]];
//    [manager.responseSerializer setAcceptableContentTypes:[[LENetwork sharedInstance] leContentType]];
//    if(settings.leHttpHead&&settings.leHttpHead.count>0){//HTTPHEAD
//        manager.requestSerializer=[AFJSONRequestSerializer serializer];
//        for (NSString *key in settings.leHttpHead.allKeys) {
//            [manager.requestSerializer setValue:[settings.leHttpHead objectForKey:key] forHTTPHeaderField:key];
//        }
//    }
//    
//    LENetworkRequestObject *weakSelf=self;
//    //    __weak typeof(self) weakSelf = self;
//    switch (settings.leRequestType) {
//        case 0://Get
//        {
//            [manager GET:settings.leGetURL parameters:settings.leParameter progress:^(NSProgress * _Nonnull downloadProgress) {
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                [weakSelf onRespondedWithRequest:task responseObject:responseObject];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                [weakSelf onRespondedWithRequest:task responseObject:nil error:error];
//            }];
//        }
//            break;
//        case 1://Post
//        {
//            [manager POST:settings.leGetURL parameters:settings.leParameter progress:^(NSProgress * _Nonnull downloadProgress){
//                
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                [weakSelf onRespondedWithRequest:task responseObject:responseObject];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                [weakSelf onRespondedWithRequest:task responseObject:nil error:error];
//            }];
//        }
//            break;
//        case 2://Head
//        {
//            [manager HEAD:settings.leGetURL parameters:settings.leParameter success:^(NSURLSessionDataTask * _Nonnull task) {
//                [weakSelf onRespondedWithRequest:task responseObject:task];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                [weakSelf onRespondedWithRequest:task responseObject:nil error:error];
//            }];
//        }
//            break;
//        case 3://Put
//        {
//            [manager PUT:settings.leGetURL parameters:settings.leParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                [weakSelf onRespondedWithRequest:task responseObject:responseObject];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                [weakSelf onRespondedWithRequest:task responseObject:nil error:error];
//            }];
//        }
//            break;
//        case 4://Patch
//        {
//            [manager PATCH:settings.leGetURL parameters:settings.leParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                [weakSelf onRespondedWithRequest:task responseObject:responseObject];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                [weakSelf onRespondedWithRequest:task responseObject:nil error:error];
//            }];
//            
//        }
//            break;
//        case 5://Delete
//        {
//            [manager DELETE:settings.leGetURL parameters:settings.leParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
//                [weakSelf onRespondedWithRequest:task responseObject:responseObject];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)  {
//                [weakSelf onRespondedWithRequest:task responseObject:nil error:error];
//            }];
//        }
//            break;
//        default:
//            break;
//    }
//}
//- (void) onRespondedWithRequest:(NSURLSessionDataTask *) operation responseObject:(id) responseObject {
//    [self onRespondedWithRequest:operation responseObject:responseObject error:nil];
//    [manager invalidateSessionCancelingTasks:YES];
//}
//- (void) onRespondedWithRequest:(NSURLSessionDataTask *) operation responseObject:(id) responseObject error:(NSError *) error {
//    if(error||!responseObject){
//        if(error.code==-1001){
//            [[LENetwork sharedInstance] leOnShowAppMessageWith:@"网络请求超时"];
//        }
//        //        else
//        {
//            if((self.leAfnetworkingSettings.leRequestType==LERequestTypeGet )){
//                NSString *json=[[LEDataManager sharedInstance] leSelectRecordFromTable:LECacheTable WithKey:self.leAfnetworkingSettings.leGetKey];
//                if(json){
//                    NSDictionary *response=[json leJSONValue];
//                    responseObjectCache=response;
//                    if(response&&self.leAfnetworkingSettings.leCurDelegateArray){
//                        [self onRespondWithResponse:responseObjectCache];
//                        //                        NSMutableArray *list=[[NSMutableArray alloc] init];
//                        //                        for(int i=0;i<self.leAfnetworkingSettings.curDelegateArray.count;++i){
//                        //                            id<LENetworkDelegate> delegate=[self.leAfnetworkingSettings.curDelegateArray objectAtIndex:i];
//                        //                            if(delegate){
//                        //                                [list addObject:delegate];
//                        //                                [delegate leRequest:self ResponedWith:response];
//                        //                            }
//                        //                        }
//                        //                        [self.leAfnetworkingSettings setCurDelegateArray:list];
//                    }
//                }
//            }else if(self.leAfnetworkingSettings.leRequestType==LERequestTypeHead){
//                NSHTTPURLResponse *res = (NSHTTPURLResponse *)operation.response;
//                id obj=[[res allHeaderFields] objectForKey:LEKeyOfResponseCount];
//                if(self.leAfnetworkingSettings.leCurDelegateArray){
//                    NSMutableDictionary *muta=[[NSMutableDictionary alloc] init];
//                    if(obj){
//                        [muta setObject:obj forKey:LEKeyOfResponseCount];
//                    }else{
//                        [muta setObject:@"0" forKey:LEKeyOfResponseCount];
//                    }
//                    responseObjectCache=muta;
//                    [self onRespondWithResponse:responseObjectCache];
//                    //                    NSMutableArray *list=[[NSMutableArray alloc] init];
//                    //                    for(int i=0;i<self.leAfnetworkingSettings.curDelegateArray.count;++i){
//                    //                        id<LENetworkDelegate> delegate=[self.leAfnetworkingSettings.curDelegateArray objectAtIndex:i];
//                    //                        if(delegate){
//                    //                            [list addObject:delegate];
//                    //                            [delegate leRequest:self ResponedWith:muta];
//                    //                        }
//                    //                    }
//                    //                    [self.leAfnetworkingSettings setCurDelegateArray:list];
//                }
//            }
//        }
//        return;
//    }
//    NSMutableDictionary *response=[[NSMutableDictionary alloc] init];
//    if(responseObject){//成功
//        NSString *responseToJSONString=nil;
//        if([responseObject respondsToSelector:@selector(length)]){
//            NSInteger length=[responseObject length];
//            if(length>0){
//                responseToJSONString=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            }
//        }
//        NSHTTPURLResponse *res = (NSHTTPURLResponse *)operation.response;
//        if([LENetwork sharedInstance].leEnableResponseDebug){
//            LELogTwoObjects(self.leAfnetworkingSettings.leGetURL,responseToJSONString);
//        }
//        id dataToObj=nil;
//        if(responseToJSONString){
//            dataToObj= [responseToJSONString leJSONValue];
//        }
//        if([dataToObj isKindOfClass:[NSDictionary class]]){
//            response =[dataToObj mutableCopy];
//        }else if([dataToObj isKindOfClass:[NSArray class]]){
//            [response setObject:dataToObj forKey:LEKeyOfResponseArray];
//        }
//        if(self.leAfnetworkingSettings.leRequestType==LERequestTypeHead){
//            NSDictionary *header=[res allHeaderFields];
//            if(header&&[header objectForKey:LEKeyOfResponseCount]){
//                [response setObject:[header objectForKey:LEKeyOfResponseCount] forKey:LEKeyOfResponseCount];
//            }else{
//                [response setObject:@"0" forKey:LEKeyOfResponseCount];
//            }
//        }
//        if([LENetwork sharedInstance].leEnableResponseWithJsonString){
//            if(responseToJSONString){
//                [response setObject:responseToJSONString forKey:LEKeyOfResponseAsJSON];
//            }
//            [response setObject:[self.leAfnetworkingSettings leGetKey] forKey:@"URL"];
//        }
//        [response setObject:[NSNumber numberWithInteger:[res statusCode]] forKey:LEKeyOfResponseStatusCode];
//        if([LENetwork sharedInstance].serverIdentifierKey&&[LENetwork sharedInstance].serverIdentifier){
//            NSString *objServerIdentifier=[[res allHeaderFields] objectForKey:[LENetwork sharedInstance].serverIdentifierKey];
//            if(!objServerIdentifier||![objServerIdentifier isEqualToString:[LENetwork sharedInstance].serverIdentifier]){
//                if([LENetwork sharedInstance].serverIdentifierDelegate&&[[LENetwork sharedInstance].serverIdentifierDelegate respondsToSelector:@selector(leFailedCheckingServerIdentifier)]){
//                    [[LENetwork sharedInstance].serverIdentifierDelegate leFailedCheckingServerIdentifier];
//                    [response setObject:@"1000000" forKey:LEKeyOfResponseStatusCode];
//                }
//            }
//        }
//        if(response&&self.leAfnetworkingSettings.leCurDelegateArray){
//            if((self.leAfnetworkingSettings.leRequestType==LERequestTypeGet||self.leAfnetworkingSettings.leRequestType==LERequestTypeHead)){
//                NSString *json=[LENetwork leJSONStringWithObject:response];
//                if(json){
//                    [[LE_DataManager sharedInstanceOfStorage] leAddOrUpdateWithKey:self.leAfnetworkingSettings.leGetKey Value:json ToTable:LECacheTable];
//                }
//            }
//            responseObjectCache=response;
//            [self onRespondWithResponse:responseObjectCache];
//            //            NSMutableArray *list=[[NSMutableArray alloc] init];
//            //            for(int i=0;i<self.leAfnetworkingSettings.curDelegateArray.count;++i){
//            //                id<LENetworkDelegate> delegate=[self.leAfnetworkingSettings.curDelegateArray objectAtIndex:i];
//            //                if(delegate){
//            //                    [list addObject:delegate];
//            //                    [delegate leRequest:self ResponedWith:response];
//            //                }
//            //            }
//            //            [self.leAfnetworkingSettings setCurDelegateArray:list];
//        }
//    }
//}
//- (void) returnCachedResponse{
//    if(responseObjectCache&&self.leAfnetworkingSettings.leCurDelegateArray){
//        [self onRespondWithResponse:responseObjectCache];
//        //        NSMutableArray *list=[[NSMutableArray alloc] init];
//        //        for(int i=0;i<self.leAfnetworkingSettings.curDelegateArray.count;++i){
//        //            id<LENetworkDelegate> delegate=[self.leAfnetworkingSettings.curDelegateArray objectAtIndex:i];
//        //            if(delegate){
//        //                [list addObject:delegate];
//        //                [delegate leRequest:self ResponedWith:responseObjectCache];
//        //            }
//        //        }
//        //        [self.leAfnetworkingSettings setCurDelegateArray:list];
//    }
//}
//-(void) onRespondWithResponse:(NSDictionary *) response{
//    int statusCode=[[response objectForKey:LEKeyOfResponseStatusCode] intValue];
//    BOOL requestFailed=statusCode/100!=2;
//    NSString *errormsg=nil;
//    if(requestFailed){
//        if(statusCode!=500){
//            errormsg=[response objectForKey:LEKeyOfResponseErrormsg];
//            [[LENetwork sharedInstance] leOnShowAppMessageWith:errormsg];
//        }
//    }
//    NSMutableArray *list=[[NSMutableArray alloc] init];
//    for(int i=0;i<self.leAfnetworkingSettings.leCurDelegateArray.count;++i){
//        id<LENetworkDelegate> delegate=[self.leAfnetworkingSettings.leCurDelegateArray objectAtIndex:i];
//        if(delegate){
//            [list addObject:delegate];
//            if(requestFailed){
//                if([delegate respondsToSelector:@selector(leRequest:FailedWithStatusCode:Message:)]){
//                    [delegate leRequest:self FailedWithStatusCode:statusCode Message:errormsg];
//                }
//            }else{
//                if([delegate respondsToSelector:@selector(leRequest:ResponedWith:)]){
//                    [delegate leRequest:self ResponedWith:responseObjectCache];
//                }
//            }
//        }
//    }
//    [self.leAfnetworkingSettings leSetDelegateArray:list];
//}
//@end
//
//
//@implementation LENetwork{
//    NSMutableDictionary *afnetworkingCache;
//}
//- (void) leSetServerIdentifierKey:(NSString *) identifierKey{
//    self.serverIdentifierKey=identifierKey;
//}
//- (void) leSetServerIdentifier:(NSString *) identifier{
//    self.serverIdentifier=identifier;
//}
//- (void) leSetServerIdentifierDelegate:(id<LENetworkServerIdentifierCheckDelegate>) delegate{
//    self.serverIdentifierDelegate=delegate;
//}
//-(void) leSetStatusCode:(NSIndexSet *) status{
//    self.statusCode=status;
//}
//-(NSIndexSet *) leStatusCode{
//    return self.statusCode;
//}
//-(NSIndexSet *) statusCode{
//    if(_statusCode==nil){
//        _statusCode=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 400)];
//    }
//    return _statusCode;
//}
//
//-(void) leSetContentType:(NSSet *) type{
//    self.contentType=type;
//}
//-(NSSet *) leContentType{
//    return self.contentType;
//}
//-(NSSet *) contentType{
//    if(_contentType==nil){
//        _contentType=[[NSSet alloc] initWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain", nil];
//    }
//    return _contentType;
//}
//-(BOOL) leEnableDebug{
//    return self.enableDebug;
//}
//-(BOOL) leEnableResponseDebug{
//    return self.enableResponseDebug;
//}
//-(BOOL) leEnableResponseWithJsonString{
//    return self.enableResponseWithJsonString;
//}
//-(NSString *) leMd5Salt{
//    return self.md5Salt;
//}
//-(void) leSetEnableDebug:(BOOL) enable{
//    self.enableDebug=enable;
//}
//-(void) leSetEnableResponseDebug:(BOOL) enable{
//    self.enableResponseDebug=enable;
//}
//-(void) leSetEnableResponseWithJsonString:(BOOL) enable{
//    self.enableResponseWithJsonString=enable;
//}
//-(void) leSetServerHost:(NSString *) host{
//    self->serverHost=host;
//}
//-(void) leSetMD5Salt:(NSString *) salt{
//    self.md5Salt=salt;
//}
//-(void) leSetMessageDelegate:(id<LEAppMessageDelegate>) delegate{
//    self.messageDelegate=delegate;
//}
//static BOOL enableNetWorkAlert;
//static AFNetworkReachabilityStatus currentNetworkStatus;
//static LENetwork *theSharedInstance = nil;
//static NSUserDefaults *currentUserDefalts;
//static int networkCounter;
//- (int) getNetworkCounter{return ++networkCounter;}
//+ (instancetype) sharedInstance { @synchronized(self) { if (theSharedInstance == nil) {
//    theSharedInstance = [[self alloc] init];
//    currentUserDefalts = [NSUserDefaults standardUserDefaults];
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        currentNetworkStatus=status;
//        [NSTimer scheduledTimerWithTimeInterval:1 target:theSharedInstance selector:@selector(onEnableNetworkAlert) userInfo:nil repeats:NO];
//        if(enableNetWorkAlert){
//            switch (status) {
//                case AFNetworkReachabilityStatusNotReachable:{
//                    [[LENetwork sharedInstance] leOnShowAppMessageWith:@"当前网络不可用，请检查网络"];
//                    break;
//                }
//                    //                case AFNetworkReachabilityStatusReachableViaWiFi:{ break; }
//                    //                case AFNetworkReachabilityStatusReachableViaWWAN:{ break; }
//                default:
//                    break;
//            }
//        }
//    }];
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//} } return theSharedInstance; }
//-(NSString *) leGetServerHost{
//    if(self->serverHost)return self->serverHost;
//    return @"";
//}
//
//-(void) leOnShowAppMessageWith:(NSString *) message{
//    if(self.messageDelegate&&[self.messageDelegate respondsToSelector:@selector(leOnShowAppMessageWith:)]){
//        [self.messageDelegate leOnShowAppMessageWith:message];
//    }
//}
//- (void) onEnableNetworkAlert{ enableNetWorkAlert=YES; }
//
//- (LENetworkRequestObject *) leRequestWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter delegate:(id<LENetworkDelegate>)delegate{
//    return [self leRequestWithApi:api uri:uri httpHead:httpHead requestType:requestType parameter:parameter delegate:delegate Identification:nil];
//}
//
//- (LENetworkRequestObject *) leRequestWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter delegate:(id<LENetworkDelegate>)delegate Identification:(NSString *) identification{
//    return [self leRequestWithApi:api uri:uri httpHead:httpHead requestType:requestType parameter:parameter useCache:NO duration:0 delegate:delegate Identification:identification];
//}
//- (LENetworkRequestObject *) leRequestWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter useCache:(BOOL) useCache duration:(int) duration delegate:(id<LENetworkDelegate>)delegate{
//    return [self leRequestWithApi:api uri:uri httpHead:httpHead requestType:requestType parameter:parameter useCache:useCache duration:duration delegate:delegate Identification:nil];
//}
//- (LENetworkRequestObject *) leRequestWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter useCache:(BOOL) useCache duration:(int) duration delegate:(id<LENetworkDelegate>)delegate Identification:(NSString *) identification{
//    return [self leRequestWithApi:api uri:uri httpHead:httpHead requestType:requestType parameter:parameter useCache:useCache duration:duration delegate:delegate AutoRequest:YES Identification:identification];
//}
//- (LENetworkRequestObject *) leRequestWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) requestType parameter:(id) parameter useCache:(BOOL) useCache duration:(int) duration delegate:(id<LENetworkDelegate>)delegate  AutoRequest:(BOOL) autoRequest{
//    return [self leRequestWithApi:api uri:uri httpHead:httpHead requestType:requestType parameter:parameter useCache:useCache duration:duration delegate:delegate AutoRequest:autoRequest Identification:nil];
//}
//- (LENetworkRequestObject *) leRequestWithApi:(NSString *) api uri:(NSString *) uri httpHead:(NSDictionary *) httpHead requestType:(LERequestType) leRequestType parameter:(id) parameter useCache:(BOOL) useCache duration:(int) duration delegate:(id<LENetworkDelegate>)delegate  AutoRequest:(BOOL) autoRequest Identification:(NSString *) identification{
//    if(!afnetworkingCache){
//        afnetworkingCache=[[NSMutableDictionary alloc] init];
//    }
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    LENetworkSettings *settings=[[LENetworkSettings alloc] initWithApi:api uri:uri httpHead:httpHead requestType:leRequestType parameter:parameter useCache:useCache duration:duration delegate:delegate Identification:identification];
//    [settings leSetCreateTimeStamp:[LENetwork leGetTimeStamp]];
//    if(settings.leUseCache&&(leRequestType==LERequestTypeGet||leRequestType==LERequestTypeHead)){
//        LENetworkRequestObject *requestObject=[afnetworkingCache objectForKey:settings.leGetKey];
//        if(requestObject){
//            if(([LENetwork leGetTimeStamp]-requestObject.leAfnetworkingSettings.leCreateTimestamp-requestObject.leAfnetworkingSettings.leDuration)>0){
//                requestObject=nil;
//            }
//        }
//        if(requestObject){
//            settings=nil;
//            [requestObject.leAfnetworkingSettings leAddUniqueDelegate:delegate];
//            [NSTimer scheduledTimerWithTimeInterval:0.01 target:requestObject selector:@selector(returnCachedResponse) userInfo:nil repeats:NO];
//            return requestObject;
//        }else {
//            requestObject=[[LENetworkRequestObject alloc] initWithSettings:settings];
//            [requestObject leExecRequest:autoRequest];
//            LENetworkRequestObject *ori=[afnetworkingCache objectForKey:requestObject.leAfnetworkingSettings.leGetKey];
//            [afnetworkingCache setObject:requestObject forKey:requestObject.leAfnetworkingSettings.leGetKey];
//            ori=nil;
//            return requestObject;
//        }
//    }else{
//        LENetworkRequestObject *requestObject= [[LENetworkRequestObject alloc] initWithSettings:settings];
//        [requestObject leExecRequest:autoRequest];
//        return requestObject;
//    }
//}
//-(void) leRemoveDelegate:(id) delegate{
//    for (LENetworkRequestObject *requestObject in afnetworkingCache.allValues) {
//        if(requestObject&&requestObject.leAfnetworkingSettings){
//            for (NSInteger i=requestObject.leAfnetworkingSettings.leCurDelegateArray.count-1; i>=0; i--) {
//                id<LENetworkDelegate> delegate=[requestObject.leAfnetworkingSettings.leCurDelegateArray objectAtIndex:i];
//                if([delegate isEqual:delegate]){
//                    [requestObject.leAfnetworkingSettings.leCurDelegateArray removeObjectAtIndex:i];
//                }
//            }
//        }
//    }
//}
//-(void) leRemoveDelegateWithKey:(NSString *) key Value:(id) value{
//    LENetworkRequestObject *requestObject=[afnetworkingCache objectForKey:key];
//    if(requestObject){
//        if(requestObject&&requestObject.leAfnetworkingSettings){
//            for (NSInteger i=requestObject.leAfnetworkingSettings.leCurDelegateArray.count-1; i>=0; i--) {
//                id<LENetworkDelegate> delegate=[requestObject.leAfnetworkingSettings.leCurDelegateArray objectAtIndex:i];
//                if([delegate isEqual:delegate]){
//                    [requestObject.leAfnetworkingSettings.leCurDelegateArray removeObjectAtIndex:i];
//                }
//            }
//        }
//    }
//}
//- (void) leSave:(NSString *) value WithKey:(NSString *) key{
//    if(value&&key){
//        [currentUserDefalts setObject:value forKey:key];
//        [currentUserDefalts synchronize];
//    }
//}
//- (NSString *) leGetValueWithKey:(NSString *) key{
//    NSString *value=nil;
//    if(key){
//        value = [currentUserDefalts objectForKey:key];
//    }
//    return value;
//}
//
//- (NSDictionary *) leGetLocalCacheWithApi:(NSString *) api uri:(NSString *) uri parameter:(id) parameter{
//    NSString *key=[LENetworkSettings leGetKeyWithApi:api uri:uri parameter:parameter];
//    if(key){
//        NSString *json=[[LE_DataManager sharedInstanceOfStorage] leGetDataWithTable:LECacheTable Key:key];
//        if(json){
//            return [json leJSONValue];
//        }
//    }
//    return nil;
//}
//+ (int)leGetTimeStamp:(NSDate *)date {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy.MM.dd";
//    NSString *sdate = [formatter stringFromDate:date];
//    NSDate *ndate = [formatter dateFromString:sdate];
//    return (int)ndate.timeIntervalSince1970;
//}
//+ (int)leGetTimeStamp {
//    return [[NSDate date] timeIntervalSince1970];
//}
//+(NSString*) JSONStringWithDictionary:(NSDictionary *) dic {
//    NSMutableString *jsonString=[[NSMutableString alloc] initWithString:@""];
//    NSString *value=nil;
//    for (NSString *key in dic.allKeys) {
//        if(value){
//            if(jsonString.length>0){
//                [jsonString appendString:@","];
//            }
//        }
//        id obj=[dic objectForKey:key];
//        if([obj isKindOfClass:[NSDictionary class]]){
//            value=[LENetwork JSONStringWithDictionary:obj];
//            [jsonString appendFormat:@" \"%@\":%@", key, value];
//        }else if([obj isKindOfClass:[NSArray class]]){
//            value=[LENetwork JSONStringWithArray:obj];
//            [jsonString appendFormat:@" \"%@\":%@", key, value];
//        }else {
//            value=[NSString stringWithFormat:@"%@",obj];
//            value=[value stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//            value=[value stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
//            value=[value stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//            value=[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            [jsonString appendFormat:@" \"%@\":\"%@\"", key, value];
//        }
//    }
//    [jsonString insertString:@"{" atIndex:0];
//    [jsonString appendString:@"}"];
//    return jsonString;
//}
//+(NSString*) JSONStringWithArray:(NSArray *) array {
//    NSMutableString *jsonString=[[NSMutableString alloc] initWithString:@""];
//    for (int i=0; i<array.count; i++) {
//        id obj=[array objectAtIndex:i];
//        if([obj isKindOfClass:[NSDictionary class]]||[obj isKindOfClass:[NSMutableDictionary class]]){
//            if(jsonString.length>0){
//                [jsonString appendFormat:@",%@",[(NSDictionary *)obj leObjToJSONString]];
//            }else{
//                [jsonString appendString:[(NSDictionary *)obj leObjToJSONString]];
//            }
//        }else {
//            if(jsonString.length>0){
//                [jsonString appendFormat:@",\"%@\"",obj];
//            }else {
//                [jsonString appendFormat:@"\"%@\"",obj];
//            }
//        }
//    }
//    [jsonString insertString:@"[" atIndex:0];
//    [jsonString appendString:@"]"];
//    return jsonString;
//}
//+ (NSString *) leJSONStringWithObject:(id) obj{
//    NSString *jsonString = @"";
//    if([[[UIDevice currentDevice].name lowercaseString] rangeOfString:@"simulator"].location !=NSNotFound){
//        if([obj isKindOfClass:[NSDictionary class]]||[obj isMemberOfClass:[NSDictionary class]]){
//            jsonString = [self JSONStringWithDictionary:obj];
//        }else if([obj isKindOfClass:[NSArray class]]||[obj isMemberOfClass:[NSArray class]]){
//            jsonString = [self JSONStringWithArray:obj];
//        }
//    }else{
//        NSError *error=nil;
//        if([NSJSONSerialization isValidJSONObject:obj]){
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
//            if (jsonData) {
//                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            }
//        }
//    }
//    if(jsonString){
//        jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    }
//    return jsonString;
//}
//+ (NSString *) leMd5:(NSString *) str{
//    return [str leMd5WithSalt:[LENetwork sharedInstance].leMd5Salt?[LENetwork sharedInstance].leMd5Salt:@""];
//}
//+ (void) leDictionaryToEntity:(NSDictionary *)dict entity:(NSObject*)entity{
//    if (dict && entity) {
//        for (NSString *keyName in [dict allKeys]) {//构建出属性的set方法
//            NSString *destMethodName = [NSString stringWithFormat:@"set%@:",[keyName capitalizedString]]; //capitalizedString返回每个单词首字母大写的字符串（每个单词的其余字母转换为小写）
//            SEL destMethodSelector = NSSelectorFromString(destMethodName);
//            if ([entity respondsToSelector:destMethodSelector]) {
//                LESuppressPerformSelectorLeakWarning(
//                                                     [entity performSelector:destMethodSelector withObject:[dict objectForKey:keyName]];
//                                                     );
//            }
//        }
//    }
//}
//+ (NSDictionary *) leEntityToDictionary:(id)entity{
//    NSString *className=[NSString stringWithUTF8String:object_getClassName(entity)];
//    Class clazz =  NSClassFromString(className);
//    unsigned int count;
//    objc_property_t* properties = class_copyPropertyList(clazz, &count);
//    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
//    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i < count ; i++){
//        objc_property_t prop=properties[i];
//        const char* propertyName = property_getName(prop);
//        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
//        //      const char* attributeName = property_getAttributes(prop);
//        //      LELog(@"%@",[NSString stringWithUTF8String:propertyName]);
//        //      LELog(@"%@",[NSString stringWithUTF8String:attributeName]);
//        id value =nil;
//        LESuppressPerformSelectorLeakWarning(
//                                             value=[entity performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName])];
//                                             );
//        if(value ==nil){
//            [valueArray addObject:@""];
//        }else {
//            [valueArray addObject:value];
//        }
//    }
//    free(properties);
//    NSDictionary* returnDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
//    return returnDic;
//}
//@end

@implementation LEDataModel
-(id) initWithDataSource:(NSDictionary *) data {
    return [LEDataModel handleDataModelEngine:data withClass:[self class]];
}
+(NSMutableArray *) initWithDataSources:(NSArray *) dataArray ClassName:(NSString *) className{
    return [self initWithDataSources:dataArray ClassName:className Prefix:@""];
}
+(NSMutableArray *) initWithDataSources:(NSArray *) dataArray ClassName:(NSString *) className Prefix:(NSString *) prefix{
    className=[className stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[className substringToIndex:1] uppercaseString]];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    if(prefix&&prefix.length>0){
        className=[NSString stringWithFormat:@"%@_%@",prefix,className];
    }
    for (int i=0; i<dataArray.count; i++) {
        id obj=[[NSClassFromString(className) alloc] initWithDataSource:[dataArray objectAtIndex:i]];
        if(obj){
            [array addObject:obj];
        }
    }
    return array;
}
// 下面是数据模型转换的主要逻辑，来自于吴海超的WHC_DataModel，gitHub:https://github.com/netyouli
+ (NSString *)getClassNameString:(const char *)attr{
    NSString * strClassName = nil;
    NSString * attrStr = @(attr);
    NSRange  oneRange = [attrStr rangeOfString:@"T@\""];
    if(oneRange.location != NSNotFound){
        NSRange twoRange = [attrStr rangeOfString:@"\"" options:NSBackwardsSearch];
        if(twoRange.location != NSNotFound){
            NSRange  classRange = NSMakeRange(oneRange.location + oneRange.length, twoRange.location - (oneRange.location + oneRange.length));
            strClassName = [attrStr substringWithRange:classRange];
        }
    }
    return strClassName;
}

+ (BOOL)existproperty:(NSString *)property withObject:(NSObject *)object{
    unsigned int  propertyCount = 0;
    Ivar *vars = class_copyIvarList([object class], &propertyCount);
    for (NSInteger i = 0; i < propertyCount; i++) {
        Ivar var = vars[i];
        NSString * tempProperty = [[NSString stringWithUTF8String:ivar_getName(var)] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if([property isEqualToString:tempProperty]){
            return YES;
        }
    }
    propertyCount=0;
    vars = class_copyIvarList(class_getSuperclass([object class]), &propertyCount);
    for (NSInteger i = 0; i < propertyCount; i++) {
        Ivar var = vars[i];
        NSString * tempProperty = [[NSString stringWithUTF8String:ivar_getName(var)] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if([property isEqualToString:tempProperty]){
            return YES;
        }
    }
    return NO;
}

+ (Class)classExistProperty:(NSString *)property withObject:(NSObject *)object{
    Class  class = [NSNull class];
    BOOL found=NO;
    unsigned int  propertyCount = 0;
    Ivar *vars = class_copyIvarList([object class], &propertyCount);
    for (NSInteger i = 0; i < propertyCount; i++) {
        Ivar var = vars[i];
        NSString * tempProperty = [NSString stringWithUTF8String:ivar_getName(var)];//[[NSString stringWithUTF8String:ivar_getName(var)] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if([tempProperty hasPrefix:@"_"]){
            tempProperty=[tempProperty substringFromIndex:1];
        }
        if([property isEqualToString:tempProperty]){
            NSString * type = [NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
            if([type hasPrefix:@"@"]){
                type = [type stringByReplacingOccurrencesOfString:@"@" withString:@""];
                type = [type stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                class = NSClassFromString(type);
                found=YES;
                break;
            }
        }
    }
    free(vars);
    if(found){
        return class;
    }
    propertyCount=0;
    vars = class_copyIvarList(class_getSuperclass([object class]), &propertyCount);
    for (NSInteger i = 0; i < propertyCount; i++) {
        Ivar var = vars[i];
        NSString * tempProperty = [NSString stringWithUTF8String:ivar_getName(var)];//[[NSString stringWithUTF8String:ivar_getName(var)] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if([tempProperty hasPrefix:@"_"]){
            tempProperty=[tempProperty substringFromIndex:1];
        }
        if([property isEqualToString:tempProperty]){
            NSString * type = [NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
            if([type hasPrefix:@"@"]){
                type = [type stringByReplacingOccurrencesOfString:@"@" withString:@""];
                type = [type stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                class = NSClassFromString(type);
                found=YES;
                break;
            }
        }
    }
    free(vars);
    return class;
}
+ (id)handleDataModelEngine:(id)object withClass:(Class) class{
    if(object){
        LEDataModel *modelObject = [class new];
        if(modelObject){
            [modelObject setDataSource:object];
            if([object isKindOfClass:[NSDictionary class]]){
                NSDictionary  * dict = object;
                NSInteger       count = dict.count;
                NSArray       * keyArr = [dict allKeys];
                for (NSInteger i = 0; i < count; i++) {
                    id key=keyArr[i];
                    id subObject = dict[key];
                    if(subObject){
                        id propertyExistence=[LEDataModel classExistProperty:key withObject:modelObject];
                        //                                                NSLog(@"%@",propertyExistence);
                        if (propertyExistence == [NSString class]){
                            if([subObject isKindOfClass:[NSNull class]]){
                                [modelObject setValue:@"" forKey:key];
                            }else{
                                [modelObject setValue:subObject forKey:key];
                            }
                        }else if (propertyExistence == [NSNumber class]){
                            if([subObject isKindOfClass:[NSNull class]]){
                                [modelObject setValue:@(0) forKey:key];
                            }else{
                                if([subObject isKindOfClass:[NSString class]]){
                                    subObject=[[NSNumberFormatter new] numberFromString:subObject];
                                }
                                [modelObject setValue:subObject forKey:key];
                            }
                        }else if(propertyExistence == [NSDictionary class] || propertyExistence == [NSMutableDictionary class]){
                            if([subObject isKindOfClass:[NSNull class]]){
                                [modelObject setValue:@{} forKey:key];
                            }else{
                                NSString *subClassName=[key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[key substringToIndex:1] uppercaseString]];
                                subClassName=[NSString stringWithFormat:@"%@_%@", NSStringFromClass(class),subClassName];
                                id subModelObject=[LEDataModel handleDataModelEngine:subObject withClass:NSClassFromString(subClassName)];
                                [modelObject setValue:subModelObject forKey:key];
                            }
                        }else if (propertyExistence == [NSArray class] || propertyExistence == [NSMutableArray class]){
                            if([subObject isKindOfClass:[NSNull class]]){
                                [modelObject setValue:@[] forKey:key];
                            }else{
                                id subModelObject=[LEDataModel initWithDataSources:subObject ClassName:key Prefix:NSStringFromClass(class)];
                                [modelObject setValue:subModelObject forKey:key];
                            }
                        }else if(propertyExistence == [NSNull class]){
                            //                            NSLog(@"<<<<<%@ 缺少字段%@>>>>>",class,key);
                        }else if(subObject && ![subObject isKindOfClass:[NSNull class]]){
                            id subModelObject = [self handleDataModelEngine:subObject withClass:propertyExistence];
                            [modelObject setValue:subModelObject forKey:key];
                        }
                    }
                }
            }else if([object isKindOfClass:[NSString class]]){
                if(object){
                    return object;
                }else{
                    return @"";
                }
            }else if([object isKindOfClass:[NSNumber class]]){
                if(object){
                    return object;
                }else{
                    return @(0);
                }
            }
            return modelObject;
        }
    }
    return nil;
}
@end
