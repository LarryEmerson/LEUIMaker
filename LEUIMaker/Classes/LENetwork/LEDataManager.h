//
//  LEDataManager.h
//  Pods
//
//  Created by emerson larry on 2017/2/6.
//
//

#import <LEFoundation/LEFoundation.h>
#import <objc/runtime.h>
#import <AFNetworking/AFNetworking.h>
#import <FMDB/FMDB.h>



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
@property (nonatomic) id leDataBase;
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

@interface LEDataModel : NSObject
@property (nonatomic)          NSDictionary          * dataSource;
@property (nonatomic , strong) NSNumber              * id;
-(id) initWithDataSource:(NSDictionary *) data;
+(NSMutableArray *) initWithDataSources:(NSArray *) dataArray ClassName:(NSString *) className;
@end


@interface LEDataManager (FMDB)<LEDataManagerDelegate>
@end
