//
//  AboutViewController.m
//  FPSApp
//
//  Created by Rex on 2016/6/29.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "AboutViewController.h"
#import "ConnectLoadingView.h"
#import "HomeViewController.h"
#import "CFMainViewController.h"

@interface AboutViewController (){
    FPSProtocol *protocol;
    UIButton *updateFirmBtn;
//    NSTimer *responseModeTimer;
    KeyCodeFile * codeFile;
    NSMutableArray *localConfig;
    ConnectLoadingView *loadingView;
    int loadFailCount;
    int currentHotKey;
    LandingViewController *landingVC;
    HomeViewController *homeVC;
    
    //
    CFMainViewController *configMainVC;
    UINavigationController *configMainNav;
}
@property (weak, nonatomic) IBOutlet UILabel *aboutTitle;

@end

@implementation AboutViewController

@synthesize configCloseBtn,brookLogo,logoImgView,appVerView,firmWareVerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.configCloseBtn addTarget:self action:@selector(jumpToConfigMacroList) forControlEvents:UIControlEventTouchUpInside];
    
    self.configCloseBtn.userInteractionEnabled = NO;
    
    [self initParameter];
    [self initInterface];
    
}

-(void)viewWillDisappear:(BOOL)animated {
//    [self cancelTimer];
}

-(void)initParameter{
    
    codeFile = [[KeyCodeFile alloc] init];
    localConfig = [[ConfigMacroData sharedInstance] getConfigArray];
    
}

-(void)initInterface{
    
    CGFloat leftBar_w = 327/self.imgScale;
    
    self.aboutTitle.text = NSLocalizedString(@"About", nil);
    
    //側邊欄
    leftBar = [[mainLeftBar alloc] initWithFrame:CGRectMake(0, 0, leftBar_w, self.view.bounds.size.height) currentPage:MainAboutPage];
    
    leftBar.image = [UIImage imageNamed:@"mainmenu_bg"];
    
    leftBar.mainVC = self;
    
    [self.view addSubview:leftBar];
    
    CGFloat configClose_w = 79/self.imgScale;
    CGFloat configClose_h = 80/self.imgScale;
    
    configCloseBtn.frame = CGRectMake(self.view.bounds.size.width*0.138, self.view.frame.size.height*0.86, configClose_w, configClose_h);
    
    brookLogo.layer.borderWidth = 1.0f;
    brookLogo.layer.cornerRadius = 10.0f;
    brookLogo.layer.borderColor = [[UIColor colorWithRed:18.0/255.0 green:128.0/255.0 blue:164.0/255.0 alpha:1] CGColor];
    brookLogo.backgroundColor = [UIColor colorWithRed:10.0/255.0 green:91.0/255.0 blue:117.0/255.0 alpha:1];
    
    [self setFrameToFitPad:logoImgView OriginXoffset:0 OriginYoffset:0];
    
    UIView *copyRightView = [[UIView alloc] initWithFrame:CGRectMake(logoImgView.frame.origin.x+logoImgView.frame.size.width+20, 0, brookLogo.frame.size.width-logoImgView.frame.size.width-40, brookLogo.frame.size.height*0.25)];
    
    UILabel *copyRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, copyRightView.frame.size.width, copyRightView.frame.size.height)];
    copyRight.numberOfLines = 0;
    copyRight.textColor = [UIColor whiteColor];
    copyRight.text = NSLocalizedString(@"Copyright© Brook Design, LLC. All Rights Reserved", nil);
    
    [self setFontForPad:copyRight fontSize:15.0];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(copyRightView.frame.origin.x, copyRightView.frame.origin.y+copyRightView.frame.size.height, copyRightView.frame.size.width-10, 2)];
    
    lineView1.backgroundColor = [UIColor colorWithRed:120/255.0 green:164/255.0 blue:181/255.0 alpha:1];
    
    appVerView = [[UIView alloc] initWithFrame:CGRectMake(logoImgView.frame.origin.x+logoImgView.frame.size.width+20, copyRightView.frame.origin.y+copyRightView.frame.size.height+1, brookLogo.frame.size.width-logoImgView.frame.size.width-40, brookLogo.frame.size.height*0.25)];
    
    appVerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, appVerView.frame.size.width, appVerView.frame.size.height/3)];
    
    appVerLabel.textColor = [UIColor whiteColor];
    appVerLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"APP Version:", nil),[NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    
    [self setFontForPad:appVerLabel fontSize:12.0];
    
    appLatestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, appVerLabel.frame.origin.x+appVerLabel.frame.size.height, appVerView.frame.size.width, appVerView.frame.size.height/3)];
    
    appLatestLabel.textColor = [UIColor colorWithRed:29.0/255.0 green:179.0/255.0 blue:229.0/255.0 alpha:1];
    appLatestLabel.text = NSLocalizedString(@"Latest", nil);
    
    [self setFontForPad:appLatestLabel fontSize:12.0];
    
    UIButton *updateAppBtn = [[UIButton alloc] initWithFrame:CGRectMake(appVerView.frame.size.width-self.view.bounds.size.width*0.131-10, appVerView.frame.size.height-self.view.bounds.size.height*0.07-5, self.view.bounds.size.width*0.131, self.view.bounds.size.height*0.07)];
    
    [self setFontForPad:updateAppBtn fontSize:12.0];
    
    [updateAppBtn setTitle:NSLocalizedString(@"Update", nil) forState:UIControlStateNormal];
    [updateAppBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_up"] forState:UIControlStateNormal];
    [updateAppBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_down"] forState:UIControlStateHighlighted];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(copyRightView.frame.origin.x, appVerView.frame.origin.y+appVerView.frame.size.height, copyRightView.frame.size.width-10, 2)];
    lineView2.backgroundColor = [UIColor colorWithRed:120/255.0 green:164/255.0 blue:181/255.0 alpha:1];
    
    firmWareVerView = [[UIView alloc] initWithFrame:CGRectMake(logoImgView.frame.origin.x+logoImgView.frame.size.width+20, appVerView.frame.origin.y+copyRightView.frame.size.height+1, brookLogo.frame.size.width-logoImgView.frame.size.width-40, brookLogo.frame.size.height*0.25)];
    
    firmVerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, firmWareVerView.frame.size.width, firmWareVerView.frame.size.height/3)];
    
    firmVerLabel.textColor = [UIColor whiteColor];
    firmVerLabel.text = NSLocalizedString(@"Firmware Version:", nil);
    
    [self setFontForPad:firmVerLabel fontSize:12.0];
    
    firmLatestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, firmVerLabel.frame.origin.x+firmVerLabel.frame.size.height, appVerView.frame.size.width, appVerView.frame.size.height/3)];
    
    firmLatestLabel.textColor = [UIColor colorWithRed:29.0/255.0 green:179.0/255.0 blue:229.0/255.0 alpha:1];
    firmLatestLabel.text = NSLocalizedString(@"Latest", nil);
    
    [self setFontForPad:firmLatestLabel fontSize:12.0];
    
    updateFirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(firmWareVerView.frame.size.width-self.view.bounds.size.width*0.131-10, firmWareVerView.frame.size.height-self.view.bounds.size.height*0.07-5, self.view.bounds.size.width*0.131, self.view.bounds.size.height*0.07)];
    
    [self setFontForPad:updateFirmBtn fontSize:12.0];
    
    [updateFirmBtn setTitle:NSLocalizedString(@"Update", nil) forState:UIControlStateNormal];
    [updateFirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_up"] forState:UIControlStateNormal];
    [updateFirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_down"] forState:UIControlStateHighlighted];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(copyRightView.frame.origin.x, firmWareVerView.frame.origin.y+firmWareVerView.frame.size.height, copyRightView.frame.size.width-10, 2)];
    lineView3.backgroundColor = [UIColor colorWithRed:120/255.0 green:164/255.0 blue:181/255.0 alpha:1];
    
    UIView *contactView = [[UIView alloc] initWithFrame:CGRectMake(logoImgView.frame.origin.x+logoImgView.frame.size.width+20, firmWareVerView.frame.origin.y+firmWareVerView.frame.size.height+1, brookLogo.frame.size.width-logoImgView.frame.size.width-40, brookLogo.frame.size.height*0.25)];
    UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contactView.frame.size.width, contactView.frame.size.height)];
    contactLabel.numberOfLines = 0;
    contactLabel.textColor = [UIColor whiteColor];
    contactLabel.text = NSLocalizedString(@"www.brookaccessory.com\nbrook@brookaccessory.com", nil);
    
    [self setFontForPad:contactLabel fontSize:12.0];
    
    [brookLogo addSubview:copyRightView];
    [copyRightView addSubview:copyRight];
    [brookLogo addSubview:lineView1];
    [brookLogo addSubview:appVerView];
    [appVerView addSubview:appVerLabel];
    [appVerView addSubview:appLatestLabel];
    [appVerView addSubview:updateAppBtn];
    [brookLogo addSubview:lineView2];
    [brookLogo addSubview:firmWareVerView];
    [firmWareVerView addSubview:firmVerLabel];
    [firmWareVerView addSubview:firmLatestLabel];
    [firmWareVerView addSubview:updateFirmBtn];
    [brookLogo addSubview:lineView3];
    [brookLogo addSubview:contactView];
    [contactView addSubview:contactLabel];
    
    
    //Rex 
    updateFirmBtn.enabled = NO;
    updateAppBtn.enabled = NO;
    appVerView.hidden = NO;
    firmWareVerView.hidden = NO;
    updateFirmBtn.hidden = YES;
    updateAppBtn.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSString *fwVersion = [[ProtocolDataController sharedInstance] getFwVersion];
    NSLog(@"fwVersion = %@", fwVersion);
    firmVerLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Firmware Version:", nil), fwVersion];
    firmLatestLabel.text = NSLocalizedString(@"Latest", nil);
    
    [ProtocolDataController sharedInstance].connectStateDelegate = self;
    [ProtocolDataController sharedInstance].dataResponseDelegate = self;
    
    [[ProtocolDataController sharedInstance] startListeningResponse];
    
    //
    [self.view bringSubviewToFront:self.configCloseBtn];
}

#pragma mark - Protocol delegate 
-(void)onConnectionState:(ConnectState)state{
    
    [[ConfigMacroData sharedInstance] changeBLEConnectedState:state];

    
    switch (state) {
        case Connected:
            
            firmWareVerView.alpha = 1;
            updateFirmBtn.enabled = YES;
            self.configCloseBtn.userInteractionEnabled = YES;
            break;
        case Disconnect:
            
            firmWareVerView.alpha = 0.5;
            updateFirmBtn.enabled = NO;
            self.configCloseBtn.userInteractionEnabled = NO;
            
            if (landingVC == nil) {
                
                landingVC = (LandingViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LandingVC"];
            }
            
            [appDelegate.window setRootViewController:landingVC];
            
            [appDelegate.window makeKeyAndVisible];
            
            break;
        default:
            break;
    }
}

//-(void)startResponseMode{
//    
//    [[ProtocolDataController sharedInstance] responseMode];
//    
//}

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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onBtStateChanged:(bool)isEnable{
    
}

-(void)onResponseDeviceStatus:(DeviceStatus *)ds{
    
}

-(void) onResponseMoveConfig:(bool)isSuccess{
    
}

-(void) onResponseMoveMacro:(bool)isSuccess{
    
}



#pragma mark - LeftBar Delegate
-(void)DidPressControlButton{
//    [self cancelTimer];
    [[ProtocolDataController sharedInstance] stopListeningResponse];
}

//- (void)cancelTimer{
//    if(responseModeTimer != nil){
//        [responseModeTimer invalidate];
//        responseModeTimer = nil;
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - jumpToConfigMacroList
-(void)jumpToConfigMacroList {
    
    if (configMainVC == nil) {
        configMainVC = (CFMainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFMainVC"];
    }
    
    if (configMainNav == nil) {
        configMainNav = [[UINavigationController alloc]initWithRootViewController:configMainVC];
    }
    configMainVC.isSelectedConfig = YES;
    
    //[self cancelTimer];
    [self presentViewController:configMainNav animated:YES completion:nil];
    
    
}



@end
