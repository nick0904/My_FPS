//
//  ConfigMacroData.m
//  FPSApp
//
//  Created by Rex on 2016/8/10.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "ConfigMacroData.h"

@implementation ConfigMacroData

+(ConfigMacroData*) sharedInstance{
    
    static ConfigMacroData *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ConfigMacroData alloc] init];
    });
    
    return sharedInstance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    
    configArray = [[NSMutableArray alloc] initWithCapacity:0];
    macroArray = [[NSMutableArray alloc] initWithCapacity:0];
//    configImgArray = [[NSMutableArray alloc] initWithCapacity:0];
    defaults = [NSUserDefaults standardUserDefaults];
    usingConfig = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.logIn = NO;
    self.userName = @"";
}

-(void)setConfigArray:(NSMutableArray *)array{
    configArray = [array mutableCopy];
}

-(NSMutableArray *)getConfigArray{
    return [configArray mutableCopy];
}

-(NSString *)getConfigName:(int)index{
    if(index >= configArray.count)
        return @"";
    
    NSString *configName = [[configArray objectAtIndex:index] objectForKey:@"configName"];
    return configName;
}

-(void)moveConfigFrom:(int)from To:(int)to{
    [configArray exchangeObjectAtIndex:from withObjectAtIndex:to];
}

-(void)removeConfigIndex:(int)index{
    [configArray removeObjectAtIndex:index];
}

-(NSMutableArray *)getConfigHotKeys{
    
    NSMutableArray *existHotKey = [NSMutableArray new];
    
    for (int i=0; i<configArray.count; i++) {
        NSString *hotKey = [[configArray objectAtIndex:i] objectForKey:@"configHotKey"];
        
        [existHotKey addObject:hotKey];
    }
    
    return existHotKey;
    
}



-(void)setMacroArray:(NSMutableArray *)array{
    
    macroArray = [array mutableCopy];
}


-(NSMutableArray *)getMacroArray{
    return [macroArray mutableCopy];
}

-(void)moveMacroFrom:(int)from To:(int)to{
    [macroArray exchangeObjectAtIndex:from withObjectAtIndex:to];
}

-(void)removeMacroIndex:(int)index{
    [macroArray removeObjectAtIndex:index];
}


-(void)changeBLEConnectedState:(ConnectState)state{
    if (state == Connected) {
        BLEConnected = YES;
    }else{
        BLEConnected = NO;
    }
}

-(BOOL)BLEConnected{
    return BLEConnected;
}


//-(void)saveImageAndName:(NSMutableArray *)array{
//    
//    [defaults setObject:array forKey:@"image"];
//    
//    [defaults synchronize];
//    
//}

//Ting
-(void)saveConfigImage:(NSMutableDictionary *)imageDictionary Key:(NSString *)key{
    
    NSMutableDictionary *configImgDic = [imageDictionary mutableCopy];
    
//    NSLog(@"saveConfigImage-----configHotKey = %@", [configImgDic objectForKey:@"configHotKey"]);
    
    [defaults setObject:configImgDic forKey:key];
    
    [defaults synchronize];
    
}

-(NSMutableDictionary *)getConfigImageKey:(NSString *)key{
    
    NSMutableDictionary *configImgDic = [[defaults objectForKey:key] mutableCopy];
    
    return configImgDic;
}

-(void)removeConfigImageKey:(NSString *)key{
    
    [defaults removeObjectForKey:key];
    
    [defaults synchronize];
}

-(void)saveUsingConfig:(NSMutableDictionary *)config{
    usingConfig = [config mutableCopy];
}

-(NSMutableDictionary *)getUsingConfig{
    return usingConfig;
}


@end
