//
//  ConfigMacroData.h
//  FPSApp
//
//  Created by Rex on 2016/8/10.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigMacroData : NSObject{
    
    NSUserDefaults *defaults;
    NSMutableDictionary *configDict;
    NSMutableArray *configArray;
    NSMutableArray *macroArray;
    BOOL BLEConnected;
    
    NSMutableDictionary *usingConfig;  //使用中的config
    
    //Rex
//    NSMutableArray *configImgArray;
    //
}
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPassword;
@property (nonatomic) BOOL logIn;
@property (nonatomic) BOOL rememberAcc;

+(ConfigMacroData*) sharedInstance;

-(void)setConfigArray:(NSMutableArray *)array;

-(NSMutableArray *)getConfigArray;
-(NSString *)getConfigName:(int)index;
-(NSMutableArray *)getConfigHotKeys;
-(void)moveConfigFrom:(int)from To:(int)to;
-(void)removeConfigIndex:(int)index;


-(void)setMacroArray:(NSMutableArray *)array;
-(NSMutableArray *)getMacroArray;
-(void)moveMacroFrom:(int)from To:(int)to;
-(void)removeMacroIndex:(int)index;


//Rex
-(void)saveConfigImage:(NSMutableDictionary *)imageDictionary Key:(NSString *)key;
-(NSMutableDictionary *)getConfigImageKey:(NSString *)key;
-(void)removeConfigImageKey:(NSString *)key;

-(void)changeBLEConnectedState:(ConnectState)state;

-(BOOL)BLEConnected;

-(void)saveUsingConfig:(NSMutableDictionary *)config;

-(NSMutableDictionary *)getUsingConfig;
/*
 configHotKey
 platform
 configName
 LEDColor
 flagADSToggle
 flagShootingSpeed
 flagInvertedYAxis
 flagSniperBreath
 flagAntiRecoil
 flagADSSync
 HIPSensitivity
 ADSSensitivity
 deadZONE
 sniperBreathHotKey
 antiRecoilHotkey
 antiRecoilOffsetValue
 shootingSpeed
 keyMapArray
 ballisticsArray
 */

@end
