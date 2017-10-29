//
//  SystemClass.h
//  DataBase_Roca
//
//  Created by Kimi on 12/9/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataBaseClass.h"

@interface SystemConfigClass : DataBaseClass
{

}


@property (assign) NSInteger CON001;
@property (nonatomic, strong) NSString *CON002;
@property (nonatomic, strong) NSString *CON003;
@property (nonatomic, strong) NSString *CON004;
@property (nonatomic, strong) NSString *CON005;
@property (nonatomic, strong) NSString *CON006;
@property (nonatomic, strong) NSString *CON007;
@property (nonatomic, strong) NSString *CON008;
@property (nonatomic, strong) NSString *CON009;
@property (nonatomic, strong) NSString *CON010;

@property (nonatomic, strong) NSString *SYS001;
@property (nonatomic, strong) NSString *SYS002;
@property (nonatomic, strong) NSString *SYS003;
@property (nonatomic, strong) NSString *SYS004;

-(id)init;
- (id)initWithPKNo:(int)pkNo;
- (void)UpdateThisData;

@end
