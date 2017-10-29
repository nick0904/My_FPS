//
//  UserManagerClass.m
//  ZMIApp
//
//  Created by Tom on 2016/4/25.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "UserManagerClass.h"

@implementation UserManagerClass

@synthesize MAN001,MAN002,MAN003,MAN004,MAN005,MAN006,MAN007,SYS001,SYS002,SYS003,SYS004;

-(id)init
{
    self=[super init];
    
    if(self)
    {
        [self openDatabase];
        
    }
    
    
    return self;
}

//初始化 管理者
- (id)initByAccount:(NSString*)account{
    
    if( self = [super init])
    {
        [self openDatabase];
        
        //查詢會員資料
        NSString *Command = [NSString stringWithFormat:@"SELECT MAN001,MAN002,MAN003,MAN004,MAN005,MAN006,MAN007,SYS001,SYS002,SYS003,SYS004 FROM USER_MANAGER WHERE MAN002 = '%@';",account];
        
 
        FMResultSet *rs = [database executeQuery:Command];//SELECT:指令：幾筆欄位
        
        if (rs.next)
        {
            
            MAN001 = [rs intForColumn:@"MAN001"]; //[[DataArray objectAtIndex:0] integerValue];
            MAN002 = [rs stringForColumn:@"MAN002"];//[DataArray objectAtIndex:1];
            MAN003 = [rs stringForColumn:@"MAN003"];//[DataArray objectAtIndex:2];
            MAN004 = [rs stringForColumn:@"MAN004"];//[DataArray objectAtIndex:3];
            MAN005 = [rs stringForColumn:@"MAN005"];//[DataArray objectAtIndex:4];
            MAN006 = [rs stringForColumn:@"MAN006"];//[DataArray objectAtIndex:5];
            MAN007 = [rs stringForColumn:@"MAN007"];//[DataArray objectAtIndex:6];
            
            SYS001 = [rs stringForColumn:@"SYS001"];//[DataArray objectAtIndex:7];
            SYS002 = [rs stringForColumn:@"SYS002"];//[DataArray objectAtIndex:8];
            SYS003 = [rs stringForColumn:@"SYS003"];//[DataArray objectAtIndex:9];
            SYS004 = [rs stringForColumn:@"SYS004"];//[DataArray objectAtIndex:10];
            
            //test
            NSLog(@"MAN001:%ld",(long)MAN001);
            NSLog(@"MAN002:%@",MAN002);
            NSLog(@"MAN003:%@",MAN003);
            NSLog(@"MAN004:%@",MAN004);
            NSLog(@"MAN005:%@",MAN005);
            NSLog(@"MAN006:%@",MAN006);
            NSLog(@"MAN007:%@",MAN007);

            
            NSLog(@"sys001:%@",SYS001);
            NSLog(@"sys002:%@",SYS002);
            NSLog(@"sys003:%@",SYS003);
            NSLog(@"sys004:%@",SYS004);
            
            
        }
    
    }
    return self;
}

//登入 帳號 密碼 檢查
-(BOOL)loginCheck:(NSString*)account Password:(NSString*)password
{

    
    //查詢會員資料
    NSString *Command = [NSString stringWithFormat:@"SELECT MAN001,MAN002,MAN003,MAN004,MAN005,MAN006,MAN007,SYS001,SYS002,SYS003,SYS004 FROM USER_MANAGER WHERE MAN004='1' and MAN002 = ? and MAN003 = ?;"];
    
    
    FMResultSet *rs = [database executeQuery:Command,account,password];
    
    
    if (rs.next)
    {
        
        MAN001 = [rs intForColumn:@"MAN001"]; //[[DataArray objectAtIndex:0] integerValue];
        MAN002 = [rs stringForColumn:@"MAN002"];//[DataArray objectAtIndex:1];
        MAN003 = [rs stringForColumn:@"MAN003"];//[DataArray objectAtIndex:2];
        MAN004 = [rs stringForColumn:@"MAN004"];//[DataArray objectAtIndex:3];
        MAN005 = [rs stringForColumn:@"MAN005"];//[DataArray objectAtIndex:4];
        MAN006 = [rs stringForColumn:@"MAN006"];//[DataArray objectAtIndex:5];
        MAN007 = [rs stringForColumn:@"MAN007"];//[DataArray objectAtIndex:6];
        
        SYS001 = [rs stringForColumn:@"SYS001"];//[DataArray objectAtIndex:7];
        SYS002 = [rs stringForColumn:@"SYS002"];//[DataArray objectAtIndex:8];
        SYS003 = [rs stringForColumn:@"SYS003"];//[DataArray objectAtIndex:9];
        SYS004 = [rs stringForColumn:@"SYS004"];//[DataArray objectAtIndex:10];
        
        //test
        NSLog(@"MAN001:%ld",(long)MAN001);
        NSLog(@"MAN002:%@",MAN002);
        NSLog(@"MAN003:%@",MAN003);
        NSLog(@"MAN004:%@",MAN004);
        NSLog(@"MAN005:%@",MAN005);
        NSLog(@"MAN006:%@",MAN006);
        NSLog(@"MAN007:%@",MAN007);
        
        
        NSLog(@"sys001:%@",SYS001);
        NSLog(@"sys002:%@",SYS002);
        NSLog(@"sys003:%@",SYS003);
        NSLog(@"sys004:%@",SYS004);
        
        return YES;
        
    }else{
        
        return NO;
    }
}

//新增 管理者 資料
- (void)AddNew:(UserManagerClass*)userManagerClass;
{
    NSString *SYS005=@"0";//雲端同步狀態碼 0:未上傳 1:已上傳 2:不上傳
    
    NSString *Command = [NSString stringWithFormat:@"INSERT INTO USER_MANAGER(MAN002,MAN003,MAN004,MAN007,SYS002,SYS004,SYS005) VALUES(?,?,?,?,?,?,?);"];
    
    [database executeUpdate:Command,userManagerClass.MAN002,userManagerClass.MAN003,userManagerClass.MAN004,userManagerClass.MAN007,userManagerClass.SYS002,userManagerClass.SYS004,SYS005];
    
}

//更新 不含設備
- (void)UpdatePassword
{
    NSString *SYS005=@"0";//雲端同步狀態碼 0:未上傳 1:已上傳 2:不上傳
    NSString *newSYS001=[self getAppNowDateTime];
    NSString *newSYS003=[self getCurrentUserAccount];
    
    
    NSString *Command = [NSString stringWithFormat:@"UPDATE USER_MANAGER SET MAN003=?,SYS001=?,SYS003=?,SYS005=? WHERE MAN001='%ld';",(long)MAN001];
    

    
    [database executeUpdate:Command,MAN003,newSYS001,newSYS003,SYS005];
}

//更新連線設備資訊
- (void)UpdateDeviceData
{
    NSString *SYS005=@"0";//雲端同步狀態碼 0:未上傳 1:已上傳 2:不上傳
    NSString *newSYS001=[self getAppNowDateTime];
    NSString *newSYS003=[self getCurrentUserAccount];
    
    
    NSString *Command = [NSString stringWithFormat:@"UPDATE USER_MANAGER SET MAN005='%@',MAN006='%@',SYS001='%@',SYS003='%@',SYS005='%@' WHERE MAN001='%ld';",MAN005,MAN006,newSYS001,newSYS003,SYS005,(long)MAN001];
    

    
    [database executeUpdate:Command];
}

//檢查帳號是否重複
-(BOOL)accountIsDuplicate:(NSString*)account
{
    //查詢會員資料
    NSString *Command = [NSString stringWithFormat:@"SELECT MAN002 FROM USER_MANAGER WHERE MAN002 = ?;"];
    
    FMResultSet *rs = [database executeQuery:Command,account];//SELECT:指令：幾筆欄位
    
    if(rs.next)
    {
        return YES;
        
    }else{
        
        return NO;
    }
}

@end
