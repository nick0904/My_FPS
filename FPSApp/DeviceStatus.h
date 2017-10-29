//
//  DeviceStatus.h
//  IdeabusSDK_FPS
//
//  Created by 點睛 on 2016/7/19.
//  Copyright © 2016年 Tsai Chun-Ming. All rights reserved.
//
#import <Foundation/Foundation.h>




@interface DeviceStatus: NSObject{
    
    /**
     * 當前使用的config檔的 hotkey
     */
      //int configHotKey ;
    
    /**
     * 是否有接上滑鼠
     *    0 = No Plugin
     *    1 = plugin
     */
      //int mouse ;
    
    /**
     * 是否有接上鍵盤
     *    0 = No Plugin
     *    1 = plugin
     */
      //int keybord ;
    
    /**
     * 是否有接上手把
     *    0 = No Plugin,
     *    1 = ps4, 2=ps3, 3=xbox1, 4=x360
     */
      //int controller ;
    
    
    /**
     *    那個平台
     *
     *    0 = No Plugin,
     *    1 = ps4, 2=ps3, 3=xbox1, 4=x360
     */
      //int console ;
}

@property (nonatomic) int mouse;
@property (nonatomic) int configHotKey;
@property (nonatomic) int keybord;
@property (nonatomic) int controller;
@property (nonatomic) int console;

//@property (nonatomic, strong) NSMutableArray *array;

+ (DeviceStatus*)parse: (NSString*)data;
 
-(NSString*) toStr;

+(int)hexStringToInt:(NSString *)hexString;

@end

 