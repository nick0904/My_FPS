

#import "FingerPrintImageView.h"

@implementation FingerPrintImageView {
    
    NSMutableArray *fp_animation_pics;
    
    UILongPressGestureRecognizer *lp;
}

-(id)initWithFrame:(CGRect)frame mySuperView:(UIView *)superView {
    
    self = [super init];
    
    if (!self) {
        
        return nil;
    }
    
    self.frame = frame;
    
    self.m_superView = superView;
    
    self.userInteractionEnabled = YES;
    
    //動畫圖片陣列
    fp_animation_pics = [NSMutableArray new];
    for (int picIndex = 1; picIndex <= 21; picIndex++) {
        
        [fp_animation_pics addObject:[UIImage imageNamed:[NSString stringWithFormat:@"config_ani_a_fingerprint_%d",picIndex]]];
    }
    
    //加入動畫
    self.animationImages = fp_animation_pics;
    self.animationDuration = 2.5;
    [self startAnimating];
    
    
    return self;
    
}

@end
