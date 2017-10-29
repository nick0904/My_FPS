//
//  FingerView.m
//  FPSApp
//
//  Created by 曾偉亮 on 2016/8/1.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "FingerView.h"
#import "CFEditViewController.h"

@implementation FingerView {
    
    NSMutableArray<UIImage *> *ary_animationImgs;
    
    //UILongPressGestureRecognizer *lp_gesture;
    
    UIPanGestureRecognizer *pan_gesture;
}

@synthesize m_fingerView,animationImgView,minimumPoint,maxmumPoint,superObject,rulerIndex;



#pragma mark - 設定動畫效果
-(void)settingFingerAnimation {
    
    ary_animationImgs = [NSMutableArray new];
    
    for (int i = 1; i < 22; i++) {
        
        [ary_animationImgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"config_ani_a_fingerprint_%d.png",i]]];
    }
    
    animationImgView.animationImages = ary_animationImgs;
    
    animationImgView.animationDuration = 2.5;
    
    [animationImgView startAnimating];
    
}


#pragma mark - 增加長按手勢
-(void)addLongPress {
    
//    lp_gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
//    
//    lp_gesture.minimumPressDuration = 0.1;
//    
//    
//    [self.m_fingerView addGestureRecognizer:lp_gesture];
    
    
    pan_gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    
    [self.m_fingerView addGestureRecognizer:pan_gesture];
    
}


#pragma mark - 長按手勢觸發方法
-(void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    
    //UIGestureRecognizerState state = lp_gesture.state;
    
    UIGestureRecognizerState state = pan_gesture.state;
    
    CGPoint currentPoint = [gesture locationInView:self];
    
    switch (state) {
            
        case UIGestureRecognizerStateBegan:
            //長按觸發開始
            break;
        case UIGestureRecognizerStateChanged: {
            //長按狀態改變(移動)
            
            if (CGRectContainsPoint(self.m_fingerView.frame, currentPoint)) {
                
                if (currentPoint.x >= maxmumPoint.x) {
                    
                    self.m_fingerView.center = CGPointMake(maxmumPoint.x, m_fingerView.center.y);
                }
                else if (currentPoint.x <= minimumPoint.x) {
                    
                    self.m_fingerView.center = CGPointMake(minimumPoint.x, m_fingerView.center.y);
                }
                else {
                    
                    self.m_fingerView.center = CGPointMake(currentPoint.x, self.m_fingerView.center.y);
                }
                
                if (superObject != nil) {
                
                    CFEditViewController *vc = (CFEditViewController *)superObject;
                    
                    NSString *valueStr = [NSString stringWithFormat:@"%ld",(long)[self getRulerValue:self.m_fingerView.center]];
                    
                    vc.textFieldValue.text = valueStr;
                    
                    if (vc.isSyncOrNot == YES) {
                        
                        vc.fingerViewADSTextField.text = vc.fingerViewHipTextField.text;
                    }
                    
                    
                }
                
            }
            
        }
        break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            //手指離開螢幕
            CFEditViewController *vc = (CFEditViewController *)superObject;
            
            [vc liveModeForFingerView];
            
            [vc getAllFingerValue];
            
        }
            break;
        default:
            break;
    }
    
}




#pragma mark - 指紋移動之作標點轉換成數值
-(NSInteger)getRulerValue:(CGPoint)currentP {
    
    //最大座標x值 - 最小座標x值
    CGFloat range =  maxmumPoint.x - minimumPoint.x;
    
    //切成99等分
    CGFloat unitValue = range / 99;
    
    //目前座標轉換成尺標的值
    NSInteger value = 1 + ((currentP.x - minimumPoint.x) / unitValue);
    
    return value;
}

#pragma mark - 由textField的值轉換成座標
-(void)getPointFrom:(NSInteger)value {
    
    //最大座標x值 - 最小座標x值
    CGFloat range =  maxmumPoint.x - minimumPoint.x;
    
    //切成99等分
    CGFloat unitValue = range / 99;
    
    CGFloat pointX = minimumPoint.x + ((value-1) * unitValue);
    
    m_fingerView.center = CGPointMake(pointX, m_fingerView.center.y);
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    NSLog(@"TOUCH");
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //fingerView 隱藏
    CFEditViewController *vc = (CFEditViewController *)superObject;
    
    [vc rulerIndex:rulerIndex];
    
    
    
}

@end
