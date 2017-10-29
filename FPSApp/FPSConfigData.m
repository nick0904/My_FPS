//
//  ConfigData.m
//  IdeabusSDK_FuelPlus
//
//  Created by 點睛 on 2016/7/20.
//  Copyright © 2016年 Ting. All rights reserved.
//


#import "FPSConfigData.h"

 
@implementation FPSConfigData


    NSInteger liveModeFieldToPacketNumTable[21] ={0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,4,5,6,7,8};


  int configHotKey = 0xFF;
  int platform = 0x00;
  int LEDColor = 0;
  bool  funcFlag_ADSToggle = false;
  bool  funcFlag_shootingSpeed = false;
  bool  funcFlag_invertedYAxis = false;
  bool  funcFlag_sniperBreath = false;
  bool  funcFlag_antiRecoil = false;
  bool  funcFlag_ADSSync = false;

  int HIPSensitivity = 0;
  int ADSSensitivity = 0;
  int DeadZONE = 0;
  int sniperBreathHotKey = 0xFF;
  int sniperBreathMapkey = 0xFF;//?????
  int antiRecoilHotkey = 0xFF;
  int antiRecoilOffsetValue= 0;
  int shootingSpeed = 0;//16 bits


-(void)initParam{
    configName= [[NSMutableString alloc] init];
    keyMapArray = [NSMutableArray arrayWithCapacity:  CONFIG_KEY_MAP_LENGTH];
    [self fillArrayByZero:keyMapArray : CONFIG_KEY_MAP_LENGTH];
   
    ballistics = [NSMutableArray arrayWithCapacity:CONFIG_BALLISTICS_LENGTH];
    [self fillArrayByZero:ballistics :CONFIG_BALLISTICS_LENGTH];
    
    
    
    ballisticsChanged = [NSMutableArray arrayWithCapacity:CONFIG_BALLISTICS_LENGTH];
    [self fillArrayByZero:ballisticsChanged :CONFIG_BALLISTICS_LENGTH];
    
    
}

-(void) fillArrayByZero:(NSMutableArray*) arr  :(int)num{
    for(int i=0; i< num; i++){
        [arr addObject:[NSNumber numberWithInt:0]];
    }
    
}


//--------------------------------
- (int) getConfigHotKey {
    return configHotKey;
}

- (void) setConfigHotKey:(int) configHotKey2 {
     configHotKey = configHotKey2;
}

- (int) getPlatform {
    return platform;
}

/**
 *
 * @param platform  CONFIGdATA.PLATFORM_PS3 ，CONFIGdATA.PLATFORM_PS4  ...
 */
- (void) setPlatform:(int) platform2 {
     platform = platform2;
}

-(NSMutableString*) getConfigName {
    return [configName mutableCopy];
}

- (void) setConfigName:(NSMutableString*) configName2 {
     configName = [configName2 mutableCopy];
}

-( int) getLEDColor {
    return LEDColor;
}

- (void) setLEDColor:(int) LEDColor2 {
     LEDColor = LEDColor2;
}

-( bool) isFuncFlag_ADSToggle {
    return funcFlag_ADSToggle;
}

- (void) setFuncFlag_ADSToggle:(bool) funcFlag_ADSToggle2 {
     funcFlag_ADSToggle = funcFlag_ADSToggle2;
}

- (bool) isFuncFlag_shootingSpeed {
    return funcFlag_shootingSpeed;
}

-( void) setFuncFlag_shootingSpeed:(bool) funcFlag_shootingSpeed2 {
     funcFlag_shootingSpeed = funcFlag_shootingSpeed2;
}

- (bool) isFuncFlag_invertedYAxis {
    return funcFlag_invertedYAxis;
}

- (void) setFuncFlag_invertedYAxis:(bool) funcFlag_invertedYAxis2 {
     funcFlag_invertedYAxis = funcFlag_invertedYAxis2;
}

- (bool) isFuncFlag_sniperBreath {
    return funcFlag_sniperBreath;
}

- (void) setFuncFlag_sniperBreath:(bool) funcFlag_sniperBreath2 {
     funcFlag_sniperBreath = funcFlag_sniperBreath2;
}

- (bool) isFuncFlag_antiRecoil {
    return funcFlag_antiRecoil;
}

- (void) setFuncFlag_antiRecoil:(bool) funcFlag_antiRecoil2 {
     funcFlag_antiRecoil = funcFlag_antiRecoil2;
}

- (bool) isFuncFlag_ADSSync {
    return funcFlag_ADSSync;
}

- (void) setFuncFlag_ADSSync:(bool) funcFlag_ADSSync2 {
    funcFlag_ADSSync = funcFlag_ADSSync2;
}



- (int) getHIPSensitivity {
    return HIPSensitivity;
}

- (void) setHIPSensitivity:(int) HIPSensitivity2 {
     HIPSensitivity = HIPSensitivity2;
}

- (int) getADSSensitivity {
    return ADSSensitivity;
}

- (void) setADSSensitivity:(int) ADSSensitivity2 {
     ADSSensitivity = ADSSensitivity2;
}

- (int) getDeadZONE {
    return DeadZONE;
}

- (void) setDeadZONE:(int) deadZONE2 {
    DeadZONE = deadZONE2;
}

- (int) getSniperBreathHotKey {
    return sniperBreathHotKey;
}

- (void) setSniperBreathHotKey:(int) sniperBreathHotKey2 {
     sniperBreathHotKey = sniperBreathHotKey2;
}

- (int) getSniperBreathMapkey {
    return sniperBreathMapkey;
}

- (void) setSniperBreathMapkey:(int) sniperBreathMapkey2 {
     sniperBreathMapkey = sniperBreathMapkey2;
}

- (int) getAntiRecoilHotkey {
    return antiRecoilHotkey;
}

- (void) setAntiRecoilHotkey:(int) antiRecoilHotkey2 {
     antiRecoilHotkey = antiRecoilHotkey2;
}

- (int) getAntiRecoilOffsetValue {
    return antiRecoilOffsetValue;
}

- (void) setAntiRecoilOffsetValue:(int) antiRecoilOffsetValue2 {
     antiRecoilOffsetValue = antiRecoilOffsetValue2;
}

- (int) getShootingSpeed {
    return shootingSpeed;
}

- (void) setShootingSpeed:(int) shootingSpeed2 {
     shootingSpeed = shootingSpeed2;
}

- (NSArray*) getKeyMapArray {
    return keyMapArray;
}

- (void) setKeyMapArray:(NSMutableArray*) keyMapArr2 {
     keyMapArray = [keyMapArr2 mutableCopy];
}


- (NSArray*) getBallistics {
    
    return ballistics;
}
- (void) setBallistics:(NSMutableArray*) ballistics2 {
    
    ballistics = [ballistics2 mutableCopy];
}


- (NSArray*) getBallisticsChanged {
    
    return ballisticsChanged;
}

- (void) setBallisticsChanged:(NSMutableArray*) ballisticChanged2 {
    
    ballisticsChanged = [ballisticChanged2 mutableCopy];
}

 

//configName 轉16進制參考
- (NSString*) toHexString {
    NSMutableString* hexStr = [[NSMutableString alloc] init];// new StringBuffer();
    [hexStr appendString:[NSString stringWithFormat:@"%02X", configHotKey]];
    [hexStr appendString:[NSString stringWithFormat:@"%02X", platform]];
    
    NSMutableString* configNameHexStr = [[NSMutableString alloc] init];
    int len =   [configName length];
    for (int i = 0; i < CONFIG_NAME_LENGTH; i++) {
        if(i < len){
            int ch = [configName characterAtIndex:i];
             //BaseGlobal.printLog("d", TAG, " keyMapArray  hex str = " + kmHexStr);
            
            //int ch = (int)this.configName[i];
            [configNameHexStr appendString:[NSString stringWithFormat: @"%04X", ch]];
        }
        else{
            [configNameHexStr appendString: [NSString stringWithFormat: @"FFFF"]];
        }
        
    }
    
   // BaseGlobal.printLog("d", TAG, " config name hex str = " + configNameHexStr);
    [hexStr appendString: configNameHexStr];//config name
    
    [hexStr appendString: [NSString stringWithFormat: @"%02X", LEDColor]];
    
    int flag = 0x00;
    flag = ( funcFlag_ADSToggle)?  flag | 0x01 : flag;
    flag = ( funcFlag_shootingSpeed)?  flag | 0x02 : flag;
    flag = ( funcFlag_invertedYAxis)?  flag | 0x04 : flag;
    flag = ( funcFlag_sniperBreath)?  flag | 0x08 : flag;
    flag = ( funcFlag_antiRecoil)?  flag | 0x10 : flag;
    flag = ( funcFlag_ADSSync)?  flag | 0x20 : flag;
    
    
    [hexStr appendString:[NSString stringWithFormat: @"%02X", flag]] ;
    
    [hexStr appendString:[NSString stringWithFormat: @"%02X", HIPSensitivity]] ;
    [hexStr appendString:[NSString stringWithFormat: @"%02X", ADSSensitivity]] ;
    [hexStr appendString:[NSString stringWithFormat: @"%02X", DeadZONE]] ;
    [hexStr appendString:[NSString stringWithFormat: @"%02X", sniperBreathHotKey]] ;
    [hexStr appendString:[NSString stringWithFormat: @"%02X", sniperBreathMapkey]] ;
    [hexStr appendString:[NSString stringWithFormat: @"%02X", antiRecoilHotkey]] ;
    [hexStr appendString:[NSString stringWithFormat: @"%02X", antiRecoilOffsetValue]] ;

 
    //todo 指令欄位有問題，和規格文件設定不同
    //        hexStr.append(Integer.toHexString(this.shootingSpeed));
    //hexStr.append("0124");
    [hexStr appendString:[NSString stringWithFormat: @"%04X", shootingSpeed]];
    
    
    // keyMapArray
     NSMutableString* kmHexStr = [[NSMutableString alloc] init];
    
    int keylen = [keyMapArray count];
    for (int i = 0; i < keylen; i++) {
        
       // NSLog([NSString stringWithFormat:@"keymap: %d",  [((NSNumber*)[keyMapArray objectAtIndex:i]) intValue] ] );
        
        NSString* k = [NSString stringWithFormat: @"%02X", [((NSNumber*)[keyMapArray objectAtIndex:i]) intValue]];
//        NSLog(k);
        [kmHexStr appendString:k ];
    }
    //BaseGlobal.printLog("d", TAG, " keyMapArray  hex str = " + kmHexStr);
    [hexStr appendString: kmHexStr];
    
    //ballistics
    NSMutableString* ballisticsHexStr = [[NSMutableString alloc] init];
         
    int blen =  [ballistics count];
    for (int i = 0; i < blen; i++) {
        
          NSString* k = [NSString stringWithFormat: @"%02X",
                         [((NSNumber*)[ballistics objectAtIndex:i]) intValue]];
       
        
        [ballisticsHexStr appendString: k];
    }
    
    [hexStr appendString: ballisticsHexStr];
    
    
    long ballint = 0;
    NSUInteger blen2 =  [ballistics count];
    for (int i = 0; i < blen2; i++) {
        

        if ( [[ballisticsChanged objectAtIndex:i] intValue] == 1   ) {
            ballint = ballint | (0x1 << i);
        }
    }
    
    [hexStr appendString: [NSString stringWithFormat: @"%06lX", ballint]];
    
    return  hexStr ;
     
}
 

/**
 *   for  live mode  cmd
 *
 * @param changeFieldID
 * @return
 */
-( NSString*) toHexString:(int) changeFieldID {
    
    int changedPacketNum = [self getChangedFieldPacketNum: changeFieldID];
    
    NSLog(@"changedPacketNum: %d", changedPacketNum);
    return [self toHexStringImp: changedPacketNum ];
    
}

//int 16進制參考
-(NSString*) toHexStringImp:(int ) changedPacketNum {
    
    NSMutableString* hexStr = [[NSMutableString alloc] init];
    
    if(changedPacketNum == 0)
    {
        [hexStr appendString: [NSString stringWithFormat: @"%02X", LEDColor]];
        //(fillPreZero(Integer.toHexString(this.LEDColor)));
        
        int flag = 0x00;
        flag = (funcFlag_ADSToggle)?  flag | 0x01 : flag;
        flag = (funcFlag_shootingSpeed)?  flag | 0x02 : flag;
        flag = (funcFlag_invertedYAxis)?  flag | 0x04 : flag;
        flag = (funcFlag_sniperBreath)?  flag | 0x08 : flag;
        flag = (funcFlag_antiRecoil)?  flag | 0x10 : flag;
        flag = (funcFlag_ADSSync)?  flag | 0x20 : flag;
        
        [hexStr appendString: [NSString stringWithFormat: @"%02X", flag]];
        //(fillPreZero(Integer.toHexString(flag)));
        
         [hexStr appendString: [NSString stringWithFormat: @"%02X", HIPSensitivity]];
         [hexStr appendString: [NSString stringWithFormat: @"%02X", ADSSensitivity]];
         [hexStr appendString: [NSString stringWithFormat: @"%02X", DeadZONE]];
         [hexStr appendString: [NSString stringWithFormat: @"%02X", sniperBreathHotKey]];
         [hexStr appendString: [NSString stringWithFormat: @"%02X", sniperBreathMapkey]];
         [hexStr appendString: [NSString stringWithFormat: @"%02X", antiRecoilHotkey]];
         [hexStr appendString: [NSString stringWithFormat: @"%02X", antiRecoilOffsetValue]];
        
        
        NSLog(@"hexStr: %@", hexStr);

        //todo 指令欄位有問題，和規格文件設定不同
        //            hexStr.append(Integer.toHexString(this.shootingSpeed));
        //hexStr.append("0124");
        [hexStr appendString:[NSString stringWithFormat: @"%04X", shootingSpeed]] ;
        
        
        // keyMapArray   0~4
         NSMutableString* kmHexStr = [[NSMutableString alloc] init];
       // StringBuffer kmHexStr = new StringBuffer();
        int keylen =   [keyMapArray count];
        for (int i = 0; i <= 4; i++) {
            
        NSString* k = [NSString stringWithFormat: @"%02X", [((NSNumber*)[keyMapArray objectAtIndex:i]) intValue]];
            [kmHexStr appendString:k ];
        }
        //BaseGlobal.printLog("d", TAG, " keyMapArray  hex str = " + kmHexStr);
        
        [hexStr appendString: kmHexStr];
        
        return hexStr ;
    }
    
    if(changedPacketNum ==1){
        // keyMapArray   5~20
        
        NSMutableString* kmHexStr = [[NSMutableString alloc] init];
        // StringBuffer kmHexStr = new StringBuffer();
        int keylen =   [keyMapArray count];
        for (int i = 5; i <= 20; i++) {
          NSString* k = [NSString stringWithFormat: @"%02X",[((NSNumber*)[keyMapArray objectAtIndex:i]) intValue]];
            [kmHexStr appendString:k ];
        }
        //BaseGlobal.printLog("d", TAG, " keyMapArray  hex str = " + kmHexStr);
        
        [hexStr appendString: kmHexStr];
        
        return hexStr ;
        
      
    }
    
    
    if(changedPacketNum == 2){
        // keyMapArray   21
        
        NSMutableString* kmHexStr = [[NSMutableString alloc] init];
        // StringBuffer kmHexStr = new StringBuffer();
        int keylen =   [keyMapArray count];
        for (int i = 21; i <= 21; i++) {
            NSString* k = [NSString stringWithFormat: @"%02X", [((NSNumber*)[keyMapArray objectAtIndex:i]) intValue] ];//
            [kmHexStr appendString:k ];
        }
        //BaseGlobal.printLog("d", TAG, " keyMapArray  hex str = " + kmHexStr);
        
        [hexStr appendString: kmHexStr];
        
      
        
        //ballistics  0~14
        
        NSMutableString* ballisticsHexStr = [[NSMutableString alloc] init];
        
        int blen =  [ballistics count];
        for (int i = 0; i <= 14; i++) {
            NSString* k = [NSString stringWithFormat: @"%02X", [((NSNumber*)[ballistics objectAtIndex:i]) intValue]];
           
            [ballisticsHexStr appendString: k];
        }
        //BaseGlobal.printLog("d", TAG, " ballistics  hex str = " + ballisticsHexStr);
        [hexStr appendString: ballisticsHexStr];
 
        return hexStr  ;
    }
    
    if(changedPacketNum == 3){
        //ballistics  15~19
        
        NSMutableString* ballisticsHexStr = [[NSMutableString alloc] init];
        
        int blen =  [ballistics count];
        for (int i = 15; i <= 19; i++) {
            NSString* k = [NSString stringWithFormat: @"%02X", [((NSNumber*)[ballistics objectAtIndex:i]) intValue]];
            
            [ballisticsHexStr appendString: k];
        }
        //BaseGlobal.printLog("d", TAG, " ballistics  hex str = " + ballisticsHexStr);
        [hexStr appendString: ballisticsHexStr];
        
        return hexStr  ;
        
      
    }
    
    //BaseGlobal.printLog("d", TAG, " changedPacketNum= " + changedPacketNum);
    return @"";
}

-( int) getChangedFieldPacketNum:(int) changeFieldID {
    int cpn;
    if(changeFieldID ==  CHANGE_FUNCFLAG_ADS_TOGGLE |
       changeFieldID ==  CHANGE_FUNCFLAG_ANTI_RECOIL |
       changeFieldID ==  CHANGE_FUNCFLAG_INVERTED_Y_AXIS |
       changeFieldID ==  CHANGE_FUNCFLAG_SHOOTING_SPEED |
       changeFieldID ==  CHANGE_FUNCFLAG_SNIPER_BREATH   |
       changeFieldID ==  CHANGE_FUNCFLAG_ADS_SYNC
       )
    {
        //            cpn = liveModeFieldToPacketNumTableForFuncFlag[changeFieldID%100];
        cpn = 0;
    }
    else
    {
        cpn = liveModeFieldToPacketNumTable[changeFieldID];
    }
    
    return cpn;
}


-( void) importHexString:(NSString*) hexStr {
    configHotKey =  [self hexStringToInt: [hexStr substringToIndex:2]];
    
    
    hexStr = [hexStr substringFromIndex: 2];
    platform =  [self hexStringToInt: [hexStr substringToIndex:2]];
    
    hexStr = [hexStr substringFromIndex: 2];
    
    NSString* name = [hexStr substringToIndex:CONFIG_NAME_LENGTH*2 *2]; // unicode *2,  hex str *2
    for(int i=0; i< CONFIG_NAME_LENGTH; i++){
        NSString* ch = [name substringWithRange:NSMakeRange(i*4, 4)];
        if(![ch isEqualToString:@"FFFF"]){
            
            int c = [self hexStringToInt:ch];
              [configName appendString:[NSString stringWithCharacters:(unichar *)&c length:1] ];
            
            //[configName appendString:[NSString stringWithFormat:@"%C", c] ];
        }
    }
      
    
    hexStr = [hexStr substringFromIndex: CONFIG_NAME_LENGTH*2 *2]; // unicode *2,  hex str *2
     LEDColor =  [self hexStringToInt: [hexStr substringToIndex:2]];

    hexStr = [hexStr substringFromIndex: 2];


    //config flag
    int   flag =  [self hexStringToInt: [hexStr substringToIndex:2]];
     funcFlag_ADSToggle = (flag & 1) == 1;
     funcFlag_shootingSpeed = (flag  & 2) == 2;
     funcFlag_invertedYAxis = (flag & 4) == 4;
     funcFlag_sniperBreath = (flag & 8) == 8;
     funcFlag_antiRecoil = (flag & 16) == 16;
     funcFlag_ADSSync = (flag & 32) == 32;
    
    hexStr = [hexStr substringFromIndex: 2];

    
  //  HIPSensitivity =  (unsigned int)strtoul([[hexStr substringToIndex:2] UTF8String], 0, 16);
     HIPSensitivity =  [self hexStringToInt: [hexStr substringToIndex:2]];
    
    hexStr = [hexStr substringFromIndex: 2];

    
    ADSSensitivity =  [self hexStringToInt: [hexStr substringToIndex:2]];
  //  ADSSensitivity =  (unsigned int)strtoul([[hexStr substringToIndex:2] UTF8String], 0, 16);
    hexStr = [hexStr substringFromIndex: 2];
    
    DeadZONE =  [self hexStringToInt: [hexStr substringToIndex:2]];

  //  DeadZONE =  (unsigned int)strtoul([[hexStr substringToIndex:2] UTF8String], 0, 16);
    hexStr = [hexStr substringFromIndex: 2];
    
    //sniperBreathHotKey =  (unsigned int)strtoul([[hexStr substringToIndex:2] UTF8String], 0, 16);
     sniperBreathHotKey =  [self hexStringToInt: [hexStr substringToIndex:2]];
    hexStr = [hexStr substringFromIndex: 2];
    
    //sniperBreathMapkey =  (unsigned int)strtoul([[hexStr substringToIndex:2] UTF8String], 0, 16);
     sniperBreathMapkey =  [self hexStringToInt: [hexStr substringToIndex:2]];
    hexStr = [hexStr substringFromIndex: 2];
    
    //antiRecoilHotkey =  (unsigned int)strtoul([[hexStr substringToIndex:2] UTF8String], 0, 16);
     antiRecoilHotkey =  [self hexStringToInt: [hexStr substringToIndex:2]];
    hexStr = [hexStr substringFromIndex: 2];
    
   // antiRecoilOffsetValue =  (unsigned int)strtoul([[hexStr substringToIndex:2] UTF8String], 0, 16);
     antiRecoilOffsetValue =  [self hexStringToInt: [hexStr substringToIndex:2]];
    hexStr = [hexStr substringFromIndex: 2];
    
   // shootingSpeed =  (unsigned int)strtoul([[hexStr substringToIndex:4] UTF8String], 0, 16);
     shootingSpeed =  [self hexStringToInt: [hexStr substringToIndex:4]];
    hexStr = [hexStr substringFromIndex: 4];
    
    
    
    for (int i = 0; i < CONFIG_KEY_MAP_LENGTH; i++) {
        //int key = Integer.parseInt(hexStr.substring(0,2),16);
        //int key = (unsigned int)strtoul([[hexStr substringToIndex:2] UTF8String], 0, 16);
        int key = [self hexStringToInt: [hexStr substringToIndex:2]];
        [keyMapArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:key] ];
        
        hexStr = [hexStr substringFromIndex: 2];
    }
    
    for (int i = 0; i < CONFIG_BALLISTICS_LENGTH; i++) {
        int Y = [self hexStringToInt: [hexStr substringToIndex:2]];
        [ballistics replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:Y] ];
    
         hexStr = [hexStr substringFromIndex: 2];
    }
    
    
    //ballistics  Changed  point
    int  CONFIG_BALLISTICS_CHANGED_LENGTH = 3; //byte
    int ballist = [self hexStringToInt: [hexStr substringToIndex:CONFIG_BALLISTICS_CHANGED_LENGTH *2]];
    
    for (int i = 0; i < CONFIG_BALLISTICS_LENGTH; i++) {
        [ballisticsChanged replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:(( ballist >> i) & 0x1)] ];
    
    }
    
}

- (int)hexStringToInt:(NSString *)hexString{
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    //    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&result];
    return result;
}


-(NSString*)toString{
    return [NSString stringWithFormat:@"name: %@  adssync: %d  keymap:%@ ballist:%@  ballist changed: %@",
            configName,  funcFlag_ADSSync,  [keyMapArray description], [ballistics description ], [ballisticsChanged description] ];
}

-( bool) isAll_FF:(NSString*) dataHexStr {
    
    //75bytes  , 150 F
    return [dataHexStr isEqualToString:  CONFIG_ALL_FF_STRING];
}



@end