//
//  SharedConfigObj.h
//  FPSApp
//
//  Created by 曾偉亮 on 2016/9/22.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedConfigObj : NSObject

@property (strong, nonatomic) NSString *sharedConfig_date;//日期

@property (strong, nonatomic) NSString *sharedConfig_num;//流水編號

@property (strong, nonatomic) NSString *sharedConfig_platform;//機台種類

@property (strong, nonatomic) NSNumber *sharedConfig_like;//喜歡

@property (strong, nonatomic) NSNumber *sharedConfig_disLike;//不喜歡

@property (strong, nonatomic) NSNumber *sharedConfig_download;//下載次數

@property (strong, nonatomic) NSString *sharedConfig_title;//遊戲名稱

@property (strong, nonatomic) NSString *sharedConfig_editor;//傳送者

@property (strong, nonatomic) NSString *sharedConfig_content;//遊戲內容簡介

@property (strong, nonatomic) NSString *sharedConfig_url;//txt 檔的 url

@end
