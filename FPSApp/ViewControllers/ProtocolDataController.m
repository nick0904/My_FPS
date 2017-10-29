//
//  ProtocolDataController.m
//  FPSApp
//
//  Created by Rex on 2016/8/11.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "ProtocolDataController.h"

@implementation ProtocolDataController

+(ProtocolDataController*) sharedInstance{
    
    static ProtocolDataController *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ProtocolDataController alloc] getInstanceSimulation:NO PrintLog:YES];
    });
    
    return sharedInstance;
}

@end
