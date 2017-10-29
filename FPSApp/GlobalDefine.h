//
//  GlobalDefine.h

//
//  Created by Tom on 2015/10/18.
//  Copyright © 2015年 Tom. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h

//stroy board ID Name


//Db Name
#define kDBNameSQLite @"DataModel.sqlite"


//Data Formate
#define kDistanceFormat         @"%2.1f"
#define kCaloriesFormat         @"%d"
#define kHeartRateFormat        @"%d"
#define kTimeRemainingFormat    @"%2d:%02d"
#define kRPMFormat              @"%d"
#define kLevelFormat            @"%d"
#define kWattsFormat            @"%d"
#define kInclineLevelFormat     @"%d"
#define kLapsFormat             @"%2.1f"
#define kSpeedFormat            @"%2.1f"

#define kAverageHRFormat          @"%d bpm"
#define kAverageSpeedFormat       @"%2.1f mph"
#define kAverageRPMFormat         @"%d"
#define kAverageWattFormat        @"%d"
#define kAverageMETFormat         @"%2.1f"
#define kAverageResistanceFormat  @"%i"

//Rex
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kClientID @"1080888517158-h2enmfgd1cl4g0dnata5rp2kji0c4p83.apps.googleusercontent.com"

/******************/
//Type Define

 //頁面
typedef enum
{
    
    MainHomePage,      //主頁
    MainLoginPage,     //登入頁
    MainSettingPage,   //首頁
    MainAboutPage,      //
    MainHelpPage       //
    
    /*
     UN_Logo,
     UN_Service,//使用條款頁
     UN_Help,//說明
     UN_LoginMain,//登入主頁
     UN_Login,//登入頁
     UN_NewUser,//註冊
     UN_EditUser,//編輯使用者
     UN_FSMain,
     UN_SWRevealView,//FS主頁
     UN_ForgetPwd
     */
    
}UIPageName;



#endif /* Global_Define_h */
