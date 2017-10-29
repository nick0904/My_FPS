

#import "CFCreatViewController.h"
#import "LandingViewController.h"
#import "EliteObject.h"

@interface CFCreatViewController () {
    
    CFEditViewController *configEditVC;
    
    CFMainViewController *cfMainVC;
    
    int platformInt;
    
    LandingViewController *landingVC;
    
    //cloud 相關
    FPCloudClass *cloudClass;
    
    //菁英陣列
    NSMutableArray<EliteObject *> *ary_Elite;
    
    NSMutableArray *ary_eliteBgView;
    
    
    //本機暫存
    CFTableViewCellObject *eliteTempConfigData;
    
    //硬體
    FPSConfigData *configData;
    
    //新增一筆
    int newInt;
    
    //被選的 elite
    NSInteger selected_elite_index;
    
    //轉圈圈等待畫面
    ConnectLoadingView *loadingView;
    
    //下載索引
    NSInteger elite_downloadIndex;
    
}


@property (strong, nonatomic) IBOutlet UIView *customEliteView;

@property (strong, nonatomic) IBOutlet UIView *machine_list;

@property (strong, nonatomic) IBOutlet UIImageView *selectedMachineView;

@property (strong, nonatomic) IBOutlet UIButton *customBt;

@property (strong, nonatomic) IBOutlet UIButton *eliteBt;


@property (strong, nonatomic) IBOutlet UILabel *createNewLabel;

@property (strong, nonatomic) IBOutlet UIButton *mainSaveBt;

@property (strong, nonatomic) IBOutlet UIButton *mainCancelBt;

@property (strong, nonatomic) IBOutlet UITableView *m_EliteTableView;

@property (strong, nonatomic) IBOutlet UIImageView *unselectedView;


@end

@implementation CFCreatViewController

@synthesize configNewObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    configNewObj = [[CFTableViewCellObject alloc] init];
//    
//    
//    _customEliteView.alpha = 0.0;
//    _customEliteView.userInteractionEnabled = NO;
//    _selectedMachineView.alpha = 0.0;
//    
//    //customBt
//    _customBt.titleLabel.adjustsFontSizeToFitWidth = YES;
//    
//    [self setFrameToFitPad:_customBt OriginXoffset:0 OriginYoffset:0];
//    
//    //elite
//    _eliteBt.titleLabel.adjustsFontSizeToFitWidth = YES;
//    
//    [self setFrameToFitPad:_eliteBt OriginXoffset:0 OriginYoffset:0];

    
    //暫存資料初始化
    eliteTempConfigData = [[CFTableViewCellObject alloc] init];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    
    
    configNewObj = [[CFTableViewCellObject alloc] init];
    
    
    _customEliteView.alpha = 0.0;
    _customEliteView.userInteractionEnabled = NO;
    _selectedMachineView.alpha = 0.0;
    _machine_list.alpha = 1.0;
    _machine_list.userInteractionEnabled = YES;
    
    //customBt
    _customBt.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self setFrameToFitPad:_customBt OriginXoffset:0 OriginYoffset:0];
    
    //elite
    _eliteBt.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self eliteBtEnable:NO];

    //暫時關閉
    _eliteBt.userInteractionEnabled = YES;
    _eliteBt.alpha = 1.0;
    
    [self setFrameToFitPad:_eliteBt OriginXoffset:0 OriginYoffset:0];

    [self changeLanguesImediately];
    
    //cloud 初始化
    cloudClass = [[FPCloudClass alloc]init];
    cloudClass.delegate = self;
    
    
    //菁英陣列初始化
    ary_Elite = [[NSMutableArray alloc] init];
    ary_eliteBgView = [[NSMutableArray alloc] init];
    
    
    //請求抓取菁英雲端資料
    [self postSyncEliteAPI:@""];
    
    
    self.unselectedView.hidden = NO;
    
    self.m_EliteTableView.userInteractionEnabled = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    
    if (cfMainVC == nil) {
        cfMainVC = (CFMainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFMainVC"];
    }
    
    //cfMainVC.isSelectedConfig = YES;
    
    //cell 背景顏色歸零
    [self setTableViewCellBackGroundViewOrigin:self.m_EliteTableView];
    
    [ary_eliteBgView removeAllObjects];
    ary_eliteBgView = nil;
    
    [ary_Elite removeAllObjects];
    ary_Elite = nil;
    
    configNewObj = nil;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)backToConfig:(UIButton *)sender {
    
    _selectedMachineView.alpha = 0.0;
    _customEliteView.alpha = 0.0;
    _customEliteView.userInteractionEnabled = NO;
    _machine_list.alpha = 1.0;
    _machine_list.userInteractionEnabled = YES;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - TableView DataSource & Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (ary_eliteBgView.count == 0) {
        
        for (int i = 0; i < ary_Elite.count; i++) {
            
            NSString *selected = [NSString stringWithFormat:@"0"];
            
            [ary_eliteBgView addObject:selected];
        }

    }
    
    return ary_Elite.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"config_create_cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    //遊戲圖片
    UIImageView *gameIconView = [cell.contentView viewWithTag:10];
    UIImage *gameIconImage = [UIImage imageWithData:ary_Elite[indexPath.row].elite_gameIcon];
    gameIconView.image = gameIconImage;
    
    [self setFrameToFitPad:gameIconView OriginXoffset:0 OriginYoffset:0];
    
    //遊戲名稱
    UILabel *gameLabel = [cell.contentView viewWithTag:20];
    gameLabel.text = ary_Elite[indexPath.row].elite_gameName;
    
    
    //機台圖片
    //UIImageView *machineIconView = [cell.contentView viewWithTag:30];

    
    //標記顏色
    //UIImageView *markView = [cell.contentView viewWithTag:40];


    //改變背景顏色
    UIImageView *bgView = [cell.contentView viewWithTag:101];
    bgView.alpha = 0;
    NSString *bg = [ary_eliteBgView objectAtIndex:indexPath.row];
    
    if ([bg isEqualToString:@"1"]) {
        
        bgView.alpha = 1.0;
    }
    else {
        
        bgView.alpha = 0.0;
    }
    
    
    //修正 tableView 分隔線問題
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = customColorView;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //改變cell的背景顏色
    for (int i = 0; i < ary_Elite.count ; i++) {
        
        if (i == indexPath.row) {
            
            ary_eliteBgView[i] = [NSString stringWithFormat:@"1"];
        
            selected_elite_index = i;
        }
        else {
            
            ary_eliteBgView[i] = [NSString stringWithFormat:@"0"];
            
        }
        
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView reloadData];


}


#pragma mark - cell backgroundView setOrigin
-(void)setTableViewCellBackGroundViewOrigin:(UITableView *)tableView {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"config_create_cell"];
    UIImageView *bgView = [cell.contentView viewWithTag:101];
    bgView.alpha = 0.0;
    
}


#pragma mark - 選擇一個機台的方法
- (IBAction)selecMachineAction:(UIButton *)sender {
    
    _machine_list.alpha = 0.0;
    _machine_list.userInteractionEnabled = false;
    
    __block NSString *platformIconStr;
    
    [UIView animateWithDuration:0.68 animations:^{
        
        switch (sender.tag) {
            case 10:
                platformIconStr = @"platform_a_4_x360_88x88";
                platformInt = 4;
                break;
            case 20:
                platformIconStr = @"platform_a_3_x1_88x88";
                platformInt = 8;
                break;
            case 30:
                platformIconStr = @"platform_a_1_ps4_88x88";
                platformInt = 2;
                break;
            case 40:
                platformIconStr = @"platform_a_2_ps3_88x88";
                platformInt = 1;
                break;
            default:
                break;
        }
    
        _selectedMachineView.image = [UIImage imageNamed:platformIconStr];
        
        configNewObj.configHotKeyStr = [NSString stringWithFormat:@"%d",platformInt];
        
        _selectedMachineView.alpha = 1.0;
        _customEliteView.alpha = 1.0;
        _customEliteView.userInteractionEnabled = YES;
        
        
        //重新抓elite雲端資料
        [self postSyncEliteAPI:[NSString stringWithFormat:@"%d",platformInt]];
        
        
    }];

}


#pragma mark - 到編輯面
- (IBAction)gotoConfigEditPage:(UIButton *)sender {
    
    if (configEditVC == nil) {
        
        configEditVC = (CFEditViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFEditVC"];
    }
    
    if (sender == _customBt) {
        //Custom
        
        //Nick preference 都先顯示
        //2016.10.12 再改為隱藏
        configEditVC.isCustom = YES;
        
        [self defaultValueForCustom];
    
        NSLog(@"Creat ====///=====");
        
    }
    else if (sender == _eliteBt) {
        //Elite
        
        configEditVC.isCustom = NO;
    }

    configEditVC.isCreate = YES;
    configEditVC.alreadyInitView=NO;
    
    //點擊後前往 config edit 頁面
    //[self presentViewController:configEditVC animated:YES completion:nil];
    
    [self.navigationController pushViewController:configEditVC animated:YES];
    
}


#pragma mark - 點選Elite
- (IBAction)clickEliteBtAction:(UIButton *)sender {
    
    [self eliteBtEnable:YES];
    
}

-(void)eliteBtEnable:(BOOL)enable {
    
    if (enable) {
        
        self.m_EliteTableView.userInteractionEnabled = YES;
        
        self.unselectedView.hidden = YES;
        
        self.customBt.userInteractionEnabled = NO;
        
        self.customBt.alpha = 0.35;
        
        self.mainSaveBt.userInteractionEnabled = YES;
        
        [self.mainSaveBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    else {
        
        self.m_EliteTableView.userInteractionEnabled = NO;
        
        self.unselectedView.hidden = NO;
        
        self.customBt.userInteractionEnabled = YES;
        
        self.customBt.alpha = 1.0;
        
        self.mainSaveBt.userInteractionEnabled = YES;
        
         [self.mainSaveBt setTitleColor:[UIColor colorWithRed:0.17 green:0.67 blue:0.8 alpha:1.0] forState:UIControlStateNormal];
        
    }
    
    
}

#pragma mark - mianSaveAction
- (IBAction)mianSaveAction:(id)sender {
    
    //檢查是否有網路
    if (![CheckNetwork isExistenceNetwork]) {
        
        //無網路時
        [self showAlert:NSLocalizedString(@"Connect fail", nil) message:NSLocalizedString(@"Please check your wifi", nil)];
        
        return;
    }
    
    
    [self ShowLoadingView:0 ishidden:NO];//0:download...
    
    //下載並解析 txt 檔
    [self getTxtfileFromUrlAtIndexPathRow:selected_elite_index];
    
    elite_downloadIndex = selected_elite_index;

}


#pragma mark - 等待畫面資訊
-(void)ShowLoadingView:(int)status ishidden:(BOOL)ishidden  {
    
    /*
     status 說明
     0:downlaod
     */
    
    if (loadingView == nil) {
        
        loadingView = [[ConnectLoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        [self.view addSubview:loadingView];
        
    }
    
    switch (status) {
            
        case 0:
            [loadingView setStatusLabel:NSLocalizedString(@"Download...", nil)];
            break;//下載中...
        default:
            break;
            
    }
    
    [self.view bringSubviewToFront:loadingView];
    
    loadingView.hidden = ishidden;
    
    
}


#pragma mark - new config 預設值
-(void)defaultValueForCustom {
    
    if (configNewObj == nil) {
        
        configNewObj = [CFTableViewCellObject new];
    }
    
    NSMutableArray *configAry = [[ConfigMacroData sharedInstance] getConfigArray];
    
    NSMutableDictionary *configNameDic = [NSMutableDictionary new];
    
    //gameIcon 為 Brooker 預設
    configNewObj.configGameIcon = @"platform_a_5_custom_104x104";
    
    //config FileName
    NSString *newName = @"Config_1";
    
    NSMutableArray *ary_configName = [NSMutableArray arrayWithObjects:@"Config_1",@"Config_2",@"Config_3",@"Config_4",@"Config_5",@"Config_6",@"Config_7",@"Config_8", nil];
    
    NSMutableArray *ary_configNameBool = [NSMutableArray arrayWithObjects:@"0", @"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];

    if (configAry.count == 0) {
        
        newName = @"Config_1";
    }
    else {
        
        for (int existConfigNameInt = 0; existConfigNameInt < configAry.count; existConfigNameInt++) {
            
            configNameDic = configAry[existConfigNameInt];
            
            NSString *configIntName = (NSString *)[configNameDic objectForKey:@"configName"];
            
            for (int targetInt = 0; targetInt < ary_configName.count; targetInt++) {
                
                NSString *intName = [NSString stringWithFormat:@"Config_%d",targetInt+1];
                
                if ([configIntName isEqualToString:intName]) {
                    
                    ary_configNameBool[targetInt] = @"1";
                    
                }

            }
            
        }
        
    }
    
    
    for (int configNameInt = 0; configNameInt < ary_configNameBool.count; configNameInt++) {
        
        if ([ary_configNameBool[configNameInt] isEqualToString:@"0"]) {
            
            newName = (NSString *)ary_configName[configNameInt];
            
            break;
        }
        
    }
    
    configNewObj.configFileName = newName;
    
    
    //config HotKey
    //選擇可使用的 hotkey, 限F1 ~ F8 (keycode:58~65)
    int newHotkey = 58;
    
    NSMutableArray *ary_hotKey = [NSMutableArray arrayWithObjects:@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65", nil];
    
    NSMutableArray *ary_hotkeyBool = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    
    NSMutableDictionary *configDic = [NSMutableDictionary new];

    if (configAry.count == 0) {
        
        newHotkey = 58;
    }
    else {
        
        for (int existHokeyIndex = 0; existHokeyIndex < configAry.count; existHokeyIndex++) {
            
            configDic = configAry[existHokeyIndex];
            
            NSString *existHotkey = (NSString *)[configDic objectForKey:@"configHotKey"];
            
            int existHotkeyInt = [existHotkey intValue];
            
            for (int targetIndex = 0; targetIndex < ary_hotKey.count; targetIndex++) {
                
                if (existHotkeyInt == [ary_hotKey[targetIndex]intValue]) {
                    
                    ary_hotkeyBool[targetIndex] = @"1";
                }
                
            }
            
        }
        
    }
    
    
    for (int i = 0; i < ary_hotkeyBool.count; i++) {
        
        if ([ary_hotkeyBool[i] isEqualToString:@"0"]) {
            
            newHotkey = [ary_hotKey[i] intValue];
            
            break;
        }
        
    }
    
    NSString *newHotkeyStr = [NSString stringWithFormat:@"%d",newHotkey];
    
    configNewObj.configHotKeyStr = newHotkeyStr;
    
    
    
    
    //config LEDColor (預設為紅色: 1)
    configNewObj.configLEDColor = @"1";
    
    //config platform
    configNewObj.configPlatformIcon = [NSString stringWithFormat:@"%d",platformInt];
    
    //mouse
    configNewObj.hipStr = @"50";
    configNewObj.adsStr = @"50";
    configNewObj.isSync = NO;
    configNewObj.isADStoggle = NO;
    configNewObj.deadZoneStr = @"1";
    
    //盲區
    configNewObj.ballistics_Y_value = [NSMutableArray new];
    configNewObj.ballistics_changed = [NSMutableArray new];
    
    
    //keymap
    configNewObj.keyMap = [NSMutableArray new];
    for (int i = 0; i < 22; i++) {
        
        [configNewObj.keyMap addObject:[NSNumber numberWithInt:0]];
    }

    [configNewObj.keyMap replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:82]];//UpArrow
    [configNewObj.keyMap replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:79]];//RightArrow
    [configNewObj.keyMap replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:81]];//DownArrow
    [configNewObj.keyMap replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:80]];//LeftArrow
    
    [configNewObj.keyMap replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:21]];//R
    [configNewObj.keyMap replaceObjectAtIndex:5 withObject:[NSNumber numberWithInt:30]];//1
    [configNewObj.keyMap replaceObjectAtIndex:6 withObject:[NSNumber numberWithInt:44]];//SpaceBar
    [configNewObj.keyMap replaceObjectAtIndex:7 withObject:[NSNumber numberWithInt:6]];//C
    
    [configNewObj.keyMap replaceObjectAtIndex:8 withObject:[NSNumber numberWithInt:20]];//Q
    [configNewObj.keyMap replaceObjectAtIndex:9 withObject:[NSNumber numberWithInt:10]];//G
    
    [configNewObj.keyMap replaceObjectAtIndex:10 withObject:[NSNumber numberWithInt:106]];//Left mouse
    [configNewObj.keyMap replaceObjectAtIndex:11 withObject:[NSNumber numberWithInt:105]];//Right mouse
    
    [configNewObj.keyMap replaceObjectAtIndex:12 withObject:[NSNumber numberWithInt:113]];//Left Shift
    [configNewObj.keyMap replaceObjectAtIndex:13 withObject:[NSNumber numberWithInt:8]];//E
    
    
    [configNewObj.keyMap replaceObjectAtIndex:14 withObject:[NSNumber numberWithInt:40]];//Enter
    [configNewObj.keyMap replaceObjectAtIndex:15 withObject:[NSNumber numberWithInt:0]];//None
    
    
    [configNewObj.keyMap replaceObjectAtIndex:16 withObject:[NSNumber numberWithInt:41]];//ESC
    [configNewObj.keyMap replaceObjectAtIndex:17 withObject:[NSNumber numberWithInt:43]];//Tab
    
    
    [configNewObj.keyMap replaceObjectAtIndex:18 withObject:[NSNumber numberWithInt:26]];//W
    [configNewObj.keyMap replaceObjectAtIndex:19 withObject:[NSNumber numberWithInt:22]];//S
    [configNewObj.keyMap replaceObjectAtIndex:20 withObject:[NSNumber numberWithInt:4]];//A
    [configNewObj.keyMap replaceObjectAtIndex:21 withObject:[NSNumber numberWithInt:7]];//D
    
    
    
    
    //preference
    configNewObj.isShootingSpeed = NO;
    configNewObj.shootingSpeedStr = @"50";
    configNewObj.isInverted = NO;
    configNewObj.isSniperBreath = NO;
    configNewObj.sniperBreathHotkey = @"0";
    configNewObj.isAntiRecoil = NO;
    configNewObj.antiRecoilHotkey = @"0";
    configNewObj.antiRecoilStr = @"200";
    
    
    [self copyNewObjToEditObj];
 
}

-(void)copyNewObjToEditObj {
    
    if (configEditVC == nil) {
        
        configEditVC = (CFEditViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFEditVC"];
    }
    
    configEditVC.edit_configObj = [CFTableViewCellObject new];
    
    //gameIcon
    configEditVC.edit_configObj.configGameIcon = [configNewObj.configGameIcon copy];
    
    //file Name
    configEditVC.edit_configObj.configFileName = [configNewObj.configFileName copy];
    
    //hot key
    configEditVC.edit_configObj.configHotKeyStr = [configNewObj.configHotKeyStr copy];
    
    //LEDColor
    configEditVC.edit_configObj.configLEDColor = [configNewObj.configLEDColor copy];
    
    //platform
    configEditVC.edit_configObj.configPlatformIcon = [configNewObj.configPlatformIcon copy];
    
    //hipStr
    configEditVC.edit_configObj.hipStr = [configNewObj.hipStr copy];
    
    //adsStr
    configEditVC.edit_configObj.adsStr = [configNewObj.adsStr copy];
    
    //isSync
    configEditVC.edit_configObj.isSync = configNewObj.isSync;
    
    //isADStoggle
    configEditVC.edit_configObj.isADStoggle = configNewObj.isADStoggle;

    
    //deazone
    configEditVC.edit_configObj.deadZoneStr = [configNewObj.deadZoneStr copy];
    
    
    //=======  keyboard  ==========
    configEditVC.edit_configObj.keyMap = [[NSMutableArray alloc]initWithCapacity:0];
    configEditVC.edit_configObj.keyMap = [configNewObj.keyMap mutableCopy];
    
    //盲區
    configEditVC.edit_configObj.ballistics_Y_value = [[NSMutableArray alloc] initWithCapacity:0];
    configEditVC.edit_configObj.ballistics_Y_value = [configNewObj.ballistics_Y_value mutableCopy];
    
    configEditVC.edit_configObj.ballistics_changed = [[NSMutableArray alloc] initWithCapacity:0];
    configEditVC.edit_configObj.ballistics_changed = [configNewObj.ballistics_changed mutableCopy];
    
    
    //isShootingSpeed
    configEditVC.edit_configObj.isShootingSpeed = configNewObj.isShootingSpeed;
    
    
    //shootingSpeedStr
    configEditVC.edit_configObj.shootingSpeedStr = [configNewObj.shootingSpeedStr copy];
    
    //isInverted
    configEditVC.edit_configObj.isInverted = configNewObj.isInverted;
    
    //isSniperBreath
    configEditVC.edit_configObj.isSniperBreath = configNewObj.isSniperBreath;
    
    //isAntiRecoil
    configEditVC.edit_configObj.isAntiRecoil = configNewObj.isAntiRecoil;
    
    //anti RecoilStr offset
    configEditVC.edit_configObj.antiRecoilStr = [configNewObj.antiRecoilStr copy];
    
    //antiRecoilHotkey
    configEditVC.edit_configObj.antiRecoilHotkey = [configNewObj.antiRecoilHotkey copy];
    
    //sniperBreathHotkey
    configEditVC.edit_configObj.sniperBreathHotkey = [configNewObj.sniperBreathHotkey copy];
    
}


#pragma mark - Protocal Delegate
-(void)onConnectionState:(ConnectState)state{
    
    //ScanFinish,掃描結束
    //Connected,連線成功
    //Disconnected,斷線
    //ConnectTimeout連線超時
    
    [[ConfigMacroData sharedInstance] changeBLEConnectedState:state];
    
    switch (state) {
        case Disconnect: {
            
            //重新連線
            if (landingVC == nil) {
                
                landingVC = (LandingViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LandingVC"];
            }
            
            [appDelegate.window setRootViewController:landingVC];
            
            [appDelegate.window makeKeyAndVisible];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 立即變更語系
-(void)changeLanguesImediately {
    
    self.createNewLabel.text = NSLocalizedString(@"Create New", nil);//新增
 
    [self.customBt setTitle:NSLocalizedString(@"Custom", nil) forState:UIControlStateNormal];//自訂
    
    [self.eliteBt setTitle:NSLocalizedString(@"Elite", nil) forState:UIControlStateNormal];//菁英
    
    [self.mainSaveBt setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];//儲存
    
    [self.mainCancelBt setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];//取消
    
}

#pragma mark - FPCloudResponse Delegate
-(void)FPCloudResponseData:(NSURLResponse *)response Data:(NSData *)data Error:(NSError *)error EventId:(int)eventid {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(data==nil) {
            
            NSLog(@"Error:%@",error.description);
            
            return ;
        }
        
        NSError *jsonError;
        
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        
        switch (eventid) {
                case CloudAPIEvent_syncelite:
                [self processSyncElite:responseData Error:jsonError];
                break;
            default:
                break;
        }
        
    });
    
}


//#pragma mark - post  &  process EliteGameListAPI
//-(void)processEliteGameList:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
//    
//    NSNumber *code = [resopnseData objectForKey:@"ret"];
//    
//    if (code.intValue== 0) {
//        //success
//        NSLog(@"取得 Elite 版遊戲資訊 成功");
//        
//        NSLog(@"取得 Elite 版遊戲資訊: %@",resopnseData);
//        
//        NSMutableArray *eliteAry = [[NSMutableArray alloc]init];
//        
//        eliteAry = [resopnseData objectForKey:@"list"];
//        
//        [ary_Elite removeAllObjects];
//        
//        for (int i = 0; i < eliteAry.count; i++) {
//            
//            EliteObject *obj = [[EliteObject alloc] init];
//            
//            obj.elite_name = [eliteAry[i] objectForKey:@"name"];//菁英名稱
//            
//            obj.elite_ID = [eliteAry[i] objectForKey:@"id"];//菁英 ID
//            
//            [ary_Elite addObject:obj];
//            
//        }
//        
//        [self.m_EliteTableView reloadData];
//        
//    }
//    else {
//        
//        
//        NSLog(@"取得 Elite 版遊戲資訊 失敗");
//    }
//}



#pragma mark - post  &  process syncEliteAPI(取得某筆菁英資料)
-(void)processSyncElite:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    NSNumber *code = [resopnseData objectForKey:@"ret"];
    
    if (code.intValue == 0) {
        //成功
         NSLog(@"syncEliteData: %@",resopnseData);
        
        NSMutableArray *eliteAry = [[NSMutableArray alloc]init];
        
        eliteAry = [resopnseData objectForKey:@"list"];
        
        [ary_Elite removeAllObjects];
        
        for (int i = 0; i < eliteAry.count; i++) {
            
            EliteObject *obj = [[EliteObject alloc] init];
            
            //菁英名稱
            obj.elite_gameName = [eliteAry[i] objectForKey:@"name"];
            
            //圖片
            NSString *urlStr = [eliteAry[i] objectForKey:@"pic"];
            [self getImgDataFromURL:urlStr index:i];
            
            //url
            obj.elite_url = [eliteAry[i] objectForKey:@"url"];//txt檔
            
            
            [ary_Elite addObject:obj];
            
        }
        
        [self.m_EliteTableView reloadData];
       
    }
    else {
        //失敗
        NSLog(@"syncEliteData 下載失敗");
    }
    
}

-(void)postSyncEliteAPI:(NSString *)chosePlatform {
    
    int eventID = CloudAPIEvent_syncelite;
    
    //用戶編號
    NSString *uid = [ConfigMacroData sharedInstance].uid;
    
    //頁數(選填)
    int page = 0;//預設為0 (每一頁50筆)
    
    //遊戲名稱(選填)
    NSString *gameName = @"";
    
    
    //遊戲平台(選填)
    NSString *platform = chosePlatform;
    
    
    //時間撮
    NSString *ts = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
    
    //簽名 MD5(用戶編號+KEY+時間戳)
    NSString *sn = [NSString stringWithFormat:@"%@%@%@",uid,ts,kAPIKey];
    
    sn = [ShareCommon md5:sn];
    
    NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      uid,@"uid",
                                      platform,@"platform",
                                      gameName,@"game",
                                      page,@"Page",
                                      ts,@"ts",
                                      sn,@"sn",nil];
    
    [cloudClass postDataAsync:sendParam APIName:KAPI_syncelite EventId:eventID];

    
}

#pragma mark - getImgFromURL (從 url 抓取圖片)
-(void)getImgDataFromURL:(NSString *)urlStr index:(int)index {
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            
            NSLog(@"img Error:%@",error);
            
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ary_Elite[index].elite_gameIcon = data;
            
            [self.m_EliteTableView reloadData];
            
        });
        
    }];
    
    [dataTask resume];
    
}


#pragma mark - getTxtfileFromUrlAtIndexPathRow 從 url 抓取 txt 檔
-(void)getTxtfileFromUrlAtIndexPathRow:(NSInteger)indexPathRow {
    
    NSString *urlStr = ary_Elite[indexPathRow].elite_url;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            
            NSLog(@"txt Error:%@",error);
            
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"str:%@",str);
            
            [self parseTxtFile:str];
            
        });
        
    }];
    
    [dataTask resume];
}



#pragma mrak - 解析 txt 檔
-(void)parseTxtFile:(NSString *)txtStr {
    
    if (eliteTempConfigData == nil) {
        
        eliteTempConfigData = [[CFTableViewCellObject alloc] init];
    }
    
    
    //configHotKey
    NSString *configHotKeyStrHex = [txtStr substringWithRange:NSMakeRange(0, 2)];//(1, 2)
    NSLog(@"configHotKeyStrHex:%@",configHotKeyStrHex);
    int configHotKeyInt = [self hexStringToInt:configHotKeyStrHex];
    [configData setConfigHotKey:configHotKeyInt];
    eliteTempConfigData.configHotKeyStr = [NSString stringWithFormat:@"%d",configHotKeyInt];
    
    
    //platform
    NSString *platformStrHex = [txtStr substringWithRange:NSMakeRange(3, 2)];//(4, 2)
    NSLog(@"platformStrHex:%@",platformStrHex);
    int thePlatformInt = [self hexStringToInt:platformStrHex];
    [configData setPlatform:thePlatformInt];
    eliteTempConfigData.configPlatformIcon = [NSString stringWithFormat:@"%d",thePlatformInt];
    
    
    //ConfigName
    NSString *configNameStrHex = [txtStr substringWithRange:NSMakeRange(6, 99)];//(7, 99)
    NSLog(@"configNameStrHex:%@",configNameStrHex);
    
    NSString *configNameTemp = [self stringDeleteString:configNameStrHex];
    
    NSLog(@"configNameTemp:%@",configNameTemp);
    
    NSMutableString *configName = [[NSMutableString alloc] init];
    
    for (int i = 0; i < 20; i++) {
        
        NSString *ch = [configNameTemp substringWithRange:NSMakeRange(i*4, 4)];
        
        if (![ch isEqualToString:@"FFFF"]) {
            
            int c = [self hexStringToInt:ch];
            
            [configName appendString:[NSString stringWithCharacters:(unichar *)&c length:1] ];
        }
        
    }
    
    [configData setConfigName:configName];
    eliteTempConfigData.configFileName = configName;
    
    
    //LED
    NSString *LEDStrHex = [txtStr substringWithRange:NSMakeRange(106, 2)];//(107, 2)
    NSLog(@"LEDStrHex:%@",LEDStrHex);
    int LEDInt = [self hexStringToInt:LEDStrHex];
    [configData setLEDColor:LEDInt];
    eliteTempConfigData.configLEDColor = [NSString stringWithFormat:@"%d",LEDInt];
    
    
    
    //ConfigFuncFlag
    NSString *ConfigFuncFlagStrHex = [txtStr substringWithRange:NSMakeRange(109, 2)];//(110,2)
    NSLog(@"ConfigFuncFlagStrHex:%@",ConfigFuncFlagStrHex);
    int flag = [self hexStringToInt:[ConfigFuncFlagStrHex substringToIndex:2]];
    
    int adsToggleFlag = (flag & 1) == 1;
    int shootingSpeedFlag = (flag & 2) == 2;
    int invertedYFlag = (flag & 4) == 4;
    int sniperBreathFlag = (flag & 8) == 8;
    int antiRecoilFlag = (flag & 16) == 16;
    int adsSyncFlag = (flag & 32) == 32;
    
    [configData setFuncFlag_ADSToggle:adsToggleFlag];
    [configData setFuncFlag_shootingSpeed:shootingSpeedFlag];
    [configData setFuncFlag_invertedYAxis:invertedYFlag];
    [configData setFuncFlag_sniperBreath:sniperBreathFlag];
    [configData setFuncFlag_antiRecoil:antiRecoilFlag];
    [configData setFuncFlag_ADSSync:adsSyncFlag];
    
    
    eliteTempConfigData.isADStoggle = adsToggleFlag;
    eliteTempConfigData.isShootingSpeed = shootingSpeedFlag;
    eliteTempConfigData.isInverted = invertedYFlag;
    eliteTempConfigData.isSniperBreath = sniperBreathFlag;
    eliteTempConfigData.isAntiRecoil = antiRecoilFlag;
    eliteTempConfigData.isSync = adsSyncFlag;
    
    
    
    //Hip_SensitivityStrHex
    NSString *Hip_SensitivityStrHex = [txtStr substringWithRange:NSMakeRange(112, 2)];//(113, 2)
    NSLog(@"Hip_SensitivityStrHex:%@",Hip_SensitivityStrHex);
    int Hip_SensitivityInt = [self hexStringToInt:Hip_SensitivityStrHex];
    [configData setHIPSensitivity:Hip_SensitivityInt];
    eliteTempConfigData.hipStr = [NSString stringWithFormat:@"%d",Hip_SensitivityInt];
    
    
    
    //ADS_SensitivityStrHex
    NSString *ADS_SensitivityStrHex = [txtStr substringWithRange:NSMakeRange(115, 2)];//(116, 2)
    NSLog(@"ADS_SensitivityStrHex:%@",ADS_SensitivityStrHex);
    int ADS_SensitivityInt = [self hexStringToInt:ADS_SensitivityStrHex];
    [configData setADSSensitivity:ADS_SensitivityInt];
    eliteTempConfigData.adsStr = [NSString stringWithFormat:@"%d",ADS_SensitivityInt];
    
    
    
    //DeadZONEStrHex
    NSString *DeadZONEStrHex = [txtStr substringWithRange:NSMakeRange(118, 2)];//(119, 2)
    NSLog(@"DeadZONEStrHex:%@",DeadZONEStrHex);
    int DeadZONEInt = [self hexStringToInt:DeadZONEStrHex];
    [configData setDeadZONE:DeadZONEInt];
    eliteTempConfigData.deadZoneStr = [NSString stringWithFormat:@"%d",DeadZONEInt];
    
    
    //Sniperbreath_hotkeyStrHex
    NSString *Sniperbreath_hotkeyStrHex = [txtStr substringWithRange:NSMakeRange(121, 2)];//(122, 2)
    NSLog(@"Sniperbreath_hotkeyStrHex:%@",Sniperbreath_hotkeyStrHex);
    int Sniperbreath_hotkeyInt = [self hexStringToInt:Sniperbreath_hotkeyStrHex];
    [configData setSniperBreathHotKey:Sniperbreath_hotkeyInt];
    eliteTempConfigData.sniperBreathHotkey = [NSString stringWithFormat:@"%d",Sniperbreath_hotkeyInt];
    
    
    
    //Sniperbreath_mapkeyStHex (目前沒用到)
    NSString *Sniperbreath_mapkeyStHex = [txtStr substringWithRange:NSMakeRange(124, 2)];//(125, 2)
    NSLog(@"Sniperbreath_mapkeyStHex:%@",Sniperbreath_mapkeyStHex);
    int Sniperbreath_mapkeyInt = [self hexStringToInt:Sniperbreath_mapkeyStHex];
    [configData setSniperBreathMapkey:Sniperbreath_mapkeyInt];
    
    
    //AntiRecoil_hotkeyStrHex
    NSString *AntiRecoil_hotkeyStrHex = [txtStr substringWithRange:NSMakeRange(127, 2)];//(128, 2)
    NSLog(@"AntiRecoil_hotkeyStrHex:%@",AntiRecoil_hotkeyStrHex);
    int AntiRecoil_hotkeyInt = [self hexStringToInt:AntiRecoil_hotkeyStrHex];
    [configData setAntiRecoilHotkey:AntiRecoil_hotkeyInt];
    eliteTempConfigData.antiRecoilHotkey = [NSString stringWithFormat:@"%d",AntiRecoil_hotkeyInt];
    
    
    
    //AntiRecoil_offsetValueStrHex
    NSString *AntiRecoil_offsetValueStrHex = [txtStr substringWithRange:NSMakeRange(130, 2)];//(131, 2)
    NSLog(@"AntiRecoil_offsetValueStrHex:%@",AntiRecoil_offsetValueStrHex);
    int AntiRecoil_offsetValueInt = [self hexStringToInt:AntiRecoil_offsetValueStrHex];
    [configData setAntiRecoilOffsetValue:AntiRecoil_offsetValueInt];
    eliteTempConfigData.antiRecoilStr = [NSString stringWithFormat:@"%d",AntiRecoil_offsetValueInt];
    
    
    
    //ShootingSpeedStrHex
    NSString *ShootingSpeedStrHex = [txtStr substringWithRange:NSMakeRange(133, 4)];//(134, 4)
    NSLog(@"ShootingSpeedStrHex:%@",ShootingSpeedStrHex);
    int shootingSpeedInt = [self hexStringToInt:ShootingSpeedStrHex];
    [configData setShootingSpeed:shootingSpeedInt];
    eliteTempConfigData.shootingSpeedStr = [NSString stringWithFormat:@"%d",shootingSpeedInt];
    
    NSLog(@"eliteTempConfigData.shootingSpeedStr:%@",eliteTempConfigData.shootingSpeedStr);
    
    
    //KeymapArrayStrHex
    NSString *KeymapArrayStrHex = [txtStr substringWithRange:NSMakeRange(138, 65)];//(139, 65)
    NSLog(@"KeymapArrayStrHex:%@",KeymapArrayStrHex);
    
    NSString *KeymapTempArray = [self stringDeleteString:KeymapArrayStrHex];
    
    NSMutableArray *ary_keyMap = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 22; i++) {
        
        NSString *keyMap_ch = [KeymapTempArray substringWithRange:NSMakeRange(i*2, 2)];
        
        int keyMapInt = [self hexStringToInt:keyMap_ch];
        
        [ary_keyMap addObject:[NSString stringWithFormat:@"%d",keyMapInt]];
    }
    
    [configData setKeyMapArray:ary_keyMap];
    
    [eliteTempConfigData.keyMap removeAllObjects];
    
    if (eliteTempConfigData.keyMap == nil) {
        
        eliteTempConfigData.keyMap = [[NSMutableArray alloc] init];
    }
    
    for (int i = 0; i < ary_keyMap.count; i++) {
        
        NSNumber *num = [NSNumber numberWithInt:[ary_keyMap[i] intValue]];
        
        [eliteTempConfigData.keyMap addObject:num];
        
    }
    
    NSLog(@"eliteTempConfigData.keyMap:%@",eliteTempConfigData.keyMap);
    
    
    //BallisticsStrHex
    NSString *BallisticsStrHex = [txtStr substringWithRange:NSMakeRange(204, 59)];//(205, 59)
    NSLog(@"BallisticsStrHex:%@",BallisticsStrHex);
    
    NSMutableArray *ary_ballistics = [[NSMutableArray alloc] init];
    
    NSString *ballisticStr = [self stringDeleteString:BallisticsStrHex];
    
    for (int i = 0; i < 20; i++) {
        
        NSString *ballistic_ch = [ballisticStr substringWithRange: NSMakeRange(i*2, 2)];
        
        int ballisticInt = [self hexStringToInt:ballistic_ch];
        
        [ary_ballistics addObject:[NSString stringWithFormat:@"%d",ballisticInt]];
        
    }
    
    [configData setBallistics:ary_ballistics];
    
    [eliteTempConfigData.ballistics_Y_value removeAllObjects];
    
    if (eliteTempConfigData.ballistics_Y_value == nil) {
        
        eliteTempConfigData.ballistics_Y_value = [[NSMutableArray alloc]init];
    }
    
    for (int i = 0; i < ary_ballistics.count; i++) {
        
        NSNumber *num = [NSNumber numberWithInt:[ary_ballistics[i] intValue]];
        
        [eliteTempConfigData.ballistics_Y_value addObject:num];
    }
    
    NSLog(@"eliteTempConfigData.ballistics_Y_value:%@",eliteTempConfigData.ballistics_Y_value);
    
    
    
    //BallisticsTempStrHex
    NSString *BallisticsTempStrHex = [txtStr substringWithRange:NSMakeRange(264, 8)];//(265, 8)
    NSLog(@"BallisticsTempStrHex:%@",BallisticsTempStrHex);
    NSString *ballisticTemp = [self stringDeleteString:BallisticsTempStrHex];
    
    NSMutableArray *ary_ballisticTemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++) {
        
        [ary_ballisticTemp addObject:[NSNumber numberWithInt:0]];
    }
    
    NSNumber *ballisticNum = [NSNumber numberWithUnsignedInteger:[ballisticTemp length]];
    int ballisticInt = [ballisticNum intValue];
    
    [eliteTempConfigData.ballistics_changed removeAllObjects];
    
    if(eliteTempConfigData.ballistics_changed == nil) {
        
        eliteTempConfigData.ballistics_changed = [[NSMutableArray alloc] init];
    }
    
    for (int i = 0; i < 20; i++) {
        
        [ary_ballisticTemp replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:(( ballisticInt >> i) & 0x1)] ];
    }
    
    for (int i = 0; i < 20; i++) {
        
        [eliteTempConfigData.ballistics_changed addObject:[NSString stringWithFormat:@"%@",ary_ballisticTemp[i]]];
    }
    
    NSLog(@"ary_ballisticTemp:%@",ary_ballisticTemp);
    
    [configData setBallisticsChanged:ary_ballisticTemp];
    
    
    //硬體新增一筆資料
    NSNumber *indexNum = [NSNumber numberWithUnsignedInteger:[self checkConfigDataTotalCount]];
    
    newInt = [indexNum intValue];
    
    [[ProtocolDataController sharedInstance] saveConfig:newInt :configData];
    
}

#pragma mark - 16 轉 10 (int)
- (int)hexStringToInt:(NSString *)hexString{
    
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&result];
    return result;
}


#pragma mark - 字串刪除","
-(NSString *)stringDeleteString:(NSString *)str {
    
    NSMutableString *oriStr = [NSMutableString stringWithString:str];
    
    for (int i = 0; i < oriStr.length; i++) {
        
        unichar c = [oriStr characterAtIndex:i];
        
        NSRange range = NSMakeRange(i, 1);
        
        if ( c == ',') {
            
            [oriStr deleteCharactersInRange:range];
            
            --i;
        }
        
    }
    
    NSString *newstr = [NSString stringWithString:oriStr];
    
    return newstr;
}

#pragma checkConfigDataTotalCount
-(NSUInteger)checkConfigDataTotalCount {
    
    NSMutableArray *configArray = [[ConfigMacroData sharedInstance] getConfigArray];
    
    return configArray.count;
}


#pragma mark - 沒網路時跳出預設 Alert
-(void)showAlert:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
    
    [alertView addAction:okAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}


#pragma mark - 存回硬體是否成功
-(void)onResponseSaveConfig:(bool)isSuccess {
    
    NSLog(@"==>EliteConfig onResponseSaveConfig==>%d",isSuccess);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self doSave:isSuccess];
        
    });
    
}


#pragma mark - 資料儲存至硬體成功後,暫存在本機
-(void)doSave:(bool)isSuccess {
    
    if (isSuccess) {
        
        //儲存 config
        NSMutableArray *configAry = [[ConfigMacroData sharedInstance] getConfigArray];
        
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        eliteTempConfigData.configHotKeyStr,@"configHotKey",
                                        eliteTempConfigData.configPlatformIcon,@"platform",
                                        eliteTempConfigData.configFileName,@"configName",
                                        eliteTempConfigData.configLEDColor,@"LEDColor",
                                        @(eliteTempConfigData.isADStoggle),@"flagADSToggle",
                                        @(eliteTempConfigData.isShootingSpeed),@"flagShootingSpeed",
                                        @(eliteTempConfigData.isInverted),@"flagInvertedYAxis",
                                        @(eliteTempConfigData.isSniperBreath),@"flagSniperBreath",
                                        @(eliteTempConfigData.isAntiRecoil),@"flagAntiRecoil",
                                        @(eliteTempConfigData.isSync),@"flagADSSync",
                                        eliteTempConfigData.hipStr,@"HIPSensitivity",
                                        eliteTempConfigData.adsStr,@"ADSSensitivity",
                                        eliteTempConfigData.deadZoneStr,@"deadZONE",
                                        eliteTempConfigData.sniperBreathHotkey,@"sniperBreathHotKey",
                                        eliteTempConfigData.antiRecoilHotkey,@"antiRecoilHotkey",
                                        eliteTempConfigData.antiRecoilStr,@"antiRecoilOffsetValue",
                                        [eliteTempConfigData.shootingSpeedStr mutableCopy],@"shootingSpeed",
                                        [eliteTempConfigData.keyMap mutableCopy],@"keyMapArray",
                                        [eliteTempConfigData.ballistics_Y_value mutableCopy],@"ballisticsArray",
                                        [eliteTempConfigData.ballistics_changed mutableCopy],@"ballisticChanged",nil];
        
        
        
        [configAry addObject:tempDic];
        
        [[ConfigMacroData sharedInstance] setConfigArray:configAry];
        
        //儲存圖片
        NSMutableDictionary *configImgDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              eliteTempConfigData.configHotKeyStr,@"configHotKey",
                                              ary_Elite[elite_downloadIndex].elite_gameIcon,@"configImage",nil];
        
        [[ConfigMacroData sharedInstance] saveConfigImage:configImgDict Key:eliteTempConfigData.configFileName];
        
        
        //等待畫面消失
        [loadingView removeFromSuperview];
        loadingView = nil;
        
        //回到 Config Macro 主頁
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }
    else {
        
        [[ProtocolDataController sharedInstance] saveConfig:newInt :configData];
        
    }
    
}



@end
