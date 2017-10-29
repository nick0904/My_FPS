//
//  HelpViewController.m
//  FPSApp
//
//  Created by Rex on 2016/6/29.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "HelpViewController.h"
#import "ConnectLoadingView.h"
#import "HomeViewController.h"
#import "CFMainViewController.h"


@interface HelpViewController (){
    NSArray *viewAry;
    BOOL cellOpen;
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
@property (weak, nonatomic) IBOutlet UILabel *helpTitle;

@end

@implementation HelpViewController

@synthesize configCloseBtn,helpScroll,helpSearchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initParameter];
    [self initInterface];
    
    [self.configCloseBtn addTarget:self action:@selector(jumpToConfigMacroList) forControlEvents:UIControlEventTouchUpInside];
    self.configCloseBtn.userInteractionEnabled = NO;
    
}

-(void)initParameter{
    QACellArray = [[NSMutableArray alloc] initWithCapacity:0];
    cellOpen = NO;

    codeFile = [[KeyCodeFile alloc] init];
    localConfig = [[ConfigMacroData sharedInstance] getConfigArray];
}

-(void)initInterface{
    
    CGFloat leftBar_w = 327/self.imgScale;
    
    self.helpTitle.text = NSLocalizedString(@"Help", nil);
    
    //側邊欄
    leftBar = [[mainLeftBar alloc] initWithFrame:CGRectMake(0, 0, leftBar_w, self.view.bounds.size.height) currentPage:MainHelpPage];
    
    leftBar.image = [UIImage imageNamed:@"mainmenu_bg"];
    
    leftBar.mainVC = self;
    
    [self.view addSubview:leftBar];
    
    CGFloat configClose_w = 79/self.imgScale;
    CGFloat configClose_h = 80/self.imgScale;
    
    configCloseBtn.frame = CGRectMake(self.view.bounds.size.width*0.138, self.view.frame.size.height*0.86, configClose_w, configClose_h);
    
    helpScroll.layer.borderWidth = 1.0f;
    helpScroll.layer.cornerRadius = 10.0f;
    helpScroll.layer.borderColor = [[UIColor colorWithRed:18.0/255.0 green:128.0/255.0 blue:164.0/255.0 alpha:1] CGColor];
    helpScroll.backgroundColor = [UIColor colorWithRed:10.0/255.0 green:91.0/255.0 blue:117.0/255.0 alpha:1];
    
    helpSearchBar.frame = CGRectMake(helpScroll.frame.origin.x+helpScroll.frame.size.width-self.view.bounds.size.width*0.19, helpScroll.frame.origin.y-44-5, self.view.bounds.size.width*0.19, 44);
    
    UITextField *searchField = [helpSearchBar valueForKey:@"searchField"];
    
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 14.0f;
        searchField.layer.borderColor = [[UIColor colorWithRed:18.0/255.0 green:128.0/255.0 blue:164.0/255.0 alpha:1] CGColor];
        searchField.layer.borderWidth = 1;
        searchField.layer.masksToBounds = YES;
    }
    
    float labelBase_width = 443/self.imgScale;
    float labelBase_height = 36/self.imgScale;
    
    UIImageView *QABase = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, labelBase_width, labelBase_height)];
    
    QABase.image = [UIImage imageNamed:@"bg_wordsquare_2_a_titlebar_2"];
    
    [helpScroll addSubview:QABase];
    
    UILabel *QAlabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, labelBase_width, labelBase_height)];
    
    QAlabel.text = NSLocalizedString(@"Q&A", nil);
    QAlabel.textColor = [UIColor whiteColor];
    
    [self setFontForPad:QAlabel fontSize:12.0];
    
    [QABase addSubview:QAlabel];
    
    QATable = [[UITableView alloc] initWithFrame:CGRectMake(5, QABase.frame.origin.y+QABase.frame.size.height, self.view.frame.size.width*0.54, self.view.frame.size.height*0.453) style:UITableViewStylePlain];
    
    QATable.backgroundColor = [UIColor clearColor];
    QATable.delegate = self;
    QATable.dataSource = self;
    QATable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [helpScroll addSubview:QATable];
    
    
    UIImageView *guideBase = [[UIImageView alloc] initWithFrame:CGRectMake(5, QATable.frame.origin.y+QATable.frame.size.height, labelBase_width, labelBase_height)];
    
    guideBase.image = [UIImage imageNamed:@"bg_wordsquare_2_a_titlebar_2"];
    
    
    UILabel *guidelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, guideBase.frame.origin.y, labelBase_width, labelBase_height)];
    
    guidelabel.text = NSLocalizedString(@"User guide", nil);
    guidelabel.textColor = [UIColor whiteColor];
    
    [self setFontForPad:guidelabel fontSize:12.0];
    
    UIImageView *guideView = [[UIImageView alloc] initWithFrame:CGRectMake(5, guideBase.frame.origin.y+guideBase.frame.size.height, helpScroll.frame.size.width-10, self.view.frame.size.height*0.11)];
    
    guideView.image = [UIImage imageNamed:@"bg_wordsquare_4_a_1"];
    
    float btnWidth = 171/self.imgScale;
    float btnHeight = 51/self.imgScale;
    
    UIButton *getGuideBtn = [[UIButton alloc] initWithFrame:CGRectMake(helpScroll.frame.size.width-self.view.frame.size.width*0.022-btnWidth, guideView.frame.size.height/2-btnHeight/2, btnWidth, btnHeight)];
    
    [getGuideBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_up_smaller"] forState:UIControlStateNormal];
    
    [getGuideBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_down_smaller"] forState:UIControlStateHighlighted];
    
    [getGuideBtn setTitle:NSLocalizedString(@"Get", nil) forState:UIControlStateNormal];
    
    [self setFontForPad:getGuideBtn fontSize:12.0];
    
    UILabel *pdfLabel = [[UILabel alloc] initWithFrame:CGRectMake(getGuideBtn.frame.origin.x-helpScroll.frame.size.width/2-5, getGuideBtn.frame.origin.y, helpScroll.frame.size.width/2, btnHeight)];
    
    pdfLabel.textColor = [UIColor whiteColor];
    pdfLabel.text = NSLocalizedString(@"user guide.pdf", nil);
    pdfLabel.textAlignment = NSTextAlignmentRight;
    
    [self setFontForPad:pdfLabel fontSize:12.0];
    
    
    UIImageView *contactBase = [[UIImageView alloc] initWithFrame:CGRectMake(5, guideView.frame.origin.y+guideView.frame.size.height, labelBase_width, labelBase_height)];
    
    contactBase.image = [UIImage imageNamed:@"bg_wordsquare_2_a_titlebar_2"];
    
    
    UILabel *contactlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, contactBase.frame.origin.y, labelBase_width, labelBase_height)];
    
    contactlabel.text = NSLocalizedString(@"Contact us", nil);
    contactlabel.textColor = [UIColor whiteColor];
    
    [self setFontForPad:contactlabel fontSize:12.0];
    
    UIImageView *contactView = [[UIImageView alloc] initWithFrame:CGRectMake(5, contactBase.frame.origin.y+contactBase.frame.size.height, helpScroll.frame.size.width-10, self.view.frame.size.height*0.11)];
    
    contactView.image = [UIImage imageNamed:@"bg_wordsquare_4_a_1"];
    
    
    UIButton *goContactBtn = [[UIButton alloc] initWithFrame:CGRectMake(helpScroll.frame.size.width-self.view.frame.size.width*0.022-btnWidth, contactView.frame.size.height/2-btnHeight/2, btnWidth, btnHeight)];
    
    [goContactBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_up_smaller"] forState:UIControlStateNormal];
    [goContactBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_a_down_smaller"] forState:UIControlStateHighlighted];
    
    [goContactBtn setTitle:NSLocalizedString(@"Go", nil) forState:UIControlStateNormal];
    
    [self setFontForPad:goContactBtn fontSize:12.0];
    
    UILabel *getFormLabel = [[UILabel alloc] initWithFrame:CGRectMake(goContactBtn.frame.origin.x-helpScroll.frame.size.width/4*3-5, goContactBtn.frame.origin.y, helpScroll.frame.size.width/4*3, btnHeight)];
    
    getFormLabel.textColor = [UIColor whiteColor];
    getFormLabel.text = NSLocalizedString(@"Brook Contact Us Form", nil);
    getFormLabel.textAlignment = NSTextAlignmentRight;
    
    [self setFontForPad:getFormLabel fontSize:12.0];
    
    [helpScroll addSubview:guideBase];
    [helpScroll addSubview:guidelabel];
    [helpScroll addSubview:guideView];
    guideView.userInteractionEnabled = YES;
    [guideView addSubview:getGuideBtn];
    [guideView addSubview:pdfLabel];

    
    [helpScroll addSubview:contactBase];
    [helpScroll addSubview:contactlabel];
    [helpScroll addSubview:contactView];
    contactView.userInteractionEnabled = YES;
    [contactView addSubview:goContactBtn];
    [contactView addSubview:getFormLabel];
    
    viewAry = [[NSArray alloc] initWithObjects:guideBase,guidelabel,guideView,contactlabel,contactBase,contactView, nil];
    
    helpScroll.contentSize = CGSizeMake(helpScroll.frame.size.width, contactView.frame.origin.y+contactView.frame.size.height);
    
    helpSearchBar.hidden = YES;
    
    
    //Rex
    helpScroll.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [ProtocolDataController sharedInstance].connectStateDelegate = self;
    [ProtocolDataController sharedInstance].dataResponseDelegate = self;
    
    [[ProtocolDataController sharedInstance] startListeningResponse];
//    responseModeTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startResponseMode) userInfo:nil repeats:YES];
    
    [self.view bringSubviewToFront:self.configCloseBtn];
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

#pragma mark - Tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
    
    return 44;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [QATable dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    float arrow_width = 22/self.imgScale;
    float arrow_height = 33/self.imgScale;
    
    NSArray *engNumAry = [[NSArray alloc] initWithObjects:NSLocalizedString(@"One", nil),NSLocalizedString(@"Two", nil),NSLocalizedString(@"Three", nil),NSLocalizedString(@"Four", nil), nil];
    
    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%ld. Question %@", nil),(long)indexPath.row+1, [engNumAry objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help_icon_a_arrow_1"]];
    
    [cell setLayoutMargins:UIEdgeInsetsZero];
    
    [cell.accessoryView setFrame:CGRectMake(0, 0, arrow_width, arrow_height)];
    
    UIImageView *cellBackImg;
    
    if(indexPath.row%2 == 0){
        
        cellBackImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_wordsquare_4_a_1"]];
        
    }else{
        cellBackImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_wordsquare_4_a_2"]];
    }
    
    cell.backgroundView = cellBackImg;
    
    if (QACellArray.count < 4) {
        NSMutableDictionary *cellDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:cell,@"cell",@"0",@"status", nil];
        
        [QACellArray addObject:cellDict];
    }
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    float arrow_width;
    float arrow_height;
    
    int closeCount = 0;
        
    for (int i=0; i<QACellArray.count; i++) {
        
        UITableViewCell *cell = [[QACellArray objectAtIndex:i] objectForKey:@"cell"];
        
        UIImage *cellAccessoryImg;
        
        if (indexPath.row == i) {
            
            if ([[[QACellArray objectAtIndex:i] objectForKey:@"status"] intValue] == 0) {
                cellAccessoryImg = [UIImage imageNamed:@"help_icon_a_arrow_2"];
                arrow_width = 33/self.imgScale;
                arrow_height = 22/self.imgScale;
                
                [[QACellArray objectAtIndex:i] setObject:@"1" forKey:@"status"];
            }else{
                cellAccessoryImg = [UIImage imageNamed:@"help_icon_a_arrow_1"];
                arrow_width = 22/self.imgScale;
                arrow_height = 33/self.imgScale;
                [[QACellArray objectAtIndex:i] setObject:@"0" forKey:@"status"];
            }
            
        }else{
            cellAccessoryImg = [UIImage imageNamed:@"help_icon_a_arrow_1"];
            arrow_width = 22/self.imgScale;
            arrow_height = 33/self.imgScale;
            
            [[QACellArray objectAtIndex:i] setObject:@"0" forKey:@"status"];
        }
        
        cell.accessoryView = [[UIImageView alloc] initWithImage:cellAccessoryImg];
        
        [cell.accessoryView setFrame:CGRectMake(0, 0, arrow_width, arrow_height)];
        
        if ([[[QACellArray objectAtIndex:i] objectForKey:@"status"] intValue] == 0) {
            closeCount++;
        }
    }
    
    /*
    if (closeCount == 4) {
        [self rerenderView:NO];
        cellOpen = NO;
    }
    
    if (closeCount == 3) {
        [self rerenderView:YES];
        cellOpen = YES;
    }
     */
}

-(void)rerenderView:(BOOL)shouldOpen{
    
    float openSize = 0;
    
    for (int i=0; i<viewAry.count; i++) {
        
        UIView *view = [viewAry objectAtIndex:i];
        
        if (shouldOpen) {
            if (!cellOpen) {
                openSize = 100;
            }
        }else{
            openSize = -100;
        }
        
        [UIView transitionWithView:view duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+openSize, view.frame.size.width, view.frame.size.height);
        } completion:nil];
    }
    
    helpScroll.contentSize = CGSizeMake(helpScroll.frame.size.width, helpScroll.contentSize.height+openSize);
    
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
        //[responseModeTimer invalidate];
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

-(void)onBtStateChanged:(bool)isEnable{
    
}

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

-(void)onResponseDeviceStatus:(DeviceStatus *)ds{
    
}

-(void)onResponseMoveConfig:(bool)isSuccess{
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
