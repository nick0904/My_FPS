

#import "CFMainViewController.h"
#import "ViewController.h"
#import "KeyCodeFile.h"
#import "LandingViewController.h"
#import "Function.h"
#import "HomeViewController.h"

@interface CFMainViewController () {
    
    //存儲箭頭動畫的陣列
    NSMutableArray *ary_arrowImg;
    
    //Config - EditVC
    CFEditViewController *m_cfEditVC;
    
    //Config - CreatVC
    CFCreatViewController *m_cfCreateVC;
    
    //config - BackupVC
    CFBackupViewController *m_cfBackupVC;
    
    //Marco - Create
    MCCreateViewController *m_mcCreateVC;
    
    
    //btAnimation
    BtAnimationCurve *m_btAnimation;
    
    //menu 是否被按下
    BOOL isMenuBtSelected;
    

    NSIndexPath *m_currentIndexPath;
    UIImageView *currentSelecedCell;
    UIImageView *preSelectedCell;
    NSInteger currentRow;
    NSInteger preRow;
    
    
    //判斷 Config 還是 Marco
    BOOL isConfig; //(YES -> Config ,NO -> Marco)
    NSTimer *m_timer;
    
    //其他主頁
    HomeViewController *homeVC;
    UserLoginViewController *loginVC;
    AboutViewController *aboutVC;
    HelpViewController *helpVC;
    UserSettingViewController *settingVC;
    LandingViewController *landingVC;
    
    
    //客製化 tableView & tableViewCell 相關
    NSIndexPath *preIndexPath;
    UISwipeGestureRecognizer *cellSwipGestureLeft;
    UISwipeGestureRecognizer *cellSwipGestureRight;
    
    NSInteger configIndexPath;
    
    KeyCodeFile *keycodeClass;
    
    
    //轉圈圈 等待畫面
    ConnectLoadingView *loadView;
    

    //測試用
    NSMutableArray *list_gameIcon;
    NSMutableArray *list_machine;
    NSMutableArray *list_gameDescription;
    NSMutableArray *list_colors;
    
    
    //
    NSMutableArray *list_bgimage;
    
    
    //硬體刪除資料用
    int deleteIndex;
    
    //
    UINavigationController *configMainNav;
    
    //(本機圖片)
//    NSMutableArray *configImgAry;
    
    
    //cloud 相關
    FPCloudClass *cloudClass;
    
    
}

//箭頭動畫的imageView
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;

//按鈕旋轉的固定桿
@property (weak, nonatomic) IBOutlet UIImageView *barView;

//config按鈕
@property (weak, nonatomic) IBOutlet UIButton *configBt;

//marco按鈕
@property (weak, nonatomic) IBOutlet UIButton *marcoBt;

//連接按鈕與列表的line
@property (weak, nonatomic) IBOutlet UIImageView *lineView;

//menu 的觸發按鈕
@property (strong, nonatomic) IBOutlet UIButton *menuBt;

@property (strong, nonatomic) IBOutlet UIView *menuView;

@property (strong, nonatomic) IBOutlet UIScrollView *menuScrollerView;


@property (strong, nonatomic) IBOutlet UILabel *configMarcoLabel;


@property (strong, nonatomic) IBOutlet CustomizedTableView *m_tableView;


@property (strong, nonatomic) IBOutlet UIView *bottomList_config;

@property (strong, nonatomic) IBOutlet UIView *bottomList_marco;


@property (strong, nonatomic) IBOutlet UIButton *configEditBT;

@property (strong, nonatomic) IBOutlet UIButton *configLoadBt;

@property (strong, nonatomic) IBOutlet UIButton *configNewBt;

@property (strong, nonatomic) IBOutlet UIButton *configBackupBt;


@property (strong, nonatomic) IBOutlet UIButton *macroEditBt;

@property (strong, nonatomic) IBOutlet UIButton *macroNewBt;


@end

@implementation CFMainViewController

@synthesize ary_configObj,ary_marocObj;

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //隱藏導覽列
    self.navigationController.navigationBarHidden = YES;
    
    //將箭頭動畫所有圖片加入到 ary_arrowImg
    ary_arrowImg = [NSMutableArray new];
    for (int arrowImgIndex = 1; arrowImgIndex <= 7; arrowImgIndex++) {
        
        [ary_arrowImg addObject:[UIImage imageNamed:[NSString stringWithFormat:@"ani_arrow_a_0%d",arrowImgIndex]]];
    }
    _arrowImgView.animationImages = ary_arrowImg;
    _arrowImgView.animationDuration = 1.5;
    [_arrowImgView startAnimating];
    
    
    //bt動畫相關屬性初始化
    m_btAnimation = [[BtAnimationCurve alloc] init];
    m_btAnimation.m_parentVC = self;
    m_btAnimation.m_barView = self.barView;
    m_btAnimation.m_configBt = self.configBt;
    m_btAnimation.m_marcoBt = self.marcoBt;
    m_btAnimation.m_pathRadious = self.view.frame.size.height/7.5;
    m_btAnimation.m_animationTime = 0.68;
    m_btAnimation.m_lineView = self.lineView;
    
    
    //判斷主頁是點選 Config 還是 Macro
    if (self.isSelectedConfig == YES) {//nick
        m_btAnimation.configAnimFlag = YES;
    }else {
        m_btAnimation.configAnimFlag = NO;
    }
    
    NSLog(@"m_btAnimation.configAnimFlag = %i", m_btAnimation.configAnimFlag);

    
    [self.configBt addTarget:m_btAnimation action:@selector(btAnimationCurve:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.marcoBt addTarget:m_btAnimation action:@selector(btAnimationCurve:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setFrameToFitPad:m_btAnimation.m_configBt OriginXoffset:0 OriginYoffset:0];
    [self setFrameToFitPad:m_btAnimation.m_marcoBt OriginXoffset:0 OriginYoffset:0];
    [self setFrameToFitPad:m_btAnimation.m_barView OriginXoffset:0 OriginYoffset:0];
    
    
    //configBt中心位置
    self.configBt.center = CGPointMake([m_btAnimation getPositionFormAngles:225 center:self.barView.center radious:m_btAnimation.m_pathRadious].x, [m_btAnimation getPositionFormAngles:225 center:self.barView.center radious:m_btAnimation.m_pathRadious].y);
    self.configBt.userInteractionEnabled = NO;
    
    //marcoBt中心位置
    self.marcoBt.center = CGPointMake([m_btAnimation getPositionFormAngles:45 center:self.barView.center radious:m_btAnimation.m_pathRadious].x, [m_btAnimation getPositionFormAngles:45 center:self.barView.center radious:m_btAnimation.m_pathRadious].y);
    
    isMenuBtSelected = NO;
    _menuView.alpha = 0.0;
    
    self.isSeleced_config = NO;
    
    self.isSeleced_marco = NO;
    
    //將側邊 bt 加入 menuScrollerView(目前5個)
    self.menuView.frame = CGRectMake(self.menuView.frame.origin.x, self.menuView.frame.origin.y,self.menuView.frame.size.width,self.menuView.frame.size.height);
    
    CGFloat bt_width = 100/self.imgScale;;
    
    CGFloat space = (self.menuView.frame.size.height - 5*bt_width)/6;
    
    for (int btIndex = 0; btIndex < 5; btIndex++) {
        
        UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(0,0, bt_width, bt_width)];
        
        bt.center = CGPointMake(self.menuScrollerView.center.x, space * (btIndex+1) + bt_width * (2*btIndex +1)/2);
       
        [bt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mainmenu_btn_a_0%d",btIndex+1]] forState:UIControlStateNormal];
        
        [bt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mainmenu_btn_a_0%d_down",btIndex+1]] forState:UIControlStateHighlighted];
        
        [bt addTarget:self action:@selector(changeToOtherMainVC:) forControlEvents:UIControlEventTouchUpInside];
        
        bt.tag = btIndex;
        
        [_menuScrollerView addSubview:bt];
        
    }
    

    //設定 menuScrollerView 的 contentSize
    _menuScrollerView.contentSize = CGSizeMake(_menuScrollerView.frame.size.width, 5*(space + bt_width)+ space);
    
    //預設在 config 頁面
    //nick
    //isConfig = YES;

    //客製化 tableView
    [self.m_tableView initData];
    
    self.m_tableView.m_superVC = self;
    
    [self.m_tableView addLongPressGesture];
    
    //[self.m_tableView registerClass:[CustomizedCell class] forCellReuseIdentifier:@"configTableViewCell"];
    
    self.m_tableView.dataSource = self;
    self.m_tableView.delegate = self;
    self.m_tableView.gestureMinimumPressDuration = 0.5;
    [self addLeftAndRightSwipGesture];

    
    //keycodeClass
    keycodeClass = [[KeyCodeFile alloc]init];
    
    
    //******************************  測試用 Config ***************************
    //config 第一組
    CFTableViewCellObject *cftableViewcellObj_0 = [CFTableViewCellObject new];
    cftableViewcellObj_0.configFileName = [NSString stringWithFormat:@"ConfigFileOne"];
    cftableViewcellObj_0.configPlatformIcon = [NSString stringWithFormat:@"platform_a_1_ps4_88x88"];
    cftableViewcellObj_0.configGameIcon = [NSString stringWithFormat:@"platform_a_5_custom_104x104"];
    cftableViewcellObj_0.configLEDColor = [NSString stringWithFormat:@"platform_btn_a_colorlable_1"];
    cftableViewcellObj_0.configHotKeyStr = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_0.hipStr = [NSString stringWithFormat:@"45"];
    cftableViewcellObj_0.adsStr = [NSString stringWithFormat:@"55"];
    cftableViewcellObj_0.isSync = NO;
    cftableViewcellObj_0.isADStoggle = NO;
    cftableViewcellObj_0.deadZoneStr = [NSString stringWithFormat:@"39"];
    cftableViewcellObj_0.isShootingSpeed = NO;
    cftableViewcellObj_0.shootingSpeedStr = [NSString stringWithFormat:@"35"];
    cftableViewcellObj_0.isInverted = NO;
    cftableViewcellObj_0.isSniperBreath = NO;
    cftableViewcellObj_0.sniperBreathHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_0.isAntiRecoil = NO;
    cftableViewcellObj_0.antiRecoilHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_0.antiRecoilStr = [NSString stringWithFormat:@"60"];
    
    cftableViewcellObj_0.ballistics_Y_value = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        int y = 0;
        [cftableViewcellObj_0.ballistics_Y_value addObject:[NSNumber numberWithInt:y]];
        y += 5;
    }
    
    cftableViewcellObj_0.keyMap = [NSMutableArray new];
    for (int i = 0; i < 22; i++) {
        
        [cftableViewcellObj_0.keyMap addObject:[NSNumber numberWithInt:4]];
    }
    
    cftableViewcellObj_0.ballistics_changed = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        [cftableViewcellObj_0.ballistics_changed addObject:@"0"];
    }

    
    
    //config 第二組
    CFTableViewCellObject *cftableViewcellObj_1 = [CFTableViewCellObject new];
    cftableViewcellObj_1.configFileName = [NSString stringWithFormat:@"ConfigFileTwo"];
    cftableViewcellObj_1.configPlatformIcon = [NSString stringWithFormat:@"platform_a_2_ps3_88x88"];
    cftableViewcellObj_1.configGameIcon = [NSString stringWithFormat:@"platform_a_5_custom_104x104"];
    cftableViewcellObj_1.configLEDColor = [NSString stringWithFormat:@"platform_btn_a_colorlable_2"];
    cftableViewcellObj_1.configHotKeyStr = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_1.hipStr = [NSString stringWithFormat:@"65"];
    cftableViewcellObj_1.adsStr = [NSString stringWithFormat:@"35"];
    cftableViewcellObj_1.isSync = NO;
    cftableViewcellObj_1.isADStoggle = NO;
    cftableViewcellObj_1.deadZoneStr = [NSString stringWithFormat:@"70"];
    cftableViewcellObj_1.isShootingSpeed = NO;
    cftableViewcellObj_1.shootingSpeedStr = [NSString stringWithFormat:@"55"];
    cftableViewcellObj_1.isInverted = NO;
    cftableViewcellObj_1.isSniperBreath = NO;
    cftableViewcellObj_1.sniperBreathHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_1.isAntiRecoil = NO;
    cftableViewcellObj_1.antiRecoilHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_1.antiRecoilStr = [NSString stringWithFormat:@"55"];

    cftableViewcellObj_1.ballistics_Y_value = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        int y = 1;
        [cftableViewcellObj_1.ballistics_Y_value addObject:[NSNumber numberWithInt:y]];
        y += 5;
    }
    
    cftableViewcellObj_1.keyMap = [NSMutableArray new];
    for (int i = 0; i < 22; i++) {
        
        [cftableViewcellObj_1.keyMap addObject:[NSNumber numberWithInt:11]];
    }

    cftableViewcellObj_1.ballistics_changed = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        [cftableViewcellObj_1.ballistics_changed addObject:@"0"];
    }

    
    
    //config 第三組
    CFTableViewCellObject *cftableViewcellObj_2 = [CFTableViewCellObject new];
    cftableViewcellObj_2.configFileName = [NSString stringWithFormat:@"ConfigFileThree"];
    cftableViewcellObj_2.configPlatformIcon = [NSString stringWithFormat:@"platform_a_3_x1_88x88"];
    cftableViewcellObj_2.configGameIcon = [NSString stringWithFormat:@"platform_a_5_custom_104x104"];
    cftableViewcellObj_2.configLEDColor = [NSString stringWithFormat:@"platform_btn_a_colorlable_4"];
    cftableViewcellObj_2.configHotKeyStr = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_2.hipStr = [NSString stringWithFormat:@"55"];
    cftableViewcellObj_2.adsStr = [NSString stringWithFormat:@"90"];
    cftableViewcellObj_2.isSync = NO;
    cftableViewcellObj_2.isADStoggle = NO;
    cftableViewcellObj_2.deadZoneStr = [NSString stringWithFormat:@"25"];
    cftableViewcellObj_2.isShootingSpeed = NO;
    cftableViewcellObj_2.shootingSpeedStr = [NSString stringWithFormat:@"58"];
    cftableViewcellObj_2.isInverted = NO;
    cftableViewcellObj_2.isSniperBreath = NO;
    cftableViewcellObj_2.sniperBreathHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_2.isAntiRecoil = NO;
    cftableViewcellObj_2.antiRecoilHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_2.antiRecoilStr = [NSString stringWithFormat:@"55"];
    
    cftableViewcellObj_2.ballistics_Y_value = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        int y = 2;
        [cftableViewcellObj_2.ballistics_Y_value addObject:[NSNumber numberWithInt:y]];
        y += 5;
    }
    
    cftableViewcellObj_2.keyMap = [NSMutableArray new];
    for (int i = 0; i < 22; i++) {
        
        [cftableViewcellObj_2.keyMap addObject:[NSNumber numberWithInt:10]];
    }

    cftableViewcellObj_2.ballistics_changed = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        [cftableViewcellObj_2.ballistics_changed addObject:@"0"];
    }

    
    
    //config 第四組
    CFTableViewCellObject *cftableViewcellObj_3 = [CFTableViewCellObject new];
    cftableViewcellObj_3.configFileName = [NSString stringWithFormat:@"ConfigFileFour"];
    cftableViewcellObj_3.configPlatformIcon = [NSString stringWithFormat:@"platform_a_4_x360_88x88"];
    cftableViewcellObj_3.configGameIcon = [NSString stringWithFormat:@"platform_a_5_custom_104x104"];
    cftableViewcellObj_3.configLEDColor = [NSString stringWithFormat:@"platform_btn_a_colorlable_6"];
    cftableViewcellObj_3.configHotKeyStr = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_3.hipStr = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_3.adsStr = [NSString stringWithFormat:@"25"];
    cftableViewcellObj_3.isSync = NO;
    cftableViewcellObj_3.isADStoggle = NO;
    cftableViewcellObj_3.deadZoneStr = [NSString stringWithFormat:@"73"];
    cftableViewcellObj_3.isShootingSpeed = NO;
    cftableViewcellObj_3.shootingSpeedStr = [NSString stringWithFormat:@"11"];
    cftableViewcellObj_3.isInverted = NO;
    cftableViewcellObj_3.isSniperBreath = NO;
    cftableViewcellObj_3.sniperBreathHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_3.isAntiRecoil = NO;
    cftableViewcellObj_3.antiRecoilHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_3.antiRecoilStr = [NSString stringWithFormat:@"66"];
    
    cftableViewcellObj_3.ballistics_Y_value = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        int y = 3;
        [cftableViewcellObj_3.ballistics_Y_value addObject:[NSNumber numberWithInt:y]];
        y += 5;
    }
    
    cftableViewcellObj_3.keyMap = [NSMutableArray new];
    for (int i = 0; i < 22; i++) {
        
        [cftableViewcellObj_3.keyMap addObject:[NSNumber numberWithInt:9]];
    }

    cftableViewcellObj_3.ballistics_changed = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        [cftableViewcellObj_3.ballistics_changed addObject:@"0"];
    }

    
    
    //config 第五組
    CFTableViewCellObject *cftableViewcellObj_4 = [CFTableViewCellObject new];
    cftableViewcellObj_4.configFileName = [NSString stringWithFormat:@"ConfigFileFive"];
    cftableViewcellObj_4.configPlatformIcon = [NSString stringWithFormat:@"platform_a_1_ps4_88x88"];
    cftableViewcellObj_4.configGameIcon = [NSString stringWithFormat:@"platform_a_5_custom_104x104"];
    cftableViewcellObj_4.configLEDColor = [NSString stringWithFormat:@"platform_btn_a_colorlable_7"];
    cftableViewcellObj_4.configHotKeyStr = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_4.hipStr = [NSString stringWithFormat:@"14"];
    cftableViewcellObj_4.adsStr = [NSString stringWithFormat:@"60"];
    cftableViewcellObj_4.isSync = NO;
    cftableViewcellObj_4.isADStoggle = NO;
    cftableViewcellObj_4.deadZoneStr = [NSString stringWithFormat:@"55"];
    cftableViewcellObj_4.isShootingSpeed = NO;
    cftableViewcellObj_4.shootingSpeedStr = [NSString stringWithFormat:@"41"];
    cftableViewcellObj_4.isInverted = NO;
    cftableViewcellObj_4.isSniperBreath = NO;
    cftableViewcellObj_4.sniperBreathHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_4.isAntiRecoil = NO;
    cftableViewcellObj_4.antiRecoilHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_4.antiRecoilStr = [NSString stringWithFormat:@"68"];
    
    cftableViewcellObj_4.ballistics_Y_value = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        int y = 4;
        [cftableViewcellObj_4.ballistics_Y_value addObject:[NSNumber numberWithInt:y]];
        y += 5;
    }
    
    cftableViewcellObj_4.keyMap = [NSMutableArray new];
    for (int i = 0; i < 22; i++) {
        
        [cftableViewcellObj_4.keyMap addObject:[NSNumber numberWithInt:8]];
    }
    
    cftableViewcellObj_4.ballistics_changed = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        [cftableViewcellObj_4.ballistics_changed addObject:@"0"];
    }


    //config 第六組
    CFTableViewCellObject *cftableViewcellObj_5 = [CFTableViewCellObject new];
    cftableViewcellObj_5.configFileName = [NSString stringWithFormat:@"ConfigFileSix"];
    cftableViewcellObj_5.configPlatformIcon = [NSString stringWithFormat:@"platform_a_2_ps3_88x88"];
    cftableViewcellObj_5.configGameIcon = [NSString stringWithFormat:@"platform_a_5_custom_104x104"];
    cftableViewcellObj_5.configLEDColor = [NSString stringWithFormat:@"platform_btn_a_colorlable_8"];
    cftableViewcellObj_5.configHotKeyStr = [NSString stringWithFormat:@""];
    cftableViewcellObj_5.hipStr = [NSString stringWithFormat:@"77"];
    cftableViewcellObj_5.adsStr = [NSString stringWithFormat:@"33"];
    cftableViewcellObj_5.isSync = NO;
    cftableViewcellObj_5.isADStoggle = NO;
    cftableViewcellObj_5.deadZoneStr = [NSString stringWithFormat:@"55"];
    cftableViewcellObj_5.isShootingSpeed = NO;
    cftableViewcellObj_5.shootingSpeedStr = [NSString stringWithFormat:@"52"];
    cftableViewcellObj_5.isInverted = NO;
    cftableViewcellObj_5.isSniperBreath = NO;
    cftableViewcellObj_5.sniperBreathHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_5.isAntiRecoil = NO;
    cftableViewcellObj_5.antiRecoilHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_5.antiRecoilStr = [NSString stringWithFormat:@"100"];
    
    cftableViewcellObj_5.ballistics_Y_value = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        int y = 5;
        [cftableViewcellObj_5.ballistics_Y_value addObject:[NSNumber numberWithInt:y]];
        y += 5;
    }
    
    cftableViewcellObj_5.keyMap = [NSMutableArray new];
    for (int i = 0; i < 22; i++) {
        
        [cftableViewcellObj_5.keyMap addObject:[NSNumber numberWithInt:7]];
    }
    
    cftableViewcellObj_5.ballistics_changed = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        [cftableViewcellObj_5.ballistics_changed addObject:@"0"];
    }

    
    //config 第七組
    CFTableViewCellObject *cftableViewcellObj_6 = [CFTableViewCellObject new];
    cftableViewcellObj_6.configFileName = [NSString stringWithFormat:@"ConfigFileSeven"];
    cftableViewcellObj_6.configPlatformIcon = [NSString stringWithFormat:@"platform_a_3_x1_88x88"];
    cftableViewcellObj_6.configGameIcon = [NSString stringWithFormat:@"platform_a_5_custom_104x104"];
    cftableViewcellObj_6.configLEDColor = [NSString stringWithFormat:@"platform_btn_a_colorlable_9"];
    cftableViewcellObj_6.configHotKeyStr = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_6.hipStr = [NSString stringWithFormat:@"99"];
    cftableViewcellObj_6.adsStr = [NSString stringWithFormat:@"65"];
    cftableViewcellObj_6.isSync = NO;
    cftableViewcellObj_6.isADStoggle = NO;
    cftableViewcellObj_6.deadZoneStr = [NSString stringWithFormat:@"84"];
    cftableViewcellObj_6.isShootingSpeed = NO;
    cftableViewcellObj_6.shootingSpeedStr = [NSString stringWithFormat:@"23"];
    cftableViewcellObj_6.isInverted = NO;
    cftableViewcellObj_6.isSniperBreath = NO;
    cftableViewcellObj_6.sniperBreathHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_6.isAntiRecoil = NO;
    cftableViewcellObj_6.antiRecoilHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_6.antiRecoilStr = [NSString stringWithFormat:@"55"];
    
    cftableViewcellObj_6.ballistics_Y_value = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        int y = 0;
        [cftableViewcellObj_6.ballistics_Y_value addObject:[NSNumber numberWithInt:y]];
        y += 5;
    }
    
    cftableViewcellObj_6.keyMap = [NSMutableArray new];
    for (int i = 0; i < 22; i++) {
        
        [cftableViewcellObj_6.keyMap addObject:[NSNumber numberWithInt:4]];
    }
    
    cftableViewcellObj_6.ballistics_changed = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        [cftableViewcellObj_6.ballistics_changed addObject:@"0"];
    }

    
    //config 第八組
    CFTableViewCellObject *cftableViewcellObj_7 = [CFTableViewCellObject new];
    cftableViewcellObj_7.configFileName = [NSString stringWithFormat:@"ConfigFileEight"];
    cftableViewcellObj_7.configPlatformIcon = [NSString stringWithFormat:@"platform_a_3_x1_88x88"];
    cftableViewcellObj_7.configGameIcon = [NSString stringWithFormat:@"platform_a_5_custom_104x104"];
    cftableViewcellObj_7.configLEDColor = [NSString stringWithFormat:@"platform_btn_a_colorlable_5"];
    cftableViewcellObj_7.configHotKeyStr = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_7.hipStr = [NSString stringWithFormat:@"95"];
    cftableViewcellObj_7.adsStr = [NSString stringWithFormat:@"58"];
    cftableViewcellObj_7.isSync = NO;
    cftableViewcellObj_7.isADStoggle = NO;
    cftableViewcellObj_7.deadZoneStr = [NSString stringWithFormat:@"15"];
    cftableViewcellObj_7.isShootingSpeed = NO;
    cftableViewcellObj_7.shootingSpeedStr = [NSString stringWithFormat:@"55"];
    cftableViewcellObj_7.isInverted = NO;
    cftableViewcellObj_7.isSniperBreath = NO;
    cftableViewcellObj_7.sniperBreathHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_7.isAntiRecoil = NO;
    cftableViewcellObj_7.antiRecoilHotkey = [NSString stringWithFormat:@"0"];
    cftableViewcellObj_7.antiRecoilStr = [NSString stringWithFormat:@"82"];
    
    cftableViewcellObj_7.ballistics_Y_value = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        int y = 2;
        [cftableViewcellObj_7.ballistics_Y_value addObject:[NSNumber numberWithInt:y]];
        y += 5;
    }
    
    cftableViewcellObj_7.keyMap = [NSMutableArray new];
    for (int i = 0; i < 22; i++) {
        
        [cftableViewcellObj_7.keyMap addObject:[NSNumber numberWithInt:5]];
    }
    
    cftableViewcellObj_7.ballistics_changed = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        
        [cftableViewcellObj_7.ballistics_changed addObject:@"0"];
    }

    
    //ary_configObj = [NSMutableArray arrayWithObjects:cftableViewcellObj_0,cftableViewcellObj_1,cftableViewcellObj_2,cftableViewcellObj_3,cftableViewcellObj_4,cftableViewcellObj_5,cftableViewcellObj_6, nil];
    
    
    ary_configObj = [[NSMutableArray alloc] initWithCapacity:0];
    
    //按下cell背景變色
    list_bgimage = [NSMutableArray arrayWithObjects:
                    [NSString stringWithFormat:@"0"],
                    [NSString stringWithFormat:@"0"],
                    [NSString stringWithFormat:@"0"],
                    [NSString stringWithFormat:@"0"],
                    [NSString stringWithFormat:@"0"],
                    [NSString stringWithFormat:@"0"],
                    [NSString stringWithFormat:@"0"],
                    [NSString stringWithFormat:@"0"],nil];

    
    //******************************  測試用 Marco ***************************
    //Macro 第一組
    MCTableViewCellObject *mctableViewcellObj_0 = [MCTableViewCellObject new];
    mctableViewcellObj_0.hotKeyImgStr = [NSString stringWithFormat:@"config_icon_a_unchangable_1"];
    mctableViewcellObj_0.marcoHotKey = [NSString stringWithFormat:@"4"];
    mctableViewcellObj_0.marcoFileName = [NSString stringWithFormat:@"Macro1"];
    mctableViewcellObj_0.marcoPlatformImgStr = cftableViewcellObj_0.configPlatformIcon;
    
    
    mctableViewcellObj_0.marco_ary_key = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:142],[NSNumber numberWithInt:144],[NSNumber numberWithInt:15],[NSNumber numberWithInt:14],[NSNumber numberWithInt:29],[NSNumber numberWithInt:22],[NSNumber numberWithInt:140],[NSNumber numberWithInt:155],[NSNumber numberWithInt:14],[NSNumber numberWithInt:129],[NSNumber numberWithInt:65],[NSNumber numberWithInt:233],[NSNumber numberWithInt:79],[NSNumber numberWithInt:130],[NSNumber numberWithInt:-1],[NSNumber numberWithInt:-1], nil];
    
    mctableViewcellObj_0.marco_ary_delayTime = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:100],[NSNumber numberWithInt:800],[NSNumber numberWithInt:99],[NSNumber numberWithInt:1500],[NSNumber numberWithInt:800],[NSNumber numberWithInt:2000],[NSNumber numberWithInt:1000],[NSNumber numberWithInt:100],[NSNumber numberWithInt:1000],[NSNumber numberWithInt:67],[NSNumber numberWithInt:0],[NSNumber numberWithInt:1000],[NSNumber numberWithInt:3000],[NSNumber numberWithInt:4000],nil];
    
    
    //Marco 第二組
    MCTableViewCellObject *mctableViewcellObj_1 = [MCTableViewCellObject new];
    mctableViewcellObj_1.hotKeyImgStr = [NSString stringWithFormat:@"config_icon_a_unchangable_1"];
    mctableViewcellObj_1.marcoHotKey = [NSString stringWithFormat:@"5"];
    mctableViewcellObj_1.marcoFileName = [NSString stringWithFormat:@"Macro2"];
    mctableViewcellObj_1.marcoPlatformImgStr = cftableViewcellObj_1.configPlatformIcon;
    
    mctableViewcellObj_1.marco_ary_key = [NSMutableArray new];
    for (int i = 0; i < 16; i++) {
        
        [mctableViewcellObj_1.marco_ary_key addObject:[NSNumber numberWithInt:11]];
        
    }

    
    
    //Marco 第三組
    MCTableViewCellObject *mctableViewcellObj_2 = [MCTableViewCellObject new];
    mctableViewcellObj_2.hotKeyImgStr = [NSString stringWithFormat:@"config_icon_a_unchangable_1"];
    mctableViewcellObj_2.marcoHotKey = [NSString stringWithFormat:@"6"];
    mctableViewcellObj_2.marcoFileName = [NSString stringWithFormat:@"Macro3"];
    mctableViewcellObj_2.marcoPlatformImgStr = cftableViewcellObj_1.configPlatformIcon;

    mctableViewcellObj_2.marco_ary_key = [NSMutableArray new];
    for (int i = 0; i < 16; i++) {
        
        [mctableViewcellObj_2.marco_ary_key addObject:[NSNumber numberWithInt:12]];
    }

    
    //Marco 第四組
    MCTableViewCellObject *mctableViewcellObj_3 = [MCTableViewCellObject new];
    mctableViewcellObj_3.hotKeyImgStr = [NSString stringWithFormat:@"config_icon_a_unchangable_1"];
    mctableViewcellObj_3.marcoHotKey = [NSString stringWithFormat:@"7"];
    mctableViewcellObj_3.marcoFileName = [NSString stringWithFormat:@"Macro4"];
    mctableViewcellObj_3.marcoPlatformImgStr = cftableViewcellObj_3.configPlatformIcon;
    
    mctableViewcellObj_3.marco_ary_key = [NSMutableArray new];
    for (int i = 0; i < 16; i++) {
        
        [mctableViewcellObj_3.marco_ary_key addObject:[NSNumber numberWithInt:13]];
    }

    
    
    //Marco 第五組
    MCTableViewCellObject *mctableViewcellObj_4 = [MCTableViewCellObject new];
    mctableViewcellObj_4.hotKeyImgStr = [NSString stringWithFormat:@"config_icon_a_unchangable_1"];
    mctableViewcellObj_4.marcoHotKey = [NSString stringWithFormat:@"8"];
    mctableViewcellObj_4.marcoFileName = [NSString stringWithFormat:@"Macro5"];
    mctableViewcellObj_4.marcoPlatformImgStr = cftableViewcellObj_4.configPlatformIcon;
    
    mctableViewcellObj_4.marco_ary_key = [NSMutableArray new];
    for (int i = 0; i < 16; i++) {
        
        [mctableViewcellObj_4.marco_ary_key addObject:[NSNumber numberWithInt:25]];
    }

    
    
    //Marco 第六組
    MCTableViewCellObject *mctableViewcellObj_5 = [MCTableViewCellObject new];
    mctableViewcellObj_5.hotKeyImgStr = [NSString stringWithFormat:@"config_icon_a_unchangable_1"];
    mctableViewcellObj_5.marcoHotKey = [NSString stringWithFormat:@"9"];
    mctableViewcellObj_5.marcoFileName = [NSString stringWithFormat:@"Macro6"];
    mctableViewcellObj_5.marcoPlatformImgStr = cftableViewcellObj_5.configPlatformIcon;
    
    mctableViewcellObj_5.marco_ary_key = [NSMutableArray new];
    for (int i = 0; i < 16; i++) {
        
        [mctableViewcellObj_5.marco_ary_key addObject:[NSNumber numberWithInt:29]];
    }

    
    
    //Marco 第七組
    MCTableViewCellObject *mctableViewcellObj_6 = [MCTableViewCellObject new];
    mctableViewcellObj_6.hotKeyImgStr = [NSString stringWithFormat:@"config_icon_a_unchangable_1"];
    mctableViewcellObj_6.marcoHotKey = [NSString stringWithFormat:@"10"];
    mctableViewcellObj_6.marcoFileName = [NSString stringWithFormat:@"Macro7"];
    mctableViewcellObj_6.marcoPlatformImgStr = cftableViewcellObj_6.configPlatformIcon;
    
    mctableViewcellObj_6.marco_ary_key = [NSMutableArray new];
    for (int i = 0; i < 16; i++) {
        
        [mctableViewcellObj_6.marco_ary_key addObject:[NSNumber numberWithInt:113]];
    }

    
    //Marco 第八組
    MCTableViewCellObject *mctableViewcellObj_7 = [MCTableViewCellObject new];
    mctableViewcellObj_7.hotKeyImgStr = [NSString stringWithFormat:@"config_icon_a_unchangable_1"];
    mctableViewcellObj_7.marcoHotKey = [NSString stringWithFormat:@"11"];
    mctableViewcellObj_7.marcoFileName = [NSString stringWithFormat:@"Macro8"];
    mctableViewcellObj_7.marcoPlatformImgStr = cftableViewcellObj_7.configPlatformIcon;
    
    mctableViewcellObj_7.marco_ary_key = [NSMutableArray new];
    for (int i = 0; i < 16; i++) {
        
        [mctableViewcellObj_7.marco_ary_key addObject:[NSNumber numberWithInt:105]];
    }

    
    //ary_marocObj = [NSMutableArray arrayWithObjects:mctableViewcellObj_0,mctableViewcellObj_1,mctableViewcellObj_2,mctableViewcellObj_3,mctableViewcellObj_4,mctableViewcellObj_5,mctableViewcellObj_6, nil];

    ary_marocObj = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    //cloud 初始化
    cloudClass = [[FPCloudClass alloc]init];
    cloudClass.delegate = self;
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    //portocol delegate
    [ProtocolDataController sharedInstance].dataResponseDelegate = self;
    [ProtocolDataController sharedInstance].connectStateDelegate = self;

    
    //判斷主頁是點選 Config 還是 Macro
    if (self.isSelectedConfig == YES) {//nick
        
        m_btAnimation.configAnimFlag = YES;
    }
    else {
        
        m_btAnimation.configAnimFlag = NO;
    }
    
    
//    [ary_configObj removeAllObjects];
//    
//    NSMutableArray *configArray = [[ConfigMacroData sharedInstance]getConfigArray];
//    
//    NSLog(@"+++++///====: %lu",(unsigned long)[[[ConfigMacroData sharedInstance]getConfigArray]count]);
//    
//    //**********   ary_configObj 對應 getConfigArray   **********
//    for (int i = 0; i < [[[ConfigMacroData sharedInstance]getConfigArray]count]; i++) {
//        
//        CFTableViewCellObject *config = [CFTableViewCellObject new];
//        
//        config.configFileName = [[configArray objectAtIndex:i] objectForKey:@"configName"];
//        
//        //platform
//        config.configPlatformIcon = [[configArray objectAtIndex:i] objectForKey:@"platform"];
//        
//        
//        //LEDColor(platformColor)
//        NSString *platformNumStr = [[configArray objectAtIndex:i]objectForKey:@"LEDColor"];
//        config.configLEDColor = platformNumStr;
//        
//        
//        //預設遊戲圖片
//        config.configGameIcon = [NSString stringWithFormat:@"platform_a_5_custom_104x104"];
//        
//        //hotkey int 轉 NSString
//        config.configHotKeyStr = [[configArray objectAtIndex:i]objectForKey:@"configHotKey"];
//        
//        
//        config.hipStr = [[configArray objectAtIndex:i] objectForKey:@"HIPSensitivity"];
//        
//        config.adsStr = [[configArray objectAtIndex:i] objectForKey:@"ADSSensitivity"];
//        
//        config.isSync = [[[configArray objectAtIndex:i] objectForKey:@"flagADSSync"]intValue];
//        
//        config.isADStoggle = [[[configArray objectAtIndex:i] objectForKey:@"flagADSToggle"]intValue];
//        
//        config.deadZoneStr = [[configArray objectAtIndex:i] objectForKey:@"deadZONE"];
//        
//        config.isShootingSpeed = [[[configArray objectAtIndex:i] objectForKey:@"flagShootingSpeed"]intValue];
//        
//        config.shootingSpeedStr = [[configArray objectAtIndex:i] objectForKey:@"shootingSpeed"];
//        
//        config.isInverted = [[[configArray objectAtIndex:i] objectForKey:@"flagInvertedYAxis"]intValue];
//        
//        config.isSniperBreath = [[[configArray objectAtIndex:i] objectForKey:@"flagSniperBreath"]intValue];
//        
//        //sniperBreathHotkey int 轉 NSString
//        int sniperBreathHotkeyNum = [[[configArray objectAtIndex:i] objectForKey:@"sniperBreathHotKey"]intValue];
//        NSString *sniperBreathHotkeyStr = [keycodeClass returnKeyboardKey:sniperBreathHotkeyNum];
//        config.sniperBreathHotkey = sniperBreathHotkeyStr;
//        
//        
//        config.isAntiRecoil = [[[configArray objectAtIndex:i] objectForKey:@"flagAntiRecoil"] boolValue];
//        
//        
//        //antiRecoilHotkey int 轉 NSString
//        int antiRecoilHotkeyNum = [[[configArray objectAtIndex:i]objectForKey:@"antiRecoilHotkey"]intValue];
//        
//        NSString *antiRecoilHotkeyStr = [keycodeClass returnKeyboardKey:antiRecoilHotkeyNum];
//        config.antiRecoilHotkey = antiRecoilHotkeyStr;
//        
//        
//        config.antiRecoilStr = [[configArray objectAtIndex:i] objectForKey:@"antiRecoilOffsetValue"];
//        
//        config.keyMap = [[configArray objectAtIndex:i] objectForKey:@"keyMapArray"];
//        
//        config.ballistics_Y_value = [[configArray objectAtIndex:i] objectForKey:@"ballisticsArray"];
//        
//        config.ballistics_changed = [[configArray objectAtIndex:i] objectForKey:@"ballisticsChanged"];
//        
//        [ary_configObj addObject:config];
//        
//    }
//    
//    //**********   ary_marcoObj 對應 getConfigArray   **********
//    
//    [ary_marocObj removeAllObjects];
//    
//    NSMutableArray *marcoArray = [[ConfigMacroData sharedInstance] getMacroArray];
//    
//    for (int i = 0; i < [[[ConfigMacroData sharedInstance]getMacroArray]count]; i++) {
//       
//        MCTableViewCellObject *macro = [MCTableViewCellObject new];
//        
//        //macro fileName
//        macro.marcoFileName = [[marcoArray objectAtIndex:i] objectForKey:@"macroName"];
// 
//        //macro platform
//        macro.marcoPlatformImgStr = [[marcoArray objectAtIndex:i] objectForKey:@"macroPlatform"];
//        
//        //macro hotkey
//        macro.marcoHotKey = [[marcoArray objectAtIndex:i] objectForKey:@"macroHotkey"];
//        
//        
//        //macro KeyArray
//        macro.marco_ary_key = [[marcoArray objectAtIndex:i] objectForKey:@"macroKeyArr"];
//        
//        //marco delatimeArray
//        macro.marco_ary_delayTime = [[marcoArray objectAtIndex:i] objectForKey:@"macroDelayArr"];
//
//        [ary_marocObj addObject:macro];
//    }
//    
//    
//    //
//    m_timer = [NSTimer scheduledTimerWithTimeInterval:1/5 target:self selector:@selector(showConfigOrMarcoObject) userInfo:nil repeats:YES];
// 
//    for (int i = 0; i < list_bgimage.count ; i++) {
//        
//        list_bgimage[i] = [NSString stringWithFormat:@"0"];
//    }
//
//    preIndexPath = nil;
//    
//    [self.m_tableView reloadData];
    
    
    [self configAndMacroReloadData];
    
    
    
    
    //(本機圖片)
//    configImgAry = [[ConfigMacroData sharedInstance] getConfigImage];
//    
//    NSLog(@"LOAD configImgAry:%d",configImgAry.count);
    

    [m_btAnimation bezierPath];
    
//    if (configMainNav == nil) {
//        
//        configMainNav = [[UINavigationController alloc]initWithRootViewController:self];
//    }
    
    
    
    //即時切換語系
    [self.configEditBT setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];//編輯
    
    [self.configNewBt setTitle:NSLocalizedString(@"New", nil) forState:UIControlStateNormal];//新增
    
    [self.configLoadBt setTitle:NSLocalizedString(@"Load", nil) forState:UIControlStateNormal];//載入
    
    [self.configBackupBt setTitle:NSLocalizedString(@"Backup", nil) forState:UIControlStateNormal];//備份
    
    [self.macroEditBt setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];//編輯
    
    [self.macroNewBt setTitle:NSLocalizedString(@"New", nil) forState:UIControlStateNormal];//新增
}

#pragma mark - configAndMacroReloadData
-(void)configAndMacroReloadData {
    
    [ary_configObj removeAllObjects];
    
    NSMutableArray *configArray = [[ConfigMacroData sharedInstance] getConfigArray];
    
    NSLog(@"+++++///====: %lu",(unsigned long)[configArray count]);
    
    //**********   ary_configObj 對應 getConfigArray   **********
    for (int i = 0; i < [configArray count]; i++) {
        
        CFTableViewCellObject *config = [CFTableViewCellObject new];
        
        config.configFileName = [[configArray objectAtIndex:i] objectForKey:@"configName"];
        
        //platform
        config.configPlatformIcon = [[configArray objectAtIndex:i] objectForKey:@"platform"];
        
        
        //LEDColor(platformColor)
        NSString *platformNumStr = [[configArray objectAtIndex:i]objectForKey:@"LEDColor"];
        config.configLEDColor = platformNumStr;
        
        
        //預設遊戲圖片
        //config.configGameIcon = [NSString stringWithFormat:@"platform_a_5_custom_104x104"];
        
        
        //hotkey int 轉 NSString
        config.configHotKeyStr = [[configArray objectAtIndex:i]objectForKey:@"configHotKey"];
        
        config.hipStr = [[configArray objectAtIndex:i] objectForKey:@"HIPSensitivity"];
        
        config.adsStr = [[configArray objectAtIndex:i] objectForKey:@"ADSSensitivity"];
        
        config.isSync = [[[configArray objectAtIndex:i] objectForKey:@"flagADSSync"]intValue];
        
        config.isADStoggle = [[[configArray objectAtIndex:i] objectForKey:@"flagADSToggle"]intValue];
        
        config.deadZoneStr = [[configArray objectAtIndex:i] objectForKey:@"deadZONE"];
        
        config.isShootingSpeed = [[[configArray objectAtIndex:i] objectForKey:@"flagShootingSpeed"]intValue];
        
        config.shootingSpeedStr = [[configArray objectAtIndex:i] objectForKey:@"shootingSpeed"];
        
        config.isInverted = [[[configArray objectAtIndex:i] objectForKey:@"flagInvertedYAxis"]intValue];
        
        config.isSniperBreath = [[[configArray objectAtIndex:i] objectForKey:@"flagSniperBreath"]intValue];
        
        //sniperBreathHotkey int 轉 NSString
        int sniperBreathHotkeyNum = [[[configArray objectAtIndex:i] objectForKey:@"sniperBreathHotKey"]intValue];
        NSString *sniperBreathHotkeyStr = [keycodeClass returnKeyboardKey:sniperBreathHotkeyNum];
        config.sniperBreathHotkey = sniperBreathHotkeyStr;
        
        
        config.isAntiRecoil = [[[configArray objectAtIndex:i] objectForKey:@"flagAntiRecoil"] boolValue];
        
        
        //antiRecoilHotkey int 轉 NSString
        int antiRecoilHotkeyNum = [[[configArray objectAtIndex:i]objectForKey:@"antiRecoilHotkey"]intValue];
        
        NSString *antiRecoilHotkeyStr = [keycodeClass returnKeyboardKey:antiRecoilHotkeyNum];
        config.antiRecoilHotkey = antiRecoilHotkeyStr;
        
        
        config.antiRecoilStr = [[configArray objectAtIndex:i] objectForKey:@"antiRecoilOffsetValue"];
        
        config.keyMap = [[configArray objectAtIndex:i] objectForKey:@"keyMapArray"];
        
        config.ballistics_Y_value = [[configArray objectAtIndex:i] objectForKey:@"ballisticsArray"];
        
        config.ballistics_changed = [[configArray objectAtIndex:i] objectForKey:@"ballisticsChanged"];
        
        [ary_configObj addObject:config];
        
    }
    
    //**********   ary_marcoObj 對應 getConfigArray   **********
    
    [ary_marocObj removeAllObjects];
    
    NSMutableArray *marcoArray = [[ConfigMacroData sharedInstance] getMacroArray];
    
    NSLog(@"+++++///====marcoArray: %lu",(unsigned long)[marcoArray count]);
    
    for (int i = 0; i < [marcoArray count]; i++) {
        
        MCTableViewCellObject *macro = [MCTableViewCellObject new];
        
        //macro fileName
        macro.marcoFileName = [[marcoArray objectAtIndex:i] objectForKey:@"macroName"];
        
        //macro platform
        macro.marcoPlatformImgStr = [[marcoArray objectAtIndex:i] objectForKey:@"macroPlatform"];
        
        //macro hotkey
        macro.marcoHotKey = [[marcoArray objectAtIndex:i] objectForKey:@"macroHotkey"];
        
        //macro KeyArray
        macro.marco_ary_key = [[marcoArray objectAtIndex:i] objectForKey:@"macroKeyArr"];
        
        //marco delatimeArray
        macro.marco_ary_delayTime = [[marcoArray objectAtIndex:i] objectForKey:@"macroDelayArr"];
        
        
        
        [ary_marocObj addObject:macro];
    }
    
    
    //
    //m_timer = [NSTimer scheduledTimerWithTimeInterval:1/5 target:self selector:@selector(showConfigOrMarcoObject) userInfo:nil repeats:YES];
    
    for (int i = 0; i < list_bgimage.count ; i++) {
        
        list_bgimage[i] = [NSString stringWithFormat:@"0"];
    }
    
    preIndexPath = nil;
    
    NSLog(@"ary_configObj==>%d",ary_configObj.count);
    
    [self.m_tableView reloadData];
}


-(void)viewWillDisappear:(BOOL)animated {
    
    NSLog(@"CFMainViewController     viewWillDisappear");
    
    //dataResponseDelegate設為nil，如果有些ViewController沒有實作Delegate會出現類似”[HomeViewController onResponseLiveMode:]: unrecognized selector sent to instance 0x162a6a00“的錯誤，不然就是之後每個ViewController的Delegate都要實作
    [ProtocolDataController sharedInstance].dataResponseDelegate = nil;
    
    
    //[m_timer invalidate];
    
    
    //隱藏側邊選單
    [_menuBt setImage:[UIImage imageNamed:@"config_mainmenu_off_btn_a_up"] forState:UIControlStateNormal];
    
    _menuView.alpha = 0.0;
    
    self.isSeleced_config = NO;
    self.isSeleced_marco = NO;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - configBtAction(config下面選單)
- (IBAction)configBtAction:(UIButton *)sender {
    
//    if (isSeleced_config == NO) {
//        
//        self.configEditBT.userInteractionEnabled = NO;
//        self.configLoadBt.userInteractionEnabled = NO;
//        
//    }
//    else {
//        
//        self.configEditBT.userInteractionEnabled = YES;
//        self.configLoadBt.userInteractionEnabled = YES;
//    }
    
    if (sender.tag == 11) {//編輯頁面
        
        if (self.isSeleced_config == NO) {
            
            return;
        }
        
        if (m_cfEditVC == nil) {
            
            m_cfEditVC = (CFEditViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFEditVC"];
        }
        
        m_cfEditVC.isCreate = NO;
        
        self.isSeleced_config = NO;
        
        m_cfEditVC.alreadyInitView = NO;
        
        m_cfEditVC.isCustom = YES;
        
        [self.navigationController pushViewController:m_cfEditVC animated:YES];
        
        //[self presentViewController:m_cfEditVC animated:YES completion:nil];
    
    }
    else if (sender.tag == 22) {//新增頁面
        
        //點擊新增須先判斷 config 是否已超過 8 組
        if (ary_configObj.count >= 8) {
            
            WaringViewController *waring = [self.storyboard instantiateViewControllerWithIdentifier:@"Key_WaringViewController"];
            waring.parentObj = self;
            waring.waring_message = NSLocalizedString(@"config limit 8", nil);// @"config上限為8組";
            
            //waring.waring_description = @"config上限為8組,請刪除\nconfig後，再繼續新增";
            [self presentViewController:waring animated:YES completion:nil];
            
            self.isSelectedConfig = YES;
            
            return;
        }
        
        if (m_cfCreateVC == nil) {
            
            m_cfCreateVC = (CFCreatViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFCreateVC"];
        }
        
    
        
        [self.navigationController pushViewController:m_cfCreateVC animated:YES];
        
        //[self presentViewController:m_cfCreateVC animated:YES completion:nil];
        
    }
    else if (sender.tag == 33) { //loading 頁面
        
        if (self.isSeleced_config == NO) {
            
            return;
        }
        
        [self loadConfigAction];
        
        //Loading 等待畫面
        loadView = [[ConnectLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        [loadView setStatusLabel:NSLocalizedString(@"Loading...", nil)];
        
        [self.view addSubview:loadView];

        
    }
    else if (sender.tag == 44) { //backup 頁面
        
        
        if (![CheckNetwork isExistenceNetwork]) {
            
            //無網路時
            [self showAlert:NSLocalizedString(@"Connect fail", nil) message:NSLocalizedString(@"Please check your wifi", nil)];
            
            return;
        }
        else {
            
            UILabel *l = (UILabel *)[self.view viewWithTag:83];
            l.textColor = [UIColor whiteColor];
            
            
            if (m_cfBackupVC == nil) {
                
                m_cfBackupVC = (CFBackupViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFBackupVC"];
            }
            
            if (self.isSeleced_config == NO) {
                //無點選 直接進入 Backup
                
                //先判斷是否已登入
                if ([self checkLogin] == NO) {
                    
                    [self alertViewForLogin];
                    
                    return;
                }
                
                
                [self.navigationController pushViewController:m_cfBackupVC animated:YES];
            }
            else {
                //點選一組config ---> Backup
                
                NSLog(@"點選一組config ---> Backup");
                
                //先判斷是否已登入
                if ([self checkLogin] == NO) {
                    
                    [self alertViewForLogin];
                    
                    return;
                }

                
                [self postConfigDataBackup];
                
                self.isSeleced_config = NO;
                
//                //Loading 等待畫面
//                loadView = [[ConnectLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//                
//                [loadView setStatusLabel:NSLocalizedString(@"Loading...", nil)];
//                
//                [self.view addSubview:loadView];
//                
//                [self.navigationController pushViewController:m_cfBackupVC animated:YES];
                
            }

        }
        
    }
    
}

#pragma mark - checkLogin
-(BOOL)checkLogin {
    
    BOOL isLogin = NO;
    
    if ([ConfigMacroData sharedInstance].logIn) {
        
        isLogin = YES;
    }
    else {
        
        isLogin = NO;
    }

    return isLogin;
}

#pragma mark - alertView for login
-(void)alertViewForLogin {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Please sign in first", nil) preferredStyle:UIAlertControllerStyleAlert];//請先登入
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirm", nil)style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];//確定
    
    
    [alert addAction:doneAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



#pragma mark - 判斷是config 還是 macro 在 reloadData
-(void)configOrMacroReloadData:(BOOL)configAction {
    
    if (configAction == YES) {
        
        self.isSelectedConfig = YES;
        _configMarcoLabel.text = NSLocalizedString(@"Config", nil);
        _bottomList_config.hidden = NO;
        _bottomList_marco.hidden = YES;
    }
    else {
        
        self.isSelectedConfig = NO;
        _configMarcoLabel.text = NSLocalizedString(@"Macro", nil);
        _bottomList_config.hidden = YES;
        _bottomList_marco.hidden = NO;
    }
    
    [self.m_tableView reloadData];
}


#pragma  mark - Tableview DataSource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger theCount;
    
    if(m_btAnimation != nil) {
        
        //nick
        if (self.isSelectedConfig == YES) {
            
            theCount = ary_configObj.count;
        }
        else {
            
            theCount = ary_marocObj.count;
        }
    }
    
    NSLog(@"theCount==>%d",theCount);
    
    return theCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomizedCell *cell;
    
    if (m_btAnimation != nil) {
        
        //nick
        if (self.isSelectedConfig == YES) {
            
            //======  config  ==========
            CustomizedCell *configCell = [tableView dequeueReusableCellWithIdentifier:@"configTableViewCell" forIndexPath:indexPath];
            
            cell = configCell;
            
            //客製化 tableViewCell
            cell.superTableView = self.m_tableView;
            cell.superIndexPath = indexPath;
            cell.superAryList = ary_configObj;
            
            //NSLog(@"cell ary_configObj:%@",ary_configObj[0]);
            //NSLog(@"cell superAryList:%@",cell.superAryList[0]);
            
            cell.theRowHeight = tableView.rowHeight;
            [cell createDeleteBt:self.m_tableView];
            cell.cellSuperVC = self;
            
            //改變cell的背景顏色
            NSString *item=[list_bgimage objectAtIndex:indexPath.row];
            UIImageView *bg = [cell.contentView viewWithTag:10];
            if([item isEqualToString:@"1"])
            {
                bg.alpha = 1.0;
            }
            else{
                
                bg.alpha = 0.0;
            }
            
            //遊戲Icon
            
            
            UIImageView *gameIcon = [cell.contentView viewWithTag:20];
            
            NSData *imgData;
            
            
//          NSLog(@"cellForRowAtIndexPath-----indexPath.row = %i", indexPath.row);
            
            
            NSString *configName = [[ConfigMacroData sharedInstance] getConfigName:indexPath.row];
            
//          NSLog(@"cellForRowAtIndexPath-----configName = %@", configName);
            
            NSMutableDictionary *configImgDic = [[ConfigMacroData sharedInstance] getConfigImageKey:configName];
            
            imgData = [configImgDic objectForKey:@"configImage"];
            
            gameIcon.image = [UIImage imageWithData:imgData];
            
            
            
//            if(configImgAry.count > 0 && indexPath.row<=configImgAry.count-1)
//            {
//                
//                
//                imgData = [[configImgAry objectAtIndex:indexPath.row] objectForKey:@"configImage"];
//            
//                gameIcon.image = [UIImage imageWithData:imgData];
//                
//                NSLog(@"set configImage");
//                
//            }else{
//                gameIcon.image = [UIImage imageNamed:@"platform_a_5_custom_408x408"];
//            }
    
            gameIcon.layer.cornerRadius = 5.0;
            gameIcon.layer.masksToBounds = YES;
            
            [self setFrameToFitPad:gameIcon OriginXoffset:0 OriginYoffset:0];
            
            NSLog(@"ary_configObj.count:%d",ary_configObj.count);
            //NSLog(@"gameImg ========");
            //遊戲config名稱(configFileName)
            UILabel *description = [cell.contentView viewWithTag:30];
            description.text = [ary_configObj[indexPath.row] configFileName];
            

            
            //機台種類
            UIImageView *machine = [cell.contentView viewWithTag:40];
            int configPlatformInt = [ary_configObj[indexPath.row].configPlatformIcon intValue];
            machine.image = [UIImage imageNamed:[self getPlatformNumTransformToIcon:configPlatformInt]];
            [self setFrameToFitPad:machine OriginXoffset:0 OriginYoffset:0 ];
            
            //NSLog(@"platform ===========");
            
            //LED顏色
            UIImageView *colorView = [cell.contentView viewWithTag:50];
            int colorNum = [ary_configObj[indexPath.row].configLEDColor intValue];
            NSString *colorStr = [self getNumTrsfromToPlatformColor:colorNum];
            colorView.image = [UIImage imageNamed:colorStr];
            
            //NSLog(@"LEDColor ===========");
            
        }
        else {
            
            //========  marco  ==========
            CustomizedCell *marcoCell = [tableView dequeueReusableCellWithIdentifier:@"marcoTableViewCell" forIndexPath:indexPath];
           
            cell = marcoCell;
            
            
            //客製化 tableViewCell
            cell.superTableView = self.m_tableView;
            cell.superIndexPath = indexPath;
            cell.superAryList = ary_marocObj;
            cell.theRowHeight = tableView.rowHeight;
            [cell createDeleteBt:self.m_tableView];
            cell.cellSuperVC = self;
            
            
            
            //改變cell的背景顏色
            NSString *item = [list_bgimage objectAtIndex:indexPath.row];
            UIImageView *bg = [cell.contentView viewWithTag:111];
//            if([item isEqualToString:@"1"]) {
//                
//                
//                bg.alpha = 1.0;
//                
//            }else{
//                
//                bg.alpha = 0.0;
//            }
            
            //快捷鍵按鍵圖案  //config_icon_a_unchangable_3
            UIImageView *hotKeyImgView = [cell.contentView viewWithTag:222];
            NSString *imgStr = @"config_icon_a_unchangable_1";
            hotKeyImgView.image = [UIImage imageNamed:imgStr];
            [self setFrameToFitPad:hotKeyImgView OriginXoffset:0 OriginYoffset:0];
            
            //快捷鍵字母
            UILabel *hotKeylabel = [cell.contentView viewWithTag:333];
            hotKeylabel.adjustsFontSizeToFitWidth = YES;
            int macrokeycode = [ary_marocObj[indexPath.row].marcoHotKey intValue];
            hotKeylabel.text = [keycodeClass returnKeyboardKey:macrokeycode];
            
            
            //快捷鍵分隔線  //config_icon_a_unchangable_4
            UIImageView *lineView = [cell.contentView viewWithTag:444];
            lineView.image = [UIImage imageNamed:@"config_icon_a_unchangable_2"];
            
            if([item isEqualToString:@"1"]) {
                
                //背景
                bg.alpha = 1.0;
                
                //快捷鍵按鍵圖案
                hotKeyImgView.image = [UIImage imageNamed:@"config_icon_a_unchangable_3"];
                
                //快捷鍵字母
                hotKeylabel.textColor = [UIColor whiteColor];
                
                //快捷鍵分隔線
                 lineView.image = [UIImage imageNamed:@"config_icon_a_unchangable_4"];
            }
            else{
                
                //背景
                bg.alpha = 0.0;
                
                //快捷鍵按鍵圖案
                hotKeyImgView.image = [UIImage imageNamed:imgStr];
                
                //快捷鍵字母
                hotKeylabel.textColor = [UIColor colorWithRed:0.0 green:0.75 blue:1.0 alpha:1.0];
                
                //快捷鍵分隔線
                 lineView.image = [UIImage imageNamed:@"config_icon_a_unchangable_2"];
                
            }
            
            
            
            //快捷鍵巨集名稱
            UILabel *hotKeyFileLabel = [cell.contentView viewWithTag:555];
            hotKeyFileLabel.text = ary_marocObj[indexPath.row].marcoFileName;
            //[self setFrameToFitPad:hotKeyFileLabel OriginXoffset:0 OriginYoffset:0];
            
            //快捷鍵遊戲台圖片
            UIImageView *hotKeyMachineImgView = [cell.contentView viewWithTag:666];
            int macroPlatformInt = [ary_marocObj[indexPath.row].marcoPlatformImgStr intValue];
            hotKeyMachineImgView.image = [UIImage imageNamed:[self getPlatformNumTransformToIcon:macroPlatformInt]];
            [self setFrameToFitPad:hotKeyMachineImgView OriginXoffset:0 OriginYoffset:0];

        }
        
        
    }
    
    
    //修正 tableView 分隔線問題
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = customColorView;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (self.isSelectedConfig == YES) {
        
        self.isSeleced_config = YES;
        
        m_currentIndexPath = indexPath;
        
        //改變cell的背景顏色
        for (int i = 0; i < list_bgimage.count ; i++) {
            
            NSString *item = [list_bgimage objectAtIndex:i];
            
            item = @"0";
            
            if(i==indexPath.row) {
                
                item=@"1";
            }
            
            list_bgimage[i]=item;
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
        if (m_cfEditVC == nil) {
            
            m_cfEditVC = (CFEditViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFEditVC"];
        }
        
        m_cfEditVC.edit_configObj = ary_configObj[indexPath.row];
        
        m_cfEditVC.indexPathRow = indexPath.row;
        
        m_cfEditVC.isCreate = NO;
        

    }
    else {
        
        self.isSeleced_marco = YES;
        
        m_currentIndexPath = indexPath;//new
        
        //改變cell的背景顏色
        for (int i = 0; i < list_bgimage.count ; i++) {
            
            NSString *item = [list_bgimage objectAtIndex:i];
            
            item = @"0";
            
            if(i==indexPath.row) {
                
                item=@"1";
            }
            
            list_bgimage[i]=item;
        }//new
        

        
        if (m_mcCreateVC == nil) {
            
            m_mcCreateVC = (MCCreateViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MCCreateVC"];
        }
        
        m_mcCreateVC.edit_marcoObj = ary_marocObj[indexPath.row];
        
        m_mcCreateVC.indexPathRow = indexPath.row;
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    [tableView reloadData];
    
}

-(void)tableView:(CustomizedTableView *)tableView willMoveCellAtIndexPath:(NSIndexPath *)indexPath {
    
    m_currentIndexPath = indexPath;
    
    //改變cell的背景顏色
    for (int i = 0; i < list_bgimage.count ; i++) {
        
        NSString *item = [list_bgimage objectAtIndex:i];
        
        item = @"0";        
        
        list_bgimage[i]=item;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}

-(void)tableView:(CustomizedTableView *)tableView endMoveCellAtIndexPath:(NSIndexPath *)indexPath {
    
    //改變cell的背景顏色
    for (int i = 0; i < list_bgimage.count ; i++) {
        
        NSString *item = [list_bgimage objectAtIndex:i];
        
        item = @"0";
        
        list_bgimage[i]=item;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
    
}



-(void)changeBackgroundColorForCustomizedTableView:(NSInteger)selectedInteger {
    
    //改變cell的背景顏色
    for (int i = 0; i < list_bgimage.count ; i++) {
        
        NSString *item = [list_bgimage objectAtIndex:i];
        
        item = @"0";
        
        if(i == selectedInteger) {
            
            item=@"1";
        }
        
        list_bgimage[i]=item;
    }

}



#pragma mark - CustomizedTableView DataSource
-(NSMutableArray *)dataSourceArrayInTableView:(CustomizedTableView *)tableView {
    
    //需判斷是 config 還是 Marco
    NSMutableArray *aryDataSource;

    
    if (self.isSelectedConfig == YES) {
        
        aryDataSource = ary_configObj;
        
    }else {
        
        aryDataSource = ary_marocObj;
    }
    
    return aryDataSource;
}


-(void)tableView:(CustomizedTableView *)tableView newDataSourceArrayAfterMove:(NSMutableArray *)newDataSourceArray {
    
    //需判斷是 config 還是 Marco
    if (self.isSelectedConfig == YES) {
        
        ary_configObj = newDataSourceArray;

    }else {
        
        ary_marocObj = newDataSourceArray;
    }
    
}




#pragma mark - 顯示側邊選單
- (IBAction)showMenu:(UIButton *)sender {
    
    isMenuBtSelected = isMenuBtSelected == NO ? YES : NO;
    
    if (isMenuBtSelected == YES) {
        
         [_menuBt setImage:[UIImage imageNamed:@"config_mainmenu_off_btn_a_down"] forState:UIControlStateNormal];
        
        _menuView.alpha = 1.0;
    }
    else {
        
           [_menuBt setImage:[UIImage imageNamed:@"config_mainmenu_off_btn_a_up"] forState:UIControlStateNormal];
        
        _menuView.alpha = 0.0;
    }

}

#pragma mark - 顯示 marco (下選單)
- (IBAction)marcoBtAction:(UIButton *)sender {
    
    if (m_mcCreateVC == nil) {
        
        m_mcCreateVC = (MCCreateViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MCCreateVC"];
    }
    
    m_mcCreateVC.superVC = self;
    
    if (sender.tag == 1111) {
        //marco edite
        
        if (self.isSeleced_marco == YES) {
            
            self.isMarcoEdit = YES;
            
            m_mcCreateVC.alreadyInitView = NO;
            //[self.navigationController pushViewController:m_mcCreateVC animated:YES];
            [self presentViewController:m_mcCreateVC animated:YES completion:nil];

            self.isSeleced_marco = NO;
            self.isSelectedConfig = NO;
            
        }
        else {
            
            return;
        }
        
    
        
    }
    else if (sender.tag == 2222) {
        //marco create new
        
        //marco超過八組不能再新增
        if (ary_marocObj.count >= 8) {
            
            WaringViewController *waring = [self.storyboard instantiateViewControllerWithIdentifier:@"Key_WaringViewController"];
            waring.parentObj = self;
            waring.waring_message = NSLocalizedString(@"macro limit 8", nil); //@"巨集上限為8組";
            //waring.waring_description = @"Marco上限為8組,請刪除\nmarco後，再繼續新增";
            [self presentViewController:waring animated:YES completion:nil];
            
            self.isSelectedConfig = NO;
            
            return;
        }
        
        self.isMarcoEdit = NO;
        
        m_mcCreateVC.alreadyInitView = NO;
    
        [self presentViewController:m_mcCreateVC animated:YES completion:nil];
    }
    
}


#pragma mark - tableView 內容要顯示 Config 還是 Marco 物件
//-(void)showConfigOrMarcoObject {
//    
//    //nick
//    if (isConfig != self.isSelectedConfig) {
//        
//        //nick
//        if ( self.isSelectedConfig == YES) {
//            //Config 狀態
//            
//            isConfig = YES;
//            
//            _configMarcoLabel.text = @"Config";
//            
//            _bottomList_config.hidden = NO;
//            
//            _bottomList_marco.hidden = YES;
//        }
//        else {
//            //Marco 狀態
//            
//            isConfig = NO;
//            
//            _configMarcoLabel.text = @"Macro";
//            
//            _bottomList_config.hidden = YES;
//            
//            _bottomList_marco.hidden = NO;
//        }
//        
//        [_m_tableView reloadData];
//    }
////    else {
////        
////        return;
////    }
//
//}



/*
 向左滑動顯示刪除鍵
 向右滑動隱藏刪除鍵
 */
-(void)addLeftAndRightSwipGesture {
    
    //滑動手勢(左)
    cellSwipGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipAction:)];
    
    cellSwipGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    cellSwipGestureLeft.numberOfTouchesRequired = 1;
    
    [self.m_tableView addGestureRecognizer:cellSwipGestureLeft];
    
    //滑動手勢(右)
    cellSwipGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipAction:)];
    
    cellSwipGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    cellSwipGestureRight.numberOfTouchesRequired = 1;
    
    [self.m_tableView addGestureRecognizer:cellSwipGestureRight];
    
    //preIndexPath
    preIndexPath = nil;
}

//偵測tableView 上下滑動事件
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //當tableView 向上滑 或 向下滑
    //隱藏所有的 deleteBt
    
    if (preIndexPath == nil) {
        
        return;
    }
    else {
        
        CustomizedCell *cell = [self.m_tableView cellForRowAtIndexPath:preIndexPath];
        
        [self cellShowDeleteBtOrClose:cell showDeleteBt:NO];
        
        preIndexPath = nil;
        
        NSLog(@"上下滑動 隱藏cell");
        
    }
    
}


#pragma mark - cellSwipAction(cell 向右滑 - 向左滑)
-(void)cellSwipAction:(UISwipeGestureRecognizer *)gesture {
    
    //取得在 tableView 裡的手指座標
    CGPoint currentPoint = [gesture locationInView:self.m_tableView];
    
    //目前手指座標所對應的 tableView indexPath
    NSIndexPath *currentIndexPath = [self.m_tableView indexPathForRowAtPoint:currentPoint];
    
    //目前與使用者互動的 cell
    CustomizedCell *cell = [self.m_tableView cellForRowAtIndexPath:currentIndexPath];
    
    if ([gesture isEqual:cellSwipGestureLeft]) {
        
        if (preIndexPath == nil) {
            
            preIndexPath = currentIndexPath;
        }
        else if (preIndexPath != nil && ![preIndexPath isEqual:currentIndexPath]) {
            
            //先將上一個隱藏
            CustomizedCell *preCell = [self.m_tableView cellForRowAtIndexPath:preIndexPath];
            
            [self cellShowDeleteBtOrClose:preCell showDeleteBt:NO];
            
            preIndexPath = currentIndexPath;
        }
        
        [self cellShowDeleteBtOrClose:cell showDeleteBt:YES];
        
    }
    else if ([gesture isEqual:cellSwipGestureRight]) {
        
        [self cellShowDeleteBtOrClose:cell showDeleteBt:NO];
    }
    
}


#pragma mark - 顯示或隱藏 cell 的 刪除鍵
-(void)cellShowDeleteBtOrClose:(CustomizedCell *)theCell showDeleteBt:(BOOL)show {
    
    if (show) {
        
        [UIView animateWithDuration:0.28 animations:^{
            
            theCell.contentView.frame = CGRectMake(0 - self.m_tableView.frame.size.width/3, theCell.contentView.frame.origin.y, theCell.contentView.frame.size.width, theCell.contentView.frame.size.height);
            
            theCell.cellDeleteBt.alpha = 1.0;
            
            theCell.cellDeleteBt.userInteractionEnabled = YES;
            
            [self.m_tableView removeLongPressGesture];
            
        }];
    }
    else {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            theCell.contentView.frame = CGRectMake(0, theCell.contentView.frame.origin.y, theCell.contentView.frame.size.width, theCell.contentView.frame.size.height);
            
            theCell.cellDeleteBt.userInteractionEnabled = NO;
            
            theCell.cellDeleteBt.alpha = 0;
            
            [self.m_tableView addLongPressGesture];
        }];
        
    }
    
}




/*
 
 更換至其他主頁面
 
*/
#pragma mark - 更換至其他主頁面
-(void)changeToOtherMainVC:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    switch (sender.tag) {
        case 0://home
            [self homeBtnAction];
            break;
        case 1://login
            [self logInBtnAction];
            break;
        case 2://setting
            [self settingBtnAction];
            break;
        case 3://info
            [self aboutBtnAction];
            break;
        case 4://help
            [self helpBtnAction];
            break;
        default:
            break;
    }
    
    
}

#pragma mark - home 頁面
-(void)homeBtnAction{
    
    if (homeVC == nil) {
        
        homeVC = (HomeViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    }
    
    [appDelegate.window setRootViewController:homeVC];
    
    [appDelegate.window makeKeyAndVisible];
}

#pragma mark - login 頁面
-(void)logInBtnAction{
    
    if (loginVC == nil) {
        
        loginVC = (UserLoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"UserLoginVC"];
    }
    
    [appDelegate.window setRootViewController:loginVC];
    
    [appDelegate.window makeKeyAndVisible];
    
}

#pragma mark - setting 頁面
-(void)settingBtnAction{
    
    if (settingVC == nil) {
        
        settingVC = (UserSettingViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"UserSettingVC"];
    }
    
    [appDelegate.window setRootViewController:settingVC];
    
    [appDelegate.window makeKeyAndVisible];
}

#pragma mark - info 頁面
-(void)aboutBtnAction{
    
    if ( aboutVC == nil) {
        
        aboutVC = (AboutViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AboutVC"];
    }
    
    [appDelegate.window setRootViewController:aboutVC];
    
    [appDelegate.window makeKeyAndVisible];

}


#pragma mark - help 頁面
-(void)helpBtnAction{
    
    if (helpVC == nil) {
        
        helpVC = (HelpViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HelpVC"];
    }
    
    [appDelegate.window setRootViewController:helpVC];
    
    [appDelegate.window makeKeyAndVisible];
}


#pragma mark - platform 取得數字轉換成對應的圖片
-(NSString *)getPlatformNumTransformToIcon:(int)platformNum {
    
    NSString *iconStr;

    switch (platformNum) {
        case 1:
            iconStr = @"platform_a_2_ps3_88x88";
            break;
        case 2:
            iconStr = @"platform_a_1_ps4_88x88";
            break;
        case 4:
            iconStr = @"platform_a_4_x360_88x88";
            break;
        case 8:
            iconStr = @"platform_a_3_x1_88x88";
            break;
        default:
            break;
    }
    
    return iconStr;
}


#pragma mark - getNumTrsfromToPlatformColor 取得數字轉換成對應的圖片
-(NSString *)getNumTrsfromToPlatformColor:(int)colorNum {
    
    NSString *platformStr;
    
    switch (colorNum) {
            
        case 1:
            platformStr = @"platform_btn_a_colorlable_1";
            break;
        case 2:
            platformStr = @"platform_btn_a_colorlable_2";
            break;
        case 3:
            platformStr = @"platform_btn_a_colorlable_3";
            break;
        case 4:
            platformStr = @"platform_btn_a_colorlable_4";
            break;
        case 5:
            platformStr = @"platform_btn_a_colorlable_5";
            break;
        case 6:
            platformStr = @"platform_btn_a_colorlable_6";
            break;
        case 7:
            platformStr = @"platform_btn_a_colorlable_7";
            break;
        case 8:
            platformStr = @"platform_btn_a_colorlable_8";
            break;
        case 9:
            platformStr = @"platform_btn_a_colorlable_9";
            break;
        case 10:
            platformStr = @"platform_btn_a_colorlable_10";
            break;
        default:
            break;

    }
    
    return platformStr;
}



#pragma mark - Loading Config
//protocol 觸發事件
-(void)loadConfigAction{
    
    int configHotKey = [ary_configObj[m_cfEditVC.indexPathRow].configHotKeyStr intValue];
    
    [[ProtocolDataController sharedInstance] MacroConfigFunctionSet:configHotKey];
}

-(void)onResponseResponseMode:(int)keyCode{
}

-(void)onResponseMacroConfigFunctionSet:(bool)isSuccess {
    
    if (isSuccess) {
        
        [NSThread sleepForTimeInterval:0.5];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        NSMutableArray *allConfigAry = [[ConfigMacroData sharedInstance] getConfigArray];
        
        [[ConfigMacroData sharedInstance] saveUsingConfig:[allConfigAry objectAtIndex:m_cfEditVC.indexPathRow]];
        
        [loadView removeFromSuperview];
        
        loadView = nil;
        
    }
    else {
        
        [[ProtocolDataController sharedInstance] MacroConfigFunctionSet:(int)m_cfEditVC.indexPathRow];

    }
}


#pragma  mark - cellBackgroundReset
-(void)cellBackgroundReset {
    
    //改變cell的背景顏色
    for (int i = 0; i < list_bgimage.count ; i++) {
        
        NSString *item = [list_bgimage objectAtIndex:i];
        
        item = @"0";
        
        list_bgimage[i] = item;
    }

}



#pragma mark - 硬體 Config & Macro 資料刪除
-(void)deleteConfigOrMacroData:(NSInteger)currentIndexPath {
    
    NSNumber *theIndex = [NSNumber numberWithInteger:currentIndexPath];
    
    int deleteNum = [theIndex intValue];
    NSLog(@"deleteNum:%d",deleteNum);
    
    deleteIndex = deleteNum;
    
    if (self.isSelectedConfig == YES) {
        
        [[ProtocolDataController sharedInstance] delConfig:deleteNum];
        
        
        //if (configImgAry.count != 0 && configImgAry.count == ary_configObj.count) {
        //
        //    [configImgAry removeObjectAtIndex:deleteIndex];
        //}
        
        
    }
    else {
        
        [[ProtocolDataController sharedInstance] delMacro:deleteNum];
    }
    
    
    //產生 等待畫面
    loadView = [[ConnectLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [loadView setStatusLabel:NSLocalizedString(@"Delete...", nil)];
    
    [self.view addSubview:loadView];

    
}

//delete Config
-(void)onResponseDelConfig:(bool)isSuccess :(int)no {
    
    if (isSuccess) {
        
        NSUInteger totalCount = 0;
        totalCount = ary_configObj.count;
        NSNumber *totalNum = [NSNumber numberWithUnsignedInteger:totalCount];
        int total = [totalNum intValue];
        
        NSLog(@"onResponseDelConfig-----deleteIndex = %i", deleteIndex);
        NSLog(@"onResponseDelConfig-----total = %i", total);
        
        if (deleteIndex == 0) {
            
            if (total > 1) {
                
                for (int i = 1; i <= total; i++) {
                    
                    [[ProtocolDataController sharedInstance] moveConfig:i :i-1];
                }
                
            }else {
                
                [loadView removeFromSuperview];
                
                loadView = nil;
            }
            
        }else if (deleteIndex == total) {
            
            [loadView removeFromSuperview];
            
            loadView = nil;
        }else {
            
            for (int i = deleteIndex + 1; i <= total; i++) {
                
                [[ProtocolDataController sharedInstance] moveConfig:i :i - 1];
            }
            
        }
        
        
//        NSMutableArray *temp= [[ConfigMacroData sharedInstance] getConfigArray];
//        [temp removeObjectAtIndex:deleteIndex];
        
        //NSMutableArray *tempConfigImgAry = [[ConfigMacroData sharedInstance] getConfigImage];
        //[tempConfigImgAry removeObjectAtIndex:deleteIndex];
        
//        [configImgAry removeObjectAtIndex:deleteIndex];
        
        NSLog(@"onResponseDelConfig-----deleteIndex = %i", deleteIndex);
        NSString *configName = [[ConfigMacroData sharedInstance] getConfigName:deleteIndex];
        NSLog(@"onResponseDelConfig-----configName = %@", configName);
        
        //刪除本機圖片
        [[ConfigMacroData sharedInstance] removeConfigImageKey:configName];
        //刪除APP暫存的硬體資料
        [[ConfigMacroData sharedInstance] removeConfigIndex:deleteIndex];
        
        
        //[[ConfigMacroData sharedInstance] setConfigArray:ary_configObj];
        
        [loadView removeFromSuperview];
        
        [self.m_tableView reloadData];
    }
    else {
        [[ProtocolDataController sharedInstance] delConfig:deleteIndex];
    }
    
}

//delete Macro
-(void)onResponseDelMacro:(bool)isSuccess :(int)no {
    
    if (isSuccess) {
        
        NSUInteger totalCount = 0;
        totalCount = ary_marocObj.count;
        NSNumber *totalNum = [NSNumber numberWithUnsignedInteger:totalCount];
        int total = [totalNum intValue];
        
        NSLog(@"onResponseDelMacro-----deleteIndex = %i", deleteIndex);
        NSLog(@"onResponseDelMacro-----total = %i", total);
        
        if (deleteIndex == 0) {
            
            if (total > 1) {
                
                for (int i = 1; i <= total; i++) {
                    
                    [[ProtocolDataController sharedInstance] moveMacro:i :i-1];
                }
                
            }else {
                
                [loadView removeFromSuperview];
                
                loadView = nil;
            }
            
        }else if (deleteIndex == total) {
            
            [loadView removeFromSuperview];
            
            loadView = nil;
        }else {
            
            for (int i = deleteIndex + 1; i <= total; i++) {
                [[ProtocolDataController sharedInstance] moveMacro:i :i-1];
            }
        }

        //刪除APP暫存的硬體資料
        [[ConfigMacroData sharedInstance] removeMacroIndex:deleteIndex];
        
        [loadView removeFromSuperview];
        
    }
    else {
        
        [[ProtocolDataController sharedInstance] delMacro:deleteIndex];
    }
    
}


#pragma mark - 硬體 Config & Macro 資料移動
-(void)moveConfigOrMacrodData:(NSInteger)fromIndexPath to:(NSInteger)toIndexPath {
    
    NSNumber *fromIndex = [NSNumber numberWithInteger:fromIndexPath];
    int fromInt = [fromIndex intValue];
    
    NSNumber *toIndex = [NSNumber numberWithInteger:toIndexPath];
    int toInt = [toIndex intValue];
    
    
    if (self.isSelectedConfig == YES) {
        
        if (fromInt == toInt) {
            
            return;
        }
        else if (fromInt < toInt) {
            
            for (int moveInt = 0; moveInt < toInt - fromInt; moveInt++) {
                
                 [[ProtocolDataController sharedInstance] moveConfig:fromInt :fromInt + 1];
                
                [[ConfigMacroData sharedInstance] moveConfigFrom:fromInt To:fromInt + 1];
                
                fromInt += 1;
            }
            
        }
        else if (fromInt > toInt) {
            
            
            for (int movingInt = 0; movingInt < fromInt - toInt; movingInt++) {
                
                [[ProtocolDataController sharedInstance] moveConfig:fromInt :fromInt - 1];
                
                [[ConfigMacroData sharedInstance] moveConfigFrom:fromInt To:fromInt - 1];
                
                fromInt -= 1;
                
            }
            
        }
        
    }
    else {
        
        if (fromInt == toInt) {
            
            return;
        }
        else if (fromInt < toInt) {
            
            for (int moveInt = 0; moveInt < toInt - fromInt; moveInt++) {
                
                [[ProtocolDataController sharedInstance] moveMacro:fromInt :fromInt + 1];
                
                [[ConfigMacroData sharedInstance] moveMacroFrom:fromInt To:fromInt + 1];
                
                fromInt += 1;
            }
            
        }
        else if (fromInt > toInt) {
            
            
            for (int movingInt = 0; movingInt < fromInt - toInt; movingInt++) {
                
                [[ProtocolDataController sharedInstance] moveMacro:fromInt :fromInt - 1 ];
                
                [[ConfigMacroData sharedInstance] moveMacroFrom:fromInt To:fromInt - 1];
                
                fromInt -= 1;
                
            }
            
        }

        
    }
    

    
}

//move config
-(void)onResponseMoveConfig:(bool)isSuccess{
    
    if (isSuccess) {
        
        if (loadView != nil) {
            
            [loadView removeFromSuperview];
            
            loadView = nil;
        }

        
    }
    else {
        
        
        
    }
    
}

//move marco
-(void)onResponseMoveMacro:(bool)isSuccess {
    
    if (isSuccess) {
        
        if (loadView != nil) {
            
            [loadView removeFromSuperview];
            
            loadView = nil;
        }


    }
    else {
        
        
    }
    
}



#pragma mark - Protocal Delegate
-(void)onConnectionState:(ConnectState)state{
    
    //ScanFinish,掃描結束
    //Connected,連線成功
    //Disconnected,斷線
    //ConnectTimeout連線超時
    
    [[ConfigMacroData sharedInstance] changeBLEConnectedState:state];
    
    if(state == Disconnect) {

        //重新連線
        if (landingVC == nil) {
            landingVC = (LandingViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LandingVC"];
        }

        [appDelegate.window setRootViewController:landingVC];
            
        [appDelegate.window makeKeyAndVisible];
        
    }
}

#pragma mark - Screen Rotation
/*
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    

 
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationMaskPortraitUpsideDown) {
        
        return NO;
    }
    
    return YES;
     
     
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //return UIInterfaceOrientationMaskAll;
    
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}
*/
- (void) onResponseDeviceStatus:(DeviceStatus*) ds{
    
}

-(void) onResponseLiveMode:(bool)isSuccess{
    
}


#pragma mark - FPCloudResponse Delegate
-(void)FPCloudResponseData:(NSURLResponse *)response Data:(NSData *)data Error:(NSError *)error EventId:(int)eventid{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(data==nil)
        {
            NSLog(@"Error:%@",error.description);
            
            return ;
        }
        
        NSError *jsonError;
        
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        
        switch (eventid) {
            case CloudAPIEvent_uploaduserprofile:
                [self processUploadUserFile:responseData Error:jsonError];
                break;
            default:
                break;
        }
        
        
        
    });
    
}

//(上傳雲端回傳結果)
-(void)processUploadUserFile:(NSDictionary *)resopnseData Error:(NSError *)jsonError{
    
    NSNumber *code = [resopnseData objectForKey:@"ret"];
    
    if (code.intValue== 0) {
        //success
        
        //轉圈圈停止
        if (loadView != nil) {
            
            [loadView removeFromSuperview];
            loadView = nil;
        }
        
        [self.navigationController pushViewController:m_cfBackupVC animated:YES];
        
        
    }else{
        //fail
        
        
    }
    
    NSLog(@"uploadfile.resopnseData = %@",resopnseData);
    
}



#pragma mark - post ConfigData Backup
-(void)postConfigDataBackup {
    
    //post 相關參數
    int eventID = CloudAPIEvent_uploaduserprofile;
    
    //Content
    NSString *Content = @"game content";//預設描述內容
    
    //status
    NSString *status = @"0";//預設為0:私人,1:公開
    
    //簽名 MD5(用戶編號+KEY+時間戳)
    NSString *uid = [ConfigMacroData sharedInstance].uid;//用戶編號
    NSString *ts = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];//時間戳
    NSString *sn = [NSString stringWithFormat:@"%@%@%@",uid,kAPIKey,ts];
    sn = [ShareCommon md5:sn];//用戶編號+key+時間戳
    
    //platform
    NSString *platform = ary_configObj[m_cfEditVC.indexPathRow].configPlatformIcon;
    
    //game
    NSString *game = ary_configObj[m_cfEditVC.indexPathRow].configFileName;
    
    //config txt
    NSString *file = [self getConfigDataToiCloud];
  
    NSString *path = [[self applicationDocumentsDirectory].path
                      stringByAppendingPathComponent:@"fileName.txt"];
    
    [file writeToFile:path atomically:YES
                   encoding:NSUTF8StringEncoding error:nil];

    
    //pic
    int num = [[NSNumber numberWithInteger:m_cfEditVC.indexPathRow] intValue];
    NSString *configName = [[ConfigMacroData sharedInstance] getConfigName: num];
    NSMutableDictionary *configImgDic = [[ConfigMacroData sharedInstance] getConfigImageKey:configName];
    NSData *imgData = [configImgDic objectForKey:@"configImage"];
    UIImage *img = [UIImage imageWithData:imgData];
    
    
    //將參數包成 dic
    NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      Content,@"Content",
                                      status,@"status",
                                      uid,@"uid",
                                      ts,@"ts",
                                      sn,@"sn",
                                      platform,@"platform",
                                      game,@"game",
                                      nil];
    

    //Loading 等待畫面
    loadView = [[ConnectLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [loadView setStatusLabel:NSLocalizedString(@"Uploading...", nil)];
    
    [self.view addSubview:loadView];
    
    //上傳雲端
    //[cloudClass postDataSync:sendParam APIName:kAPI_uploaduserprofile EventId:eventID withImage:img withFile:path];
    
    [cloudClass postDataAsync:sendParam APIName:kAPI_uploaduserprofile EventId:eventID withImage:img withFile:path];

    
}

#pragma mark - getConfigDataToiCloud
-(NSString *)getConfigDataToiCloud {
    
    /*
     排列順序 &                  bytes
     1.ConfigHotKey             == 1
     2.Platform                 == 1
     3.ConfigName0~39           == 40
     4.LED_Color                == 1
     5.ConfigFuncFlag           == 1
     6.Hip_Sensitivity          == 1
     7.ADS_Sensitivity          == 1
     8.DeadZONE                 == 1
     9.Sniperbreath_hotkey      == 1
     10.Sniperbreath_mapkey     == 1
     11.AntiRecoil_hotkey       == 1
     12.AntiRecoil_offsetValue  == 1
     13.Shooting Speed_0~1      == 2
     14.KeymapArray_0~21        == 22
     15.Ballistics_0~19         == 20
     16.BallisticsTemp_0~2      == 3
    */
    
    
    //轉16進制(除configName外,其他都是取 int值 轉16進制,再轉成NSString)
    CFTableViewCellObject *selectedObj = ary_configObj[m_cfEditVC.indexPathRow];
    
    //ConfigHotKey
    int configHotkeyInt = [selectedObj.configHotKeyStr intValue];
    NSString *configHotkeyStrHex = [Function ToHex:configHotkeyInt];
    
    
    //Platform
    int configPlatformInt = [selectedObj.configPlatformIcon intValue];
    NSString *configPlatformStrHex = [Function ToHex:configPlatformInt];
    
    //ConfigName0~39 (字串轉16進制)
    NSString *configNameStr = selectedObj.configFileName;
    NSString *configNameStrHex = [Function configNameToHex:configNameStr];
    
    
    //LED_Color
    int configLEDInt = [selectedObj.configLEDColor intValue];
    NSString *configLEDStrHex = [Function ToHex:configLEDInt];
    
    //ConfigFuncFlag
    int flag = 0x00;
    flag = (selectedObj.isADStoggle) ? flag | 0x01 : flag;
    flag = (selectedObj.isShootingSpeed) ?  flag | 0x02 : flag;
    flag = (selectedObj.isInverted) ?  flag | 0x04 : flag;
    flag = (selectedObj.isSniperBreath) ?  flag | 0x08 : flag;
    flag = (selectedObj.isAntiRecoil) ? flag | 0x10 : flag;
    flag = (selectedObj.isSync) ? flag | 0x20 : flag;
    
    NSString *configFuncFlagStrHex = [NSString stringWithFormat:@"%02X",flag];
    
    
    //Hip_Sensitivity
    int configHIPInt = [selectedObj.hipStr intValue];
    NSString *configHIPStrHex = [Function ToHex:configHIPInt];
    
    //ADS_Sensitivity
    int configADSInt = [selectedObj.adsStr intValue];
    NSString *configADSStrHex = [Function ToHex: configADSInt];
    
    //DeadZONE
    int configDeadZoneInt = [selectedObj.deadZoneStr intValue];
    NSString *configDeadZoneStrHex = [Function ToHex:configDeadZoneInt];
    
    //Sniperbreath_hotkey
    int configSniperbreathHotkeyInt = [selectedObj.sniperBreathHotkey intValue];
    NSString *configSniperbreathHotkeyStrHex = [Function ToHex:configSniperbreathHotkeyInt];
    
    //Sniperbreath_mapkey (目前沒用到,設定值與Ming同)
    NSString *configSniperBreathMapkeyStrHex = [Function ToHex:0];
    
    //AntiRecoil_hotkey
    int configAntiRecoilHotketInt = [selectedObj.antiRecoilHotkey intValue];
    NSString *configAntiRecoilHotketStrHex = [Function ToHex:configAntiRecoilHotketInt];
    
    //AntiRecoil_offsetValue
    int configAntiRecoilOffsetInt = [selectedObj.antiRecoilStr intValue];
    NSString *configAntiRecoilOffsetStrHex = [Function ToHex:configAntiRecoilOffsetInt];
    
    //Shooting Speed_0~1
    int configShootingSpeedInt = [selectedObj.shootingSpeedStr intValue];
    NSString *configsShootingSpeedHex = [NSString stringWithFormat:@"%04X",configShootingSpeedInt];

    
    //KeymapArray_0~21
    NSMutableString *keyMapAryStrHex = [[NSMutableString alloc]init];
    
    for (int i = 0; i < selectedObj.keyMap.count; i++) {
        
        NSString *key = [Function ToHex:[selectedObj.keyMap[i] intValue]];
        
        [keyMapAryStrHex appendFormat:@"%@,",key];
    }

    //最後一節多一個 "," 要刪掉
    NSString *finalKeyMapStrHex = (NSString *)[keyMapAryStrHex substringToIndex:keyMapAryStrHex.length - 1];
    
    
    //Ballistics_0~19
    NSMutableString *ballisticAryStrHex = [[NSMutableString alloc] init];
    
    for (int i = 0; i < selectedObj.ballistics_Y_value.count; i++) {
        
        NSString *ballistic = [Function ToHex:[selectedObj.ballistics_Y_value[i] intValue]];
        
        [ballisticAryStrHex appendFormat:@"%@,",ballistic];
    }
    
    //最後一節多一個 "," 要刪掉
    NSString *finalBallisticAryStrHex = (NSString *)[ballisticAryStrHex substringToIndex:ballisticAryStrHex.length - 1];

    
    //BallisticsTemp_0~2 ( Changed  point)
    NSMutableString *ballisticsTempHex = [[NSMutableString alloc] init];
    long changedInt = 0;
    NSUInteger blen = [selectedObj.ballistics_changed count];
    for (int i = 0; i < blen; i++) {
        
        if ([[selectedObj.ballistics_changed objectAtIndex:i] intValue] == 1) {
            
            changedInt = changedInt | (0x1 << i);
        }
    }
    
    [ballisticsTempHex appendString:[NSString stringWithFormat:@"%06lX",changedInt]];
    [ballisticsTempHex insertString:@"," atIndex:2];
    [ballisticsTempHex insertString:@"," atIndex:5];

    
    
    NSString *txtStr = [NSString stringWithFormat:@"\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",configHotkeyStrHex,configPlatformStrHex,configNameStrHex,configLEDStrHex,configFuncFlagStrHex,configHIPStrHex,configADSStrHex,configDeadZoneStrHex,configSniperbreathHotkeyStrHex,configSniperBreathMapkeyStrHex,configAntiRecoilHotketStrHex,configAntiRecoilOffsetStrHex,configsShootingSpeedHex,finalKeyMapStrHex,finalBallisticAryStrHex,ballisticsTempHex];
    
    NSLog(@"txtStr ====== %@",txtStr);
    
    return txtStr;
    
}



- (NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - 沒網路時跳出預設 Alert
-(void)showAlert:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
    
    [alertView addAction:okAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

@end
