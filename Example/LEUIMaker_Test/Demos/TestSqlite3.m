


//
//  TestSqlite3.m
//  LEUIMaker
//
//  Created by emerson larry on 2017/2/6.
//  Copyright © 2017年 LarryEmerson. All rights reserved.
//

#import "TestSqlite3.h" 

#define TableName @"tablename"
static int keyCounter=0;

@implementation TestSqlite3{
    LEConfigurableList *list;
}
-(void) leAdditionalInits{
    [[LEUICommon sharedInstance] leSetViewBGColor:LEColorBG9];
    LEView *view=[LEView new].leSuperViewcontroller(self);
    [LENavigation new].leSuperView(view).leTitle(@"测试TestSqlite3");
    view.leSubViewContainer.leBgColor(LEColorText9);
    list=[LEConfigurableListWithRefresh new].leSuperView(view.leSubViewContainer).leDelegate(self).leDataSource(self);
    list.backgroundColor=[LEUICommon sharedInstance].leViewBGColor;
    //
    NSMutableArray *curData=[NSMutableArray new];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Arrow],
                         LEConfigurableCellKey_Title:@"leReloadWithNewPath",
                         LEConfigurableCellKey_Function:@"leReloadWithNewPath"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Arrow],
                         LEConfigurableCellKey_Title:@"leCreateTable",
                         LEConfigurableCellKey_Function:@"leCreateTable"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Arrow],
                         LEConfigurableCellKey_Title:@"leInsertRecordToTable",
                         LEConfigurableCellKey_Function:@"leInsertRecordToTable"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Arrow],
                         LEConfigurableCellKey_Title:@"leSelectRecordsFromTable",
                         LEConfigurableCellKey_Function:@"leSelectRecordsFromTable"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Arrow],
                         LEConfigurableCellKey_Title:@"leBatchImportToTable",
                         LEConfigurableCellKey_Function:@"leBatchImportToTable"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Arrow],
                         LEConfigurableCellKey_Title:@"leClearTable",
                         LEConfigurableCellKey_Function:@"leClearTable"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Arrow],
                         LEConfigurableCellKey_Title:@"leRemoveTable",
                         LEConfigurableCellKey_Function:@"leRemoveTable"}];
    
    
    [list leOnRefreshedWithData:curData];
//    [LEDataManager sharedInstance];
}
//
-(void) leReloadWithNewPath{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%zd.db",LEIntToString(rand()%100)]];
    [LEHUD leShowHud:dbPath];
    LELogObject(dbPath)
    [[LEDataManager sharedInstance] leReloadWithNewPath:dbPath];
}
-(void) leCreateTable{
    [[LEDataManager sharedInstance] leCreateTable:TableName];
}
-(void) leInsertRecordToTable{
    NSString *value=LEIntToString(rand()%1000);
    LELogObject(value)
    [LEHUD leShowHud:value];
    [[LEDataManager sharedInstance] leInsertRecordToTable:TableName WithKey:LEIntToString(keyCounter++) Value:value];
}
-(void) leSelectRecordsFromTable{
    NSArray *result=[[LEDataManager sharedInstance] leSelectRecordsFromTable:TableName];
    LELogObject(result)
    [LEHUD leShowHud:[NSString stringWithFormat:@"%@", result]];
}
-(void) leBatchImportToTable{
    [[LEDataManager sharedInstance] leClearTable:TableName];
    NSMutableArray *muta=[NSMutableArray new];
    for (NSInteger i=0,j=1+rand()%5; i<j; i++) {
        [muta addObject:[NSString stringWithFormat:@"insert into %@ (key,value) values ('%@', '%@')",TableName,LEIntToString(keyCounter++),LEIntegerToString(i)]];
    }
    LELogObject(muta)
    [[LEDataManager sharedInstance] leBatchImportToTable:TableName WithData:muta];
}
-(void) leClearTable{
    [[LEDataManager sharedInstance] leClearTable:TableName];
}
-(void) leRemoveTable{
    [[LEDataManager sharedInstance] leRemoveTable:TableName];
}
-(void) leOnCellEventWithInfo:(NSDictionary *)info{ 
}
//
@end
