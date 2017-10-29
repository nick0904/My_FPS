//
//  MViewController.m
//  FuelSation
//
//  Created by Tom on 2016/4/14.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "MViewController.h"


@interface MViewController ()

@end

@implementation MViewController

@synthesize imgScale, appDelegate;

#pragma mark - System default

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Screen Rotation
/*
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{


}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //Nick
    return NO;
    
    //return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //return UIInterfaceOrientationMaskAll;
    
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

 */
 
- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

 
/*  螢幕尺寸  */
-(CGSize)currentDevice_screenSize {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    return screenSize;
}


-(void)setFrameToFitPad:(UIView *)viewToSet OriginXoffset:(CGFloat)dx OriginYoffset:(CGFloat)dy {
    
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6P) {
        
        viewToSet.frame = CGRectMake(viewToSet.frame.origin.x + dx, viewToSet.frame.origin.y + dy, viewToSet.frame.size.width, viewToSet.frame.size.width);
    }
    
}

-(void)setFontForPad:(id)view fontSize:(float)size{
    
    if (IS_IPHONE_4_OR_LESS) {
        
        if ([view isKindOfClass:[UILabel class]]) {
            
            UILabel *label = view;
            
            label.font = [UIFont systemFontOfSize:size];
        }
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = view;
            
            button.titleLabel.font = [UIFont systemFontOfSize:size];
        }
        
    }
    
}






@end
