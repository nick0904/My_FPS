//
//  HomeViewController.m
//  FPSApp
//
//  Created by Rex on 2016/6/28.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "HomeViewController.h"
#import "ConnectLoadingView.h"
#import "BtAnimationCurve.h"
#import "ViewController.h"

@interface HomeViewController (){
    
    //ConnectLoadingView *loadingView;
    CFMainViewController *configMainVC;
    UINavigationController *configMainNav;
    UIView *coverView;
    NSTimer *scanDeviceTimer;
    UILabel *msgKeyboard;
    UILabel *msgConnected;
    UILabel *msgHotKey;
    NSMutableArray *localConfig;
    KeyCodeFile *codeFile;              //keycode轉碼
    int loadFailCount;
    int currentHotKey;                  //使用中Config Hotkey
    int currentConfigIndex;
    LandingViewController *landingVC;   //Loading首頁
    NSMutableDictionary *usingConfig;   //使用中的Config
    
    //    NSMutableArray *configImgArray;
    //    NSTimer *responseTimer;
    UIImageView *msgImgIcon;               //訊息框手把圖示
    UILabel *keyboardlabel;
    
    //bool isFirstFunctionSet;
}

@property (strong, nonatomic) IBOutlet UIImageView *gameImgView;

@end



@implementation HomeViewController

@synthesize mainBg,configImg,animationImgView,mainConfigTitle,scanDeviceImgView,lineOne,lineTwo,systemMsg,logMsgTextField,keyboardIcon,F2Label,deviceImg,joystickImg,keyboardImg,mouseImg;//,leftBar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initParameter];
    
    coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2000, 2000)];
    
    coverView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:coverView];
    [self.view bringSubviewToFront:coverView];
}
  
-(void)initParameter{
    
}

-(void)onBtStateChanged:(bool)isEnable{
    
}

-(void)initInterface{
    
    //底圖
    mainBg.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    CGFloat leftBar_w = 327/self.imgScale;
    
    
    //側邊欄
    if (leftBar == nil) {
        leftBar = [[mainLeftBar alloc] initWithFrame:CGRectMake(0, 0, leftBar_w, self.view.bounds.size.height) currentPage:MainHomePage];
        
        leftBar.image = [UIImage imageNamed:@"mainmenu_bg"];
        
        leftBar.mainVC = self;
        
        leftBar.delegate = self;
        
        [self.view addSubview:leftBar];
    }
    

    
    CGFloat arrow_w = 149/self.imgScale;
    CGFloat arrow_h = 40/self.imgScale;
    
    
    //箭頭動畫
    animationImgView.frame = CGRectMake(self.view.frame.size.width*0.21, self.view.bounds.size.height*0.24, arrow_w, arrow_h);
    
    mainConfigTitle.frame = CGRectMake(self.view.bounds.size.width/2-self.view.bounds.size.width*0.539/2, self.view.bounds.size.height*0.05, self.view.bounds.size.width*0.539, self.view.bounds.size.height*0.066);
    
    mainConfigTitle.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    
    
    CGFloat redLine_w = 330/self.imgScale;
    CGFloat redLine_h = 50/self.imgScale;
    
    
    //紅色裝飾線
    lineOne.frame = CGRectMake(self.view.bounds.size.width/2-redLine_w, mainConfigTitle.frame.origin.y+mainConfigTitle.frame.size.height+5, redLine_w, redLine_h);
    
    lineTwo.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height*0.43, redLine_w, redLine_h);
    
    CGFloat keyboardIcon_w = 40/self.imgScale;
    CGFloat keyboardIcon_h = 37/self.imgScale;
    
    
    //鍵盤按鈕圖示
    keyboardIcon.frame = CGRectMake(configImg.frame.origin.x+configImg.frame.size.width, lineTwo.frame.origin.y-keyboardIcon_h-5, keyboardIcon_w, keyboardIcon_h);
    
    [self setFrameToFitPad:keyboardIcon OriginXoffset:5 OriginYoffset:0];
    
    F2Label.frame = CGRectMake(keyboardIcon.frame.origin.x+keyboardIcon.frame.size.width+5, keyboardIcon.frame.origin.y, keyboardIcon_w, keyboardIcon_h);
    
    [self setFontForPad:F2Label fontSize:12.0];
    
    CGFloat deviceImg_w = 320/self.imgScale;
    CGFloat deviceImg_h = 323/self.imgScale;
    
    
    //右上掃瞄裝置圖示
    scanDeviceImgView.frame = CGRectMake(self.view.bounds.size.width-deviceImg_w, 0, deviceImg_w, deviceImg_h);
    
    CGFloat systemMsg_w = 399/self.imgScale;
    CGFloat systemMsg_h = 337/self.imgScale;
    
    
    
    //右下系統log區
    systemMsg.frame = CGRectMake(self.view.bounds.size.width*0.667, lineTwo.frame.origin.y+lineTwo.frame.size.height, systemMsg_w, systemMsg_h);
    
    logMsgTextField.frame = CGRectMake(systemMsg.frame.origin.x+20, systemMsg.frame.origin.y+20, systemMsg_w-40, systemMsg_h-35);
    
    NSArray *arrowImg = @[@"ani_arrow_a_01",
                          @"ani_arrow_a_02",
                          @"ani_arrow_a_03",
                          @"ani_arrow_a_04",
                          @"ani_arrow_a_05",
                          @"ani_arrow_a_06",
                          @"ani_arrow_a_07"];
    
    NSArray *scanImg = @[@"device_ani_a_01",@"device_ani_a_02",@"device_ani_a_03",@"device_ani_a_04",@"device_ani_a_05",@"device_ani_a_06",@"device_ani_a_07",@"device_ani_a_08",@"device_ani_a_09",@"device_ani_a_10",@"device_ani_a_11",@"device_ani_a_12",@"device_ani_a_13",@"device_ani_a_14",@"device_ani_a_15",@"device_ani_a_16",@"device_ani_a_17",@"device_ani_a_18",@"device_ani_a_19",@"device_ani_a_20"];
    
    //箭頭動畫
    [self setAnimation:arrowImg animateImgView:animationImgView duration:2];
    
    //右上掃描動畫
    [self setAnimation:scanImg animateImgView:scanDeviceImgView duration:2];
    
    [self.configBt addTarget:m_btAnimation action:@selector(toConfigPage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.marcoBt addTarget:m_btAnimation action:@selector(toMarcoPage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view bringSubviewToFront:self.configBt];
    
    //[self setBarAnimation];
    
    [coverView removeFromSuperview];
    
    logMsgTextField.text = @"";
    
    if (msgHotKey == nil) {
        msgHotKey = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, logMsgTextField.frame.size.width, logMsgTextField.frame.size.height/6)];
        
        msgHotKey.textColor = [UIColor whiteColor];
        msgHotKey.font = [UIFont systemFontOfSize:12.0];
        msgHotKey.text = NSLocalizedString(@"Hotkey:", nil);
        
        [logMsgTextField addSubview:msgHotKey];
    }
    
    UIView *msgLine;
    
    if (msgLine == nil) {
        msgLine = [[UIView alloc] initWithFrame:CGRectMake(0, msgHotKey.frame.origin.y+msgHotKey.frame.size.height, msgHotKey.frame.size.width, 1)];
        
        //55 181 238
        msgLine.backgroundColor = [UIColor colorWithRed:55/255.0 green:181/255.0 blue:283/255.0 alpha:1];
        
        [logMsgTextField addSubview:msgLine];
    }
    

    
    if (msgConnected == nil) {
        msgConnected = [[UILabel alloc] initWithFrame:CGRectMake(msgHotKey.frame.origin.x, msgLine.frame.origin.y, msgHotKey.frame.size.width, msgHotKey.frame.size.height)];
        
        msgConnected.textColor = [UIColor whiteColor];
        msgConnected.font = [UIFont systemFontOfSize:12.0];
        msgConnected.text = NSLocalizedString(@"Bluetooth disconnected", nil);
        //2016/10/24 如果有沒連到硬體 要顯示 Bluetooth disconnected
        msgConnected.hidden = NO;
        
        msgConnected.adjustsFontSizeToFitWidth = YES;
        [logMsgTextField addSubview:msgConnected];
    }
    

    
    if (msgKeyboard == nil) {
        msgKeyboard = [[UILabel alloc] initWithFrame:CGRectMake(msgHotKey.frame.origin.x, logMsgTextField.frame.size.height-SCREEN_HEIGHT*0.033-5, msgHotKey.frame.size.width, msgHotKey.frame.size.height)];
        
        msgKeyboard.textColor = [UIColor whiteColor];
        msgKeyboard.font = [UIFont systemFontOfSize:12.0];
        msgKeyboard.text = @" ";
        msgKeyboard.numberOfLines = 1;
        msgKeyboard.minimumScaleFactor = 1;
        msgKeyboard.lineBreakMode = NSLineBreakByClipping;
        msgKeyboard.adjustsFontSizeToFitWidth = YES;
        msgKeyboard.frame = CGRectMake(msgKeyboard.frame.origin.x, msgKeyboard.frame.origin.y, msgKeyboard.frame.size.width, msgKeyboard.frame.size.height);
        
        [logMsgTextField addSubview:msgKeyboard];
    }
    

    if (keyboardlabel == nil) {
        keyboardlabel = [[UILabel alloc] initWithFrame:CGRectMake(msgKeyboard.frame.origin.x, msgKeyboard.frame.origin.y-msgKeyboard.frame.size.height-3, msgHotKey.frame.size.width, msgHotKey.frame.size.height)];
        
        keyboardlabel.textColor = [UIColor whiteColor];
        keyboardlabel.font = [UIFont systemFontOfSize:12.0];
        keyboardlabel.text = @"";
        keyboardlabel.adjustsFontSizeToFitWidth = YES;
        [logMsgTextField addSubview:keyboardlabel];
        
    }
    

    float msgIconWidth = 32/self.imgScale;
    float msgIconHeight = 31/self.imgScale;
    
    if (msgImgIcon == nil) {
        msgImgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(msgKeyboard.frame.origin.x+msgKeyboard.frame.size.width+2, msgKeyboard.frame.origin.y-2, msgIconWidth, msgIconHeight)];
        
        //msgImgIcon.image = [UIImage imageNamed:@"config_console_01"];
        msgImgIcon.image = nil;
        
        
        [logMsgTextField addSubview:msgImgIcon];
    }

    
    if ([[ConfigMacroData sharedInstance] BLEConnected]) {
        msgConnected.text = NSLocalizedString(@"Bluetooth connected", nil);
        //2016/10/24 如果有連到硬體 不顯示 Bluetooth connected
        msgConnected.hidden = YES;
        
        
        self.configBt.userInteractionEnabled = YES;
        self.marcoBt.userInteractionEnabled = YES;
        
    }else{
        msgConnected.text = NSLocalizedString(@"Bluetooth disconnected", nil);
        
        //Nick 測試用先打開(YES: 打開, NO:關閉)
        self.configBt.userInteractionEnabled = NO;
        self.marcoBt.userInteractionEnabled = NO;
    }
    
    //mainConfigTitle.text = @" ";

}

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"HomeViewController     viewWillAppear");
    //[self initInterface];
    
    deviceImg.image = nil;
    
    //[scanDeviceTimer invalidate];
    [self cancelTimer];
    
    [ProtocolDataController sharedInstance].connectStateDelegate = self;
    [ProtocolDataController sharedInstance].dataResponseDelegate = self;
    
    //原本line=292有開，可能不小心註解到了---Ting
    [self scanConsole];
    
    codeFile = [[KeyCodeFile alloc] init];
    localConfig = [[ConfigMacroData sharedInstance] getConfigArray];
    
    keyboardlabel.text = @"";
    msgHotKey.text = @" ";
    msgConnected.text = @" ";
    msgKeyboard.text = @" ";
    
    
    //isFirstFunctionSet = YES;
    
    //rex
    scanDeviceTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scanConsole) userInfo:nil repeats:YES];
    
    [[ProtocolDataController sharedInstance] startListeningResponse];
    
    usingConfig = [[ConfigMacroData sharedInstance] getUsingConfig];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self initInterface];
    
    //裝置為ipad時調整
    
    [self setFrameToFitPad:self.configImg OriginXoffset:0 OriginYoffset:0];
    
    [self setFrameToFitPad:self.gameImgView OriginXoffset:0 OriginYoffset:0];
    
    [self setFrameToFitPad:self.configBt OriginXoffset:0 OriginYoffset:0];
    
    [self setFrameToFitPad:self.marcoBt OriginXoffset:0 OriginYoffset:0];
    
    self.gameImgView.frame = CGRectMake(self.gameImgView.frame.origin.x, self.gameImgView.frame.origin.y, self.gameImgView.frame.size.width, self.gameImgView.frame.size.width);
    
    if(IS_IPHONE_6 || IS_IPHONE_6P) {
        
        _gameImgView.layer.cornerRadius = 22;
    }
    else if (IS_IPHONE_5) {
        
        _gameImgView.layer.cornerRadius = 16;
        
    }
    else {
        
        _gameImgView.layer.cornerRadius = 12;
    }
    
    _gameImgView.layer.masksToBounds = YES;

}

-(void)viewWillDisappear:(BOOL)animated {
    NSLog(@"HomeViewController     viewWillDisappear");
    [self cancelTimer];
}

-(void)DidPressControlButton{
    //[scanDeviceTimer invalidate];
    //scanDeviceTimer = nil;
    
    [self cancelTimer];
}


-(void)scanConsole{
   [[ProtocolDataController sharedInstance] getDeviceStatus];
}

-(void)startResponseMode{
    [[ProtocolDataController sharedInstance] responseMode];
}

#pragma  mark - 呼叫Config/Marco
-(void)toConfigPage{
    
//    if (configMainVC == nil) {
//        configMainVC = (CFMainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFMainVC"];
//    }
    
    [self toConfigAndMarcoMainVC:YES];
    
}

-(void)toMarcoPage{

//    if (configMainVC == nil) {
//        configMainVC = (CFMainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFMainVC"];
//    }
    
    [self toConfigAndMarcoMainVC:NO];
    
}

-(void)toConfigAndMarcoMainVC:(bool)isConfig{
    
    if (configMainVC == nil) {
        configMainVC = (CFMainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFMainVC"];
    }
    
    if (configMainNav == nil) {
        configMainNav = [[UINavigationController alloc]initWithRootViewController:configMainVC];
    }
    configMainVC.isSelectedConfig = isConfig;
    
    //[self cancelTimer];
    [self presentViewController:configMainNav animated:YES completion:nil];
    
    
    NSLog(@"toConfigAndMarcoMainVC  configMainVC.isSelectedConfig = %i", configMainVC.isSelectedConfig);
}

- (void)cancelTimer{
    if(scanDeviceTimer != nil){
        [scanDeviceTimer invalidate];
        scanDeviceTimer = nil;
    }
    [[ProtocolDataController sharedInstance] stopListeningResponse];
}

-(void)setAnimation:(NSArray *)sourceImg animateImgView:(UIImageView *)imgView duration:(CGFloat)duration{
    
    NSMutableArray *imageAry = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=0; i<sourceImg.count; i++) {
        
        UIImage *image = [UIImage imageNamed:[sourceImg objectAtIndex:i]];
        
        [imageAry addObject:image];
    }
    
    imgView.animationImages = imageAry;
    
    imgView.animationDuration = duration;
    
    [imgView startAnimating];
}

#pragma mark - Protocal Delegate
-(void)onConnectionState:(ConnectState)state{
    
    [[ConfigMacroData sharedInstance] changeBLEConnectedState:state];
    
    if ([[ConfigMacroData sharedInstance] BLEConnected]) {
        self.configBt.userInteractionEnabled = YES;
        self.marcoBt.userInteractionEnabled = YES;
        msgConnected.text = NSLocalizedString(@"Bluetooth connected", nil);
        //2016/10/24 如果有連到硬體 不顯示 Bluetooth connected
        msgConnected.hidden = YES;
    }
    else{
        [self cancelTimer];
        
        self.configBt.userInteractionEnabled = NO;
        self.marcoBt.userInteractionEnabled = NO;
        self.marcoBt.alpha = 1;
        msgConnected.text = NSLocalizedString(@"Bluetooth disconnected", nil);;
        //2016/10/24 如果有沒連到硬體 要顯示 Bluetooth connected
        msgConnected.hidden = NO;
        
        deviceImg.image = nil;
        //keyboardImg.alpha = 0.2;
        //mouseImg.alpha = 0.2;
        //joystickImg.alpha = 0.2;
        
        if (landingVC == nil) {
            landingVC = (LandingViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LandingVC"];
        }
        
        [appDelegate.window setRootViewController:landingVC];
        
        [appDelegate.window makeKeyAndVisible];

    }
}

- (void)onBtStateEnable:(bool)isEnable{
    
}

-(void)onResponseResponseMode:(int)keyCode{
    //58~65  = F1 ~ F8
    
    //NSLog(@"keyCode=%d",keyCode);
    
    //NSMutableArray *existHotKeyAry = [[ConfigMacroData sharedInstance] getConfigHotKeys];
    
    if (keyCode == 58 || keyCode == 59 || keyCode == 60 || keyCode == 61 || keyCode == 62 || keyCode == 63 || keyCode == 64 || keyCode == 65) {
        
        
        for (int i=0; i < localConfig.count; i++) {
            int existHotKey = [[[localConfig objectAtIndex:i] objectForKey:@"configHotKey"] intValue];
            msgImgIcon.image = nil;
            if (existHotKey == keyCode) {
                loadFailCount = 0;
                currentHotKey = keyCode;
                currentConfigIndex = i;
                [[ProtocolDataController sharedInstance] MacroConfigFunctionSet:keyCode];
                
//                [loadingView removeFromSuperview];
//                loadingView = [[ConnectLoadingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                
                [self checkConfigNameWithKeyCode:keyCode];
                
//                [self.view addSubview:loadingView];
                
                break;
            }
        }
    }
    
    NSString *keyboardTitle = NSLocalizedString(@"Keyboard:", nil);
    NSString *keyboardKey = [codeFile returnKeyboardKey:keyCode];
    NSLog(@"onResponseResponseMode  keyboardKey = %@", keyboardKey);
    
    if(keyCode == 105 || keyCode == 106)
        keyboardTitle = NSLocalizedString(@"Mouse:", nil);
    
    keyboardlabel.text = keyboardTitle;
    
    if (keyCode == -1 || keyCode == 255 || keyCode == 0){
        keyboardlabel.text = @"";
        msgKeyboard.text = @"";
        msgImgIcon.image = nil;
        return;
    }else if(usingConfig.count != 0){
        
        [self showConfigKey:keyCode];
        
    }else{
        msgImgIcon.image = nil;
        
        msgKeyboard.text = keyboardKey;
        
        [self checkConfigNameWithKeyCode:keyCode];
    }
}

-(void)showConfigKey:(int)keycode{
    
    int position = -1;
    
    NSMutableArray *keyMapArray = [usingConfig objectForKey:@"keyMapArray"];
    
    int platform = [[usingConfig objectForKey:@"platform"] intValue];
    
    UIImage *iconImg = nil;
    
    for (int i=0; i<keyMapArray.count; i++) {
        
        int mapKey = [[keyMapArray objectAtIndex:i] intValue];
        
        if (mapKey == keycode) {
            position = i;

        }
    }
    
    NSString *joystickStr = @"";
    
    switch (position) {
        case 0:
            joystickStr = @"D-pad right";
            
            break;
            
        case 1:
            joystickStr = @"D-pad left";
            break;
            
        case 2:
            joystickStr = @"D-pad up";
            break;
            
        case 3:
            joystickStr = @"D-pad down";
            break;
            
        case 4:
            
            if (platform == PLATFORM_PS3) {
                //joystickStr = @"三角";
                iconImg = [UIImage imageNamed:@"config_console_04"];
            }
            
            if (platform == PLATFORM_PS4) {
                //joystickStr = @"三角";
                iconImg = [UIImage imageNamed:@"config_console_04"];
            }
            
            if (platform == PLATFORM_X360) {
                //joystickStr = @"Y";
                iconImg = [UIImage imageNamed:@"config_console_08"];
            }
            
            if (platform == PLATFORM_XBOX1) {
                //joystickStr = @"Y";
                iconImg = [UIImage imageNamed:@"config_console_08"];
            }
            
            
            break;
            
        case 5:
            if (platform == PLATFORM_PS3) {
                //joystickStr = @"圈圈";
                iconImg = [UIImage imageNamed:@"config_console_01"];
            }
            
            if (platform == PLATFORM_PS4) {
                //joystickStr = @"圈圈";
                iconImg = [UIImage imageNamed:@"config_console_01"];
            }
            
            if (platform == PLATFORM_X360) {
                //joystickStr = @"B";
                iconImg = [UIImage imageNamed:@"config_console_07"];
            }
            
            if (platform == PLATFORM_XBOX1) {
                //joystickStr = @"B";
                iconImg = [UIImage imageNamed:@"config_console_07"];
            }
            
            
            break;
            
        case 6:
            
            if (platform == PLATFORM_PS3) {
                //joystickStr = @"方塊";
                iconImg = [UIImage imageNamed:@"config_console_03"];
            }
            
            if (platform == PLATFORM_PS4) {
                //joystickStr = @"方塊";
                iconImg = [UIImage imageNamed:@"config_console_03"];
            }
            
            if (platform == PLATFORM_X360) {
                //joystickStr = @"X";
                iconImg = [UIImage imageNamed:@"config_console_06"];
            }
            
            if (platform == PLATFORM_XBOX1) {
                //joystickStr = @"X";
                iconImg = [UIImage imageNamed:@"config_console_06"];
            }
            
            
            break;
            
        case 7:
            
            if (platform == PLATFORM_PS3) {
                //joystickStr = @"叉叉";
                iconImg = [UIImage imageNamed:@"config_console_02"];
            }
            
            if (platform == PLATFORM_PS4) {
                //joystickStr = @"叉叉";
                iconImg = [UIImage imageNamed:@"config_console_02"];
            }
            
            if (platform == PLATFORM_X360) {
                //joystickStr = @"A";
                iconImg = [UIImage imageNamed:@"config_console_05"];
            }
            
            if (platform == PLATFORM_XBOX1) {
                //joystickStr = @"A";
                iconImg = [UIImage imageNamed:@"config_console_05"];
            }
            
            
            break;
            
        case 8:
            
            if (platform == PLATFORM_PS3) {
                joystickStr = @"L1";
            }
            
            if (platform == PLATFORM_PS4) {
                joystickStr = @"L1";
            }
            
            if (platform == PLATFORM_X360) {
                joystickStr = @"LB";
            }
            
            if (platform == PLATFORM_XBOX1) {
                joystickStr = @"LB";
            }
            
            
            break;
            
        case 9:
            
            if (platform == PLATFORM_PS3) {
                joystickStr = @"R1";
            }
            
            if (platform == PLATFORM_PS4) {
                joystickStr = @"R1";
            }
            
            if (platform == PLATFORM_X360) {
                joystickStr = @"RB";
            }
            
            if (platform == PLATFORM_XBOX1) {
                joystickStr = @"RB";
            }
            
            
            break;
            
        case 10:
            
            if (platform == PLATFORM_PS3) {
                joystickStr = @"L2";
            }
            
            if (platform == PLATFORM_PS4) {
                joystickStr = @"L2";
            }
            
            if (platform == PLATFORM_X360) {
                joystickStr = @"LT";
            }
            
            if (platform == PLATFORM_XBOX1) {
                joystickStr = @"LT";
            }
            
            
            break;
            
        case 11:
            
            if (platform == PLATFORM_PS3) {
                joystickStr = @"R2";
            }
            
            if (platform == PLATFORM_PS4) {
                joystickStr = @"R2";
            }
            
            if (platform == PLATFORM_X360) {
                joystickStr = @"RT";
            }
            
            if (platform == PLATFORM_XBOX1) {
                joystickStr = @"RT";
            }
            
            
            break;
            
        case 12:
            
            joystickStr = @"L3";
            
            break;
            
        case 13:
            
            joystickStr = @"R3";
            
            break;
            
        case 14:
            
            if (platform == PLATFORM_PS3) {
                joystickStr = @"SELECT";
            }
            
            if (platform == PLATFORM_PS4) {
                joystickStr = @"SHARE";
            }
            
            if (platform == PLATFORM_X360) {
                joystickStr = @"Back";
            }
            
            if (platform == PLATFORM_XBOX1) {
                joystickStr = @"VIEW";
            }
            
            
            break;
            
        case 15:
            
            if (platform == PLATFORM_PS3) {
                joystickStr = @"START";
            }
            
            if (platform == PLATFORM_PS4) {
                joystickStr = @"OPTION";
            }
            
            if (platform == PLATFORM_X360) {
                joystickStr = @"START";
            }
            
            if (platform == PLATFORM_XBOX1) {
                joystickStr = @"MENU";
            }
            
            
            break;
            
        case 16:
            
            if (platform == PLATFORM_PS3) {
                joystickStr = @"PS Button";
            }
            
            if (platform == PLATFORM_PS4) {
                joystickStr = @"PS Button";
            }
            
            if (platform == PLATFORM_X360) {
                joystickStr = @"PS Button";
            }
            
            if (platform == PLATFORM_XBOX1) {
                joystickStr = @"Xbox Button";
            }
            
            
            break;
            
        case 17:
            
            if (platform == PLATFORM_PS3) {
               joystickStr = @"Touch Pad";
            }
            
            break;
            
        case 18:
            joystickStr = @"Left stick to right";
            break;
            
        case 19:
            joystickStr = @"Left stick to left";
            break;
            
        case 20:
            joystickStr = @"Left stick to up";
            break;
            
        case 21:
            joystickStr = @"Left stick to down";
            break;
            
        default:
            break;
    }
    
    NSString *keyCodeStr = [codeFile returnKeyboardKey:keycode];
    
    msgKeyboard.text = [NSString stringWithFormat:@"%@ = %@",keyCodeStr,joystickStr];
    
    //[msgKeyboard sizeToFit];
    
    msgKeyboard.frame = CGRectMake(msgKeyboard.frame.origin.x, msgKeyboard.frame.origin.y, msgKeyboard.frame.size.width, msgKeyboard.frame.size.height);
    
    msgImgIcon.frame = CGRectMake(msgKeyboard.frame.origin.x+msgKeyboard.frame.size.width+2, msgKeyboard.frame.origin.y-2, msgImgIcon.frame.size.width, msgImgIcon.frame.size.height);
    
    msgImgIcon.image = iconImg;
    
}

-(void)checkConfigNameWithKeyCode:(int)code{
    
    for (int j=0 ; j<localConfig.count; j++) {
        
        NSDictionary *currentConfig = [localConfig objectAtIndex:j];
        
        NSString *hotKey = [currentConfig objectForKey:@"configHotKey"];
        int configHotkey = [hotKey intValue];
        
        
        NSString *name = [[ConfigMacroData sharedInstance] getConfigName:j];
        NSMutableDictionary *configImgDic = [[ConfigMacroData sharedInstance] getConfigImageKey:name];
        
        int configImgHotkey = [[configImgDic objectForKey:@"configHotKey"] intValue];
        
        
//        NSLog(@"checkConfigNameWithKeyCode-----name = %@", name);
//        NSLog(@"checkConfigNameWithKeyCode-----code = %i", code);
//        NSLog(@"checkConfigNameWithKeyCode-----configHotkey = %i", configHotkey);
//        NSLog(@"checkConfigNameWithKeyCode-----configImgHotkey= %i", configImgHotkey);
        
        if (code == configHotkey) {
            
            mainConfigTitle.text = [currentConfig objectForKey:@"configName"];
        }
        
        if (code == configImgHotkey){
            
            NSData *imgData = [configImgDic objectForKey:@"configImage"];
            
            UIImage *img = [UIImage imageWithData:imgData];
            
            
            if(IS_IPHONE_6 || IS_IPHONE_6P) {
                
                _gameImgView.layer.cornerRadius = 22;
            }
            else if (IS_IPHONE_5) {
                
                _gameImgView.layer.cornerRadius = 16;
                
            }
            else {
                
                _gameImgView.layer.cornerRadius = 12;
            }
            
            self.gameImgView.image = img;
            self.gameImgView.layer.masksToBounds = YES;
            
        }
    }
}

-(void)onResponseDeviceStatus:(DeviceStatus *)ds{
    
    NSLog(@"ds.configHotKey) = %d",ds.configHotKey);
    
    //if(isFirstFunctionSet){
        //需要設定一次才會執行onResponseMacroConfigFunctionSet裡面的方法，取到usingConfig，Config編輯頁面需要load讀取正在執行的config，如果沒有執行這段，取到的usingConfig的configHotKey會是(null)
        
        //isFirstFunctionSet = NO;
        
        int keyCode = ds.configHotKey;
        
        for (int i=0; i < localConfig.count; i++) {
            int existHotKey = [[[localConfig objectAtIndex:i] objectForKey:@"configHotKey"] intValue];
            msgImgIcon.image = nil;
            if (existHotKey == keyCode) {
                loadFailCount = 0;
                currentHotKey = keyCode;
                currentConfigIndex = i;
                
                NSLog(@"onResponseDeviceStatus  onResponseMacroConfigFunctionSet = %d",currentHotKey);
                //設定usingConfig資料
                [self onResponseMacroConfigFunctionSet:YES];
                //反正不執行這個Command硬體也會自動切換
                //[[ProtocolDataController sharedInstance] MacroConfigFunctionSet:keyCode];
                
                break;
            }
        }
        
    //}
    
    
    if (ds.mouse == 1) {
        mouseImg.alpha = 1;
    }else{
        mouseImg.alpha = 0.2;
    }
    
    //NSLog(@"ds.configHotKey = %d",ds.configHotKey);
    if (ds.configHotKey == 255){
        msgHotKey.text = NSLocalizedString(@"Hotkey:", nil);
    }else{
        
        msgHotKey.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Hotkey:", nil),[codeFile returnKeyboardKey:ds.configHotKey]];
        
        [self checkConfigNameWithKeyCode:ds.configHotKey];
        
        //[loadingView removeFromSuperview];
    }
    
    if (ds.keybord == 1) {
        keyboardImg.alpha = 1;
    }else{
        keyboardImg.alpha = 0.2;
    }
    
    
    if (ds.controller >= 1) {
        
        joystickImg.alpha = 1;
        
    }else{
        
        joystickImg.alpha = 0.2;
    }
    
    /**
     *    平台
     *
     *    0 = No Plugin,
     *    1 = ps4, 2=ps3, 3=xbox1, 4=x360
     */
    //int console ;
    
    switch (ds.console) {
        case 0:
            deviceImg.image = nil;
            break;
        case 1:
            deviceImg.image = [UIImage imageNamed:@"device_01_ps4.png"];
            break;
        case 2:
            deviceImg.image = [UIImage imageNamed:@"device_02_ps3"];
            break;
        case 3:
            deviceImg.image = [UIImage imageNamed:@"device_03_xboxone"];
            break;
        case 4:
            deviceImg.image = [UIImage imageNamed:@"device_04_xbox360"];
            break;
        default:
            break;
    }
    
}

-(void)onResponseMacroConfigFunctionSet:(bool)isSuccess{
    
    loadFailCount ++;
    
    if (isSuccess) {
        //改成在onResponseDeviceStatus remove loading view
        //[loadingView removeFromSuperview];
        
        [[ConfigMacroData sharedInstance] saveUsingConfig:[localConfig objectAtIndex:currentConfigIndex]];
        usingConfig = [[ConfigMacroData sharedInstance] getUsingConfig];
        
        NSLog(@"onResponseMacroConfigFunctionSet==>configHotKey==>%@", [usingConfig objectForKey:@"configHotKey"]);
        
        msgHotKey.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Hotkey:", nil),[codeFile returnKeyboardKey:currentHotKey]];
        
        mainConfigTitle.text = [usingConfig objectForKey:@"configName"];
        
        loadFailCount = 0;
    }else{
        if (loadFailCount > 3 ) {
            //[loadingView removeFromSuperview];
        }else{
            [[ProtocolDataController sharedInstance] MacroConfigFunctionSet:currentHotKey];
        }
    }
}

-(void)onResponseMoveMacro:(bool)isSuccess{
    
}

-(void)onResponseMoveConfig:(bool)isSuccess{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
