//
//  LandingViewController.m
//  FPSApp
//
//  Created by Rex on 2016/8/5.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "LandingViewController.h"
#import "ConnectLoadingView.h"
#import "HomeViewController.h"
#import "ViewController.h"
#import "KeyCodeFile.h"
#import "ProtocolDataController.h"

@interface LandingViewController (){
    
    ConnectLoadingView *connectingView;
    ProtocolDataController *protocol;
//    NSTimer *scanTimer;
    NSUInteger scanCount;
    HomeViewController *homeVC;
    UIImageView *alertBase;
//    NSTimer *responseTimer;
    KeyCodeFile *keyCodeClass;
    int configIndex;
    int macroIndex;
    UIImageView *launchView;
    
    //LicenseView
    UIView *m_licenseView;
    
}

@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initParameter];
    [self initInterface];

    keyCodeClass = [[KeyCodeFile alloc] init];
}


-(void)initParameter{
    
    [ProtocolDataController sharedInstance].connectStateDelegate = self;
    [ProtocolDataController sharedInstance].dataResponseDelegate = self;
    
    [[ProtocolDataController sharedInstance] enableBluetooth];
    
    configArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    macroArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    scanCount = 0;
    
    configIndex = 0;
    macroIndex = 0;
    

}


-(void)initInterface{
    
    CGFloat w=self.view.frame.size.width;
    CGFloat h=self.view.frame.size.height;
    
    if(h>w)
    {
        CGFloat temp=w;
        w=h;
        h=temp;
        
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    
    connectingView = [[ConnectLoadingView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    
    [connectingView setStatusLabel:NSLocalizedString(@"Sniper Scanning...", nil)];
    
    //NSLog(@"== W:%f,H:%f",self.view.frame.size.width,self.view.frame.size.height);
    connectingView.hidden = YES;
    
    [self.view addSubview:connectingView];
    
    launchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    
    launchView.image = [UIImage imageNamed:@"openingpage_bg_2001x1125"];
    
    [self.view addSubview:launchView];
    
    
    //起始頁面 顯示app版本
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.647, SCREEN_HEIGHT*0.591, SCREEN_WIDTH*0.107, SCREEN_HEIGHT*0.07)];
    
    versionLabel.textAlignment = NSTextAlignmentRight;

    versionLabel.adjustsFontSizeToFitWidth = YES;
    
    versionLabel.text = [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    versionLabel.textColor = [UIColor whiteColor];
    //iPad 3字體太大
    versionLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
    
    [launchView addSubview:versionLabel];
}

-(void)viewDidAppear:(BOOL)animated{
    
    //起始頁面出現 2 秒後
    [self performSelector:@selector(delayCheckLicense) withObject:nil afterDelay:2.0];
    
    //connectingView.hidden = NO;
    
    //[self performSelector:@selector(scanDevice) withObject:nil afterDelay:1];
}


-(void)delayCheckLicense {

    [self checkLicenseAgreement];
    
}


-(void)scanDevice{
    
    //if (scanCount == 1) {
    
    if (launchView != nil) {
        
        [launchView removeFromSuperview];
    }
    
    [connectingView setStatusLabel:NSLocalizedString(@"Sniper Scanning...", nil)];
    [[ProtocolDataController sharedInstance] startScanTimeout:10];
        
//        [scanTimer invalidate];
//        
//        scanTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(scanFailed) userInfo:nil repeats:NO];
    
    //}
    /*
    scanCount++;
    
    if (scanCount <= 7) {
        
        NSLog(@"scanCount = %lu",scanCount);
        
        [[ProtocolDataController sharedInstance] startScanTimeout:10];
        
        [connectingView setStatusLabel:NSLocalizedString(@"FPS Scanning...", nil)];

    }else{
        
        [[ProtocolDataController sharedInstance] stopScan];
        
        [scanTimer invalidate];
        
        [self connectAlertView:NSLocalizedString(@"Write Fail", nil) failReason:NSLocalizedString(@"Bluetooth adapter not enable", nil) buttonType:ConnectFail];
    }
     */
}

-(void)scanFailed{
//    [[ProtocolDataController sharedInstance] stopScan];
    
//    [scanTimer invalidate];
    
    [self connectAlertView:NSLocalizedString(@"Write Failed", nil) failReason:NSLocalizedString(@"Bluetooth not connected", nil) buttonType:ConnectFail];
}

-(void)onConnectionState:(ConnectState)state{
    
    [[ConfigMacroData sharedInstance] changeBLEConnectedState:state];
    
    if (state == Connected) {
        
//        [scanTimer invalidate];
        
        [[ProtocolDataController sharedInstance] loadConfig:configIndex];
//        [[ProtocolDataController sharedInstance] checkDevice];
        
    }else if (state == Disconnect) {
        
        [self connectAlertView:NSLocalizedString(@"Disconnect", nil) failReason:NSLocalizedString(@"Please try again", nil) buttonType:ConnectFail];
        

    }else if (state == ScanFinish) {
        [self scanFailed];
    }else if (state == ConnectTimeout) {
        
    }
}

-(void)onBtStateChanged:(bool)isEnable{
    
}

-(void)onScanResultUUID:(NSString *)uuid Name:(NSString *)name RSSI:(int)rssi{
    
    NSLog(@"onScanResultUUID-----uuid = %@ , name = %@ , rssi = %i", uuid, name, rssi);
    
    //&&[uuid isEqualToString:@"4F846595-3C27-1954-3146-482D838E5453"]
    
    if([name containsString:@"BrookSniper"] || [name containsString:@"AvantCom-BLE"]){
        //&&[uuid isEqualToString:@"A4E5801C-F023-FF46-A5A3-2D4B55F0CE5D"])
    
        [connectingView setStatusLabel:NSLocalizedString(@"Sniper Connecting...", nil)];//Sniper 連接中...
        [[ProtocolDataController sharedInstance] connectUUID:uuid];
    }
    
}


//#pragma mark - ResponseCheckDevice
//-(void)onResponseCheckDevice:(bool)isSuccess{
//    
//    if (isSuccess) {
//        
//        NSLog(@"CheckDevice Succeed");
// 
//        //[responseTimer invalidate];
//        
//        //responseTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startResponseMode) userInfo:nil repeats:YES];
//        
//        [[ProtocolDataController sharedInstance] loadConfig:configIndex];
//        
//        
//    }else{
//        
//        NSLog(@"checkDevice Fail");
//    }
//    
//}


#pragma mark - ResponseLoadConfig
-(void)onResponseLoadConfig:(int)no :(FPSConfigData *)configData{
    
    NSLog(@"configData = %@, no = %d",configData, no);
    
//    if (configIndex < 7) {
//        
//        configIndex++;
//        
//        [[ProtocolDataController sharedInstance] loadConfig:configIndex];
//    }
    
    [connectingView setStatusLabel:NSLocalizedString(@"Sniper Loading Config...", nil)];
    
    
    
    if(configData != nil){
        NSString *configHotKey = [NSString stringWithFormat:@"%d",[configData getConfigHotKey]];
        
        NSString *platform = [NSString stringWithFormat:@"%d",[configData getPlatform]];
        
        NSString *configName = [configData getConfigName];
        
        NSString *LEDColor = [NSString stringWithFormat:@"%d",[configData getLEDColor]];
        
        NSNumber *flagADSToggle = [NSNumber numberWithBool:[configData isFuncFlag_ADSToggle]];
        
        NSNumber *flagShootingSpeed = [NSNumber numberWithBool:[configData isFuncFlag_shootingSpeed]];
        
        NSNumber *flagInvertedYAxis = [NSNumber numberWithBool:[configData isFuncFlag_invertedYAxis]];
        
        NSNumber *flagSniperBreath = [NSNumber numberWithBool:[configData isFuncFlag_sniperBreath]];
        
        NSNumber *flagAntiRecoil = [NSNumber numberWithBool:[configData isFuncFlag_antiRecoil]];
        
        NSNumber *flagADSSync = [NSNumber numberWithBool:[configData isFuncFlag_ADSSync]];
        
        NSString *HIPSensitivity = [NSString stringWithFormat:@"%d",[configData getHIPSensitivity]];
        
        NSString *ADSSensitivity = [NSString stringWithFormat:@"%d",[configData getADSSensitivity]];
        
        NSString *deadZONE = [NSString stringWithFormat:@"%d",[configData getDeadZONE]];
        
        NSString *sniperBreathHotKey = [NSString stringWithFormat:@"%d",[configData getSniperBreathHotKey]];
        
        NSString *antiRecoilHotkey = [NSString stringWithFormat:@"%d",[configData getAntiRecoilHotkey]];
        
        NSString *antiRecoilOffsetValue = [NSString stringWithFormat:@"%d",[configData getAntiRecoilOffsetValue]];
        
        NSString *shootingSpeed = [NSString stringWithFormat:@"%d",[configData getShootingSpeed]];
        
        NSMutableArray *keyMapArray = [[configData getKeyMapArray] mutableCopy];
        
        NSMutableArray *ballisticsArray = [[configData getBallistics] mutableCopy];
        
        NSMutableArray *ballisticChanged = [[configData getBallisticsChanged] mutableCopy];
        
        NSLog(@"======== Landing ballisticChanged = %@ no====>%d",ballisticChanged, no);
        
        NSMutableDictionary *configDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           configHotKey,@"configHotKey",
                                           platform,@"platform",
                                           configName,@"configName",
                                           LEDColor,@"LEDColor",
                                           flagADSToggle,@"flagADSToggle",
                                           flagShootingSpeed,@"flagShootingSpeed",
                                           flagInvertedYAxis,@"flagInvertedYAxis",
                                           flagSniperBreath,@"flagSniperBreath",
                                           flagAntiRecoil,@"flagAntiRecoil",
                                           flagADSSync,@"flagADSSync",
                                           HIPSensitivity,@"HIPSensitivity",
                                           ADSSensitivity,@"ADSSensitivity",
                                           deadZONE,@"deadZONE",
                                           sniperBreathHotKey,@"sniperBreathHotKey",
                                           antiRecoilHotkey,@"antiRecoilHotkey",
                                           antiRecoilOffsetValue,@"antiRecoilOffsetValue",
                                           shootingSpeed,@"shootingSpeed",
                                           keyMapArray,@"keyMapArray",
                                           ballisticsArray,@"ballisticsArray",
                                           ballisticChanged,@"ballisticChanged",nil];
        
        [configArray addObject:configDict];
        
        
    }
    
    if (configIndex == 7 && no == 7) {
        
        [[ConfigMacroData sharedInstance] setConfigArray:configArray];
        
        
        //Rex 換機子 砍圖片
        
//        NSMutableArray *configImgAry = [[ConfigMacroData sharedInstance] getConfigImage];
//        NSMutableArray *configAry = [[ConfigMacroData sharedInstance] getConfigArray];
        
//        if (configImgAry.count != configAry.count) {
//            NSLog(@"Rex 換機子 砍圖片");
//            
//            [configImgAry removeAllObjects];
//            
//            UIImage *img = [UIImage imageNamed:@"platform_a_5_custom_408x408"];
//            
//            NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
//            
//            for (int i = 0; i < configAry.count; i++) {
//                
//                NSString *configHotkey = [NSString stringWithFormat:@"%@",[[configAry objectAtIndex:i] objectForKey:@"configHotKey"]];
//                
//                NSMutableDictionary *configDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                                   configHotkey,@"configHotKey",
//                                                   imgData,@"configImage",nil];
//                
//                [configImgAry addObject:configDict];
//                
//            }
//            
//            [[ConfigMacroData sharedInstance] saveConfigImage:configImgAry];
//        }
        
        for (int i = 0; i < configArray.count; i++) {
            
            NSMutableDictionary *configDictionary = [configArray objectAtIndex:i];
            
            NSString *configName = [configDictionary objectForKey:@"configName"];
            
            NSMutableDictionary *configImgDic = [[ConfigMacroData sharedInstance] getConfigImageKey:configName];
            //如果本機不存在圖片
            if(configImgDic == nil || [configImgDic objectForKey:@"configImage"] == nil){
                NSString *configHotkey = [NSString stringWithFormat:@"%@",[configDictionary objectForKey:@"configHotKey"]];
                UIImage *img = [UIImage imageNamed:@"platform_a_5_custom_408x408"];
                NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
                
                
                NSMutableDictionary *configDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                   configHotkey, @"configHotKey",
                                                   imgData, @"configImage",nil];
                
                [[ConfigMacroData sharedInstance] saveConfigImage:configDict Key:configName];
            }
            
            
            
        }

        [[ProtocolDataController sharedInstance] loadMacro:macroIndex];
    }
    
    if (configIndex < 7) {
        
        configIndex++;
        
        [[ProtocolDataController sharedInstance] loadConfig:configIndex];
    }
    
}


#pragma mark - ResponseLoadMacro
-(void)onResponseLoadMacro:(int)no :(FPSMacroData *)macroData{
    
    NSLog(@"macroData = %@, no = %d",macroData, no);
    
    [connectingView setStatusLabel:NSLocalizedString(@"Sniper Loading Macro...", nil)];
    
    if (macroData != nil) {
        
        NSMutableString *macroName = [macroData getMacroName];
        
        NSString *macroPlatform = [NSString stringWithFormat:@"%d",[macroData getPlatform]];
        
        NSString *macroHotkey = [NSString stringWithFormat:@"%d",[macroData getHotkey]];
        
        NSMutableArray *macroKeyArr = [[macroData getKeyArr] mutableCopy];
        
        NSMutableArray *macroDelayArr = [[macroData getDelayArr] mutableCopy];
        
        NSMutableDictionary *macroDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          macroName,@"macroName",
                                          macroPlatform,@"macroPlatform",
                                          macroHotkey,@"macroHotkey",
                                          macroKeyArr,@"macroKeyArr",
                                          macroDelayArr,@"macroDelayArr",nil];
        
        [macroArray addObject:macroDict];
    }
    
    if (macroIndex == 7 && no == 7){
        
        [[ConfigMacroData sharedInstance] setMacroArray:macroArray];
        
        [self presentHomeVC];
    }
    
    if (macroIndex < 7) {
        
        macroIndex++;
        
        [[ProtocolDataController sharedInstance] loadMacro:macroIndex];
    }
}



-(void)presentHomeVC{
    
    if (homeVC == nil) {
        
        homeVC = (HomeViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    }
        
    [self presentViewController:homeVC animated:NO completion:nil];
    
    [appDelegate.window setRootViewController:homeVC];
    
    [appDelegate.window makeKeyAndVisible];
}

-(void)connectAlertView:(NSString *)failTitle failReason:(NSString *)reason buttonType:(AlertButtonType)type{
    
    alertBase = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    alertBase.image = [UIImage imageNamed:@"bg_warning_a_1"];
    alertBase.backgroundColor = [UIColor blackColor];
    alertBase.userInteractionEnabled = YES;
    
    UIImageView *alertImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:alertBase];
    
    alertImg.image = [UIImage imageNamed:@"bg_warning_a_icon_all"];
    
    float labelWidth = 732/self.imgScale;
    float labelHeight = 99/self.imgScale;
    
    UILabel *failLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-labelWidth/2, self.view.frame.size.height*0.353, labelWidth, labelHeight)];
    
    failLabel.text = failTitle;
    failLabel.textColor = [UIColor whiteColor];
    failLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:32.0];
    failLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *failReason = [[UILabel alloc] initWithFrame:CGRectMake(failLabel.frame.origin.x, failLabel.frame.origin.y+failLabel.frame.size.height, failLabel.frame.size.width, failLabel.frame.size.height)];
    
    failReason.text = reason;
    failReason.textColor = [UIColor whiteColor];
    failReason.font = [UIFont systemFontOfSize:15.0];
    failReason.textAlignment = NSTextAlignmentCenter;
    
    float alertBtnWidth = 255/self.imgScale;
    float alertBtnheight = 108/self.imgScale;
    
    switch (type) {
        case ConnectFail:{
            UIButton *retryBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-alertBtnWidth-2, self.view.frame.size.height*0.76, alertBtnWidth, alertBtnheight)];
            
            [retryBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_a_up"] forState:UIControlStateNormal];
            [retryBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_a_down"] forState:UIControlStateHighlighted];
            [retryBtn setTitle:NSLocalizedString(@"Retry", nil) forState:UIControlStateNormal];
            [retryBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [retryBtn addTarget:self action:@selector(retryBtnAction) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2+2, self.view.frame.size.height*0.76, alertBtnWidth, alertBtnheight)];
            
            [skipBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_a_up"] forState:UIControlStateNormal];
            [skipBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_a_down"] forState:UIControlStateHighlighted];
            [skipBtn setTitle:NSLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
            [skipBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [skipBtn addTarget:self action:@selector(skipBtnAction) forControlEvents:UIControlEventTouchUpInside];
            
            [alertBase addSubview:retryBtn];
            [alertBase addSubview:skipBtn];
        }
            break;
        case Overwrite:{
            
            UIButton *overWriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-alertBtnWidth/2, self.view.frame.size.height*0.76, alertBtnWidth, alertBtnheight)];
            
            [overWriteBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_a_up"] forState:UIControlStateNormal];
            [overWriteBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_a_down"] forState:UIControlStateHighlighted];
            [overWriteBtn setTitle:@"OK" forState:UIControlStateNormal];
            [overWriteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [overWriteBtn addTarget:self action:@selector(overWriteBtnAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:overWriteBtn];
        }
            
            break;
        default:
            break;
    }
    
    
    
    [alertBase addSubview:alertImg];
    [alertBase addSubview:failLabel];
    [alertBase addSubview:failReason];
}




#pragma mark - AlertBtn action
-(void)retryBtnAction{
    
    [alertBase removeFromSuperview];
    
    scanCount = 0;
    
    [self scanDevice];
}

-(void)skipBtnAction{
    
    [alertBase removeFromSuperview];
    
    [self presentHomeVC];
    
}

-(void)overWriteBtnAction{
    
    [alertBase removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LicenseView
-(void)showLicenseView {
    
    CGFloat w=self.view.frame.size.width;
    CGFloat h=self.view.frame.size.height;
    
    if(h>w) {
        
        CGFloat temp=w;
        w=h;
        h=temp;
    }

    
    //m_licenseView
    m_licenseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    [self.view addSubview:m_licenseView];
    
    //licenseBg
    UIImageView *licenseBg = [[UIImageView alloc] initWithFrame:m_licenseView.frame];
    licenseBg.image = [UIImage imageNamed:@"mainpage_bg_2001x1125"];
    [m_licenseView addSubview:licenseBg];
    
    
    CGFloat textViewHeight = h*0.8;
    
    //合約內容背景
    UIImageView *textViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1.33*textViewHeight, textViewHeight)];
    textViewBg.image = [UIImage imageNamed:@"bg_wordsquare_1_a_red_1.png"];
    textViewBg.center = CGPointMake(w/2, h/2);
    textViewBg.userInteractionEnabled = YES;
    [m_licenseView addSubview:textViewBg];
    
    //
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, textViewBg.frame.size.width*0.85, textViewBg.frame.size.height*0.8)];
    scrollView.center = CGPointMake(textViewBg.frame.size.width/2, textViewBg.frame.size.height/2);
    scrollView.backgroundColor = [UIColor clearColor];
    [textViewBg addSubview:scrollView];
    
    
    //合約標題
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, scrollView.frame.size.width, scrollView.frame.size.height/10)];
    titleLabel.text = NSLocalizedString(@"APP SOFTWARE LICENSE AGREEMENT", nil);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [scrollView addSubview:titleLabel];

    
    
    //
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 10, scrollView.frame.size.width, scrollView.frame.size.height)];
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:12.0];
    NSString *contentText = @"This App Software License Agreement (the “Agreement”) is made by and between Zeroplus Technology Co., LTD., a Taiwan company, with offices at 3F., No.123, Jian 8th Rd., Zhonghe Dist., New Taipei City on behalf of it and the company or entity downloading, installing and/or using certain of Zeroplus’ Licensed Property(“Customer”). This Agreement is effective immediately upon installation of the Licensed Property (the “Effective Date”).\n\nEnd User License Agreement \nWhenever you download or use any APP published by Zeroplus, this End User License Agreement (“License”) applies to you. By downloading and/or using an App, you are agreeing to this License. If you don’t agree with any of these terms, you cannot download or use our Apps. \n\n1. Changes to this License \nWe reserve the right to change all or part of the License at any time. If we do that, we will post the changed terms to the same web page as the old terms. IF YOU CONTINUE TO USE AN APP AFTER WE POST CHANGED TERMS, THAT USE WILL CONSTITUTE YOUR ACCEPTANCE OF THE CHANGED TERMS. \n\n2. Changes to the Apps, Services and/or Fees \nWe are constantly evolving our products. This means we may change or discontinue an App (and/or our website and any of our other services) without notice or liability to you. We may decide to charge (or charge more) for an App and/or services that integrate with an App. \n\n3. License Grant \nSubject to the restrictions this License, Zeroplus grants you a non-exclusive, non-transferable, non-sublicensable, limited license to download, install and use in object code form a single copy of the App on each of your devices (e.g., your mobile phone, PDA, computer). Any attempt to use the App other than as permitted by this License will immediately terminate the license. \n 2/7 Except for the rights explicitly granted in this License, Zeroplus retains all right, title and interest (including all intellectual property rights) in the Apps, including the copies of the App on your devices. Zeroplus may use third-party software that is subject to open source and/or third-party license terms. You are subject to those terms. \n\n4. License Restrictions \nYou may not: \n• rent, lease, sublicense, sell, assign, loan, or otherwise transfer the App, your copy of the App or any of your rights and obligations under this License; \n• remove or destroy any copyright notices or other proprietary markings on the App; \n• reverse engineer, decompile, disassemble, modify or adapt the App, merge the App into another program, or create derivative works of the App; \n• use the App in any unlawful manner, for any unlawful purpose, or in any manner inconsistent with this License. \n\n5. Termination \nThis License will terminate automatically upon the earlier of: (a) your failure to comply with any term of this License (whether or not we inform you of this termination); (b) you deleting the App(s) from your devices; and (c) if your are using the App(s) in connection with a paid service, the end of the time period specified at time of purchase. In addition, Zeroplus may terminate this License at any time, for any reason or no reason. If this License terminates, you must stop using the App(s) and delete them from your devices. \n\n6. Compliance \nYou are solely responsible for compliance with any applicable laws and regulations and your own contractual obligations to third parties. \n\n7. Privacy policy \nIf you download and/or use an App, you are subject to our privacy policy which we will use data/information you provide us to our related services only. \n\n8. Transmission of Data/Updates \nUse of an App may involve the transmission of data over the Internet to Zeroplus and to and from third parties. If you elect to receive automatic updates, we will push updates to your devices but we will always notify you first. \n\n9. Trademarks \nCertain of the product and service names used in this License and in the App may constitute trademarks of Zeroplus or third parties. You are not authorized to use any such trademarks. All trademarks are the property of their respective owners. \n\n10. Miscellaneous \nThe Terms and this License are the entire agreement between you and Zeroplus relating to the Apps and they supersede all prior oral or written communications and representations with respect to any App or any other subject matter covered by this License.\n\n";
    
    CGSize textLableSize = [contentText sizeWithFont:textLabel.font constrainedToSize:CGSizeMake(textLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    [textLabel setFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 10, scrollView.frame.size.width, textLableSize.height)];
    textLabel.text = contentText;
    [scrollView addSubview:textLabel];

    
    //Bt size 相關
    NSString *btUpImgStr = @"btn_blue_a_up";
    NSString *btDownStr = @"btn_blue_a_down";
    CGFloat btWidth = (scrollView.frame.size.width/2)*0.6;
    CGFloat btHeight = btWidth/2;
    
    
    //acceptBt
    UIButton *acceptBt = [[UIButton alloc] initWithFrame:CGRectMake(scrollView.frame.size.width/2 - btWidth - 15,CGRectGetMaxY(textLabel.frame) + 10, btWidth, btHeight)];
    [acceptBt setTitle:@"Accept" forState:UIControlStateNormal];
    [acceptBt setBackgroundImage:[UIImage imageNamed:btUpImgStr] forState:UIControlStateNormal];
    [acceptBt setBackgroundImage:[UIImage imageNamed:btDownStr] forState:UIControlStateHighlighted];
    [acceptBt setTitleColor:[UIColor colorWithRed:0.7 green:0.0 blue:0.25 alpha:1.0] forState:UIControlStateNormal];
    [acceptBt addTarget:self action:@selector(acceptLicenseAgreement) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:acceptBt];
    
    
    //declineBt
    UIButton *declineBt = [[UIButton alloc] initWithFrame:CGRectMake( scrollView.frame.size.width/2 + 15, acceptBt.frame.origin.y , btWidth, btHeight)];
    [declineBt setTitle:@"Decline" forState:UIControlStateNormal];
    [declineBt setBackgroundImage:[UIImage imageNamed:btUpImgStr] forState:UIControlStateNormal];
    [declineBt setBackgroundImage:[UIImage imageNamed:btDownStr] forState:UIControlStateHighlighted];
    [declineBt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [declineBt setTitleColor:[UIColor colorWithRed:0.7 green:0.0 blue:0.25 alpha:1.0] forState:UIControlStateNormal];
    [declineBt addTarget:self action:@selector(declineLicenseAgreement) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:declineBt];

    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, titleLabel.frame.size.height + textLableSize.height + acceptBt.frame.size.height + 50);
    
    
}


#pragma mark - 第一次使用 app 或 未接受使用條款同意書
-(void)checkLicenseAgreement{
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *src = [path stringByAppendingString:@"/LicenseAgreement.txt"];

    
    if ([fileManager fileExistsAtPath:src]) {
        //路徑已存在,已接受使用條款同意書
        
        //掃裝置
        connectingView.hidden = NO;
        [self scanDevice];

    }
    else {
        //路徑不存在,未接受使用條款同意書
        //跳出使用條款同意書
        
        [self showLicenseView];
        
    }
    
    
}

#pragma mark - 接受使用條款同意書
-(void)acceptLicenseAgreement {
    
    [NSThread sleepForTimeInterval:0.25];
    
    //儲存路徑
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *src = [path stringByAppendingString:@"/LicenseAgreement.txt"];
    NSData *data = [@"LicenseAgreement" dataUsingEncoding:NSUTF8StringEncoding];
    [fileManager createFileAtPath:src contents:data attributes:nil];
    
    //掃裝置
    connectingView.hidden = NO;
    [self scanDevice];

    
    //隱藏條款同意書
    [m_licenseView removeFromSuperview];
    m_licenseView = nil;

}


#pragma mark - 拒絕使用條款同意書
-(void)declineLicenseAgreement {
    
    //跳出關閉app警式視窗
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Exit BrookSniper?", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];//離開 BrookSniper？
    
    //返回
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Back", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:backAction];
    
    
    //關閉APP
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Exit", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        exit(0);
    }];
    
    [alert addAction:exitAction];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}




@end
