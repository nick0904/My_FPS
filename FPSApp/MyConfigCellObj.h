//
//  MyConfigCellObj.h
//  FPSApp
//
//  Created by 曾偉亮 on 2016/9/22.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyConfigCellObj : NSObject

@property (strong, nonatomic) NSString *myConfig_date;//日期

@property (strong, nonatomic) NSString *myConfig_num;//流水編號

@property (strong, nonatomic) NSData *myConfig_gameIcon;//本機圖片

@property (strong, nonatomic) NSString *myConfig_platform;//機台種類

@property (strong, nonatomic) NSString *myConfig_like;//喜歡

@property (strong, nonatomic) NSString *myConfig_disLike;//不喜歡

@property (strong, nonatomic) NSString *myConfig_download;//下載次數

@property (strong, nonatomic) NSString *myConfig_title;//遊戲名稱

@property (strong, nonatomic) NSString *myConfig_editor;//傳送者

@property (strong, nonatomic) NSString *myConfig_content;//遊戲內容簡介

@property (strong, nonatomic) UIButton *myConfig_downloadBt;//下載按扭

@property (strong, nonatomic) UIButton *myConfig_sharedBt;//分享按鈕

@property (strong, nonatomic) UIButton *myConfig_withdrawBt;//收回分享按鈕

@property (strong, nonatomic) NSString *myConfig_url;//txt 檔的 url

/*
 status:
 0 -> 可shared (預設)
 1 -> 審查中
 2 -> 審查通過,可回收
 3 -> 被拒絕
*/
@property (strong, nonatomic) NSNumber *myConfig_status;//status

@end
