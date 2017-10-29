//
//  StyleCommon.h
//  Fitness_Sole
//
//  Created by Tom on 2015/10/23.
//  Copyright © 2015年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    ClearColor = 0,
    ButtonBackGround,
    ButtonText,
    ButtonBlueBorder,
    MessageText,
    SystemBackGround,
    ListBarBackGround,
    CalendarLight,
    CalendarGrap,
    CalendarDateControlBG,
    CalendarBlack,
    CalendarText,
    CalendarListText,
    CalendarListTitle,
    CalendarWorkOutText,
    CalendarWorkOutBG,
    DeviceSelectBG,
    DisplayMapColor,
    MenuRedColor,
    ButtonBlueBg,
    ButtonGrapBg,
    RedBgColor,
    FieldBgColor
    
}ColorNumber;

typedef enum
{
    MainTitleFont = 0,
    UserListFont,
    ButtonFont,
    MessageFont,
    ProgramFont,
    CalendarFont,
    CalendarTitle,
    CalendarDayFont,
    CalendarListFont,
    CalendarDetailFont,
    ProgramDescFont,
    DeviceTitleFont,
    DeviceItemFont,
    DisplaySimpleTitleFont,
    DisplaySimpleDataFont,
    DisplayMapTitleFont,
    HeadMenuFont
}FontNumber;

@interface StyleCommon : NSObject

+(UIColor*)getColor:(ColorNumber)colorNo;
+(UIFont*)getFont:(FontNumber)fontNo;


@end
