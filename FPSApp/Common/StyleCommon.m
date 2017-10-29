//
//  StyleCommon.m
//  Fitness_Sole
//
//  Created by Tom on 2015/10/23.
//  Copyright © 2015年 Tom. All rights reserved.
//

#import "StyleCommon.h"

@implementation StyleCommon

+(UIColor*)getColor:(ColorNumber)colorNo
{
    UIColor *color;
    
    switch (colorNo) {
            
        case ClearColor:
            color=[UIColor clearColor];
            break;
            
        case ButtonBackGround:
            color=[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
            break;
            
        case ButtonText:
            color=[UIColor whiteColor];
            break;
            
        case ButtonBlueBorder:
            color=[UIColor colorWithRed:110.0/255.0 green:187.0/255.0 blue:249.0/255.0 alpha:1];
            break;
            
        case ButtonBlueBg:
            color=[UIColor colorWithRed:0/255.0 green:158.0/255.0 blue:231.0/255.0 alpha:1];
            break;
            
        case ButtonGrapBg:
            color=[UIColor colorWithRed:199.0/255.0 green:200.0/255.0 blue:201.0/255.0 alpha:1.0];
            break;
            
        case DisplayMapColor:
            color=[UIColor colorWithRed:228.0/255.0 green:0.0/255.0 blue:18.0/255.0 alpha:1];
            //[UIColor colorWithRed:28.0/255.0 green:79.0/255.0 blue:140.0/255.0 alpha:1];
            break;
            
        case MessageText:
            color=[UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:114.0/255.0 alpha:1];
            break;
            
        case SystemBackGround:
            color=[UIColor whiteColor];
            break;
            
        case ListBarBackGround:
            color=[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
            break;
            
        case CalendarLight:
            color=[UIColor whiteColor];
            break;
            
        case CalendarGrap:
            color=[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
            break;
            
        case CalendarDateControlBG:
            color=[UIColor blackColor];
            break;
            
        case CalendarBlack:
            color=[UIColor blackColor];
            break;
            
        case CalendarText:
            color=[UIColor blackColor];
            break;
            
        case CalendarListText:
            color=[UIColor blackColor];
            break;
            
        case CalendarListTitle:
            color=[UIColor blackColor];
            break;
            
        case CalendarWorkOutText:
            color=[UIColor whiteColor];
            break;
            
        case CalendarWorkOutBG:
            color=[UIColor colorWithRed:0/255.0 green:158.0/255.0 blue:231.0/255.0 alpha:1];
            break;
            
        case DeviceSelectBG:
            color=[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1];
            break;
            
        case MenuRedColor:
            color=[UIColor colorWithRed:127.0/255.0 green:20.0/255.0 blue:22.0/255.0 alpha:1];
            break;
            
        case RedBgColor:
            color=[UIColor colorWithRed:228.0/255.0 green:0.0/255.0 blue:18.0/255.0 alpha:1];
            break;
            
        case FieldBgColor:
            color=[UIColor colorWithRed:218.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1];
            break;
            
        default:
            color=[UIColor clearColor];
            break;
    }
    
    
    
    
    return color;
    
}

+(UIFont*)getFont:(FontNumber)fontNo
{
    UIFont *font;
    
    switch (fontNo) {
            
            //表頭
        case MainTitleFont:
            font=[UIFont fontWithName:@"HandelGothicBT-Regular" size:(IS_IPAD ? 50 : 20)];
            break;
            
            //使用者清單
        case UserListFont:
            font=[UIFont fontWithName:@"HandelGothicBT-Regular" size:(IS_IPAD ? 27 : 15)];
            break;
            
            //Program 按鈕
        case ProgramFont:
            font=[UIFont fontWithName:@"HandelGothicBT-Regular" size:(IS_IPAD ? 20 : 10)];
            break;
            //按鈕
        case ButtonFont:
            font=[UIFont fontWithName:@"HandelGothicBT-Regular" size:(IS_IPAD ? 19 : 12)];
            break;
            
            //Program description
        case ProgramDescFont:
            font=[UIFont fontWithName:@"HelveticaNeue-Light" size:(IS_IPAD ? 19 : 12)];
            break;
            
            //DeviceTitleFont
        case DeviceTitleFont:
            font=[UIFont fontWithName:@"HandelGothicBT-Regular" size:(IS_IPAD ? 23 : 12)];
            break;
            
            //DeviceItemFont
        case DeviceItemFont:
            font=[UIFont fontWithName:@"HandelGothicBT-Regular" size:(IS_IPAD ? 23 : 12)];
            break;
            
            //DisplaySimpleTitleFont
        case DisplaySimpleTitleFont:
            font=[UIFont fontWithName:@"HandelGothicBT-Regular" size:(IS_IPAD ? 17 : 12)];
            break;
            
            //DisplaySimpleDataFont
        case DisplaySimpleDataFont:
            font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:(IS_IPAD ? 40 : 18)];
            
            break;
            
            //DisplayMapTitleFont
        case DisplayMapTitleFont:
            font=[UIFont fontWithName:@"HelveticaNeueLT-CondensedObl" size:(IS_IPAD ? 33 : 13)];
            
            break;
            
            
        case MessageFont:
            font=[UIFont fontWithName:@"Helvetica Light" size:(IS_IPAD ? 40 : 20)];
            break;
            
            
            
        case CalendarListFont:
            font=[UIFont fontWithName:@"HandelGothicBT-Regular" size:(IS_IPAD)?20:12];
            break;
            
        case CalendarTitle:
            font=[UIFont fontWithName:@"HandelGothicBT-Regular" size:(IS_IPAD ? 20 : 12)];
            break;
            
        case CalendarDayFont:
            font=[UIFont fontWithName:@"HandelGothicBT-Regular" size:(IS_IPAD ? 40 : 20)];
            break;
            
        case CalendarDetailFont:
            font=[UIFont fontWithName:@"HandelGothicBT-Regular" size:(IS_IPAD ? 24 : 12)];
            break;
            
        case HeadMenuFont:
            font=[UIFont fontWithName:@"HandelGothicBT-Regular" size:(IS_IPAD ? 24 : 12)];
            break;
            
            
        default:
            break;
    }
    
    
    
    
    return font;
}


@end
