//
//  AboutViewController.h
//  FPSApp
//
//  Created by Rex on 2016/6/29.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "MViewController.h"
#import "mainLeftBar.h"

@interface AboutViewController : MViewController<ConnectStateDelegate,DataResponseDelegate,MainLeftBarDelegate>{
    
    mainLeftBar *leftBar;
    
    UILabel *appVerLabel;
    UILabel *appLatestLabel;
    
    UILabel *firmVerLabel;
    UILabel *firmLatestLabel;
}
@property (strong,nonatomic)UIViewController *mainVC;
@property (weak, nonatomic) IBOutlet UIButton *configCloseBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *brookLogo;
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;

@property (strong, nonatomic) UIView *appVerView;
@property (strong, nonatomic) UIView *firmWareVerView;




@end
