

#import "BtAnimationCurve.h"
#import "CFMainViewController.h"

@implementation BtAnimationCurve {
    
//    BOOL m_configAction;
}


@synthesize m_parentVC,m_barView,m_configBt,m_marcoBt,m_animationTime,m_pathRadious,configAnimFlag,m_lineView;


#pragma mark - 動畫方法
-(void)btAnimationCurve:(UIButton *)bt {
    
    [self bezierPath];
}

#pragma mark - getPositionFormAngles (給角度求座標位置)
-(CGPoint)getPositionFormAngles:(CGFloat)angel center:(CGPoint)theCenter radious:(CGFloat)theRadious {
    
    CGFloat positionX = theCenter.x + theRadious * cosf(angel*M_PI/180);
    CGFloat positionY = theCenter.y + theRadious * sinf(angel*M_PI/180);
    CGPoint thePosition = CGPointMake(positionX, positionY);
    
    return thePosition;
}


#pragma mark - 貝爾曲線圖
-(void)bezierPath {
    
    [m_parentVC cellBackgroundReset];
    m_parentVC.isSeleced_config = NO;
    m_parentVC.isSeleced_marco = NO;
    
    self.m_lineView.alpha = 0.0;
    
    //nick
    if (configAnimFlag == NO) {// marco action
        
        //nick
        //m_configAction = YES;
        
        NSLog(@"======> 1");
        
        //nick
        configAnimFlag = YES;
        self.m_configBt.userInteractionEnabled = YES;
        self.m_marcoBt.userInteractionEnabled = NO;
        
        //建立曲線路徑(225 -> 45 順時鐘)
        UIBezierPath *bezierPath = [UIBezierPath new];
        [bezierPath addArcWithCenter:m_barView.center radius:m_pathRadious startAngle:225*M_PI/180 endAngle:45*M_PI/180 clockwise:YES];
        
        //設定動畫條件
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position";
        animation.duration = m_animationTime;
        animation.path = bezierPath.CGPath;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        //在m_configBt加入曲線路徑動畫
        [m_configBt.layer addAnimation:animation forKey:nil];
        
        //終點
        m_configBt.center = CGPointMake([self getPositionFormAngles:45 center:m_barView.center radious:m_pathRadious].x,[self getPositionFormAngles:45 center:m_barView.center radious:m_pathRadious].y);
        
        //*****************************************************************
        
        //建立曲線路徑(45 -> 225 順時鐘)
        UIBezierPath *bezierPath_02 = [UIBezierPath new];
        [bezierPath_02 addArcWithCenter:m_barView.center radius:m_pathRadious startAngle:45*M_PI/180 endAngle:225*M_PI/180 clockwise:YES];
        
        CAKeyframeAnimation *animation_02 = [CAKeyframeAnimation animation];
        animation_02.keyPath = @"position";
        animation_02.duration = m_animationTime;
        animation_02.path = bezierPath_02.CGPath;
        animation_02.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [m_marcoBt.layer addAnimation:animation_02 forKey:nil];
        
        
        //終點
        m_marcoBt.center = CGPointMake([self getPositionFormAngles:225 center:m_barView.center radious:m_pathRadious].x, [self getPositionFormAngles:225 center:m_barView.center radious:m_pathRadious].y);
        
        //按鈕尺寸變化
        [self configScale:0.7 marcoScale:1.5];
        
        [self.m_parentVC configOrMacroReloadData:NO];
        
    }
    else if (configAnimFlag == YES){//nick
        //config action
        
        NSLog(@"========> 2");
        
        //nick
        //m_configAction = NO;
        
        //nick
        configAnimFlag = NO;
        self.m_configBt.userInteractionEnabled = NO;
        self.m_marcoBt.userInteractionEnabled = YES;
        
        //建立曲線路徑(225 -> 45 逆時鐘)
        UIBezierPath *bezierPath_03 = [UIBezierPath new];
        [bezierPath_03 addArcWithCenter:m_barView.center radius:m_pathRadious startAngle:225*M_PI/180 endAngle:45*M_PI/180 clockwise:NO];
        
        //設定動畫條件
        CAKeyframeAnimation *animation_03 = [CAKeyframeAnimation animation];
        animation_03.keyPath = @"position";
        animation_03.duration = m_animationTime;
        animation_03.path = bezierPath_03.CGPath;
        animation_03.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [m_marcoBt.layer addAnimation:animation_03 forKey:nil];
        
        //終點
        m_marcoBt.center = CGPointMake([self getPositionFormAngles:45 center:m_barView.center radious:m_pathRadious].x, [self getPositionFormAngles:45 center:m_barView.center radious:m_pathRadious].y);
        
        //*****************************************************************

        //建立曲線路徑(45 -> 225 逆時鐘)
        UIBezierPath *bezierPath_04 = [UIBezierPath new];
        [bezierPath_04 addArcWithCenter:m_barView.center radius:m_pathRadious startAngle:45*M_PI/180 endAngle:225*M_PI/180 clockwise:NO];
        
        //設定動畫條件
        CAKeyframeAnimation *animation_04 = [CAKeyframeAnimation animation];
        animation_04.keyPath = @"position";
        animation_04.duration = m_animationTime;
        animation_04.path = bezierPath_04.CGPath;
        animation_04.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [m_configBt.layer addAnimation:animation_04 forKey:nil];

        
        //終點
        m_configBt.center = CGPointMake([self getPositionFormAngles:225 center:m_barView.center radious:m_pathRadious].x,[self getPositionFormAngles:225 center:m_barView.center radious:m_pathRadious].y);
        
        //按鈕尺寸變化
        [self configScale:1.0 marcoScale:1.0];
        
        
        [self.m_parentVC configOrMacroReloadData:YES];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:self.m_animationTime target:self selector:@selector(changePics) userInfo:nil repeats:NO];
}

#pragma mark - 按鈕轉動到達定位後的圖片
-(void)changePics {
    
    //nick
    if (configAnimFlag == NO) {
        
        [m_configBt setImage:[UIImage imageNamed:@"btn_config_a_up.png"] forState:UIControlStateNormal];
        
        [m_marcoBt setImage:[UIImage imageNamed:@"btn_macro_a_down.png"] forState:UIControlStateNormal];
        
    }
    else {
        
        [m_configBt setImage:[UIImage imageNamed:@"btn_config_a_down.png"] forState:UIControlStateNormal];
        
        [m_marcoBt setImage:[UIImage imageNamed:@"btn_macro_a_up.png"] forState:UIControlStateNormal];
        
    }
    
    [self performSelector:@selector(lineViewAlpha) withObject:nil afterDelay:0.0];
}

#pragma  mark - 按鈕圖片尺寸變化
-(void)configScale:(CGFloat)theScale_01 marcoScale:(CGFloat)theScale_02 {
    
    
    [UIView animateWithDuration:m_animationTime delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.m_configBt.transform = CGAffineTransformMakeScale(theScale_01 ,theScale_01);
        
        self.m_marcoBt.transform = CGAffineTransformMakeScale(theScale_02 , theScale_02);
        

    } completion:nil];
    
}


-(void)lineViewAlpha {
    
    self.m_lineView.alpha = 1.0;
}


@end
