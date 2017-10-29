//
//  KeyCodeView.h
//  FPSApp
//
//  Created by 曾偉亮 on 2016/9/7.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyCodeView : UIView

@property (strong, nonatomic) UIButton *keyBt;

@property (strong, nonatomic) UIImageView *keyImgView;

@property int keyInt;

@property int keyType;

@property int keyAryIndex;

-(void)changeKeyColor:(int)keycode;

@end
