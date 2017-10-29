//
//  ShareCommon.h
//  LazyEye
//
//  Created by Tom on 2016/3/12.
//
//

#import <Foundation/Foundation.h>

@interface ShareCommon : NSObject

+ (void)showApplicationAlert:(NSString *)message Title:(NSString*)title;

+(BOOL)isValidEmail:(NSString *)checkString;
+(BOOL)isNumeric:(NSString*)inputString;

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSString *)DateToStringByFormate:(NSDate *)date formate:(NSString*)formate;

+ (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)checkEndDate;

//取得手機唯一值
+(NSString*)getDeviceUUID;

//取得設定檔 SystemConfig.plist 資料
+(NSString*)getSystemConfigValue:(NSString*)key;

//設定設定檔 SystemConfig.plist 資料
+(void)setSystemConfigValue:(NSString*)key keyValue:(NSString*)keyValue;

//MD5 加密
+(NSString *)md5:(NSString *)input;

//取得時間戳
+(NSString *)getTimestamp;

//高斯模糊
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

+ (NSString *) pathForDocumentsResource:(NSString *) relativePath;

+ (void)saveImageToFile:(UIImage *)image FileName:(NSString *)fileName;


@end
