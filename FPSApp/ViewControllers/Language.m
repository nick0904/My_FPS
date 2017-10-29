//
//  Language.m
//  test
//
//  Created by Yume on 2014/5/26.
//  Copyright (c) 2014年 Yume. All rights reserved.
//

#import "Language.h"

@implementation Language
static NSBundle *bundle = nil;

+(void)initialize {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *current = [languages firstObject];
    if (current) {
        if ([current isEqualToString:@"zh-Hant"]);
        else if([current isEqualToString:@"en"]);
        else if([current isEqualToString:@"zh-Hans"]);
        else
            current = @"en";
    }
    [self setLanguage:current];
}

/*
 example calls:
 [Language setLanguage:@"it"];
 [Language setLanguage:@"de"];
 */
+(void)setLanguage:(NSString *)l {
//    DLog(@"preferredLang: %@", l);
    NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:l, nil]
                                              forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)get:(NSString *)key alter:(NSString *)alternate {
    return [bundle localizedStringForKey:key value:alternate table:nil];
}

+(NSString *)getImagePath:(NSString *)key WithExtension:(NSString *)extension{
    return [bundle pathForResource:key ofType:extension];
}

@end
