//
//  UserLoginViewController.m
//  FPSApp
//
//  Created by Rex on 2016/6/29.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "UserLoginViewController.h"
#import "loginPageAlertView.h"
#import "CheckNetwork.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKLoginKit/FBSDKLoginManagerLoginResult.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "ConnectLoadingView.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "HomeViewController.h"
#import "CFMainViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface UserLoginViewController ()<LoginAlertDelegate,GIDSignInUIDelegate>{
    loginPageAlertView *loginAlert;
    
    KeyCodeFile * codeFile;
    NSMutableArray *localConfig;
    int loadFailCount;
    int currentHotKey;
    ConnectLoadingView *loadingView;
    LandingViewController *landingVC;
    HomeViewController *homeVC;
    
    NSArray *thirdBtnAry;
    
    //--------
    NSString *userID;
    NSString *tempRegEmail;
    
    
    //本頁跳至Config-Macro List 頁面
    CFMainViewController *configMainVC;
    UINavigationController *configMainNav;
    
    TencentOAuth *QQ;

}

// [START viewcontroller_vars]
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;
@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;
@property (weak, nonatomic) IBOutlet UILabel *statusText;
// [END viewcontroller_vars]
@property (weak, nonatomic) IBOutlet UILabel *loginTitle;
@property (weak, nonatomic) IBOutlet UILabel *rememberTitle;

@end

@implementation UserLoginViewController

@synthesize accountTexfield,passwordTextfied,loginIconView,GPBtn,TWBtn,QQBtn,FBBtn,createACBtn,forgotPWBtn,loginBtn,remeberBtn,remeberLabel,createLabel,forgotLabel,configCloseBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    [self initParameter];
    [self initInterface];

    
    [GIDSignIn sharedInstance].clientID = kClientID;
    
    NSLog(@"[GIDSignIn sharedInstance].clientID = %@",[GIDSignIn sharedInstance].clientID);
    
    //
    [self.configCloseBtn addTarget:self action:@selector(jumpToConfigMarcoList) forControlEvents:UIControlEventTouchUpInside ];
    self.configCloseBtn.userInteractionEnabled = NO;
}



- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
    UIActivityIndicatorView *myActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height/2-25, 50, 50)];
    
    [myActivityIndicator stopAnimating];
}

-(void)initParameter{
    remeberMe = NO;
    
    cloudClass = [[FPCloudClass alloc]init];
    
    cloudClass.delegate = self;
    
    codeFile = [[KeyCodeFile alloc] init];
    localConfig = [[ConfigMacroData sharedInstance] getConfigArray];
    
}

-(void)initInterface{
    
    [self setFontForPad:remeberLabel fontSize:12.0
     ];
    
    self.loginTitle.text = NSLocalizedString(@"Login", nil);
    
    self.rememberTitle.text = NSLocalizedString(@"Remember me", nil);
    
    CGFloat leftBar_w = 327/self.imgScale;
    
    //側邊欄
    leftBar = [[mainLeftBar alloc] initWithFrame:CGRectMake(0, 0, leftBar_w, self.view.bounds.size.height) currentPage:MainLoginPage];
    
    leftBar.image = [UIImage imageNamed:@"mainmenu_bg"];
    
    leftBar.mainVC = self;
    
    [self.view addSubview:leftBar];
    
    
    UIColor *color = [UIColor redColor];
    
    CGFloat textFiled_w = self.view.bounds.size.width*0.311;
    
    accountTexfield.frame = CGRectMake(self.view.frame.size.width/2-textFiled_w/2, self.view.bounds.size.height*0.24, textFiled_w, 70/self.imgScale);
    
    accountTexfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"E-mail", nil) attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    accountTexfield.layer.borderColor = [[UIColor colorWithRed:31.0/255.0 green:188.0/255.0 blue:240.0/255.0 alpha:1]CGColor];
    accountTexfield.layer.borderWidth = 1.0f;
    accountTexfield.layer.cornerRadius = 10.0f;
    accountTexfield.layer.masksToBounds = YES;
    accountTexfield.textColor = [UIColor redColor];
    accountTexfield.keyboardType = UIKeyboardTypeURL;
    
    
    passwordTextfied.frame = CGRectMake(self.view.frame.size.width/2-textFiled_w/2, self.view.bounds.size.height*0.36, textFiled_w, 70/self.imgScale);
    
    passwordTextfied.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", nil) attributes:@{NSForegroundColorAttributeName: color,
        NSFontAttributeName:[UIFont systemFontOfSize:17.0]
    }];
    
    passwordTextfied.layer.borderColor = [[UIColor colorWithRed:31.0/255.0 green:188.0/255.0 blue:240.0/255.0 alpha:1]CGColor];
    passwordTextfied.layer.borderWidth = 1.0f;
    passwordTextfied.layer.cornerRadius = 10.0f;
    passwordTextfied.layer.masksToBounds = YES;
    passwordTextfied.textColor = [UIColor redColor];
    
    
    
    loginIconView.frame = CGRectMake(passwordTextfied.frame.origin.x, passwordTextfied.frame.origin.y+passwordTextfied.frame.size.height+10, passwordTextfied.frame.size.width, self.view.bounds.size.height*0.13);
    loginIconView.backgroundColor = [UIColor clearColor];
    
    CGFloat loginIcon_w = 84/self.imgScale;
    CGFloat loginIcon_h = 85/self.imgScale;
    
    thirdBtnAry = [NSArray arrayWithObjects:
                       FBBtn,
                       GPBtn,
                       TWBtn,
                       QQBtn,nil];
    
    float btnSpace = (loginIconView.frame.size.width-loginIcon_w*4)/3;
    
    for (int i=0; i<thirdBtnAry.count; i++) {
        
        UIButton *tmpBtn = [thirdBtnAry objectAtIndex:i];
        
        tmpBtn.frame = CGRectMake(loginIcon_w*i+btnSpace*i, loginIconView.frame.size.height/2-loginIcon_h/2, loginIcon_w, loginIcon_h);
        tmpBtn.enabled = YES;
        
    }
    
    loginBtn.frame = CGRectMake(self.view.frame.size.width/2-self.view.bounds.size.width*0.2/2, self.view.bounds.size.height*0.75, self.view.bounds.size.width*0.2, self.view.frame.size.height*0.11);
    
    loginBtn.layer.borderWidth = 1.0f;
    loginBtn.layer.cornerRadius = 5.0f;
    loginBtn.layer.borderColor = [[UIColor colorWithRed:31.0/255.0 green:188.0/255.0 blue:240.0/255.0 alpha:1]CGColor];
    
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_up"] forState:UIControlStateNormal];
    
    if ([ConfigMacroData sharedInstance].logIn) {
        [loginBtn setTitle:NSLocalizedString(@"Logged in", nil) forState:UIControlStateNormal];
    }else{
        
        [loginBtn setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    }
    
    [loginBtn setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAPI) forControlEvents:UIControlEventTouchUpInside];
    
    loginBtn.enabled = YES;
    
    CGFloat remeberBtn_w = 56/self.imgScale;
    CGFloat remeberBtn_h = 56/self.imgScale;
    
    remeberBtn.frame = CGRectMake(self.view.bounds.size.width*0.41, loginIconView.frame.origin.y+loginIconView.frame.size.height+5, remeberBtn_w, remeberBtn_h);
    
    remeberBtn.enabled = NO;
    
    if (remeberMe) {
        [remeberBtn setBackgroundImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
    }else{
        [remeberBtn setBackgroundImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
    }
    
    remeberLabel.frame = CGRectMake(remeberBtn.frame.origin.x+remeberBtn.frame.size.width+5, remeberBtn.frame.origin.y, self.view.bounds.size.width*0.187, remeberBtn_h);
    
    
    CGFloat creatbtn_w = 111/self.imgScale;
    CGFloat creatbtn_h = 104/self.imgScale;
    
    createACBtn.frame = CGRectMake(self.view.bounds.size.width*0.77, self.view.bounds.size.height*0.55, creatbtn_w, creatbtn_h);
    createACBtn.enabled = YES;
    
    forgotPWBtn.frame = CGRectMake(createACBtn.frame.origin.x+createACBtn.frame.size.width+10, createACBtn.frame.origin.y, creatbtn_w, creatbtn_h);
    forgotPWBtn.enabled = YES;
    
    createLabel.frame = CGRectMake(createACBtn.frame.origin.x, createACBtn.frame.origin.y+createACBtn.frame.size.height-5, creatbtn_w, creatbtn_h);
    
    forgotLabel.frame = CGRectMake(forgotPWBtn.frame.origin.x, createACBtn.frame.origin.y+forgotPWBtn.frame.size.height-5, creatbtn_w, creatbtn_h);
    
    CGFloat configClose_w = 79/self.imgScale;
    CGFloat configClose_h = 80/self.imgScale;
    
    configCloseBtn.frame = CGRectMake(self.view.bounds.size.width*0.138, self.view.frame.size.height*0.86, configClose_w, configClose_h);

    createLabel.text = NSLocalizedString(@"Create\nAccount", nil);
    forgotLabel.text = NSLocalizedString(@"Forgot\nPassword", nil);
    
    [self setFontForPad:createLabel fontSize:9.0];
    [self setFontForPad:forgotLabel fontSize:9.0];
}

-(void)lockLoginBtn{
    
    loginBtn.enabled = NO;
    
    [loginBtn setTitle:NSLocalizedString(@"Logged in", nil) forState:UIControlStateNormal];
    
    for (int i=0; i<thirdBtnAry.count; i++) {
        UIButton *tempBtn = [thirdBtnAry objectAtIndex:i];
        tempBtn.enabled = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [ProtocolDataController sharedInstance].connectStateDelegate = self;
    [ProtocolDataController sharedInstance].dataResponseDelegate = self;
    
    [[ProtocolDataController sharedInstance] startListeningResponse];
    
    if ([ConfigMacroData sharedInstance].logIn) {
        [loginBtn setTitle:NSLocalizedString(@"Logged in", nil) forState:UIControlStateNormal];
        [self lockLoginBtn];
    }else{
        
        [loginBtn setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    }
    
    [self.view bringSubviewToFront:self.configCloseBtn];
    
}

#pragma mark - Touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [accountTexfield resignFirstResponder];
    [passwordTextfied resignFirstResponder];
}

#pragma mark - Button Actions
- (IBAction)loginFB:(id)sender {
    
    NSLog(@"loginFB");
    
    if (![CheckNetwork isExistenceNetwork]) {
        [self showAlert:NSLocalizedString(@"Connect fail", nil) message:NSLocalizedString(@"Please check your wifi", nil)];
        
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBLogin" object:nil];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc]init];
    
    [login logInWithReadPermissions:@[@"public_profile",@"email"] fromViewController:nil
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if(error){
                                    NSLog(@"Process error,%@",error);
                                }else if(result.isCancelled){
                                    NSLog(@"Cancelled,%@",error);
                                }else if([[FBSDKAccessToken currentAccessToken] hasGranted:@"email"]){
                                    
                                    NSDictionary *para = @{@"fields":@"id, name, first_name, last_name, picture.type(large),email"};
                                    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:para];
                                    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                        if(error == nil)
                                        {
                                            NSLog(@"result = %@",result);
                                            
                                            NSString *commType = @"1";
                                            NSString *email = [result objectForKey:@"email"];
                                            NSString *name = [result objectForKey:@"name"];
                                            
                                            name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
                                            
                                            NSLog(@"name ========> %@",name);
                                            
                                            NSString *commid = [result objectForKey:@"id"];
                                            
                                            NSString *ts = [ShareCommon getTimestamp];
                                            
                                            //簽名 MD5(commid+commtype+KEY+時間戳)

                                            NSString *sn = [ShareCommon md5:[NSString stringWithFormat:@"%@%@%@%@",commid,commType,kAPIKey,ts]];
                                            
                                            NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                      email,@"email",
                                                                      name,@"name",
                                                                      commid,@"commid",
                                                                      @"",@"commtoken",
                                                                      commType,@"commtype",
                                                                      
                                                     ts,@"ts",
                                                     sn,@"sn", nil];
                                            
                                            NSLog(@"<<<<sendParam>>>> = %@",sendParam);
                                            
                                            int eventid = CloudAPIEvent_commlogin;
                                            
                                            [cloudClass postDataSync:sendParam APIName:kAPI_commlogin EventId:eventid];
                                        }
                                        else
                                        {
                                            NSLog(@"FBLogin Fail");
                                            
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/login"]];
                                            
                                            
                                        }
                                    }];
                                    
                                }
                            }];

}

- (IBAction)loginGooglePlus:(id)sender {
    
    NSLog(@"loginGooglePlus");
    
    if (![CheckNetwork isExistenceNetwork]) {
        [self showAlert:NSLocalizedString(@"Connect fail", nil) message:NSLocalizedString(@"Please check your wifi", nil)];
        
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoogleLogin" object:nil];

    GIDSignIn* signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.delegate = self;
    signIn.uiDelegate = self;
    
    
    [[GIDSignIn sharedInstance] signIn];
    
}

// [START signin_handler]
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    
    NSLog(@"userId = %@",userId);
    NSLog(@"idToken = %@",idToken);
    NSLog(@"fullName = %@",fullName);
    NSLog(@"givenName = %@",givenName);
    NSLog(@"familyName = %@",familyName);
    NSLog(@"email = %@",email);
    
    
    // [START_EXCLUDE]
    NSDictionary *statusText = @{@"statusText":
                                     [NSString stringWithFormat:@"Signed in user: %@",
                                      fullName]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ToggleAuthUINotification"
     object:nil
     userInfo:statusText];
    // [END_EXCLUDE]
    
    NSString *commType = @"3";
    
    NSString *commid = userId;
    
    NSString *ts = [ShareCommon getTimestamp];
    
    NSString *sn = [ShareCommon md5:[NSString stringWithFormat:@"%@%@%@%@",commid,commType,kAPIKey,ts]];
    
    NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      email,@"email",
                                      fullName,@"name",
                                      commid,@"commid",
                                      @"",@"commtoken",
                                      commType,@"commtype",
                                      
                                      ts,@"ts",
                                      sn,@"sn", nil];
    
    [cloudClass postDataSync:sendParam APIName:kAPI_commlogin EventId:CloudAPIEvent_commlogin];
    
}

- (IBAction)loginTwitter:(id)sender {
    
    NSLog(@"loginTwitter");
    
    if (![CheckNetwork isExistenceNetwork]) {
        [self showAlert:NSLocalizedString(@"Connect fail", nil) message:NSLocalizedString(@"Please check your wifi", nil)];
        
        return;
    }
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType options:nil
                                  completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount =[arrayOfAccounts lastObject];
                 
                 
                 NSString *commType = @"2";
                 NSString *email = twitterAccount.username;
                 NSString *name = twitterAccount.userFullName;
                 
                 
                 NSString *commid = ((NSDictionary*)[twitterAccount valueForKey:@"properties"])[@"user_id"];
                 
                 NSString *ts = [ShareCommon getTimestamp];

                 NSString *sn = [ShareCommon md5:[NSString stringWithFormat:@"%@%@%@%@",commid,commType,kAPIKey,ts]];
                 
                 NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                   email,@"email",
                                                   name,@"name",
                                                   commid,@"commid",
                                                   @"",@"commtoken",
                                                   commType,@"commtype",
                                                   
                                                   ts,@"ts",
                                                   sn,@"sn", nil];
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    
                                    [cloudClass postDataSync:sendParam APIName:kAPI_commlogin EventId:CloudAPIEvent_commlogin];
                                    
                                });
                 
             }else{
                 
                 //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://"]];
                 
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/login"]];
                 
             }
             
             
         }else{
             
             NSLog(@"取得Twitter 登入資訊錯誤,請確定有安裝Twitter App");
          
             
             
         }
         
     }];
}

//-(void)twitterLonginAPI{
//    
//    [[Twitter sharedInstance] startWithConsumerKey:@"Y7VZQ9gP97GqPbWeYJoSeoRVY" consumerSecret:@"zgwOFXVrshP877hM5v1eYbqot737JQlhyoQPrwmplktOhqAm9z"];
//    [Fabric with:@[[Twitter sharedInstance]]];
//    
//    [[Twitter sharedInstance] logInWithMethods:TWTRLoginMethodWebBased completion:^(TWTRSession *session, NSError *error) {
//        if(session){
//            
//            TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
//            NSURLRequest *request = [client URLRequestWithMethod:@"GET"
//                                                             URL:@"https://api.twitter.com/1.1/account/verify_credentials.json"
//                                                      parameters:@{@"include_email": @"true", @"skip_status": @"true"}
//                                                           error:nil];
//            
//            [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                
//                if(connectionError == nil)
//                {
//                    NSDictionary *jason = [NSJSONSerialization
//                                           JSONObjectWithData:data
//                                           options:NSJSONReadingAllowFragments
//                                           error:nil];
//                    NSString *str = [jason objectForKey:@"email"];
//                    if(str == NULL)
//                        str = @"無法取得E-mail";
//                    NSLog(@"str = %@s",str);
//                }
//            }];
//        }
//    }];
//}


- (IBAction)loginQQ:(id)sender {
    NSLog(@"loginQQ");
    
    if (![CheckNetwork isExistenceNetwork]) {
        [self showAlert:NSLocalizedString(@"Connect fail", nil) message:NSLocalizedString(@"Please check your wifi", nil)];
        
        return;
    }
    
    QQ = [[TencentOAuth alloc] initWithAppId:@"1105781582" andDelegate:self];
    
    
    NSArray *permisions = [NSArray arrayWithObjects:@"get_user_info",@"add_share", nil];
    
    [QQ authorize:permisions inSafari:NO];
    
    
}

#pragma mark - QQProtocol
-(void)tencentDidLogin {
    
    if (QQ.accessToken && 0 != [QQ.accessToken length]) {
        
        NSLog(@"QQ用戶 OpenId:%@",QQ.openId);
        
        [QQ getUserInfo];
        
    }
    else {
        
        NSLog(@"QQ 登入失敗");
    }
}

-(void)getUserInfoResponse:(APIResponse *)response {
    
    NSLog(@"QQ response:%@",response.jsonResponse);
    
    NSString *QQ_nickName = [response.jsonResponse objectForKey:@"nickname"];
    
    NSString *commType = @"3";
    NSString *email = @"";
    NSString *name = QQ.openId;
    
    NSString *commid = QQ_nickName;
    
    NSString *ts = [ShareCommon getTimestamp];
    
    NSString *sn = [ShareCommon md5:[NSString stringWithFormat:@"%@%@%@%@",commid,commType,kAPIKey,ts]];
    
    NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      email,@"email",
                                      name,@"name",
                                      commid,@"commid",
                                      @"",@"commtoken",
                                      commType,@"commtype",
                                      ts,@"ts",
                                      sn,@"sn", nil];
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       
                       [cloudClass postDataSync:sendParam APIName:kAPI_commlogin EventId:CloudAPIEvent_commlogin];
                       
                   });

}


- (IBAction)remeberMeAction:(id)sender {
    
    if (remeberMe) {
        [remeberBtn setBackgroundImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
    }else{
        [remeberBtn setBackgroundImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
    }
    
    remeberMe = !remeberMe;
}

- (IBAction)loginEmail:(id)sender {
    
    if (![self NSStringIsValidEmail:accountTexfield.text]) {
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"E-mail incorrect", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Comfirm", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertView addAction:okAction];
        
        [self presentViewController:alertView animated:YES completion:nil];
    }
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

- (IBAction)createAccount:(id)sender {
    loginAlert = [[loginPageAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) andAlertStyle:CreateAccount];
    
    loginAlert.delegate = self;
    
    [self.view addSubview:loginAlert];
}
- (IBAction)forgotPassword:(id)sender {
    loginAlert = [[loginPageAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) andAlertStyle:ForgotPassword];
    
    loginAlert.delegate = self;
    
    [self.view addSubview:loginAlert];
}

-(void)returnRegistData:(NSString *)account password:(NSString *)password confirmPwd:(NSString *)confirmPwd{
    
    int eventid = CloudAPIEvent_register;
    
    NSString *email = account;
    NSString *pass = password;
    tempRegEmail = account;
    //NSString *nickname = @"";
    NSString *ts = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSString *sn = [NSString stringWithFormat:@"%@%@%@%@",email,password,kAPIKey,ts];
    
    sn = [ShareCommon md5:sn];
    
    NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      email,@"email",
                                      pass,@"pass",
                                      ts,@"ts",
                                      sn,@"sn",nil];
    
    NSLog(@"sendParam = %@",sendParam);
    
    [cloudClass postDataSync:sendParam APIName:kAPI_register EventId:eventid];
    
}

-(void)loginAPI{

    int eventid = CloudAPIEvent_login;
    
    NSString *email = accountTexfield.text;
    NSString *pass = passwordTextfied.text;
    
    NSString *ts = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSString *sn = [NSString stringWithFormat:@"%@%@%@%@",email,pass,kAPIKey,ts];
    
    sn = [ShareCommon md5:sn];
    
    NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      email,@"email",
                                      pass,@"pass",
                                      ts,@"ts",
                                      sn,@"sn",nil];
    
    NSLog(@"sendParam = %@",sendParam);
    
    [cloudClass postDataSync:sendParam APIName:kAPI_login EventId:eventid];
}

-(void)returnForgotPwdData:(NSString *)email{
    
    /*
     email(string) 個人郵件 必填
     
     ts(int) 現在時間戳(timestamp) 必填
     
     sn(string) 簽名 MD5(個人郵件+KEY+時間戳)
     */
    
    int eventid = CloudAPIEvent_forgetpwd;
    
    NSString *emailStr = email;
    
    NSString *ts = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSString *sn = [NSString stringWithFormat:@"%@%@%@",emailStr,kAPIKey,ts];
    
    sn = [ShareCommon md5:sn];
    
    NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      emailStr,@"email",
                                      ts,@"ts",
                                      sn,@"sn",nil];
    
    NSLog(@"sendParam = %@",sendParam);
    
    [cloudClass postDataSync:sendParam APIName:kAPI_forgetpwd EventId:eventid];
}

#pragma mark - FPCloudResponse Delegate
-(void)FPCloudResponseData:(NSURLResponse *)response Data:(NSData *)data Error:(NSError *)error EventId:(int)eventid{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       
                       if(data==nil)
                       {
                           NSLog(@"Error:%@",error.description);
                           
                           return ;
                       }
                       
                       NSError *jsonError;
                       
                       NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
                       
                       switch (eventid) {
                               
                           case CloudAPIEvent_register:
                           {
                               [self processRegApi:responseData error:jsonError];
                           }
                               
                               break;
                           case CloudAPIEvent_login:
                           {
                               [self processLogin:responseData error:jsonError];
                           }
                               
                               break;
                           case CloudAPIEvent_commlogin:
                           {
                               [self processCommLoginApi:responseData error:error];
                           }
                               
                               break;
                               
                           case CloudAPIEvent_forgetpwd:
                           {
                               [self processForgotPwdApi:responseData error:jsonError];
                           }
                               
                               break;
                               
                           default:
                               break;
                       }
                       
                   });
}

-(void)processCommLoginApi:(NSDictionary *)responseData error:(NSError*)jsonError{
    
    NSNumber *code = [responseData objectForKey:@"ret"];
    
    if (code.intValue == 0) {
        
        NSLog(@"Comm responseData = %@",responseData);
        
        userID = [responseData objectForKey:@"uid"];
        
        [ConfigMacroData sharedInstance].uid = userID;
        
        [ConfigMacroData sharedInstance].logIn = YES;
        
        if([responseData objectForKey:@"nickname"]){
            [ConfigMacroData sharedInstance].userName = [responseData objectForKey:@"nickname"];
        }
        
        if([responseData objectForKey:@"name"]){
            [ConfigMacroData sharedInstance].userName = [responseData objectForKey:@"name"];
        }
        
        
        NSLog(@"[ConfigMacroData sharedInstance].userName = %@",[ConfigMacroData sharedInstance].userName);
        
        NSLog(@"[ConfigMacroData sharedInstance].userID = %@",[ConfigMacroData sharedInstance].uid);
        
        /*
         Comm responseData = {
         key = j889I2rWJ4cLFyS4;
         msg = "Login successful";
         nickname = Rex;
         ret = 0;
         uid = 909943542;
         }
         */
        
        [self showAlert:NSLocalizedString(@"Login Success", nil) message:@""];
        
        [ConfigMacroData sharedInstance].logIn = YES;
        
        [self lockLoginBtn];
        
    }else{
        
        NSLog(@"jsonError = %@",jsonError);
        [self showAlert:NSLocalizedString(@"Login Fail", nil) message:@""];
    }
    
}

-(void)processRegApi:(NSDictionary *)responseData error:(NSError*)jsonError{
    
    NSNumber *code = [responseData objectForKey:@"ret"];
    
    if((![code isEqual:[NSNull null]]) && (code.intValue==0))
    {
        
        NSLog(@"Success");
        NSString *key = [responseData objectForKey:@"key"];
        NSString *msg = [responseData objectForKey:@"msg"];
        userID = [responseData objectForKey:@"uid"];
        
        //[ConfigMacroData sharedInstance].uid = userID;
        
        loginAlert.registedEmail = tempRegEmail;
        
        [loginAlert showRegSuccessAlert];
        
    }else{
        
        [self showAlert:NSLocalizedString(@"Regist Fail", nil) message:@""];
        NSLog(@"Failed");
    }
    
    NSLog(@"responseData = %@",responseData);

}

//MARK Regist response alert delegate
-(void)shouldAgreeTerm:(NSString *)reason{
    [self showAlert:reason message:@""];
}

-(void)shouldEnterRightEmail:(NSString *)reason{
    [self showAlert:reason message:@""];
}

-(void)shouldEnterRightPassword:(NSString *)reason{
    [self showAlert:reason message:@""];
}

-(void)processLogin:(NSDictionary *)responseData error:(NSError*)jsonError{
    
    
    NSNumber *code = [responseData objectForKey:@"ret"];
    
    if (code.intValue == 0) {
        NSString *key = [responseData objectForKey:@"key"];
        NSString *nickname = [responseData objectForKey:@"nickname"];
        
        NSNumber *uid = [responseData objectForKey:@"uid"];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:key,nickname,uid, nil];
        
        userID = [NSString stringWithFormat:@"%d",uid.intValue];
        
        [ConfigMacroData sharedInstance].logIn = YES;
        
        NSLog(@"userID = %@,array = %@",userID,array);
        //NSLog(@"responseData = %@",array);
        
        
    }else{
        
        NSString *msg = [responseData objectForKey:@"msg"];
        
        [self showAlert:NSLocalizedString(@"Log in fail", nil) message:msg];
    }

}

-(void)processForgotPwdApi:(NSDictionary *)responseData error:(NSError*)jsonError{
    
    NSNumber *code = [responseData objectForKey:@"ret"];
    
    if (code.intValue == 0) {
        NSLog(@"responseData = %@",responseData);
    }else{
        NSLog(@"jsonError = %@",jsonError);
    }
    /*
     email(string) 個人郵件 必填
     
     ts(int) 現在時間戳(timestamp) 必填
     
     sn(string) 簽名 MD5(個人郵件+KEY+時間戳)
     */
    
    
}

-(void)networkError{
    
    [self showAlert:NSLocalizedString(@"Connect Fail", nil) message:NSLocalizedString(@"Please check your wifi", nil)];
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
    
    [alertView addAction:okAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark protocol delegate
-(void)onConnectionState:(ConnectState)state{
    
    [[ConfigMacroData sharedInstance] changeBLEConnectedState:state];
    
    if(state == Disconnect){
        
        self.configCloseBtn.userInteractionEnabled = NO;
        
        if (landingVC == nil) {
            
            landingVC = (LandingViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LandingVC"];
        }
        
        [appDelegate.window setRootViewController:landingVC];
        
        [appDelegate.window makeKeyAndVisible];
    }
    else if (state == Connected) {
        
        
        self.configCloseBtn.userInteractionEnabled = YES;
    }
}

-(void)startResponseMode{
    
    [[ProtocolDataController sharedInstance] responseMode];
    
}

-(void)onResponseDeviceStatus:(DeviceStatus *)ds{
    
}

-(void)onResponseResponseMode:(int)keyCode{
    //58~65  = F1 ~ F8
    
    if (keyCode == 58 || keyCode == 59 || keyCode == 60 || keyCode == 61 || keyCode == 62 || keyCode == 63 || keyCode == 64 || keyCode == 65) {
        
        loadFailCount = 0;
        for (int i=0; i < localConfig.count; i++) {
            int existHotKey = [[[localConfig objectAtIndex:i] objectForKey:@"configHotKey"] intValue];
            
            if (existHotKey == keyCode) {
                loadFailCount = 0;
                currentHotKey = keyCode;
                [[ProtocolDataController sharedInstance] MacroConfigFunctionSet:keyCode];
                
                
                [loadingView removeFromSuperview];
                loadingView = [[ConnectLoadingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                
                
                [self.view addSubview:loadingView];
                
                break;
            }
        }
    }
    
    if (keyCode == -1 || keyCode == 255 || keyCode == 0){
        return;
    }else{
        
        NSLog(@"%@",[codeFile returnKeyboardKey:keyCode]);
        
    }
}

-(void)onResponseMacroConfigFunctionSet:(bool)isSuccess{
    loadFailCount ++;
    
    if (isSuccess) {
        
        [loadingView removeFromSuperview];
        loadFailCount = 0;
        
        if (homeVC == nil) {
            homeVC = (HomeViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        }
        
        [appDelegate.window setRootViewController:homeVC];
        [appDelegate.window makeKeyAndVisible];
        
    }else{
        if (loadFailCount > 3 ) {
            [loadingView removeFromSuperview];
        }else{
            [[ProtocolDataController sharedInstance] MacroConfigFunctionSet:currentHotKey];
        }
    }
}


#pragma mark - LeftBar Delegate
-(void)DidPressControlButton{
    
    [[ProtocolDataController sharedInstance] stopListeningResponse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 直接跳至 Config-Macro list 頁面
-(void)jumpToConfigMarcoList {
    
    if (configMainVC == nil) {
        
        configMainVC = (CFMainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFMainVC"];
    }
    
    if (configMainNav == nil) {
        
        configMainNav = [[UINavigationController alloc]initWithRootViewController:configMainVC];
    }
    
    configMainVC.isSelectedConfig = YES;
    
    [self presentViewController:configMainNav animated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
