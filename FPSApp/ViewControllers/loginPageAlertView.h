//
//  loginPageAlertView.h
//  FPSApp
//
//  Created by Rex on 2016/7/19.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    
    CreateAccount,
    ForgotPassword
    
}alertViewType;

@protocol LoginAlertDelegate <NSObject>

-(void)returnRegistData:(NSString *)account password:(NSString *)password confirmPwd:(NSString *)confirmPwd;

-(void)returnForgotPwdData:(NSString *)email;

-(void)resendEmail:(NSString *)email;

-(void)shouldAgreeTerm:(NSString *)reason;
-(void)shouldEnterRightEmail:(NSString *)reason;
-(void)shouldEnterRightPassword:(NSString *)reason;

@end

@interface loginPageAlertView : UIView{
    UIImageView *loginAlertView;
    UITextField *accountTexfield;
    UITextField *passwordTexfield;
    UITextField *confirmPwdTexfield;
    UIButton *sendBtn;
    UIButton *agreeBtn;
    UIButton *createAcBtn;
    UIButton *cancelBtn;
    UILabel *agreeLabel;
    UILabel *forgotSubTitle;
    UILabel *forgotTitle;
    float keyboardHeight;
    BOOL sendPassword;
    BOOL agreeTerm;
    UILabel *sentEmailLabel;
}

@property (nonatomic)int alertType;
@property (nonatomic, strong) NSString *registedEmail;

-(id)initWithFrame:(CGRect)frame andAlertStyle:(int)style;
-(void)showRegSuccessAlert;

@property (strong, nonatomic)id<LoginAlertDelegate>delegate;

@end
