//
//  DataBaseClass.m
//  DataBase
//
//  Created by Kimi on 12/9/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataBaseClass.h"
#import "UserManagerClass.h"

@implementation DataBaseClass

- (id)initWithOpenDataBase{
    
    if( self = [super init])
    {
        
        [self openDatabase];
        
        //create table
        
        [self CREATE_SYS_CONFIG];
        [self CREATE_USER_MANAGER];
        [self CREATE_SONG_TEMP];
        [self CREATE_CHANELS];
        [self CREATE_EXP_KEYWORD];
        
    }
    return self;
    
}



#pragma mark - SQLite Methods

- (BOOL)openDatabase
{
   // if(!database) return YES;
    
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *databaseFilePath = [[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"FSDb201604.sqlite"];
    
    database = [[FMDatabase alloc] initWithPath:databaseFilePath];
    
    if ([database open])
    {
        NSLog(@"open sqlite db ok.");
        
        return true;
    }else{
        
        return false;
    }
    
}

- (void)closeDatabase
{
    if (database != NULL) {
        [database close];
        NSLog(@"close sqlite db ok.");
    }
}

- (void)createTable
{
    if (database != NULL) {
        /*
         if (![database executeUpdate:SQLCMD_CREATE_TABLE_DEVICE]) NSLog(@"Can not create table device");
         if (![database executeUpdate:SQLCMD_CREATE_TABLE_DEVICEHost]) NSLog(@"Can not create table device host");
         if (![database executeUpdate:SQLCMD_CREATE_TABLE_SNAPSHOT]) NSLog(@"Can not create table snapshot");
         if (![database executeUpdate:SQLCMD_CREATE_TABLE_REMOVELST]) NSLog(@"Can not create table removelist");
         
         if (![database executeUpdate:SQLCMD_CREATE_TABLE_SYSCONFIG])
         {
         NSLog(@"Can not create table sysconfig");
         
         }else{
         
         [database executeUpdate:@"INSERT INTO SYSCONFIG(CON001) VALUES(?)",
         @"1"];
         
         
         }
         */
        //add default value
        
        /* Edit here while table columns been modified */
        //if (![database columnExists:@"device" columnName:@""]) [database executeUpdate:@"ALTER TABLE device ADD COLUMN column-name column-type"];
    }
}

//創建資料表
//CREATE TABLE IF NOT EXISTS 資料表名稱( 欄位名稱1 數據型態 鍵值, 欄位名稱2 數據型態 鍵值,...)
/* -數據型態-----------------------------------------------------------------
 NULL:該值是一個NULL值
 INTEGER:該值是一個有正負的整數，由數據的大小決定存儲為1,2,3,4,6或8 bytes
 REAL:該值是一個浮點值，作為一個8 bytes浮點數存儲。
 TEXT:該值是一個文本字符串，使用（UTF-8，UTF-16BE或UTF-16LE）編碼存儲
 BLOB:存儲自定義的數據類型
 ------------------------------------------------------------------
 */


/*
 ------------------------------------------------------------------
 Table:SYS_CONFIG 系統設定資料表
 ------------------------------------------------------------------
 編號	CON001
 是否第一次登入	CON002
 CON003
 CON004
 CON005
 CON006
 CON007
 CON008
 CON009
 CON010
 
 
 備用欄位1	ATTRIBUTE1
 備用欄位2	ATTRIBUTE2
 備用欄位3	ATTRIBUTE3
 備用欄位4	ATTRIBUTE4
 備用欄位5	ATTRIBUTE5
 備用欄位6	ATTRIBUTE6
 備用欄位7	ATTRIBUTE7
 備用欄位8	ATTRIBUTE8
 備用欄位9	ATTRIBUTE9
 備用欄位10	ATTRIBUTE10
 
 異動日期	SYS001
 建立日期	SYS002
 異動者	SYS003
 建立者	SYS004
 
 ------------------------------------------------------------------
 */
- (void)CREATE_SYS_CONFIG{  //系統設定資料表
    
    NSString *SQLStr = @"CREATE TABLE SYS_CONFIG(CON001 INTEGER PRIMARY KEY AUTOINCREMENT,CON002 TEXT,CON003 TEXT,CON004 TEXT,CON005 TEXT,CON006 TEXT,CON007 TEXT,CON008 TEXT,CON009 TEXT,CON010 TEXT,ATTRIBUTE1 TEXT,ATTRIBUTE2 TEXT,ATTRIBUTE3 TEXT,ATTRIBUTE4 TEXT,ATTRIBUTE5 TEXT,ATTRIBUTE6 TEXT,ATTRIBUTE7 TEXT,ATTRIBUTE8 TEXT,ATTRIBUTE9 TEXT,ATTRIBUTE10 TEXT,SYS001 TEXT,SYS002 TEXT,SYS003 TEXT,SYS004 TEXT);";
    
    //建立資料表
    
    if (![database executeUpdate:SQLStr])
    {
    
        NSLog(@"Can not create table SYS_CONFIG");
        
    }else{
        NSLog(@"Init table SYS_CONFIG");
        [self INIT_SYS_CONFIG];
    }
    
    
}


/*
 ------------------------------------------------------------------
 Table:USER_MANAGER 管理者資料表
 ------------------------------------------------------------------
 編號	MAN001
 帳號	MAN002
 密碼	MAN003
 狀態碼	MAN004
 藍芽名稱	MAN005
 藍芽UUID	MAN006
 登入型態	MAN007
 
 備用欄位1	ATTRIBUTE1
 備用欄位2	ATTRIBUTE2
 備用欄位3	ATTRIBUTE3
 備用欄位4	ATTRIBUTE4
 備用欄位5	ATTRIBUTE5
 備用欄位6	ATTRIBUTE6
 備用欄位7	ATTRIBUTE7
 備用欄位8	ATTRIBUTE8
 備用欄位9	ATTRIBUTE9
 備用欄位10	ATTRIBUTE10
 異動日期	SYS001
 建立日期	SYS002
 異動者	SYS003
 建立者	SYS004
 雲端同步狀態碼	SYS005
 雲端同步日期	SYS006
 雲端編號	SYS007
 雲端同步日誌	SYS008
 
 
 ------------------------------------------------------------------
 */
- (void)CREATE_USER_MANAGER{  //管理者資料表
    
    NSString *SQLStr = @"CREATE TABLE USER_MANAGER(MAN001 INTEGER PRIMARY KEY AUTOINCREMENT,MAN002 TEXT NOT NULL,MAN003 TEXT NOT NULL,MAN004 TEXT NOT NULL,MAN005 TEXT,MAN006 TEXT,MAN007 TEXT NOT NULL,ATTRIBUTE1 TEXT,ATTRIBUTE2 TEXT,ATTRIBUTE3 TEXT,ATTRIBUTE4 TEXT,ATTRIBUTE5 TEXT,ATTRIBUTE6 TEXT,ATTRIBUTE7 TEXT,ATTRIBUTE8 TEXT,ATTRIBUTE9 TEXT,ATTRIBUTE10 TEXT,SYS001 TEXT,SYS002 TEXT,SYS003 TEXT,SYS004 TEXT,SYS005 TEXT,SYS006 TEXT,SYS007 TEXT,SYS008 TEXT);";
    //建立資料表
    
    if (![database executeUpdate:SQLStr])
    {
        NSLog(@"Can not create table USER_MANAGER");
        
    }else{
        
        NSString *SYS005=@"0";//雲端同步狀態碼 0:未上傳 1:已上傳 2:不上傳
        
        NSString *Command = [NSString stringWithFormat:@"INSERT INTO USER_MANAGER(MAN002,MAN003,MAN004,MAN007,SYS002,SYS004,SYS005) VALUES('%@','%@','%@','%@','%@','%@','%@');",@"demo@gmail.com",@"demo",@"1",@"0",[self getAppNowDateTime ],[self getCurrentUserAccount],SYS005];
        
        [database executeUpdate:Command];
        
        
    }
    
    
    
}


- (void)CREATE_EXP_KEYWORD{  //查詢關鍵字字庫
    
    NSString *SQLStr = @"CREATE TABLE EXP_KEYWORD(KEY001 integer(4) not null default (strftime('%s','now')),KEY002 TEXT,KEY003 TEXT,KEY004 TEXT,KEY005 TEXT,KEY006 TEXT);";
    
    //建立資料表
    
    if (![database executeUpdate:SQLStr])
    {
        NSLog(@"Can not create table EXP_KEYWORD");
        
        
        
    }
    
}


//= 創建資料表END ==================================================================================================================
//= 寫入資料表初始值 ===============================================================================================================
- (void)INIT_SYS_CONFIG{ //寫入系統設定資料表 初始值
    
    NSString *CON002=@"1"; //是否第一次登入 0:NO 1:YES
    
    NSString *CON003=@"";
    NSString *CON004=@"";
    
    NSString *CON005=@"";
    
    NSString *CON006=@"";
    NSString *CON007=@"";
    NSString *CON008=@"";
    NSString *CON009=@"";
    NSString *CON010=@"";
    
    NSString *SYS002=[self getAppNowDateTime];
    NSString *SYS004=[self getCurrentUserAccount];
    
    NSString *SQLStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO SYS_CONFIG(CON002,CON003,CON004,CON005,CON006,CON007,CON008,CON009,CON010,SYS002,SYS004) VALUES( '%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",CON002,CON003,CON004,CON005,CON006,CON007,CON008,CON009,CON010,SYS002,SYS004];
    
    [database executeUpdate:SQLStr];
    
}


- (void)CREATE_SONG_TEMP{  //暫存歌單
    
    NSString *SQLStr = @"CREATE TABLE SONG_TEMP(SONG001 INTEGER PRIMARY KEY AUTOINCREMENT,SONG002 TEXT NOT NULL,SONG003 TEXT NOT NULL,SONG004 TEXT,SONG005 TEXT,SONG006 TEXT,SONG007 TEXT,SONG008 TEXT,SONG009 TEXT,SONG010 TEXT,SONG011 TEXT,SONG012 TEXT,SONG013 TEXT,SONG014 TEXT,ATTRIBUTE1 TEXT,ATTRIBUTE2 TEXT,ATTRIBUTE3 TEXT,ATTRIBUTE4 TEXT,ATTRIBUTE5 TEXT,ATTRIBUTE6 TEXT,ATTRIBUTE7 TEXT,ATTRIBUTE8 TEXT,ATTRIBUTE9 TEXT,ATTRIBUTE10 TEXT,SYS001 TEXT,SYS002 TEXT,SYS003 TEXT,SYS004 TEXT,SYS005 TEXT,SYS006 TEXT,SYS007 TEXT,SYS008 TEXT);";
    //建立資料表
    
    if (![database executeUpdate:SQLStr]) NSLog(@"Can not create table SONG_TEMP");
    
}


- (void)CREATE_CHANELS{  //Chanel基本資料表
    
    NSString *SQLStr = @"CREATE TABLE CHANELS(CHAN001 INTEGER PRIMARY KEY AUTOINCREMENT,CHAN002 TEXT,CHAN003 TEXT,CHAN004 TEXT,CHAN005 TEXT,CHAN006 TEXT,CHAN007 TEXT,CHAN008 TEXT,CHAN009 INTEGER NOT NULL,ATTRIBUTE1 TEXT,ATTRIBUTE2 TEXT,ATTRIBUTE3 TEXT,ATTRIBUTE4 TEXT,ATTRIBUTE5 TEXT,ATTRIBUTE6 TEXT,ATTRIBUTE7 TEXT,ATTRIBUTE8 TEXT,ATTRIBUTE9 TEXT,ATTRIBUTE10 TEXT,SYS001 TEXT,SYS002 TEXT,SYS003 TEXT,SYS004 TEXT,SYS005 TEXT,SYS006 TEXT,SYS007 TEXT,SYS008 TEXT);";
    //建立資料表
    
    if (![database executeUpdate:SQLStr]){
        
        NSLog(@"Can not create table CHANELS");
        
        
        
    }else{
    
        //init
        
    }
    
}



//= 寫入資料表END ===================================================================================================================

- (NSString *)ArrayToString:(NSMutableArray *)Array{
    NSString *Str = @"";
    
    for (int i = 0; i < Array.count; i++)
    {
        if ( i == 0 )
            Str = [NSString stringWithFormat:@"%@",[Array objectAtIndex:i]];
        else
            Str = [NSString stringWithFormat:@"%@,%@",Str,[Array objectAtIndex:i]];
    }
    
    return Str;
}


-(NSString*)getAppNowDateTime
{
    return [ShareCommon DateToStringByFormate:[NSDate date] formate:@"yyyyMMdd HH:mm:ss"];
}

-(NSString*)getCurrentUserAccount
{
    NSString *root=@"";

    if([GlobalSettings globalSettings].userManagerClass!=NULL)
    {
        if([GlobalSettings globalSettings].userManagerClass.MAN002!=NULL)
        {
           root=[GlobalSettings globalSettings].userManagerClass.MAN002;
        }
    }
  
    return root;
    
}


@end
