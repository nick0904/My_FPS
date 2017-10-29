//
//  DeviceStatus.m
//  IdeabusSDK_FPS
//
//  Created by 點睛 on 2016/7/19.
//  Copyright © 2016年 Tsai Chun-Ming. All rights reserved.
//
 
#import "DeviceStatus.h"
static const int CONTROLLER_NO_PLUGIN = 0;
static const int CONTROLLER_PS4 = 1;
static const int CONTROLLER_PS3 =2;
static const int CONTROLLER_XBOX1 =3;
static const int CONTROLLER_X360 =4;

@implementation DeviceStatus

@synthesize mouse,keybord,controller,console,configHotKey;

+(DeviceStatus*)parse:(NSString*)data{
    DeviceStatus* ds = [[DeviceStatus alloc] init];
    
    NSString* status = [data substringWithRange:NSMakeRange(0, 2)];
    NSString* hotkey = [data substringWithRange:NSMakeRange(2, 2)];
    
    ds.mouse = [DeviceStatus hexStringToInt:status] >>7 & 1;//(Integer.parseInt(status, 16)>>7) & 1;
    ds.keybord = [DeviceStatus hexStringToInt:status] >>6 & 1;//(Integer.parseInt(status, 16)>>6) & 1;
    ds.controller = [DeviceStatus hexStringToInt:status] >>3 & 7;  //(Integer.parseInt(status, 16)>>3) & 7;
    ds.console = [DeviceStatus hexStringToInt:status] & 7;//(Integer.parseInt(status, 16)) & 7;
    
    ds.configHotKey =  [DeviceStatus hexStringToInt:hotkey];//Integer.parseInt(hotkey, 16);
    
    return ds;
}

-(NSString*)toStr{
    return [NSString stringWithFormat:@"mouse:%d \nkeybord:%d  \nconfigHotKey:%d", mouse, keybord, configHotKey];
    
     // return @"mouse: " + mouse+ @"\nkeybord: "+ keybord+"\ncontroller: " +controller + "\nconsole: "+console + "\nhotkey: "+configHotKey;
}



+(int)hexStringToInt:(NSString *)hexString{
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    [scanner scanHexInt:&result];
    return result;
}
@end
 