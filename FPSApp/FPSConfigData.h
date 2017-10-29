//
//  ConfigData.h
//  IdeabusSDK_FuelPlus
//
//  Created by 點睛 on 2016/7/20.
//  Copyright © 2016年 Ting. All rights reserved.
//
#import <Foundation/Foundation.h>



static const int CONFIG_PLATFORM_PS3 =1;
static const int CONFIG_PLATFORM_PS4 = 2;
static const int CONFIG_PLATFORM_X360 =4;
static const int CONFIG_PLATFORM_XBOX1 =8;

static  const int CONFIG_NAME_LENGTH = 20;

static  const int CONFIG_KEY_MAP_LENGTH =22;
static  const int CONFIG_BALLISTICS_LENGTH = 20;

//98個byte   , 196  個F
static  const NSString* CONFIG_ALL_FF_STRING =
@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";

//@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";

static  const int CHANGE_LED_COLOR = 0;
//    public static final int CHANGE_FUNC_FLAG = 1;
static  const int CHANGE_HIP_SENSITIVITY = 2;
static  const int CHANGE_ADS_SENSITIVITY = 3;
static const  int CHANGE_DEADZONE = 4;
static const  int CHANGE_SNIPERBREATH_HOTKEY = 5;
static const  int CHANGE_SNIPERBREATH_MAPKEY = 6;
static const  int CHANGE_ANTIRECOIL_HOTKEY = 7;
static const  int CHANGE_ANTIRECOIL_OFFSET_VALUE = 8;
static const  int CHANGE_SHOOTING_SPEED_0 = 9;
static  const int CHANGE_SHOOTING_SPEED_1 = 10;
static  const int CHANGE_KEYMAP_ARRAY_0_4 = 11;

static const  int CHANGE_KEYMAP_ARRAY_5_20 = 12;

static const  int CHANGE_KEYMAP_ARRAY_21 = 13;
static const  int CHANGE_BLLISTICS_0_14 = 14;

static  const int CHANGE_BLLISTICS_15_19 = 15;

//    public static final int CHANGE_BLLISTICS_15_30 = 15;

//    public static final int CHANGE_BLLISTICS_31_46 = 16;
//    public static final int CHANGE_BLLISTICS_47_62 = 17;
//    public static final int CHANGE_BLLISTICS_63_78 = 18;
//    public static final int CHANGE_BLLISTICS_79_94 = 19;
//    public static final int CHANGE_BLLISTICS_95_99 = 20;



static const  int CHANGE_FUNCFLAG_ADS_TOGGLE = 100;
static const  int CHANGE_FUNCFLAG_SHOOTING_SPEED = 101;
static const  int CHANGE_FUNCFLAG_INVERTED_Y_AXIS = 102;
static const  int CHANGE_FUNCFLAG_SNIPER_BREATH = 103;
static const  int CHANGE_FUNCFLAG_ANTI_RECOIL = 104;
static const  int CHANGE_FUNCFLAG_ADS_SYNC = 105;

@interface FPSConfigData: NSObject{
    NSMutableString* configName;
    NSMutableArray*    keyMapArray;
    NSMutableArray*  ballistics;
    NSMutableArray*  ballisticsChanged;
    
}

-(void)initParam;
-(void) fillArrayByZero:(NSMutableArray*) arr  :(int)num;
- (int) getConfigHotKey ;
- (void) setConfigHotKey:(int) configHotKey2 ;
- (int) getPlatform ;
/**
 *
 * @param platform  CONFIGdATA.PLATFORM_PS3 ，CONFIGdATA.PLATFORM_PS4  ...
 */
- (void) setPlatform:(int) platform2 ;
-(NSMutableString*) getConfigName ;
- (void) setConfigName:(NSMutableString*) configName2;
-( int) getLEDColor ;
- (void) setLEDColor:(int) LEDColor2;
-( bool) isFuncFlag_ADSToggle ;
- (void) setFuncFlag_ADSToggle:(bool) funcFlag_ADSToggle2;
- (bool) isFuncFlag_shootingSpeed ;
-( void) setFuncFlag_shootingSpeed:(bool) funcFlag_shootingSpeed2 ;
- (bool) isFuncFlag_invertedYAxis ;
- (void) setFuncFlag_invertedYAxis:(bool) funcFlag_invertedYAxis2;
- (bool) isFuncFlag_sniperBreath ;
- (void) setFuncFlag_sniperBreath:(bool) funcFlag_sniperBreath2;
- (bool) isFuncFlag_antiRecoil ;
- (void) setFuncFlag_antiRecoil:(bool) funcFlag_antiRecoil2 ;
- (bool) isFuncFlag_ADSSync;
- (void) setFuncFlag_ADSSync:(bool) funcFlag_ADSSync2;

- (int) getHIPSensitivity ;
- (void) setHIPSensitivity:(int) HIPSensitivity2 ;
- (int) getADSSensitivity ;
- (void) setADSSensitivity:(int) ADSSensitivity2 ;
- (int) getDeadZONE ;
- (void) setDeadZONE:(int) deadZONE2;
- (int) getSniperBreathHotKey;
- (void) setSniperBreathHotKey:(int) sniperBreathHotKey2 ;
- (int) getSniperBreathMapkey ;
- (void) setSniperBreathMapkey:(int) sniperBreathMapkey2;
- (int) getAntiRecoilHotkey ;
- (void) setAntiRecoilHotkey:(int) antiRecoilHotkey2;
- (int) getAntiRecoilOffsetValue;
- (void) setAntiRecoilOffsetValue:(int) antiRecoilOffsetValue2;
- (int) getShootingSpeed ;
- (void) setShootingSpeed:(int) shootingSpeed2 ;
- (NSArray*) getKeyMapArray ;
- (void) setKeyMapArray:(NSArray*) keyMapArr2;

- (NSArray*) getBallistics ;
- (void) setBallistics:(NSArray*) ballistic2;

- (NSArray*) getBallisticsChanged ;
- (void) setBallisticsChanged:(NSArray*) ballisticChanged2 ;

- (NSString*) toHexString ;

-( NSString*) toHexString:(int) changeFieldID;
-(NSString*) toHexStringImp:(int ) changedPacketNum;


-( int) getChangedFieldPacketNum:(int) changeFieldID ;

-( void) importHexString:(NSString*) hexStr ;

- (int)hexStringToInt:(NSString *)hexString;

-(NSString*) toString;

-( bool) isAll_FF:(NSString*) dataHexStr ;

@end
