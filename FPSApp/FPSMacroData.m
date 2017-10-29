//
//  MacroData.m
//  IdeabusSDK_FuelPlus
//
//  Created by 點睛 on 2016/7/20.
//  Copyright © 2016年 Ting. All rights reserved.
//


#import "FPSMacroData.h"



@implementation FPSMacroData
 
    int  hotkey = 0xFF;
    int  macro_platform = 0x00;


-(void)initParam{
      macroName = [[NSMutableString alloc ] init ];;
     keyArr = [NSMutableArray arrayWithCapacity:  MACRO_KEY_MAP_LENGTH];;
     delayArr = [NSMutableArray arrayWithCapacity:  MACRO_DELAY_KEY_LENGTH];  // range: 0~5000 ms
    [self fillArrayByZero:keyArr : MACRO_KEY_MAP_LENGTH];
    [self fillArrayBy99:delayArr : MACRO_DELAY_KEY_LENGTH];

   // NSLog([keyArr description]);
   // NSLog([delayArr description]);
}



-(void) fillArrayByZero:(NSMutableArray*) arr  :(int)num{
    for(int i=0; i< num; i++){
        
        [arr addObject:[NSNumber numberWithInt:0]];
    }
    
}

-(void) fillArrayBy99:(NSMutableArray*) arr  :(int)num{
    for(int i=0; i< num; i++){

        [arr addObject:[NSNumber numberWithInt:99]];
    }

}


- (int) getHotkey {
        return hotkey;
    }

- (void) setHotkey:(int) hotkey2 {
         hotkey = hotkey2;
    }

    - (int) getPlatform {
        return macro_platform;
    }

- (void) setPlatform:(int) platform2 {
         macro_platform = platform2;
    }

- (NSMutableString*) getMacroName {
        return macroName;
    }

-( void) setMacroName:(NSMutableString*) macroName2 {
         macroName = macroName2;
    }

- (NSMutableArray*) getKeyArr {
        return keyArr;
    }

- (void) setKeyArr:(NSMutableArray*) keyArr2 {//int[]
         keyArr = keyArr2;
    }

- (NSMutableArray*) getDelayArr {//int[]
        return delayArr;
    }

- (void) setDelayArr:(NSMutableArray*) delayArr2 {//int[]
         delayArr = delayArr2;
    }



- (NSString*)  toHexString {
        NSMutableString* hexStr = [[NSMutableString alloc] init ];
    
    NSLog([NSString stringWithFormat:@"%X", hotkey]);
        [hexStr appendString:[NSString stringWithFormat:@"%02X", hotkey]];
        [hexStr appendString:[NSString stringWithFormat:@"%02X", macro_platform]];
        
  
        NSMutableString* nameHexStr = [[NSMutableString alloc] init ];
        int len =  [macroName length];
        for (int i = 0; i < MACRO_NAME_LENGTH; i++) {
            if(i< len){
                int ch =   [macroName characterAtIndex:i];
                [nameHexStr appendString:[NSString stringWithFormat:@"%04X", ch]];             }
            else{
                [nameHexStr appendString:[NSString stringWithFormat:@"FFFF"]];
               
            }
        }
    
        [hexStr appendString:nameHexStr];
 

        NSMutableString* keyHexStr =  [[NSMutableString alloc] init ];
        int keylen =  [keyArr count];//int array
        for (int i = 0; i < keylen; i++) {
            if([[keyArr objectAtIndex:i] intValue] == 0)
            {
                [keyHexStr appendString: @"FF"];
            }
            else
            {
                NSString* k = [NSString stringWithFormat:@"%02X", [((NSNumber*)[keyArr objectAtIndex:i]) intValue]];

                [keyHexStr appendString: k];

            }
        }
    
        [hexStr appendString: keyHexStr];


    
        NSMutableString* delayHexStr =  [[NSMutableString alloc] init ];
        
        int dlen =  [delayArr count];//int array
        for (int i = 0; i < dlen; i++) {
            if([[keyArr objectAtIndex:i] intValue] == 0)
            {
                [delayHexStr appendString: @"FFFF"];

            }
            else
            {
                NSString* k = [NSString stringWithFormat:@"%04X",  [((NSNumber*)[delayArr objectAtIndex:i]) intValue]];
                [delayHexStr appendString: k];
            }
        }
    
        [hexStr  appendString: delayHexStr];

        return hexStr;
    }


- (void) importHexString:(NSString*) hexStr {
          hotkey = [self hexStringToInt: [hexStr substringToIndex:2]];
    
        hexStr = [hexStr substringFromIndex: 2];
         macro_platform =  [self hexStringToInt: [hexStr substringToIndex:2]];
    
        hexStr = [hexStr substringFromIndex: 2];
    
        NSString* name = [hexStr substringToIndex:MACRO_NAME_LENGTH*2 *2];// unicode *2,  hex str *2
        for(int i=0; i< MACRO_NAME_LENGTH; i++){
            NSString* ch = [name substringWithRange:NSMakeRange(i*4, 4)];
            
            if(![ch isEqualToString:@"FFFF"]){
                int c = [self hexStringToInt:ch];
               // [macroName appendString:[NSString stringWithFormat:@"%c", c] ];
                [macroName appendString:[NSString stringWithCharacters:(unichar *)&c length:1] ];

            }
            
        }

     
    
        hexStr = [hexStr substringFromIndex:MACRO_NAME_LENGTH*2 *2];// unicode *2,  hex str *2

        for (int i = 0; i < MACRO_KEY_MAP_LENGTH; i++) {
            if([[hexStr substringToIndex:2] isEqualToString:@"FF"] )
            {
                keyArr[i] = [NSNumber numberWithInt:0];//0 表示未設定
            }
            else
            {
                 int dd = [self hexStringToInt: [hexStr substringToIndex:2]];
                 [keyArr replaceObjectAtIndex:i
                                   withObject:[NSNumber numberWithInt:dd]];
            }

            
            hexStr = [hexStr substringFromIndex:2];
        }

        for (int i = 0; i < MACRO_DELAY_KEY_LENGTH; i++) {
            if( [[hexStr substringToIndex:4] isEqualToString:@"FFFF"]  )
            {
                delayArr[i]= [NSNumber numberWithInt:99];//因ui那邊的需要所以用99 表示未設定
            }
            else
            {
                int dd = [self hexStringToInt: [hexStr substringToIndex:4]];
                [delayArr replaceObjectAtIndex:i
                                  withObject:[NSNumber numberWithInt:dd]];
            }


            
            hexStr = [hexStr substringFromIndex:4];
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
    return [NSString stringWithFormat:@"%@  %d  %@%@",
            macroName, hotkey, [keyArr description], [delayArr description]];
}

-( bool) isAll_FF:(NSString*) dataHexStr {
        //68byte == 136 F
        return [dataHexStr isEqualToString: MACRO_ALL_FF_STRING];
    }



@end
