//
//  MCDelayTimeView.h
//  FPSApp
//
//  Created by 曾偉亮 on 2016/8/18.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCCreateViewController.h"

@interface MCDelayTimeView : UIView

@property int seconds;//秒數

@property (strong, nonatomic) UIButton *continueBt; //接續 (s = 99 ms)

@property (strong, nonatomic) UIButton *syncBt; //同步 (s = 0 ms)

@property (strong, nonatomic) UIButton *continueAndDelayBt; //接續且延遲 (100 >= s <= 5000 ms)

@property (strong, nonatomic) UITextField *delay_textField;//設定延遲時間

@property (strong, nonatomic) UIButton *saveDelayTimeBt;//確定延遲時間

@property (strong, nonatomic) MCCreateViewController *mySuperVC;

-(void)defineTimeBts;

-(void)returnTimeType:(int)second;

@end
