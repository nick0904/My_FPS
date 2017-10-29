//
//  UserSettingViewController.m
//  FPSApp
//
//  Created by Rex on 2016/6/29.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "UserSettingViewController.h"
#import "ConnectLoadingView.h"
#import "HomeViewController.h"
#import "UserLoginViewController.h"
#import "CFMainViewController.h"

static NSBundle *bundle = nil;

@interface UserSettingViewController (){
    
    float scrollContent_h;
    NSMutableArray *langBtnAry;
    NSString * language;
//    NSTimer *responseModeTimer;
    KeyCodeFile * codeFile;
    NSMutableArray *localConfig;
    ConnectLoadingView *loadingView;
    int loadFailCount;
    int currentHotKey;
    LandingViewController *landingVC;
    HomeViewController *homeVC;
    int selectLangIndex;
    
    NSArray *languageKeyAry;
    
    
    //本頁跳至Config-Macro List 頁面
    CFMainViewController *configMainVC;
    UINavigationController *configMainNav;
    
}
@property (weak, nonatomic) IBOutlet UILabel *settingTitle;

@end

@implementation UserSettingViewController

@synthesize configCloseBtn,languageScroll,selectLangImg;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.configCloseBtn addTarget:self action:@selector(jumpToConfigMarcoList) forControlEvents:UIControlEventTouchUpInside];
    
    self.configCloseBtn.userInteractionEnabled = NO;
    
    [self initParameter];
    [self initInterface];

    
}

-(void)initParameter{
    langBtnAry = [[NSMutableArray alloc] initWithCapacity:0];
    
    //取的APP語言
    language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    NSLog(@"language = %@",language);
    
    codeFile = [[KeyCodeFile alloc] init];
    localConfig = [[ConfigMacroData sharedInstance] getConfigArray];
    
    //en        英文
    //zh-Hant   繁體中文
    
    languageKeyAry = [[NSArray alloc] initWithObjects:@"en",@"zh-Hant", nil];
}

-(void)initInterface{
    
    CGFloat leftBar_w = 327/self.imgScale;
    
    self.settingTitle.text = NSLocalizedString(@"Setting", nil);
    
    //側邊欄
    leftBar = [[mainLeftBar alloc] initWithFrame:CGRectMake(0, 0, leftBar_w, self.view.bounds.size.height) currentPage:MainSettingPage];
    
    leftBar.image = [UIImage imageNamed:@"mainmenu_bg"];
    
    leftBar.mainVC = self;
    
    [self.view addSubview:leftBar];
    
    CGFloat configClose_w = 79/self.imgScale;
    CGFloat configClose_h = 80/self.imgScale;
    
    configCloseBtn.frame = CGRectMake(self.view.bounds.size.width*0.138, self.view.frame.size.height*0.86, configClose_w, configClose_h);
    
    languageScroll.layer.borderWidth = 1.0f;
    languageScroll.layer.cornerRadius = 10.0f;
    languageScroll.layer.borderColor = [[UIColor colorWithRed:18.0/255.0 green:128.0/255.0 blue:164.0/255.0 alpha:1] CGColor];
    languageScroll.backgroundColor = [UIColor colorWithRed:10.0/255.0 green:91.0/255.0 blue:117.0/255.0 alpha:1];
    
    selectLangImg.frame = CGRectMake(5, 10, self.view.bounds.size.width*0.22, self.view.bounds.size.height*0.06);
    
    selectLangImg.image = [UIImage imageNamed:@"bg_wordsquare_2_a_titlebar"];
    
    UILabel *selectTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, selectLangImg.frame.origin.y, selectLangImg.frame.size.width-5, selectLangImg.frame.size.height)];
    
    selectTitle.textColor = [UIColor whiteColor];
    
    selectTitle.text = NSLocalizedString(@"Select language", nil);
    [selectTitle adjustsFontSizeToFitWidth];
    
    [self setFontForPad:selectTitle fontSize:12.0];
    
    [languageScroll addSubview:selectTitle];
    
    [self setLanguageOptionView];
    
    float contentHeight = scrollContent_h;
    
    if (scrollContent_h < languageScroll.frame.size.height) {
        contentHeight = languageScroll.frame.size.height;
    }
    
    [languageScroll setContentSize:CGSizeMake(languageScroll.frame.size.width, contentHeight+20)];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-SCREEN_WIDTH*0.25/2, self.view.frame.size.height-SCREEN_HEIGHT*0.21, SCREEN_WIDTH*0.25, SCREEN_HEIGHT*0.1)];
    
    [saveBtn setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_up"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_down"] forState:UIControlStateHighlighted];
    
    [saveBtn addTarget:self action:@selector(saveChange) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveBtn];
    
}

-(void)saveChange{
    
    NSLog(@"selectLangIndex = %d",selectLangIndex);
    
    NSString *languageStr = [languageKeyAry objectAtIndex:selectLangIndex];
    
    [Language setLanguage:languageStr];

    [self reloadRootViewController];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [ProtocolDataController sharedInstance].connectStateDelegate = self;
    [ProtocolDataController sharedInstance].dataResponseDelegate = self;
    
    
    [[ProtocolDataController sharedInstance] startListeningResponse];
//    responseModeTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startResponseMode) userInfo:nil repeats:YES];
    
    
    [self.view bringSubviewToFront:self.configCloseBtn];
}

-(void)setLanguageOptionView{
    
    //NSArray *titleAry = [NSArray arrayWithObjects:@"英文",@"法文",@"繁體中文",@"義大利文",@"簡體中文",@"韓文",@"日本語",@"西班牙文",@"德文", nil];
    
    NSArray *titleAry = [NSArray arrayWithObjects:@"English",@"繁體中文", nil];
    
    CGFloat languageBtn_w = 56/self.imgScale;
    CGFloat languageBtn_h = 56/self.imgScale;
    
    int row = 1;
    
    for (int i=0; i<titleAry.count; i++) {
        
        CGFloat btnXPos = 0;
        
        if (i%2 != 0) {
            
            btnXPos = languageScroll.frame.size.width/2;
            
        }else{
            
            row ++;
            btnXPos = languageScroll.frame.size.width*0.1;
        }
        
        UIButton *languageBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnXPos, (languageBtn_h+5)*row, languageBtn_w, languageBtn_h)];
        
        UILabel *languageTitle = [[UILabel alloc] initWithFrame:CGRectMake(btnXPos+languageBtn.frame.size.width+5, (languageBtn_h+5)*row, languageScroll.frame.size.width*0.3, languageBtn_h)];
        
        languageTitle.text = [NSString stringWithFormat:@"%@",[titleAry objectAtIndex:i]];
        
        languageTitle.textColor = [UIColor whiteColor];
        
        [languageBtn setTitle:[titleAry objectAtIndex:i] forState:UIControlStateNormal];
        
        [languageBtn setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
        
        [languageBtn addTarget:self action:@selector(lanuageSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        languageBtn.tag = i+1;
        
        [langBtnAry addObject:languageBtn];
        
        [languageScroll addSubview:languageBtn];
        [languageScroll addSubview:languageTitle];

        if (i == titleAry.count-1) {
            scrollContent_h = languageBtn.frame.origin.y+languageBtn.frame.size.height;
        }
    }
    
    [self checkLanguageForBtnImg];

}

-(void)checkLanguageForBtnImg{
    
    if ([language isEqualToString:@"en"]) {
        selectLangIndex = 0;
    }
    
    if ([language isEqualToString:@"zh-Hant"]) {
        selectLangIndex = 1;
    }
    
    //待語系新增
    
    UIButton *btn = [langBtnAry objectAtIndex:selectLangIndex];
    [btn setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
    
}

-(void)lanuageSelect:(id)sender{
    
    UIButton *selectedBtn = sender;
    
    for (int i=0; i<langBtnAry.count; i++) {
        
        UIButton *nonSelectedBtn = [langBtnAry objectAtIndex:i];
        
        if (selectedBtn.tag-1 == i) {
           [selectedBtn setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
            
            selectLangIndex =  selectedBtn.tag-1;
        }else{
            [nonSelectedBtn setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
        }
    }
}


- (void)reloadRootViewController
{
    if (homeVC == nil) {
        
        homeVC = (HomeViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    }
    
    [self presentViewController:homeVC animated:NO completion:nil];
    
    [appDelegate.window setRootViewController:homeVC];
    
    [appDelegate.window makeKeyAndVisible];
}

//-(void)startResponseMode{
//    
//    [[ProtocolDataController sharedInstance] responseMode];
//}

#pragma mark - protocol delegate
-(void)onConnectionState:(ConnectState)state{
    
    [[ConfigMacroData sharedInstance] changeBLEConnectedState:state];
    
    if (state == Disconnect) {
        
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

- (void)onBtStateEnable:(bool)isEnable{
    
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
//        [responseModeTimer invalidate];
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

-(void) onResponseMoveConfig:(bool)isSuccess{
    
}

-(void) onResponseMoveMacro:(bool)isSuccess{
    
}


#pragma mark - LeftBar Delegate
-(void)DidPressControlButton{
//    [responseModeTimer invalidate];
//    responseModeTimer = nil;
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
