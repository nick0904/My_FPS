//
//  SystemClass.m
//  DataBase_Roca
//
//  Created by Kimi on 12/9/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SystemConfigClass.h"

@implementation SystemConfigClass

@synthesize CON001,CON002,CON003,CON004,CON005,CON006,CON007,CON008,CON009,CON010,SYS001,SYS002,SYS003,SYS004;


-(id)init
{
    self=[super init];
    
    if(self)
    {
        [self openDatabase];
        
    }
    
    
    return self;
}

//取得設定 by no
- (id)initWithPKNo:(int)pkNo{
    
    if( self = [super init])
	{
        //查詢會員資料
        NSString *Command = [NSString stringWithFormat:@"SELECT CON001,CON002,CON003,CON004,CON005,CON006,CON007,CON008,CON009,CON010,SYS001,SYS002,SYS003,SYS004 FROM SYS_CONFIG WHERE CON001 = %i;",pkNo];
        
        [self openDatabase];
        
        FMResultSet *rs=[database executeQuery:Command];
        
        while(rs.next)
        {

            
            //DataArray = [DataArray objectAtIndex:0];
            
            CON001 = [rs intForColumn:@"CON001"];
            CON002 = [rs stringForColumn:@"CON002"];
            CON003 = [rs stringForColumn:@"CON003"];
            CON004 = [rs stringForColumn:@"CON004"];
            CON005 = [rs stringForColumn:@"CON005"];
            CON006 = [rs stringForColumn:@"CON006"];
            CON007 = [rs stringForColumn:@"CON007"];
            CON008 = [rs stringForColumn:@"CON008"];
            CON009 = [rs stringForColumn:@"CON009"];
            CON010 = [rs stringForColumn:@"CON010"];
            
            SYS001 = [rs stringForColumn:@"SYS001"];
            SYS002 = [rs stringForColumn:@"SYS002"];
            SYS003 = [rs stringForColumn:@"SYS003"];
            SYS004 = [rs stringForColumn:@"SYS004"];
            
            //test
            NSLog(@"con001:%ld",(long)CON001);
            NSLog(@"con002:%@",CON002);
            NSLog(@"con003:%@",CON003);
            NSLog(@"con004:%@",CON004);
            NSLog(@"con005:%@",CON005);
            NSLog(@"con006:%@",CON006);
            NSLog(@"con007:%@",CON007);
            NSLog(@"con008:%@",CON008);
            NSLog(@"con009:%@",CON009);
            NSLog(@"con010:%@",CON009);
            
            NSLog(@"sys001:%@",SYS001);
            NSLog(@"sys002:%@",SYS002);
            NSLog(@"sys003:%@",SYS003);
            NSLog(@"sys004:%@",SYS004);
            
            
        }
         
        
        
	}
	return self;
}

//更新設定
- (void)UpdateThisData
{

    SYS001=[self getAppNowDateTime];
    SYS003=[self getCurrentUserAccount];
    
    NSString *SQLStr = [NSString stringWithFormat:@"UPDATE SYS_CONFIG SET CON002='%@',CON003='%@',CON004='%@',CON005='%@',CON006='%@',CON007='%@',CON008='%@',CON009='%@',CON010='%@',SYS001='%@',SYS003='%@' ;",CON002,CON003,CON004,CON005,CON006,CON007,CON008,CON009,CON010,SYS001,SYS003];//where CON001='%d'  ,CON001
    
    NSLog(@"%@",SQLStr);
    

    
    [database executeUpdate:SQLStr];
    
}


@end
