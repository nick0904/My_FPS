//
//  ConnectLoadingView.m
//  FPSApp
//
//  Created by Rex on 2016/6/29.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "ConnectLoadingView.h"

@implementation ConnectLoadingView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        
        [self initParameter];
        [self initInterface];
    }
    return self;
}

-(void)initParameter{
    
    if(IS_IPHONE_5){
        
        imgScale = 2.2;
        
    }else if(IS_IPHONE_6){
        
        imgScale = 2;
        
    }else if(IS_IPHONE_6P){
        
        imgScale = 1.75;
        
    }else{
        
        imgScale = 2.5;
        
    }
    
}

-(void)initInterface{
    
    self.backgroundColor = [UIColor blackColor];
    
    CGFloat aniImgview_w = 571/imgScale;
    CGFloat aniImgview_h = 571/imgScale;
    
    aniImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-aniImgview_w/2, self.frame.size.height/2-aniImgview_h/2, aniImgview_w, aniImgview_h)];
    
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.85, self.frame.size.width, self.frame.size.height*0.1)];
    
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.text = @"";
    [statusLabel adjustsFontSizeToFitWidth];
    [self addSubview:aniImgView];
    [self addSubview:statusLabel];
    
    [self setAnimation:aniImgView imgDuration:2.0];
}

-(void)setStatusLabel:(NSString *)string{
    
    statusLabel.text = string;
    
}

-(void)setAnimation:(UIImageView *)imgView imgDuration:(float)duration{
    
    NSArray *imgSourceAry = [NSArray arrayWithObjects:@"ani_loading_01",
                             @"ani_loading_02",
                             @"ani_loading_03",
                             @"ani_loading_04",
                             @"ani_loading_05",
                             @"ani_loading_06",
                             @"ani_loading_07",
                             @"ani_loading_08",
                             @"ani_loading_09",
                             @"ani_loading_10",
                             @"ani_loading_11",
                             @"ani_loading_12",
                             @"ani_loading_13",
                             @"ani_loading_14",
                             @"ani_loading_15",
                             @"ani_loading_16",
                             @"ani_loading_17",
                             @"ani_loading_18",
                             @"ani_loading_19",
                             @"ani_loading_20",
                             @"ani_loading_21",
                             @"ani_loading_22",
                             @"ani_loading_23",
                             @"ani_loading_24",nil];
    
    
     NSMutableArray *aniImgAry = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=0; i<imgSourceAry.count; i++) {
        
        UIImage *image = [UIImage imageNamed:[imgSourceAry objectAtIndex:i]];
        
        [aniImgAry addObject:image];
    }

    imgView.animationImages = aniImgAry;
    
    imgView.animationDuration = duration;
    
    [imgView startAnimating];
}


@end
