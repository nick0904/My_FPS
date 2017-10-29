//
//  HomeViewController.h
//  FPSApp
//
//  Created by Rex on 2016/6/28.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "MViewController.h"
#import "mainLeftBar.h"
#import "AppDelegate.h"
#import "BtAnimationCurve.h"
#import "CFMainViewController.h"

typedef enum{
    PLATFORM_PS3 = 1,
    PLATFORM_PS4 = 2,
    PLATFORM_X360 = 4,
    PLATFORM_XBOX1 = 8
}platForm;

@interface HomeViewController : MViewController<ConnectStateDelegate,DataResponseDelegate,MainLeftBarDelegate>
{
    float imgScale;
    mainLeftBar *leftBar;
    BtAnimationCurve *m_btAnimation;
}


@property (nonatomic) BOOL isConnect;

@property (weak, nonatomic) IBOutlet UIImageView *mainBg;
@property (weak, nonatomic) IBOutlet UIImageView *animationImgView;
@property (weak, nonatomic) IBOutlet UILabel *mainConfigTitle;
@property (weak, nonatomic) IBOutlet UIImageView *arrowAnimateVIew;
@property (weak, nonatomic) IBOutlet UIImageView *configImg;
//@property (weak, nonatomic) IBOutlet UIImageView *leftBar;
@property (weak, nonatomic) IBOutlet UIImageView *scanDeviceImgView;


@property (weak, nonatomic) IBOutlet UIImageView *lineOne;
@property (weak, nonatomic) IBOutlet UIImageView *lineTwo;
@property (weak, nonatomic) IBOutlet UIImageView *systemMsg;
@property (weak, nonatomic) IBOutlet UITextView *logMsgTextField;

@property (weak, nonatomic) IBOutlet UIImageView *deviceImg;
@property (weak, nonatomic) IBOutlet UIImageView *joystickImg;
@property (weak, nonatomic) IBOutlet UIImageView *keyboardImg;
@property (weak, nonatomic) IBOutlet UIImageView *mouseImg;
@property (weak, nonatomic) IBOutlet UIImageView *keyboardIcon;
@property (weak, nonatomic) IBOutlet UILabel *F2Label;
@property (weak, nonatomic) IBOutlet UIImageView *barView;
@property (weak, nonatomic) IBOutlet UIButton *configBt;
@property (weak, nonatomic) IBOutlet UIButton *marcoBt;


@end
