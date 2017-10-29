//
//  KeyCodeView.m
//  FPSApp
//
//  Created by 曾偉亮 on 2016/9/7.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "KeyCodeView.h"

@implementation KeyCodeView {
    
    NSString *oriBtStr;
    NSString *oriImgViewStr;
}

@synthesize keyBt,keyImgView,keyInt,keyType,keyAryIndex;

/*
 
藍色: type = 0
config_icon_a_kb_1
config_icon_a_kb_2
藍色可變 綠色(105,106) - 藍色
===============================
紅色: type = 1
config_icon_a_kb_3
config_icon_a_kb_4
紅色可變 綠色(105,106) - 紅色
===============================
綠色: type = 2
config_icon_a_ms_1
config_icon_a_ms_2
綠色可變 紅色 - 綠色(105,106)
===============================
灰色: type = 3
config_icon_a_none_1
config_icon_a_none_2
灰色可變 紅色 - 綠色(105,106) - 灰色

*/

-(void)changeKeyColor:(int)keycode {
    
    if (keyType == 0) { //原藍色
        
        if (keycode == 105 || keycode == 106) {
            //變綠色
            
            [keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_ms_2"] forState:UIControlStateNormal];
            
             [keyBt setTitleColor:[UIColor colorWithRed:0.55 green:1.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
            
            keyImgView.image = [UIImage imageNamed:@"config_icon_a_ms_1"];
            
        
            
        }
        else if (keycode == 0) {
            //灰色 None
            
            [keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_none_2"] forState:UIControlStateNormal];
            
            [keyBt setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
            
            keyImgView.image = [UIImage imageNamed:@"config_icon_a_none_1"];
            
        }
        else {
            //還原藍色
            
            [keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_kb_2"] forState:UIControlStateNormal];
            
            [keyBt setTitleColor:[UIColor colorWithRed:0.0 green:0.72 blue:0.95 alpha:1.0] forState:UIControlStateNormal];
            
            keyImgView.image = [UIImage imageNamed:@"config_icon_a_kb_1"];
            
        }
        
    }
    else if (keyType == 1) { //原紅色
    
        if (keycode == 105 || keycode == 106) {
            //變綠色
            [keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_ms_2"] forState:UIControlStateNormal];
            
            
             [keyBt setTitleColor:[UIColor colorWithRed:0.55 green:1.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
            
            keyImgView.image = [UIImage imageNamed:@"config_icon_a_ms_1"];
            
        }
        else if (keycode == 0) {
            //灰色 None
            
            [keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_none_2"] forState:UIControlStateNormal];
            
            [keyBt setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
            
            keyImgView.image = [UIImage imageNamed:@"config_icon_a_none_1"];
            
        }
        else {
            //還原紅色
            [keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_kb_4"] forState:UIControlStateNormal];
    
            
            [keyBt setTitleColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.01 alpha:1.0] forState:UIControlStateNormal];
            
            
            keyImgView.image = [UIImage imageNamed:@"config_icon_a_kb_3"];
        
        }
        
    }
    else if (keyType == 2) { //原綠色
        
        if (keycode == 105 || keycode == 106) {
            //還原綠色
            [keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_ms_2"] forState:UIControlStateNormal];
            
             [keyBt setTitleColor:[UIColor colorWithRed:0.55 green:1.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
            
            keyImgView.image = [UIImage imageNamed:@"config_icon_a_ms_1"];
            
        }
        else if (keycode == 0) {
            //灰色 None
            
            [keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_none_2"] forState:UIControlStateNormal];
            
            [keyBt setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
            
            keyImgView.image = [UIImage imageNamed:@"config_icon_a_none_1"];
            
        }
        else {
            //變紅色
            [keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_kb_4"] forState:UIControlStateNormal];
            
            [keyBt setTitleColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.01 alpha:1.0] forState:UIControlStateNormal];
            
            keyImgView.image = [UIImage imageNamed:@"config_icon_a_kb_3"];
            
        }
        
    }
    else if (keyType == 3) { //原灰色
        
        if (keycode == 0) {
            //還原灰色
             [keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_none_2"] forState:UIControlStateNormal];
            
             [keyBt setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
            
            keyImgView.image = [UIImage imageNamed:@"config_icon_a_none_1"];
            
            [keyBt setTitle:@"None" forState:UIControlStateNormal];

        }
        else if (keycode == 105 || keycode == 106) {
            //變綠色
            [keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_ms_2"] forState:UIControlStateNormal];
            
             [keyBt setTitleColor:[UIColor colorWithRed:0.55 green:1.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
            
            keyImgView.image = [UIImage imageNamed:@"config_icon_a_ms_1"];
            
        }
        else {
            //變紅色
            [keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_kb_4"] forState:UIControlStateNormal];
            
            [keyBt setTitleColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.01 alpha:1.0] forState:UIControlStateNormal];
            
            keyImgView.image = [UIImage imageNamed:@"config_icon_a_kb_3"];
        }
        
    }
    
}


@end
