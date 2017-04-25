//
//  LEDataManager.m
//  Pods
//
//  Created by emerson larry on 2017/2/6.
//
//

#import "LEDataManager.h"

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

@implementation LEDataManager (FMDB)
-(void) leAdditionalInits{
    [self leSetDelegate:self];
    [self leEnableDebug:YES];
}
-(id) leInitDataBase{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"LEAPPSqlite.db"];
    self.leDataBase=[FMDatabase databaseWithPath:dbPath];
    return self.leDataBase;
}
-(id) leReloadWithNewPath:(NSString *) path LastDataBase:(id) dataBase{
    [(FMDatabase *)self.leDataBase close];
    self.leDataBase=[FMDatabase databaseWithPath:path];
    
    return self.leDataBase;
}
-(void) leOpen:(id) dataBase{
    [(FMDatabase *)dataBase open];
}
-(void) leClose:(id) dataBase{
    [(FMDatabase *)dataBase close];
}
-(void) leRunSql:(NSString *) sql DataBase:(id) dataBase{
    [(FMDatabase *)dataBase executeUpdate:sql];
}
-(void) leBatchSqls:(NSArray *) sqls DataBase:(id) dataBase{
    [(FMDatabase *)dataBase beginTransaction];
    for (int i=0; i<sqls.count; i++) {
        [(FMDatabase *)dataBase executeUpdate:[sqls objectAtIndex:i]];
        LELogObject([sqls objectAtIndex:i])
    }
    [(FMDatabase *)dataBase commit];
}
-(id) leSelect:(NSString *) sql OnlyFirstRecord:(BOOL) first DataBase:(id) dataBase{
    if(first){
        FMResultSet *rs = [(FMDatabase *)dataBase executeQuery:sql];
        NSDictionary *result = nil;
        if ([rs next]) {
            result = [rs resultDictionary];
        }
        [rs close];
        return [result objectForKey:@"value"];
    }else{
        NSMutableArray *result = [NSMutableArray new];
        FMResultSet *rs = [(FMDatabase *)dataBase executeQuery:sql];
        while([rs next]) {
            [result addObject:[rs resultDictionary]];
        }
        [rs close];
        return result;
    }
}
-(void) leClearDataBase:(id) dataBase{
    [(FMDatabase *)dataBase executeUpdate:@"drop select name from sqlite_master"];
    [(FMDatabase *)dataBase executeUpdate:@"DELETE FROM sqlite_sequence"];
}
@end
