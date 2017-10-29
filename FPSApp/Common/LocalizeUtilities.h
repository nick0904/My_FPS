//
//  LocalizeUtilities.h
//  WarGame
//
//  Created by Tom on 2014/4/17.
//  Copyright (c) 2014年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalizeUtilities : NSObject

+(NSString *)getLocalizeStringByKey:(NSString *)key;
+(NSString *)getCurrentLanguage;

@end
