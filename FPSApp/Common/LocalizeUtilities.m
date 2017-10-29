//
//  LocalizeUtilities.m
//  WarGame
//  多國語系
//  Created by Tom on 2014/4/17.
//  Copyright (c) 2014年 Tom. All rights reserved.
//

#import "LocalizeUtilities.h"

@implementation LocalizeUtilities

//取得語系 字串
+(NSString *)getLocalizeStringByKey:(NSString *)key
{
    NSString* lang=[GlobalSettings globalSettings].curLanguageName;
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
    NSBundle *bundle=[NSBundle bundleWithPath:path];
    
    return NSLocalizedStringFromTableInBundle(key, nil, bundle, nil);
    
    
}

//取得語系代碼
+(NSString *)getCurrentLanguage
{
    NSString* lang=[GlobalSettings globalSettings].curLanguageName;
    
    return lang;
}

@end
