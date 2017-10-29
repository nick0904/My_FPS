//
//  ConnectLoadingView.h
//  FPSApp
//
//  Created by Rex on 2016/6/29.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectLoadingView : UIView{
    float imgScale;
    UIImageView *aniImgView;
    UILabel *statusLabel;
}

-(void)setStatusLabel:(NSString *)string;

@end
