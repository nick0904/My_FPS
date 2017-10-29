//
//  EliteObject.h
//  FPSApp
//
//  Created by 曾偉亮 on 2016/10/28.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EliteObject : NSObject

@property (strong, nonatomic) NSString *elite_content;

@property (strong, nonatomic) NSString *elite_fid;

@property (strong, nonatomic) NSData *elite_gameIconData;

@property (strong, nonatomic) NSString *elite_gameName;

@property (strong, nonatomic) NSString *elite_platform;

@property (strong, nonatomic) NSString *elite_LEDColor;

@property (strong, nonatomic) NSString *elite_ID;

@property (strong, nonatomic) NSString *elite_url;//txt 檔的 url

@property (strong, nonatomic) NSData *elite_gameIcon;//本機圖片

@end
