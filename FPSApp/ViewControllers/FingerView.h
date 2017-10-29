//
//  FingerView.h
//  FPSApp
//
//  Created by 曾偉亮 on 2016/8/1.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FingerView : UIView

@property (strong, nonatomic) UIView *m_fingerView;

@property (strong, nonatomic) UIImageView *animationImgView;

@property int fingerValue;

@property (strong, nonatomic) id superObject;

@property CGPoint minimumPoint;

@property CGPoint maxmumPoint;

@property int rulerIndex;

-(void)addLongPress;

-(void)settingFingerAnimation;

-(void)getPointFrom:(NSInteger)value;




@end
