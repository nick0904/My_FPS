//
//  DataBaseClass.h
//  DataBase
//
//  Created by Kimi on 12/9/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"


@interface DataBaseClass : NSObject
{
    FMDatabase *database;
}

- (BOOL)openDatabase;
- (void)closeDatabase;

- (id)initWithOpenDataBase;
- (NSString *)ArrayToString:(NSMutableArray *)Array;//
-(NSString*)getAppNowDateTime;//yyyyMMdd HH:mm:ss
-(NSString*)getCurrentUserAccount;



@end
