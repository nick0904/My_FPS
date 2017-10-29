//
//  mainLeftBar.m
//  FPSApp
//
//  Created by Rex on 2016/6/24.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "mainLeftBar.h"
#import "ViewController.h"
#import "HomeViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "UserLoginViewController.h"
#import "UserSettingViewController.h"

@interface mainLeftBar(){
    float       imgScale;
    NSArray     *actionBtnAry;
    AppDelegate *appDelegate;
    UIButton    *firstBtn;
    UIButton    *secBtn;
    UIButton    *thirdBtn;
    UIButton    *fourthBtn;
    HomeViewController *homeVC;
    AboutViewController *aboutVC;
    HelpViewController *helpVC;
    UserLoginViewController *userLoginVC;
    UserSettingViewController *userSettingVC;
}

@end

@implementation mainLeftBar

@synthesize currentPage;

-(id)initWithFrame:(CGRect)frame currentPage:(int)page{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        if(IS_IPHONE_5){
            imgScale = 2.2;
        }else if(IS_IPHONE_6){
            imgScale = 2;
        }else if(IS_IPHONE_6P){
            imgScale = 1.75;
        }else{
            imgScale = 2.5;
        }
        
        currentPage = page;
        
        [self initParameter];
        [self initInterface];
    }
    
    return self;
}

-(void)initParameter{
    
   appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"currentPage = %d",currentPage);
}

-(void)initInterface{
    
    self.userInteractionEnabled = YES;
    
    CGFloat currentpageImg_w = 156/imgScale;
    CGFloat currentpageImg_h = 152/imgScale;
    
    
    //目前頁面圖示
    UIImageView *currentPageImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*0.16, self.frame.size.height*0.06, currentpageImg_w, currentpageImg_h)];
    
    NSArray *redIconAry = [[NSArray alloc] initWithObjects:
                           @"mainmenu_redbigicon_01_a_homepage",
                           @"mainmenu_redbigicon_02_a_login",
                           @"mainmenu_redbigicon_03_a_settings",
                           @"mainmenu_redbigicon_04_a_about",
                           @"mainmenu_redbigicon_00_a_help",nil];
    
    currentPageImg.image = [UIImage imageNamed:[redIconAry objectAtIndex:currentPage]];
    
    CGFloat actionBtn_w = 100/imgScale;
    CGFloat actionBtn_h = 100/imgScale;
    
    UIView *actionBtnView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width*0.068, self.frame.size.height*0.38, self.frame.size.width*0.42, self.frame.size.height*0.62)];
    
    CGFloat btnSpace = (actionBtnView.frame.size.height - actionBtn_h*4)/4;
    
    
    //第一至第四功能按鈕
    firstBtn = [[UIButton alloc] initWithFrame:CGRectMake(actionBtnView.frame.size.width/2-actionBtn_w/2, 0, actionBtn_w, actionBtn_h)];
    
    secBtn = [[UIButton alloc] initWithFrame:CGRectMake(actionBtnView.frame.size.width/2-actionBtn_w/2, firstBtn.frame.origin.y+firstBtn.frame.size.height+btnSpace, actionBtn_w, actionBtn_h)];
    
    thirdBtn = [[UIButton alloc] initWithFrame:CGRectMake(actionBtnView.frame.size.width/2-actionBtn_w/2, secBtn.frame.origin.y+secBtn.frame.size.height+btnSpace, actionBtn_w, actionBtn_h)];
    
    
    fourthBtn = [[UIButton alloc] initWithFrame:CGRectMake(actionBtnView.frame.size.width/2-actionBtn_w/2, thirdBtn.frame.origin.y+thirdBtn.frame.size.height+btnSpace, actionBtn_w, actionBtn_h)];
    
    actionBtnAry = [NSArray arrayWithObjects:firstBtn,secBtn,thirdBtn,fourthBtn, nil];
    
    [self setBtnImageWithPage];
    [self setBtnActions];
    
    [self addSubview:currentPageImg];
    [self addSubview:actionBtnView];
    [actionBtnView addSubview:firstBtn];
    [actionBtnView addSubview:secBtn];
    [actionBtnView addSubview:thirdBtn];
    [actionBtnView addSubview:fourthBtn];
}

-(void)setBtnImageWithPage{
    
    NSArray *btnImgSourceAry = [[NSArray alloc] initWithObjects:@"mainmenu_btn_a_01",@"mainmenu_btn_a_02",@"mainmenu_btn_a_03",@"mainmenu_btn_a_04",@"mainmenu_btn_a_05", nil];
    
    NSArray *btnHighlightAry = [[NSArray alloc] initWithObjects:@"mainmenu_btn_a_01_down",@"mainmenu_btn_a_02_down",@"mainmenu_btn_a_03_down",@"mainmenu_btn_a_04_down",@"mainmenu_btn_a_05_down", nil];
    
    NSMutableArray *btnImgAry = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *btnimgAry_h = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=0; i<btnImgSourceAry.count; i++) {
        
        if (i != currentPage) {
            UIImage *btnImg = [UIImage imageNamed:[btnImgSourceAry objectAtIndex:i]];
            
            UIImage *downImg = [UIImage imageNamed:[btnHighlightAry objectAtIndex:i]];
            
            [btnImgAry addObject:btnImg];
            [btnimgAry_h addObject:downImg];
        }
    }
    
    for (int i=0; i<actionBtnAry.count; i++) {
        
        UIButton *tmpBtn = [actionBtnAry objectAtIndex:i];
        
        UIImage *btnImg = [btnImgAry objectAtIndex:i];
        
        UIImage *downImg = [btnimgAry_h objectAtIndex:i];
        
        [tmpBtn setImage:btnImg forState:UIControlStateNormal];
        
        [tmpBtn setImage:downImg forState:UIControlStateHighlighted];
        
    }
}

#pragma mark - Button Actions

-(void)setBtnActions{
    switch (currentPage) {
        case MainHomePage:
            
            [firstBtn addTarget:self action:@selector(logInBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [secBtn addTarget:self action:@selector(settingBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [thirdBtn addTarget:self action:@selector(infoBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [fourthBtn addTarget:self action:@selector(helpBtnAction) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            
        case MainLoginPage:
            
            [firstBtn addTarget:self action:@selector(homeBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [secBtn addTarget:self action:@selector(settingBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [thirdBtn addTarget:self action:@selector(infoBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [fourthBtn addTarget:self action:@selector(helpBtnAction) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            
        case MainSettingPage:
            
            [firstBtn addTarget:self action:@selector(homeBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [secBtn addTarget:self action:@selector(logInBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [thirdBtn addTarget:self action:@selector(infoBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [fourthBtn addTarget:self action:@selector(helpBtnAction) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            
        case MainAboutPage:
            
            [firstBtn addTarget:self action:@selector(homeBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [secBtn addTarget:self action:@selector(logInBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [thirdBtn addTarget:self action:@selector(settingBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [fourthBtn addTarget:self action:@selector(helpBtnAction) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            
        case MainHelpPage:
            
            [firstBtn addTarget:self action:@selector(homeBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [secBtn addTarget:self action:@selector(logInBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [thirdBtn addTarget:self action:@selector(settingBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [fourthBtn addTarget:self action:@selector(infoBtnAction) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            
        default:
            break;
    }
}

-(void)homeBtnAction{
    

    if (homeVC == nil) {
        homeVC = (HomeViewController *)[self.mainVC.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    }
    
    [self.delegate DidPressControlButton];
    [appDelegate.window setRootViewController:homeVC];
    [appDelegate.window makeKeyAndVisible];
    
    NSLog(@"home");
}

-(void)logInBtnAction{
    
    if (userLoginVC == nil) {
        userLoginVC = (UserLoginViewController *)[self.mainVC.storyboard instantiateViewControllerWithIdentifier:@"UserLoginVC"];
    }

    [self.delegate DidPressControlButton];
    [appDelegate.window setRootViewController:userLoginVC];
    [appDelegate.window makeKeyAndVisible];
    
}

-(void)settingBtnAction{
    NSLog(@"setting");

    if (userSettingVC == nil) {
        userSettingVC = (UserSettingViewController *)[self.mainVC.storyboard instantiateViewControllerWithIdentifier:@"UserSettingVC"];
    }

    [self.delegate DidPressControlButton];
    [appDelegate.window setRootViewController:userSettingVC];
    [appDelegate.window makeKeyAndVisible];
}

-(void)infoBtnAction{
    

    if (aboutVC == nil) {
        aboutVC = (AboutViewController *)[self.mainVC.storyboard instantiateViewControllerWithIdentifier:@"AboutVC"];
    }
    
    [self.delegate DidPressControlButton];
    [appDelegate.window setRootViewController:aboutVC];
    [appDelegate.window makeKeyAndVisible];
    NSLog(@"info");
}

-(void)helpBtnAction{
    

    if (helpVC == nil) {
        helpVC = (HelpViewController *)[self.mainVC.storyboard instantiateViewControllerWithIdentifier:@"HelpVC"];
    }
    

    [self.delegate DidPressControlButton];
    [appDelegate.window setRootViewController:helpVC];
    [appDelegate.window makeKeyAndVisible];
    
    NSLog(@"help");
}


@end
