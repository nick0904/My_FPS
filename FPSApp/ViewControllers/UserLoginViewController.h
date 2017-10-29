//
//  UserLoginViewController.h
//  FPSApp
//
//  Created by Rex on 2016/6/29.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "MViewController.h"
#import "mainLeftBar.h"
#import "FPCloudClass.h"
#import "ShareCommon.h"

@interface UserLoginViewController : MViewController<FPCloudClassDelegate,MainLeftBarDelegate,ConnectStateDelegate,DataResponseDelegate>{
    mainLeftBar *leftBar;
    BOOL remeberMe;
    FPCloudClass *cloudClass;
}
@property (strong,nonatomic)UIViewController *mainVC;
@property (weak, nonatomic) IBOutlet UITextField *accountTexfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfied;
@property (weak, nonatomic) IBOutlet UIView *loginIconView;

@property (weak, nonatomic) IBOutlet UIButton *FBBtn;
@property (weak, nonatomic) IBOutlet UIButton *GPBtn;
@property (weak, nonatomic) IBOutlet UIButton *TWBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *createACBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotPWBtn;
@property (weak, nonatomic) IBOutlet UIButton *remeberBtn;
@property (weak, nonatomic) IBOutlet UILabel *remeberLabel;

@property (weak, nonatomic) IBOutlet UILabel *createLabel;
@property (weak, nonatomic) IBOutlet UILabel *forgotLabel;
@property (strong, nonatomic) IBOutlet UIButton *configCloseBtn;


@end
