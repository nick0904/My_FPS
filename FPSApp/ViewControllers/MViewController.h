//
//  MViewController.h
//  FuelSation
//
//  Created by Tom on 2016/4/14.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface MViewController : UIViewController
{
    AppDelegate *appDelegate;
    
    //Global Array
    
}

@property (strong,nonatomic) AppDelegate *appDelegate;
@property (nonatomic) float imgScale;

-(CGSize)currentDevice_screenSize;

-(void)setFrameToFitPad:(UIView *)viewToSet OriginXoffset:(CGFloat)dx OriginYoffset:(CGFloat)dy;

-(void)setFontForPad:(id)view fontSize:(float)size;

@end
