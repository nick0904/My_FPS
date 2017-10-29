//
//  GlobalSettings.h
//  WarGame
//
//  Created by Tom on 2014/4/17.
//  Copyright (c) 2014年 Tom. All rights reserved.
//
#import <Foundation/Foundation.h>

@class AppDelegate;
@class SystemConfigClass;
@class UserManagerClass;

@interface GlobalSettings : NSObject
{
}

//AppDelegate
@property(nonatomic, strong) AppDelegate *appDelegate;

//目前語系
@property(nonatomic, strong) NSString *curLanguageName;
//是否Demo mode
@property(nonatomic) BOOL isDemoMode;

//目前使用者 基本資訊
@property (strong, nonatomic) SystemConfigClass *systemConfigClass;
@property (strong, nonatomic) UserManagerClass *userManagerClass;


//是否已同意條款
@property(nonatomic) BOOL userIsAgred;


//Chanel Name
@property (strong, nonatomic) NSMutableArray *chanelNameArr;
@property (strong, nonatomic) NSMutableArray *activityNameArr;
@property (strong, nonatomic) NSMutableArray *chanelImageArr;

+ (GlobalSettings *)globalSettings;


@end
