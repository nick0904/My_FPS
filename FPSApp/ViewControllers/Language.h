//
//  Language.h
//  test
//
//  Created by Yume on 2014/5/26.
//  Copyright (c) 2014年 Yume. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef NSLocalizedString
#define NSLocalizedString(key,comment) [Language get:(key) alter:nil]

@interface Language : NSObject
+(void)setLanguage:(NSString *)l;
+(NSString *)get:(NSString *)key alter:(NSString *)alternate;
+(NSString *)getImagePath:(NSString *)key WithExtension:(NSString *)extension;
@end
