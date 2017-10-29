//
//  UserManagerClass.h
//  ZMIApp
//
//  Created by Tom on 2016/4/25.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "DataBaseClass.h"

@interface UserManagerClass : DataBaseClass
{
    
}

@property (assign) NSInteger MAN001;
@property (nonatomic, strong) NSString *MAN002;
@property (nonatomic, strong) NSString *MAN003;
@property (nonatomic, strong) NSString *MAN004;
@property (nonatomic, strong) NSString *MAN005;
@property (nonatomic, strong) NSString *MAN006;
@property (nonatomic, strong) NSString *MAN007;

@property (nonatomic, strong) NSString *SYS001;
@property (nonatomic, strong) NSString *SYS002;
@property (nonatomic, strong) NSString *SYS003;
@property (nonatomic, strong) NSString *SYS004;

-(id)init;


//初始化 管理者
- (id)initByAccount:(NSString*)account;

//登入 帳號 密碼 檢查
-(BOOL)loginCheck:(NSString*)account Password:(NSString*)password;

//檢查帳號是否重複
-(BOOL)accountIsDuplicate:(NSString*)account;

//新增 管理者 資料
- (void)AddNew:(UserManagerClass*)userManagerClass;

//更新 不含設備
- (void)UpdatePassword;

//更新連線設備資訊
- (void)UpdateDeviceData;


@end
