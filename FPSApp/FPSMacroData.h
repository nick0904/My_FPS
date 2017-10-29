//
//  MacroData.h
//  IdeabusSDK_FuelPlus
//
//  Created by 點睛 on 2016/7/20.
//  Copyright © 2016年 Ting. All rights reserved.
//

#import <Foundation/Foundation.h>

    static const int MACRO_PLATFORM_PS3 =1;
    static const int MACRO_PLATFORM_PS4 = 2;
    static const int MACRO_PLATFORM_X360 =4;
    static const int MACRO_PLATFORM_XBOX1 =8;

    static  const int MACRO_NAME_LENGTH = 20;
    static const  int MACRO_KEY_MAP_LENGTH =16;
    static const  int MACRO_DELAY_KEY_LENGTH = 15;


//88個byte,   176個F
static  const NSString* MACRO_ALL_FF_STRING =@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";


//@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";//FFFFFFFFFFFFFF";


@interface FPSMacroData : NSObject {

    NSMutableString* macroName;// = [[NSString alloc ] init ];;
    NSMutableArray* keyArr;// = [NSArray init ];//new int[KEY_MAP_LENGTH];
    NSMutableArray* delayArr;// = new int[DELAY_KEY_LENGTH];   // range: 0~5000 ms
   

}



-(void)initParam;

-(void) fillArrayByZero:(NSMutableArray*) arr  :(int)num;
-(void) fillArrayBy99:(NSMutableArray*) arr  :(int)num;

- (int) getHotkey;

- (void) setHotkey:(int) hotkey2;

- (int) getPlatform;

- (void) setPlatform:(int) platform2;

- (NSMutableString*) getMacroName;

-( void) setMacroName:(NSMutableString*) macroName2;

- (NSMutableArray*) getKeyArr;

- (void) setKeyArr:(NSMutableArray*) keyArr2;

- (NSMutableArray*) getDelayArr;

- (void) setDelayArr:(NSMutableArray*) delayArr2 ;



- (NSString*)  toHexString;
- (void) importHexString:(NSString*) hexStr ;

- (int)hexStringToInt:(NSString *)hexString;

-(NSString*)toString;

-( bool) isAll_FF:(NSString*) dataHexStr;


@end