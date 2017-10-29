
#import <Foundation/Foundation.h>

//Send - Command code
//static int const SET_USER_PROFILE = 0x07;
//static int const SET_PROGRAM_MODE = 0x08;
//static int const SET_WORKOUT_TIME = 0x04;
//static int const SET_MAX_LEVEL = 0x23;
//static int const SET_MAX_INCLINE = 0x22;
//static int const SET_MAX_SPEED = 0x21;
//static int const SET_TARGET_HEART_RATE = 0x20;
//static int const SET_TARGET_WATT = 0x19;
//static int const SET_PROGRAM_USER_INCLINE = 0x25;
//static int const SET_PROGRAM_USER_LEVEL = 0x26;
//static int const SET_PROGRAM_USER_SPEED = 0x24;
//static int const GET_RPM = 0x14;
//static int const GET_HEART_RATE = 0x15;
//static int const GET_HEART_RATE_TYPE = 0x09;
//static int const SET_MODE = 0x02;
//static int const GET_MODE = 0x03;
//static int const GET_INCLINE = 0x12;
//static int const GET_LEVEL = 0x13;
//static int const ERROR_CODE = 0x10;

@interface CommandType : NSObject

+ (int)SET_USER_PROFILE;
+ (int)SET_PROGRAM_MODE;
+ (int)SET_WORKOUT_TIME;
+ (int)SET_MAX_LEVEL;
+ (int)SET_MAX_INCLINE;
+ (int)SET_MAX_SPEED;
+ (int)SET_TARGET_HEART_RATE;
+ (int)SET_TARGET_WATT;
+ (int)SET_PROGRAM_USER_INCLINE;
+ (int)SET_PROGRAM_USER_LEVEL;
+ (int)SET_PROGRAM_USER_SPEED;
+ (int)GET_RPM;
+ (int)GET_HEART_RATE;
+ (int)GET_HEART_RATE_TYPE;
+ (int)SET_MODE;
+ (int)GET_MODE;
+ (int)GET_INCLINE;
+ (int)GET_LEVEL;
+ (int)ERROR_CODE;

@end
