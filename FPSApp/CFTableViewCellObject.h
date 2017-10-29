//
//  CFTableViewCellObject.h
//  FPSApp
//
//  Created by 曾偉亮 on 2016/6/29.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFTableViewCellObject : NSObject

/*
 configFileName:遊戲名稱
 configPlatformIcon:遊戲機台種類名稱
 configGameIcon:遊戲圖片名稱
 configLEDColor:遊戲顏色
 configHotKeyStr:熱鍵名稱
 */
@property (strong, nonatomic) NSString *configFileName;
@property (strong, nonatomic) NSString *configPlatformIcon;
@property (strong, nonatomic) NSString *configGameIcon;
@property (strong, nonatomic) NSString *configLEDColor;
@property (strong, nonatomic) NSString *configHotKeyStr;


/*
 mouse
 */
@property (strong, nonatomic) NSString *hipStr;
@property (strong, nonatomic) NSString *adsStr;
@property BOOL isSync;
@property BOOL isADStoggle;
@property (strong, nonatomic) NSString *deadZoneStr;
@property (strong , nonatomic) NSMutableArray <NSNumber *> *ballistics_Y_value;
@property (strong, nonatomic) NSMutableArray <NSString *> *ballistics_changed;



/*
 keyboard
 */
@property (strong , nonatomic) NSMutableArray <NSNumber *> *keyMap;//



/*
 preference
 */
@property BOOL isShootingSpeed;
@property (strong, nonatomic) NSString *shootingSpeedStr;
@property BOOL isInverted;
@property BOOL isSniperBreath;
@property (strong, nonatomic) NSString *sniperBreathHotkey;
@property BOOL isAntiRecoil;
@property (strong, nonatomic) NSString *antiRecoilHotkey;
@property (strong, nonatomic) NSString *antiRecoilStr;

@end
