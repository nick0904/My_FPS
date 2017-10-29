//
//  SystemInfor.h
//
//  Created by Tom on 2015/10/18.
//  Copyright © 2015年 Tom. All rights reserved.
//

#ifndef SystemInfor_h
#define SystemInfor_h


/** String: Identifier **/
#define DEVICE_IDENTIFIER ( ( IS_IPAD ) ? DEVICE_IPAD : ( IS_IPHONE ) ? DEVICE_IPHONE , DEVICE_SIMULATOR )

/** String: iPhone **/
#define DEVICE_IPHONE @"iPhone"

/** String: iPad **/
#define DEVICE_IPAD @"iPad"

/** String: Device Model **/
#define DEVICE_MODEL ( [[UIDevice currentDevice ] model ] )

/** String: Localized Device Model **/
#define DEVICE_MODEL_LOCALIZED ( [[UIDevice currentDevice ] localizedModel ] )

/** String: Device Name **/
#define DEVICE_NAME ( [[UIDevice currentDevice ] name ] )

/** Double: Device Orientation **/
#define DEVICE_ORIENTATION ( [[UIDevice currentDevice ] orientation ] )

#define DEVICE_IS_PORTRAIT ( [[UIDevice currentDevice ] orientation ]==UIDeviceOrientationPortrait )

/** String: Simulator **/
#define DEVICE_SIMULATOR @"Simulator"

/** String: Device Type **/
/** Import UIDevice+Extended.h **/
#define DEVICE_TYPE ( [[UIDevice currentDevice ] deviceType ] )

/** BOOL: Detect if device is an iPad **/
#define IS_IPAD ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )

/** BOOL: Detect if device is an iPhone or iPod **/
#define IS_IPHONE ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )

/** BOOL: IS_RETINA **/
#define IS_RETINA ( [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2 )

/** BOOL: Detect if device is the Simulator **/
#define IS_SIMULATOR ( TARGET_IPHONE_SIMULATOR )

/** CGSize **/
#define SCREEN_SIZE ([[UIScreen mainScreen] bounds].size)

/** CGFLOAT:SCREEN width  **/
#define SCREEN_WIDTH (IOS_VERSION_LOWER_THAN_8 ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height) : [[UIScreen mainScreen] bounds].size.width)
/** CGFLOAT:SCREEN height **/
#define SCREEN_HEIGHT (IOS_VERSION_LOWER_THAN_8 ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width) : [[UIScreen mainScreen] bounds].size.height)

#define IOS_VERSION_LOWER_THAN_8 (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)

/** CGFLOAT:SCREEN width  **/
//#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

/** CGFLOAT:SCREEN height **/
//#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

/** String: System Name **/
#define SYSTEM_NAME ( [[UIDevice currentDevice ] systemName ] )

/** String: System Version **/
#define SYSTEM_VERSION ( [[UIDevice currentDevice ] systemVersion ] )

/** String:APP NAME **/
#define APP_NAME ([[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleDisplayName"])

/** String:APP VERSION **/
#define APP_VERSION ([[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"])

/** String:APP BUILDVERSION **/
#define APP_BUILD_VERSION ([[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey])

/** UIColor: Color From Hex **/
/** Import UIColor+Extended.h **/
#define colorFromHex( rgbValue ) ( [UIColor UIColorFromRGB:rgbValue ] )

/** UIColor: Color from RGB **/
#define colorFromRGB( r , g , b ) ( [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1 ] )

/** UIColor: Color from RGBA **/
#define colorFromRGBA(r , g , b , a ) ( [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a ] )

/** Float: Degrees -> Radian **/
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

/** Float: Radians -> Degrees **/
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

#define IsBigScreenSize ([[UIScreen mainScreen] bounds].size.height>=375) //iphine6


#define REGEX_FOR_NUMBERS   @"^([+-]?)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$"
#define REGEX_FOR_INTEGERS  @"^([+-]?)(?:|0|[1-9]\\d*)?$"
#define IS_A_NUMBER(string) [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_FOR_NUMBERS] evaluateWithObject:string]
#define IS_AN_INTEGER(string) [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_FOR_INTEGERS] evaluateWithObject:string]

#endif /* SystemInfor_h */
