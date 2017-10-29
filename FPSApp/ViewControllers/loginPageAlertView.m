//
//  loginPageAlertView.m
//  FPSApp
//
//  Created by Rex on 2016/7/19.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "loginPageAlertView.h"



@implementation loginPageAlertView

-(id)initWithFrame:(CGRect)frame andAlertStyle:(int)style{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.alertType = style;
        [self initParameter];
        [self initInterface];
    }
    
    return self;
}

-(void)initParameter{

    sendPassword = NO;
    agreeTerm = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)initInterface{
    
    self.backgroundColor = [UIColor blackColor];
    
    CGFloat alertViewHeight;
    
    if (self.alertType == ForgotPassword) {
        alertViewHeight = SCREEN_HEIGHT*0.76;
    }else{
        alertViewHeight = SCREEN_HEIGHT*0.88;
    }
    
    loginAlertView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-SCREEN_WIDTH*0.558/2, SCREEN_HEIGHT/2-alertViewHeight/2, SCREEN_WIDTH*0.558, alertViewHeight)];
    
    loginAlertView.image = [UIImage imageNamed:@"recentconfig_02"];
    loginAlertView.userInteractionEnabled = YES;
    
    cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(loginAlertView.frame.origin.x+loginAlertView.frame.size.width-SCREEN_WIDTH*0.06, loginAlertView.frame.origin.y, SCREEN_WIDTH*0.06, SCREEN_HEIGHT*0.1)];
    
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"bg_wordsquare_1_a_blue_3"] forState:UIControlStateNormal];
    
    [self setFrameToFitPad:cancelBtn OriginXoffset:0 OriginYoffset:0];
    
    [self addSubview:loginAlertView];
    [self addSubview:cancelBtn];
    
    if (self.alertType == ForgotPassword){
        
        [self initForgotPassword];
        
    }else if (self.alertType == CreateAccount){
        
        [self initCreatAccount];
        
    }
}

-(void)initCreatAccount{
    
    forgotTitle = [[UILabel alloc] initWithFrame:CGRectMake(loginAlertView.frame.size.width/2-SCREEN_WIDTH*0.359/2, SCREEN_HEIGHT*0.12, SCREEN_WIDTH*0.359, SCREEN_HEIGHT*0.08)];
    
    forgotTitle.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:30.0];
    forgotTitle.textColor = [UIColor whiteColor];
    forgotTitle.text = NSLocalizedString(@"Create Account", nil);
    forgotTitle.textAlignment = NSTextAlignmentCenter;
    
    [self setFontForPad:forgotTitle fontSize:20.0];
    
    CGFloat textFiled_w = self.bounds.size.width*0.311;
    
    UIColor *color = [UIColor redColor];
    
    accountTexfield = [[UITextField alloc] initWithFrame:CGRectMake(loginAlertView.frame.size.width/2-textFiled_w/2, forgotTitle.frame.origin.y+forgotTitle.frame.size.height+10, textFiled_w, SCREEN_HEIGHT*0.07)];
    
    accountTexfield.backgroundColor = [UIColor blackColor];
    
    accountTexfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" E-mail" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    accountTexfield.layer.borderColor = [[UIColor colorWithRed:31.0/255.0 green:188.0/255.0 blue:240.0/255.0 alpha:1]CGColor];
    accountTexfield.layer.borderWidth = 1.0f;
    accountTexfield.layer.cornerRadius = 5.0f;
    accountTexfield.layer.masksToBounds = YES;
    accountTexfield.textColor = [UIColor redColor];
    accountTexfield.autocorrectionType = NO;
    accountTexfield.autocapitalizationType = NO;
    [accountTexfield setKeyboardType:UIKeyboardTypeEmailAddress];
    
    
    passwordTexfield = [[UITextField alloc] initWithFrame:CGRectMake(loginAlertView.frame.size.width/2-textFiled_w/2, accountTexfield.frame.origin.y+accountTexfield.frame.size.height+SCREEN_HEIGHT*0.05, textFiled_w, SCREEN_HEIGHT*0.07)];
    
    passwordTexfield.backgroundColor = [UIColor blackColor];
    
    passwordTexfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Password" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    passwordTexfield.layer.borderColor = [[UIColor colorWithRed:31.0/255.0 green:188.0/255.0 blue:240.0/255.0 alpha:1]CGColor];
    passwordTexfield.layer.borderWidth = 1.0f;
    passwordTexfield.layer.cornerRadius = 5.0f;
    passwordTexfield.layer.masksToBounds = YES;
    passwordTexfield.textColor = [UIColor redColor];
    passwordTexfield.autocorrectionType = NO;
    passwordTexfield.autocapitalizationType = NO;
    passwordTexfield.secureTextEntry = YES;
    [passwordTexfield setKeyboardType:UIKeyboardTypeDefault];
    
    confirmPwdTexfield = [[UITextField alloc] initWithFrame:CGRectMake(loginAlertView.frame.size.width/2-textFiled_w/2, passwordTexfield.frame.origin.y+passwordTexfield.frame.size.height+SCREEN_HEIGHT*0.05, textFiled_w, SCREEN_HEIGHT*0.07)];
    
    confirmPwdTexfield.backgroundColor = [UIColor blackColor];
    
    confirmPwdTexfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Confirm Password" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    confirmPwdTexfield.layer.borderColor = [[UIColor colorWithRed:31.0/255.0 green:188.0/255.0 blue:240.0/255.0 alpha:1]CGColor];
    confirmPwdTexfield.layer.borderWidth = 1.0f;
    confirmPwdTexfield.layer.cornerRadius = 5.0f;
    confirmPwdTexfield.layer.masksToBounds = YES;
    confirmPwdTexfield.textColor = [UIColor redColor];
    confirmPwdTexfield.autocorrectionType = NO;
    confirmPwdTexfield.autocapitalizationType = NO;
    confirmPwdTexfield.secureTextEntry = YES;
    [confirmPwdTexfield setKeyboardType:UIKeyboardTypeDefault];
    
    CGFloat agreeBtn_w = SCREEN_WIDTH*0.04;
    CGFloat agreeBtn_h = SCREEN_WIDTH*0.04;
    
    agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.14, confirmPwdTexfield.frame.origin.y+confirmPwdTexfield.frame.size.height+SCREEN_HEIGHT*0.03, agreeBtn_w, agreeBtn_h)];
    
    [agreeBtn setBackgroundImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
    
    [agreeBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
    
    agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(agreeBtn.frame.origin.x+agreeBtn_w+5, agreeBtn.frame.origin.y, SCREEN_WIDTH*0.21, SCREEN_HEIGHT*0.07)];
    
    agreeLabel.textColor = [UIColor whiteColor];
    agreeLabel.text = @"I agree the Term of Service";
    agreeLabel.font = [UIFont systemFontOfSize:11.0];
    
    [self setFontForPad:agreeLabel fontSize:7.0];
    
    createAcBtn = [[UIButton alloc] initWithFrame:CGRectMake(loginAlertView.frame.size.width/2-SCREEN_WIDTH*0.21/2, agreeLabel.frame.origin.y+agreeLabel.frame.size.height+SCREEN_HEIGHT*0.03, SCREEN_WIDTH*0.21, SCREEN_HEIGHT*0.12)];
    
    [createAcBtn setTitle:NSLocalizedString(@"Create Account", nil) forState:UIControlStateNormal];
    
    [self setFontForPad:createAcBtn fontSize:13.0];
    
    [createAcBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createAcBtn addTarget:self action:@selector(creatAccountAction) forControlEvents:UIControlEventTouchUpInside];
    
    [createAcBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_up"] forState:UIControlStateNormal];
    
    [loginAlertView addSubview:forgotTitle];
    [loginAlertView addSubview:forgotSubTitle];
    [loginAlertView addSubview:accountTexfield];
    [loginAlertView addSubview:passwordTexfield];
    [loginAlertView addSubview:confirmPwdTexfield];
    [loginAlertView addSubview:agreeLabel];
    [loginAlertView addSubview:agreeBtn];
    [loginAlertView addSubview:createAcBtn];
}

-(void)initForgotPassword{
    
    forgotTitle = [[UILabel alloc] initWithFrame:CGRectMake(loginAlertView.frame.size.width/2-SCREEN_WIDTH*0.359/2, SCREEN_HEIGHT*0.12, SCREEN_WIDTH*0.359, SCREEN_HEIGHT*0.08)];
    
    forgotTitle.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:30.0];
    forgotTitle.textColor = [UIColor whiteColor];
    forgotTitle.text = NSLocalizedString(@"Forgot Password?", nil);
    forgotTitle.textAlignment = NSTextAlignmentCenter;
    
    [self setFontForPad:forgotTitle fontSize:20.0];
    
    forgotSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(forgotTitle.frame.origin.x, forgotTitle.frame.origin.y+forgotTitle.frame.size.height, forgotTitle.frame.size.width, SCREEN_HEIGHT*0.15)];
    
    forgotSubTitle.textColor = [UIColor whiteColor];
    forgotSubTitle.text = NSLocalizedString(@"Enter your account Address to get your password", nil);
    forgotSubTitle.textAlignment = NSTextAlignmentCenter;
    forgotSubTitle.numberOfLines = 0;
    
    [self setFontForPad:forgotSubTitle fontSize:12.0];
    
    CGFloat textFiled_w = self.bounds.size.width*0.311;
    
    UIColor *color = [UIColor redColor];
    
    accountTexfield = [[UITextField alloc] initWithFrame:CGRectMake(loginAlertView.frame.size.width/2-textFiled_w/2, forgotSubTitle.frame.origin.y+forgotSubTitle.frame.size.height+5, textFiled_w, SCREEN_HEIGHT*0.07)];
    
    accountTexfield.backgroundColor = [UIColor blackColor];
    
    accountTexfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" E-mail" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    accountTexfield.layer.borderColor = [[UIColor colorWithRed:31.0/255.0 green:188.0/255.0 blue:240.0/255.0 alpha:1]CGColor];
    accountTexfield.layer.borderWidth = 1.0f;
    accountTexfield.layer.cornerRadius = 5.0f;
    accountTexfield.layer.masksToBounds = YES;
    accountTexfield.textColor = [UIColor redColor];
    accountTexfield.autocorrectionType = NO;
    accountTexfield.autocapitalizationType = NO;
    [accountTexfield setKeyboardType:UIKeyboardTypeEmailAddress];
    
    sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(loginAlertView.frame.size.width/2-SCREEN_WIDTH*0.21/2, accountTexfield.frame.origin.y+accountTexfield.frame.size.height+SCREEN_HEIGHT*0.1, SCREEN_WIDTH*0.21, SCREEN_HEIGHT*0.12)];
    
    [sendBtn setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
    
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_up"] forState:UIControlStateNormal];
    
    [loginAlertView addSubview:forgotTitle];
    [loginAlertView addSubview:forgotSubTitle];
    [loginAlertView addSubview:accountTexfield];
    [loginAlertView addSubview:sendBtn];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    self.frame = CGRectMake(0, -keyboardHeight/2, self.bounds.size.width, self.bounds.size.height+500);
}

-(void)cancelAction{
    [self removeFromSuperview];
}

#pragma mark - Touch Event
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [accountTexfield resignFirstResponder];
    [passwordTexfield resignFirstResponder];
    [confirmPwdTexfield resignFirstResponder];
    
    if (self.frame.origin.y != 0) {
        [UIView transitionWithView:self duration:0.4 options:UIViewAnimationOptionTransitionNone animations:^{
            self.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-500);
        } completion:^(BOOL finished) {
            //
        }];
    }
}

#pragma mark - Button Action
-(void)sendEmail{
    
    if (!sendPassword) {
        forgotTitle.text = NSLocalizedString(@"Complete!", nil);
        
        forgotSubTitle.frame = CGRectMake(forgotSubTitle.frame.origin.x, forgotTitle.frame.origin.y+50, forgotSubTitle.frame.size.width, forgotSubTitle.frame.size.height);
        
        forgotSubTitle.text = NSLocalizedString(@"Email with password has been send to your email address.", nil);
        accountTexfield.hidden = YES;
        
        [sendBtn setTitle:@"OK" forState:UIControlStateNormal];
        
        //send email API here
        [self.delegate returnForgotPwdData:passwordTexfield.text];
        sendPassword = YES;
    }else{
        [self removeFromSuperview];
    }
    
}

-(void)agreeAction{
    
    if (!agreeTerm) {
        [agreeBtn setBackgroundImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
    }else{
        [agreeBtn setBackgroundImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
    }
    
    agreeTerm = !agreeTerm;
    
}


-(void)creatAccountAction{
    
    //[self showRegSuccessAlert];
    
    if (!agreeTerm) {
        [self.delegate shouldAgreeTerm:NSLocalizedString(@"Please agree term", nil)];
        
        return;
    }
        
    if(![self NSStringIsValidEmail:accountTexfield.text]){
        
        [self.delegate shouldEnterRightEmail:NSLocalizedString(@"E-mail incorrect", nil)];
        return;
    }
    
    if (passwordTexfield.text.length <6 || passwordTexfield.text.length > 20) {
        [self.delegate shouldEnterRightPassword:NSLocalizedString(@"Password length must between 6-20", nil)];
        return;
    }
    
    if(![passwordTexfield.text isEqualToString:confirmPwdTexfield.text]){
        [self.delegate shouldEnterRightPassword:NSLocalizedString(@"Comfirm password is not the same as password", nil)];
        return;
    }
    
    [self.delegate returnRegistData:accountTexfield.text password:passwordTexfield.text confirmPwd:confirmPwdTexfield.text];
    
}

-(void)showRegSuccessAlert{
    
    [loginAlertView removeFromSuperview];
    
    UIImage *originalImage = [UIImage imageNamed:@"recentconfig_02"];
    UIImage *stretchableImage = [originalImage stretchableImageWithLeftCapWidth:235.0 topCapHeight:0];
    
    UIImageView *successAlert = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-SCREEN_WIDTH*0.9/2, SCREEN_HEIGHT/2-SCREEN_HEIGHT*0.87/2, SCREEN_WIDTH*0.9, SCREEN_HEIGHT*0.87)];
    
    successAlert.image = stretchableImage;
    
    //loginAlertView.frame = CGRectMake(SCREEN_WIDTH/2-SCREEN_WIDTH*0.9/2, SCREEN_HEIGHT/2-SCREEN_HEIGHT*0.87/2, SCREEN_WIDTH*0.9, SCREEN_HEIGHT*0.87);
    
    cancelBtn.frame = CGRectMake(successAlert.frame.origin.x+successAlert.frame.size.width-SCREEN_WIDTH
                                 *0.06, successAlert.frame.origin.y, SCREEN_WIDTH*0.06, SCREEN_HEIGHT*0.1);
    
    UILabel *thanksLabel = [[UILabel alloc] initWithFrame:CGRectMake(successAlert.frame.size.width/2-SCREEN_WIDTH*0.47/2, SCREEN_HEIGHT*0.12, SCREEN_WIDTH*0.47, SCREEN_HEIGHT*0.16)];
    
    thanksLabel.numberOfLines = 0;
    thanksLabel.textColor = [UIColor colorWithRed:29.0/255.0 green:179.0/255.0 blue:229.0/255.0 alpha:1];
    
    UIFont *font = [UIFont systemFontOfSize:20.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineSpacing:10.0];
    
    NSDictionary *attributes = @{ NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Thanks for signing up to F.P.S \nGaming Converter", nil) attributes:attributes];
    
    [thanksLabel setAttributedText: attributedString];
    
    thanksLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *confirmImgView = [[UIImageView alloc] initWithFrame:CGRectMake(successAlert.frame.size.width/2-SCREEN_WIDTH*0.75/2, thanksLabel.frame.origin.y+thanksLabel.frame.size.height+SCREEN_HEIGHT*0.02, SCREEN_WIDTH*0.75, SCREEN_HEIGHT*0.09)];
    
    confirmImgView.image = [UIImage imageNamed:@"bg_wordsquare_1_a_highlight"];
    UILabel *confirmLabel = [[UILabel alloc] initWithFrame:CGRectMake(confirmImgView.frame.origin.x, confirmImgView.frame.origin.y, confirmImgView.frame.size.width, confirmImgView.frame.size.height)];
    
    confirmLabel.textColor = [UIColor whiteColor];
    confirmLabel.text = NSLocalizedString(@"Please confirm your email address", nil);;
    confirmLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:28.0];
    confirmLabel.textAlignment = NSTextAlignmentCenter;
    
    [self setFontForPad:confirmLabel fontSize:22.0];
    
    UILabel *mailToTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, confirmImgView.frame.origin.y+confirmImgView.frame.size.height, successAlert.frame.size.width, confirmImgView.frame.size.height)];
    
    mailToTitle.text = NSLocalizedString(@"We sent the verification to your email to:", nil);
    mailToTitle.textColor = [UIColor colorWithRed:29.0/255.0 green:179.0/255.0 blue:229.0/255.0 alpha:1];
    
    mailToTitle.textAlignment = NSTextAlignmentCenter;
    
    sentEmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(confirmImgView.frame.origin.x, mailToTitle.frame.origin.y+mailToTitle.frame.size.height, confirmImgView.frame.size.width, SCREEN_HEIGHT*0.09)];
    
    sentEmailLabel.text = self.registedEmail;
    //sentEmailLabel.text = accountTexfield.text;
    
    sentEmailLabel.textColor = [UIColor whiteColor];
    sentEmailLabel.font = [UIFont systemFontOfSize:25.0];
    sentEmailLabel.textAlignment = NSTextAlignmentCenter;
    
    [self setFontForPad:sentEmailLabel fontSize:20.0];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(successAlert.frame.size.width/2-SCREEN_WIDTH*0.75/2, sentEmailLabel.frame.origin.y+sentEmailLabel.frame.size.height+SCREEN_HEIGHT*0.05, SCREEN_WIDTH*0.75, 1)];
    
    bottomLine.backgroundColor = [UIColor colorWithRed:179.0/255.0 green:180.0/255.0 blue:181.0/255.0 alpha:1];
    
    UILabel *noMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(bottomLine.frame.origin.x, bottomLine.frame.origin.y+10, SCREEN_WIDTH*0.558, SCREEN_HEIGHT*0.02)];
    noMessageLabel.text = NSLocalizedString(@"No message received?", nil);
    
    noMessageLabel.textColor = [UIColor colorWithRed:29.0/255.0 green:179.0/255.0 blue:229.0/255.0 alpha:1];
    noMessageLabel.font = [UIFont systemFontOfSize:12.0];
    
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(bottomLine.frame.origin.x, noMessageLabel.frame.origin.y+noMessageLabel.frame.size.height, SCREEN_WIDTH*0.558, SCREEN_HEIGHT*0.12)];
    
    UIFont *subFont = [UIFont systemFontOfSize:12.0];
    
    NSMutableParagraphStyle *subParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [subParagraphStyle setLineSpacing:5.0];
    
    NSDictionary *subAttributes = @{ NSFontAttributeName: subFont, NSParagraphStyleAttributeName: subParagraphStyle };
    NSAttributedString *subAttributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Make sure to check your spam or junk folder.\nThe email will sent from \"brook@brookaccrssory.com\"", nil) attributes:subAttributes];
    
    [subLabel setAttributedText: subAttributedString];
    
    subLabel.textColor = [UIColor whiteColor];
    subLabel.numberOfLines = 0;
    subLabel.backgroundColor = [UIColor clearColor];
    
    UIButton *resendBtn = [[UIButton alloc] initWithFrame:CGRectMake(bottomLine.frame.origin.x+bottomLine.frame.size.width-SCREEN_WIDTH*0.21, bottomLine.frame.origin.y+SCREEN_HEIGHT*0.03, SCREEN_WIDTH*0.21, SCREEN_HEIGHT*0.11)];
    
    [resendBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_up"] forState:UIControlStateNormal];
    [resendBtn setTitle:NSLocalizedString(@"Resend", nil) forState:UIControlStateNormal];
    [resendBtn addTarget:self action:@selector(resendAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self setFontForPad:resendBtn fontSize:15.0];
    
    UILabel *resendLabel = [[UILabel alloc] initWithFrame:CGRectMake(resendBtn.frame.origin.x, resendBtn.frame.origin.y+resendBtn.frame.size.height, resendBtn.frame.size.width, SCREEN_HEIGHT*0.05)];
    
    resendLabel.textColor = [UIColor colorWithRed:29.0/255.0 green:179.0/255.0 blue:229.0/255.0 alpha:1];
    resendLabel.text = NSLocalizedString(@"Resend Sign-Up Email", nil);
    resendLabel.font = [UIFont systemFontOfSize:14.0];
    resendLabel.textAlignment = NSTextAlignmentCenter;
    [self setFontForPad:resendLabel fontSize:8.0];
    
    
    forgotSubTitle.hidden = YES;
    accountTexfield.hidden = YES;
    passwordTexfield.hidden = YES;
    confirmPwdTexfield.hidden = YES;
    agreeBtn.hidden = YES;
    agreeLabel.hidden = YES;
    forgotTitle.hidden = YES;
    createAcBtn.hidden = YES;
    
    [self addSubview:successAlert];
    
    [successAlert addSubview:thanksLabel];
    [successAlert addSubview:confirmImgView];
    [successAlert addSubview:confirmLabel];
    [successAlert addSubview:mailToTitle];
    [successAlert addSubview:sentEmailLabel];
    [successAlert addSubview:bottomLine];
    
    [successAlert addSubview:subLabel];
    [successAlert addSubview:noMessageLabel];
    [successAlert addSubview:resendBtn];
    [successAlert addSubview:resendLabel];
}

-(void)resendAction{
    
    //[self.delegate resendEmail:sentEmailLabel.text];
    
    NSLog(@"Resend email");
}

//檢查Email格式
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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

-(void)setFrameToFitPad:(UIView *)viewToSet OriginXoffset:(CGFloat)dx OriginYoffset:(CGFloat)dy {
    
    if (IS_IPHONE_4_OR_LESS) {
        
        viewToSet.frame = CGRectMake(viewToSet.frame.origin.x + dx, viewToSet.frame.origin.y + dy, viewToSet.frame.size.width, viewToSet.frame.size.width);
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
