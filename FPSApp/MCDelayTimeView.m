//
//  MCDelayTimeView.m
//  FPSApp
//
//  Created by 曾偉亮 on 2016/8/18.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "MCDelayTimeView.h"

@implementation MCDelayTimeView

@synthesize seconds,continueBt,continueAndDelayBt,syncBt,delay_textField,saveDelayTimeBt;

-(void)defineTimeBts {
    
    //接續
    [continueBt addTarget:self action:@selector(continueBtAction) forControlEvents:UIControlEventTouchUpInside];
    
    //同步
    [syncBt addTarget:self action:@selector(syncBtAction) forControlEvents:UIControlEventTouchUpInside];
    
    //接續且延遲
    [continueAndDelayBt addTarget:self action:@selector(continueAndDelayAction) forControlEvents:UIControlEventTouchUpInside];
    
    //確定延遲時間
    [saveDelayTimeBt addTarget:self action:@selector(getDelayTime) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark - 接續,同步,接續且延遲
-(void)continueBtAction {
    //接續 (99 ms)

    //被選
    [continueBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item2_btn_down.png"] forState:UIControlStateNormal];
    
    continueBt.userInteractionEnabled = NO;
    
    //不選
    [syncBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item1_btn_up"] forState:UIControlStateNormal];
    
    syncBt.userInteractionEnabled = YES;
    
    [continueAndDelayBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item1_btn_up"] forState:UIControlStateNormal];

    continueAndDelayBt.userInteractionEnabled = YES;
    
    delay_textField.userInteractionEnabled = NO;
    [delay_textField resignFirstResponder];
    delay_textField.text = @"";
    
    
   // MCCreateViewController *mcVC = [[MCCreateViewController alloc]init];
    
    
    [self.mySuperVC settingWindowBackToOrigin];
    
    seconds = 99;
}


-(void)syncBtAction {
    //同步 (s = 0 ms)
    
    //被選
    [syncBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item2_btn_down.png"] forState:UIControlStateNormal];
    
    syncBt.userInteractionEnabled = NO;
    
    //不選
    [continueBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item1_btn_up"] forState:UIControlStateNormal];
    
    continueBt.userInteractionEnabled = YES;
    
    [continueAndDelayBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item1_btn_up"] forState:UIControlStateNormal];
    
    continueAndDelayBt.userInteractionEnabled = YES;
    
    delay_textField.userInteractionEnabled = NO;
    [delay_textField resignFirstResponder];
    delay_textField.text = @"";
    
    //MCCreateViewController *mcVC = [[MCCreateViewController alloc]init];
    [self.mySuperVC settingWindowBackToOrigin];
    
    seconds = 0;
}


-(void)continueAndDelayAction {
    //接續且延遲 (100 >= s <= 5000 ms)
    
    //被選
    [continueAndDelayBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item2_btn_down.png"] forState:UIControlStateNormal];
    
    continueAndDelayBt.userInteractionEnabled = NO;
    
    //不選
    [syncBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item1_btn_up"] forState:UIControlStateNormal];
    
    syncBt.userInteractionEnabled = YES;
    
    
    [continueBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item1_btn_up"] forState:UIControlStateNormal];
    
    continueBt.userInteractionEnabled = YES;
    
    delay_textField.userInteractionEnabled = YES;
}


#pragma mark - 取得時間
-(void)getDelayTime {
    
    NSLog(@"save time");
    
    if (syncBt.userInteractionEnabled == NO) {
        
        seconds = 0;
    }
    else if (continueBt.userInteractionEnabled == NO){
        
        seconds = 99;
    }
    else if (continueAndDelayBt.userInteractionEnabled == NO) {
        
        if (![delay_textField.text isEqual: @""]) {
            
            seconds = [delay_textField.text intValue];
        }
        else {
            
            return;
        }
        
    }
    
    NSLog(@"設定時間:%d",seconds);
    
    if (self.mySuperVC != nil) {
        
        [self.mySuperVC saveDelayTime:seconds];
    }
    
}


-(void)returnTimeType:(int)second {
    
    if(second == 0) {
        //同步
        
        //被選
        [syncBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item2_btn_down.png"] forState:UIControlStateNormal];
        
        syncBt.userInteractionEnabled = NO;
        
        //不選
        [continueBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item1_btn_up"] forState:UIControlStateNormal];
        
        continueBt.userInteractionEnabled = YES;
        
        
        [continueAndDelayBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item1_btn_up"] forState:UIControlStateNormal];
        
        continueAndDelayBt.userInteractionEnabled = YES;
        
        delay_textField.userInteractionEnabled = NO;
        
        delay_textField.text = @"";
        
    }
    else if (second > 0 && second < 100) {
        //接續
        
        //被選
        [continueBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item2_btn_down.png"] forState:UIControlStateNormal];
        
        continueBt.userInteractionEnabled = NO;
        
        
        //不選
        [syncBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item1_btn_up"] forState:UIControlStateNormal];
        
        syncBt.userInteractionEnabled = YES;
        
        [continueAndDelayBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item1_btn_up"] forState:UIControlStateNormal];
        
        continueAndDelayBt.userInteractionEnabled = YES;
        
        delay_textField.userInteractionEnabled = NO;
        
        delay_textField.text = @"";
        
    }
    else if (second >= 100 && second <= 5000) {
        //接續且延遲
        
        //被選
        [continueAndDelayBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item2_btn_down.png"] forState:UIControlStateNormal];
        
        continueAndDelayBt.userInteractionEnabled = NO;
        
        //不選
        [syncBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item1_btn_up"] forState:UIControlStateNormal];
        
        syncBt.userInteractionEnabled = YES;
        
        [continueBt setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item1_btn_up"] forState:UIControlStateNormal];
        
        syncBt.userInteractionEnabled = YES;
        
        delay_textField.userInteractionEnabled = YES;
        
        delay_textField.text = [NSString stringWithFormat:@"%d",self.seconds];
    }
    else {
        
        return;
    }
    
}

@end
