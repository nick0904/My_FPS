

#import "MCCreateViewController.h"

#import "CFMainViewController.h"

#import "MCDelayTimeView.h"

#import "LandingViewController.h"

#import "KeyCodeView.h"

@interface MCCreateViewController () <UITextFieldDelegate> {
    
    NSMutableArray <MCSettingView *> *ary_settingView;//存放16個settingView
    
    NSMutableArray <UILabel *> *ary_listening;//儲存listeng
    
    NSMutableArray <UIButton *> *ary_delayBt;//存放15個delayBt
    
    
    /*
     keyboard up, keyboard down, keyboard up+down
     mouseL up, mouseL down, mouseL up + down
     mouseR up, mouseR down, mouseR up + down
     */
    NSMutableArray <UIButton *> *ary_selectedSettingBts;
    
    int selectedBtIndex;//紀錄被使用者點選的 settingView
    
    int chosedTimeBtIndex;//紀錄被使用者點選的 delayTime

    BOOL isCombinationKeys;//是否為組合鍵
    
    //chose的位置
    int choseIndex;
    
    
    //處理目前正在編輯的 Marco 資料
    MCTableViewCellObject *currentMarcoObj;
    
    
    //硬體
    FPSMacroData *marcoData;
//    NSTimer *macroResponseTimer;
    KeyCodeFile *keyCodeClass;
    
    
    int platformInt;
    
    //暫時存放 settingView 的 keycode
    int public_keycode;
    
    //顯示等待畫面
    ConnectLoadingView *updateView;
    
    
    //新增資料時防呆用
    BOOL isCreateAndHadInit;
    
    //等待轉圈圈畫面
    LandingViewController *landingVC;

    
    
}

@property (strong, nonatomic) IBOutlet UIView *platformBts; //選擇遊戲平台

@property (strong, nonatomic) IBOutlet UIImageView *gamePlatformImgView;

@property (strong, nonatomic) IBOutlet UITextField *marcoFileName;//巨集檔案名稱

@property (strong, nonatomic) IBOutlet UIView *hotkeySettingitem;//熱鍵物件

@property (strong, nonatomic) IBOutlet UILabel *hotketSettingLabel;//熱鍵標籤


@property (strong, nonatomic) IBOutlet KeyCodeView *macroHotkeyView;//macro Hotkey View

@property (strong, nonatomic) IBOutlet UIImageView *marcoHotkeyImg;//macro hotkey 圖示

@property (strong, nonatomic) IBOutlet UIButton *macroHotkeyBt;//nmacro hotkey 按鍵




@property (strong, nonatomic) IBOutlet UIView *settingWindow;

@property (strong, nonatomic) IBOutlet UILabel *listenLabel;

@property (strong, nonatomic) IBOutlet UIView *setting_keyboard; //設定鍵盤的畫面

@property (strong, nonatomic) IBOutlet UIView *setting_mouseLeft;//設定滑鼠左鍵

@property (strong, nonatomic) IBOutlet UIView *setting_mouseRight;//設定滑鼠右鍵

@property (strong, nonatomic) IBOutlet UIButton *hotKey_saveBt;

@property (strong, nonatomic) IBOutlet UILabel *sw_listeningLabel;

@property (strong, nonatomic) IBOutlet UIImageView *delaytimeMark;


//settingView_keyboard 的熱鍵
@property (strong, nonatomic) IBOutlet UIButton *settingView_keyboard_key_0;
@property (strong, nonatomic) IBOutlet UIButton *settingView_keyboard_key_1;
@property (strong, nonatomic) IBOutlet UIButton *settingView_keyboard_key_2;
@property (strong, nonatomic) IBOutlet UIButton *settingView_keyboard_key_3;


//selected settingBts
@property (strong, nonatomic) IBOutlet UIButton *selected_settingBt_1000;//k down

@property (strong, nonatomic) IBOutlet UIButton *selected_settingBt_1001;//k up

@property (strong, nonatomic) IBOutlet UIButton *selected_settingBt_1002;//k down+up



@property (strong, nonatomic) IBOutlet UIButton *selected_settingBt_1003;//mL down

@property (strong, nonatomic) IBOutlet UIButton *selected_settingBt_1004;//mL up

@property (strong, nonatomic) IBOutlet UIButton *selected_settingBt_1005;//mL down+up


@property (strong, nonatomic) IBOutlet UIButton *selected_settingBt_1006;//mR down

@property (strong, nonatomic) IBOutlet UIButton *selected_settingBt_1007;//mR up

@property (strong, nonatomic) IBOutlet UIButton *selected_settingBt_1008;//mR down+up


//******** settingView 共16個 *******
@property (strong, nonatomic) IBOutlet MCSettingView *v_0;

@property (strong, nonatomic) IBOutlet MCSettingView *v_1;

@property (strong, nonatomic) IBOutlet MCSettingView *v_2;

@property (strong, nonatomic) IBOutlet MCSettingView *v_3;

@property (strong, nonatomic) IBOutlet MCSettingView *v_4;

@property (strong, nonatomic) IBOutlet MCSettingView *v_5;

@property (strong, nonatomic) IBOutlet MCSettingView *v_6;

@property (strong, nonatomic) IBOutlet MCSettingView *v_7;

@property (strong, nonatomic) IBOutlet MCSettingView *v_8;

@property (strong, nonatomic) IBOutlet MCSettingView *v_9;

@property (strong, nonatomic) IBOutlet MCSettingView *v_10;

@property (strong, nonatomic) IBOutlet MCSettingView *v_11;

@property (strong, nonatomic) IBOutlet MCSettingView *v_12;

@property (strong, nonatomic) IBOutlet MCSettingView *v_13;

@property (strong, nonatomic) IBOutlet MCSettingView *v_14;

@property (strong, nonatomic) IBOutlet MCSettingView *v_15;



//********* 延遲時間設置按鍵 共15個 *********
@property (strong, nonatomic) IBOutlet UIButton *delayBt_0;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_1;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_2;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_3;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_4;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_5;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_6;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_7;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_8;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_9;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_10;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_11;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_12;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_13;

@property (strong, nonatomic) IBOutlet UIButton *delayBt_14;



////*********  listening 共16個 ********
@property (strong, nonatomic) IBOutlet UILabel *listening_0;

@property (strong, nonatomic) IBOutlet UILabel *listening_1;

@property (strong, nonatomic) IBOutlet UILabel *listening_2;

@property (strong, nonatomic) IBOutlet UILabel *listening_3;

@property (strong, nonatomic) IBOutlet UILabel *listening_4;

@property (strong, nonatomic) IBOutlet UILabel *listening_5;

@property (strong, nonatomic) IBOutlet UILabel *listening_6;

@property (strong, nonatomic) IBOutlet UILabel *listening_7;

@property (strong, nonatomic) IBOutlet UILabel *listening_8;

@property (strong, nonatomic) IBOutlet UILabel *listening_9;

@property (strong, nonatomic) IBOutlet UILabel *listening_10;

@property (strong, nonatomic) IBOutlet UILabel *listening_11;

@property (strong, nonatomic) IBOutlet UILabel *listening_12;

@property (strong, nonatomic) IBOutlet UILabel *listening_13;

@property (strong, nonatomic) IBOutlet UILabel *listening_14;

@property (strong, nonatomic) IBOutlet UILabel *listening_15;


//****** Save & Cancel
@property (strong, nonatomic) IBOutlet UIButton *main_save;

@property (strong, nonatomic) IBOutlet UIButton *main_cancel;


//彈跳出儲存頁面
@property (strong, nonatomic) IBOutlet UIView *saveChangeView;

@property (strong, nonatomic) IBOutlet UIButton *saveChanges_saveBt;

@property (strong, nonatomic) IBOutlet UIButton *saveChanges_noBt;

@property (strong, nonatomic) IBOutlet UIButton *saveChanges_cancelBt;



//****** 延遲設定頁面 *******
@property (strong, nonatomic) IBOutlet MCDelayTimeView *setting_delayTime;

@property (strong, nonatomic) IBOutlet UIButton *delay_continueBt;

@property (strong, nonatomic) IBOutlet UIButton *delay_syncBt;

@property (strong, nonatomic) IBOutlet UIButton *delay_continueAndDelayBt;

@property (strong, nonatomic) IBOutlet UITextField *delayTimeTextField;

@property (strong, nonatomic) IBOutlet UIButton *timeSaveBt;



@property (strong, nonatomic) IBOutlet UILabel *createNewLabel;

@property (strong, nonatomic) IBOutlet UILabel *delayLabel;

@property (strong, nonatomic) IBOutlet UILabel *msecLabel;

@property (strong, nonatomic) IBOutlet UILabel *saveChangesLabel;

@end

//keycode 鍵盤總數 119
#define KEYCODE_TOTALCOUNT 119

@implementation MCCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隱藏導覽列
    self.navigationController.navigationBarHidden = YES;

    //初始化 16個 settingView
    //包在ary_settingView
    ary_settingView = [NSMutableArray arrayWithObjects:_v_0,_v_1,_v_2,_v_3,_v_4,_v_5,_v_6,_v_7,_v_8,_v_9, _v_10,_v_11,_v_12,_v_13,_v_14,_v_15,nil];
    
    
    for(int viewIndex = 0; viewIndex < 16; viewIndex++) {
        
        [ary_settingView[viewIndex] refreshSettingView];
        ary_settingView[viewIndex].parentObj = self;
        ary_settingView[viewIndex].isSelected = NO;
        ary_settingView[viewIndex].parentObj = self;
        ary_settingView[viewIndex].canMove = NO;
        ary_settingView[viewIndex].oriCenterPoint = CGPointMake(ary_settingView[viewIndex].center.x, ary_settingView[viewIndex].center.y);
        
    }
    
    //將15個delayBt包在ary_delayBt
    ary_delayBt = [NSMutableArray arrayWithObjects:_delayBt_0,_delayBt_1,_delayBt_2,_delayBt_3,_delayBt_4,_delayBt_5,_delayBt_6,_delayBt_7,_delayBt_8,_delayBt_9,_delayBt_10, _delayBt_11,_delayBt_12,_delayBt_13,_delayBt_14,nil];
    
    for (int delayBtIndex = 0; delayBtIndex < ary_delayBt.count; delayBtIndex++) {
        
        ary_delayBt[delayBtIndex].userInteractionEnabled = NO;
        ary_delayBt[delayBtIndex].tag = delayBtIndex;
    }
    
    
    //setting_delayTime
    self.setting_delayTime.continueBt = self.delay_continueBt;
    self.setting_delayTime.syncBt = self.delay_syncBt;
    self.setting_delayTime.continueAndDelayBt = self.delay_continueAndDelayBt;
    self.setting_delayTime.delay_textField = self.delayTimeTextField;
    self.setting_delayTime.saveDelayTimeBt = self.timeSaveBt;
    self.setting_delayTime.delay_textField.keyboardType = UIKeyboardTypeNumberPad;
    self.setting_delayTime.delay_textField.delegate = self;
    self.setting_delayTime.delay_textField.textColor = [UIColor whiteColor];
    [self.setting_delayTime.delay_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.setting_delayTime defineTimeBts];

    
    //self.marcoFileName
    [self.marcoFileName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    

    //按下bt改變底色
    [self.main_save setBackgroundImage:[UIImage imageNamed:@"macro_btn_a_save_down"] forState:UIControlStateHighlighted];
    
    //按下bt改變文字顏色
    [self.main_save setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];

    //按下bt改變底色
    [self.main_cancel setBackgroundImage:[UIImage imageNamed:@"macro_btn_a_cancel_down"] forState:UIControlStateHighlighted];
    
    //按下bt改變文字顏色
    [self.main_cancel setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];

    
    //marcoFileName
    self.marcoFileName.delegate = self;
    
    
    
    //更改 TextField 的 placeholder 字體顏色
    UIColor *color = [UIColor lightGrayColor];
    _delayTimeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"100~5000" attributes:@{NSForegroundColorAttributeName: color}];

    
    //鍵盤滑鼠 key 初始化
    keyCodeClass = [[KeyCodeFile alloc]init];
    
    //硬體初始化
    marcoData = [[FPSMacroData alloc] init];
    [marcoData initParam];
    
    
    
    //self.superVC (CFMainViewController)
    if (self.superVC == nil) {
        
        self.superVC = (CFMainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFMainVC"];
    }
    
    self.isMacroHotkeyCallKeyCodeResponse = NO;
    self.isSettingViewCallKeyCodeResponse = NO;
    
    self.hotKey_saveBt.hidden = YES;
    
    
    //ary_selectedSettingBts
    ary_selectedSettingBts = [NSMutableArray arrayWithObjects:_selected_settingBt_1000,_selected_settingBt_1001,_selected_settingBt_1002,_selected_settingBt_1003,_selected_settingBt_1004,_selected_settingBt_1005,_selected_settingBt_1006,_selected_settingBt_1007,_selected_settingBt_1008, nil];
    
    //settingView_keyboard_key_0 ~ 3
    _settingView_keyboard_key_0.titleLabel.adjustsFontSizeToFitWidth = YES;
    _settingView_keyboard_key_1.titleLabel.adjustsFontSizeToFitWidth = YES;
    _settingView_keyboard_key_2.titleLabel.adjustsFontSizeToFitWidth = YES;
    _settingView_keyboard_key_3.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    
    //chosedTimeBtIndex
    chosedTimeBtIndex = 0;
    
    //新增資料時防呆用
    isCreateAndHadInit = NO;
    
    
    //鍵盤監聽事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkMacroFileNameRepeat) name:UIKeyboardDidHideNotification object:nil];
    
    
    //macro hotkey
    self.macroHotkeyView.keyBt = self.macroHotkeyBt;
    self.macroHotkeyView.keyImgView = self.marcoHotkeyImg;
    self.macroHotkeyView.keyType = 0;
}


-(void)viewWillAppear:(BOOL)animated {
    
    //ken
    for (int i = 0; i < ary_settingView.count; i++) {
        
        ary_settingView[i].settingView_keycode = 0;
        
    }
    
    //portocol delegate
    [ProtocolDataController sharedInstance].dataResponseDelegate = self;
    [ProtocolDataController sharedInstance].connectStateDelegate = self;
    
    if (_alreadyInitView){
        
        return;
    }
    _alreadyInitView = YES;
    
    
    //self.hotketSettingLabel.text = @"";
    [self.macroHotkeyView.keyBt setTitle:@"" forState:UIControlStateNormal];
    
    
    //新增資料時防呆用
    isCreateAndHadInit = NO;
    
    /*
     1.keyCode 轉文字
     2.辦認 keyImgType
     */
    
    currentMarcoObj = [[MCTableViewCellObject alloc] init];
    
    if (self.superVC.isMarcoEdit == YES) {
        //編輯
        NSLog(@"編輯");
        
        //copy物件
        [self setMacroDataArrayTemporary];
        
        //新增資料時防呆用
        isCreateAndHadInit = YES;
        
        //fileName
        self.marcoFileName.text = currentMarcoObj.marcoFileName;
        
        //platform
        self.gamePlatformImgView.image = [UIImage imageNamed:[self getPlatformNumTransformToIcon:[currentMarcoObj.marcoPlatformImgStr intValue]]];
        
        //hotkey
        NSString *hotkeyStr = [keyCodeClass returnKeyboardKey: [currentMarcoObj.marcoHotKey intValue]];
        
        //self.hotketSettingLabel.text = hotkeyStr;
        [self.macroHotkeyView.keyBt setTitle:hotkeyStr forState:UIControlStateNormal];
        
        //keyCode
        NSString *keyStr;
        for (int index = 0; index < ary_settingView.count; index++) {
            
             ary_settingView[index].hidden = NO;
            
            //keycode
            int KeyCodeInt = [currentMarcoObj.marco_ary_key[index] intValue];
            
            ary_settingView[index].settingView_keycode = KeyCodeInt;
            
            //keyboardLabel 顯示或隱藏
            int imgTypeInt = [self returnKeyCodeImgType:KeyCodeInt];
            
            [ary_settingView[index] showOrHideKeyboardLabel:imgTypeInt];
            
            
            //顯示 keyboard - mL - mR (up or down)
            for (int i = 0; i < 8; i++) {
                
                if (i == imgTypeInt) {
                    
                    ary_settingView[index].ary_imgView[i].hidden = NO;
                }
                else {
                    
                    ary_settingView[index].ary_imgView[i].hidden = YES;
                }
            }
        
            //keycode 轉 文字
            if (KeyCodeInt > KEYCODE_TOTALCOUNT) {
                
                KeyCodeInt -= 128;
            }
            
            keyStr = [keyCodeClass returnKeyboardKey:KeyCodeInt];
            
            ary_settingView[index].keyboardLabel.text = keyStr;
            
            
        }
        
        
        //delayTime: 判斷 delayTimeBt 為 紅色 還是 灰色
        //從 ary_settingView 去判斷
        //編輯時, ary_delayBt 顯示
        for ( int j = 0; j < ary_delayBt.count; j++) {
            
            ary_delayBt[j].hidden = NO;
        }

        [self checkDelayBtColor];
        
//        currentMarcoObj.marco_ary_delayTime = self.edit_marcoObj.marco_ary_delayTime;
        
        
        self.platformBts.hidden = YES;
        self.marcoFileName.hidden = NO;
        self.gamePlatformImgView.hidden = NO;
        
        self.hotkeySettingitem.hidden = NO;
        self.macroHotkeyView.hidden = NO;

        //saveBt 有效
        [self.main_save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.main_save.userInteractionEnabled = YES;
        
        //變更 hotkey 的顏色與圖案
        [self.macroHotkeyView changeKeyColor:[currentMarcoObj.marcoHotKey intValue]];
        
        
    }
    else {
        //新增
        NSLog(@"新增");
        
        
        //新增資料時防呆用
        isCreateAndHadInit = NO;
        
        //ary_settingView 歸零
        for (int i = 0; i < ary_settingView.count; i++) {
            
            //新增時,還沒選擇platform, settingView 隱藏
            ary_settingView[i].hidden = YES;
            
            for (int imgIndex = 0; imgIndex < 8; imgIndex ++) {
                
                if (imgIndex == 0) {
                    
                    ary_settingView[i].ary_imgView[imgIndex].hidden = NO;
                }
                else {
                    
                    ary_settingView[i].ary_imgView[imgIndex].hidden = YES;
                }
                
            }
            
        }
        
        
        //新增時,未選擇platform, ary_delayBt 隱藏
        for ( int j = 0; j < ary_delayBt.count; j++) {
        
            ary_delayBt[j].hidden = YES;
        }
        
        [self checkDelayBtColor];

        
        
        //macroFileName
        NSMutableArray *macroAry = [[ConfigMacroData sharedInstance] getMacroArray];
        
        NSMutableDictionary *macroNameDic = [NSMutableDictionary new];
        
        NSString *newName = @"Macro_1";
        
        NSMutableArray *ary_macroName = [NSMutableArray arrayWithObjects:@"Macro_1",@"Macro_2",@"Macro_3",@"Macro_4",@"Macro_5",@"Macro_6",@"Macro_7",@"Macro_8",nil];
        
        NSMutableArray *ary_macroNameBool = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
        
        if (macroAry.count == 0) {
            
            newName = @"Macro_1";
        }
        else {
            
            for (int existMacroNameInt = 0; existMacroNameInt < macroAry.count; existMacroNameInt ++) {
                
                macroNameDic = macroAry[existMacroNameInt];
                
                NSString *macroIntName = (NSString *)[macroNameDic objectForKey:@"macroName"];
                
                for (int targetInt = 0; targetInt < ary_macroName.count; targetInt++) {
                    
                    NSString *intName = [NSString stringWithFormat:@"Macro_%d",targetInt+1];
                    
                    if([macroIntName isEqualToString:intName]) {
                        
                        ary_macroNameBool[targetInt] = @"1";
                    }
                    
                }
                
            }
            
        }
        
        for (int macroNameInt = 0; macroNameInt < ary_macroNameBool.count; macroNameInt++) {
            
            if([ary_macroNameBool[macroNameInt] isEqualToString:@"0"]) {
                
                newName = (NSString *)ary_macroName[macroNameInt];
                break;
            }
            
        }
        
        self.marcoFileName.text = newName;
        currentMarcoObj.marcoFileName = newName;
        
        
        //ary_settingView keyboardLabel
        for (int i = 0; i < ary_settingView.count; i++) {
            
             ary_settingView[i].keyboardLabel.text = @"";
        }

        
        //marco_ary_key
        currentMarcoObj.marco_ary_key = [[NSMutableArray alloc] initWithCapacity:0];
        for(int keyIndex = 0;keyIndex < 16; keyIndex++) {
            
            [currentMarcoObj.marco_ary_key addObject:[NSNumber numberWithInt:0]];
        }
        
        //marco_ary_delayTime
        currentMarcoObj.marco_ary_delayTime = [[NSMutableArray alloc] initWithCapacity:0];
        for (int timeIndex = 0; timeIndex < 15; timeIndex++) {
            
            [currentMarcoObj.marco_ary_delayTime addObject:[NSNumber numberWithInt:99]];
        }
        
        NSLog(@"%@",currentMarcoObj.marco_ary_delayTime);
        
        //marcoHotKey
        currentMarcoObj.marcoHotKey = [NSString stringWithFormat:@"0"];
        
        
        //顯示 platform 選擇, 其他隱藏
        self.platformBts.hidden = NO;
        self.marcoFileName.hidden = YES;
        self.gamePlatformImgView.hidden = YES;
        
        self.hotkeySettingitem.hidden = YES;
        self.macroHotkeyView.hidden = YES;
        
        //save changed View 隱藏
        self.saveChangeView.hidden = YES;
        
        
        //saveBt 無效
        [self.main_save setTitleColor:[UIColor colorWithRed:0.17 green:0.67 blue:0.8 alpha:0.65] forState:UIControlStateNormal];
        self.main_save.userInteractionEnabled = NO;
        
        [self.macroHotkeyView.keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_kb_2"] forState:UIControlStateNormal];
        
        [self.macroHotkeyView.keyBt setTitleColor:[UIColor colorWithRed:0.0 green:0.72 blue:0.95 alpha:1.0] forState:UIControlStateNormal];
        
        self.macroHotkeyView.keyImgView.image = [UIImage imageNamed:@"config_icon_a_kb_1"];
        
    }
    
    //立即切換語系
    [self changeLanguesImediately];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    if (self.superVC == nil) {
        
        self.superVC = (CFMainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFMainVC"];
    }
    
    //self.superVC.isSelectedConfig = NO;
    
    self.saveChangeView.hidden = YES;
    
    [self.marcoFileName resignFirstResponder];
    
    [[ProtocolDataController sharedInstance] stopListeningResponse];
    //macroResponseTimer
//    [macroResponseTimer invalidate];
//    macroResponseTimer = nil;
    
    int macroHotkeyInt = [currentMarcoObj.marcoHotKey intValue];
    
    NSString *macroHotkeyStr = [keyCodeClass returnKeyboardKey:macroHotkeyInt];
    
    //self.hotketSettingLabel.text = macroHotkeyStr;
    [self.macroHotkeyView.keyBt setTitle:macroHotkeyStr forState:UIControlStateNormal];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    
    //Nick hotkey
    //currentMarcoObj = nil;
    
    //[macroResponseTimer invalidate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - checkHotkeyValue
-(BOOL)checkHotkeyValueAction {
    
    BOOL isSetting = NO;
    
    if ([currentMarcoObj.marcoHotKey intValue] != 0) {
        
        isSetting = YES;
        
        return isSetting;
    }
    
    return isSetting;
    
}




#pragma mark - setMacroDataArrayTemporary
-(void)setMacroDataArrayTemporary {
    
    
    NSMutableArray *oriArray = [[ConfigMacroData sharedInstance] getMacroArray];

    NSMutableDictionary *oriDic = [NSMutableDictionary new];
    
    oriDic = [oriArray[self.indexPathRow] mutableCopy];

    
    if (currentMarcoObj == nil) {
        
        currentMarcoObj = [[MCTableViewCellObject alloc]init];
    }
    
    //macro FileName
    currentMarcoObj.marcoFileName = [[oriDic objectForKey:@"macroName"] copy];
    
    //macro Hotkey
    currentMarcoObj.marcoHotKey = [[oriDic objectForKey:@"macroHotkey"] copy];

    //marco platform
    currentMarcoObj.marcoPlatformImgStr = [[oriDic objectForKey:@"macroPlatform"] copy];
    
    //marco KeyArray
    currentMarcoObj.marco_ary_key = [[NSMutableArray alloc] initWithCapacity:0];
    currentMarcoObj.marco_ary_key = [[oriDic objectForKey:@"macroKeyArr"] mutableCopy];
    
    
    //marco DelayTime Array
    currentMarcoObj.marco_ary_delayTime = [[NSMutableArray alloc] initWithCapacity:0];
    
    currentMarcoObj.marco_ary_delayTime = [[oriDic objectForKey:@"macroDelayArr"] mutableCopy];
    
    
}

#pragma mark - 判斷是否有值改變
-(BOOL)isValueChanged {
    
    BOOL isChanged;
    
    int changeCount = 0;
    
    NSMutableArray *oriArray = [[ConfigMacroData sharedInstance] getMacroArray];
    
    NSMutableDictionary *oriDic = [NSMutableDictionary new];
    
    oriDic = [oriArray[self.indexPathRow] mutableCopy];
    
    //macro FileName
    if (![currentMarcoObj.marcoFileName isEqualToString:[oriDic objectForKey:@"macroName"]]) {
        
        NSLog(@"macro FileName changed");
        NSLog(@"Nick fileName:%@",currentMarcoObj.marcoFileName);
        NSLog(@"Rex fileName:%@",[oriDic objectForKey:@"macroName"]);
        
        changeCount += 1;
    }
    
    //macro Hotkey
    if ([currentMarcoObj.marcoHotKey intValue] != [[oriDic objectForKey:@"macroHotkey"]intValue]) {
        
        NSLog(@"macro Hotkey changed");
        
        changeCount += 1;
    }
    
    //marco platform
    if ([currentMarcoObj.marcoPlatformImgStr intValue] != [[oriDic objectForKey:@"macroPlatform"] intValue] ) {
        
        NSLog(@"marco platform changed");
        
        changeCount += 1;
    }
    
    
    //marco Key array
    for (int settingViewIndex = 0; settingViewIndex < ary_settingView.count; settingViewIndex++) {
        
        if ([currentMarcoObj.marco_ary_key[settingViewIndex] intValue] != [[oriDic objectForKey:@"macroKeyArr"][settingViewIndex] intValue]) {
            
            NSLog(@"marco Key array changed:%d",settingViewIndex);
            
            changeCount += 1;
        }

    }
    

    //macro DelayTime array
    for (int timeIndex = 0; timeIndex < ary_delayBt.count; timeIndex++) {
        
        if ([currentMarcoObj.marco_ary_delayTime[timeIndex] intValue] != [[oriDic objectForKey:@"macroDelayArr"][timeIndex] intValue]) {
            
            NSLog(@"macro DelayTime array changed:%d",timeIndex);
            
            changeCount += 1;
        }
    }
    
    
    //是否有改變
    if(changeCount != 0) {
        
        isChanged = YES;
    }
    else {
        
        isChanged = NO;
    }

    return isChanged;
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


//#pragma mark - platform 取得圖片轉換成對應的數字
//-(int)getPlatformIconStringTransformToNum:(NSString *)platformStr {
//    
//    int num;
//    
//    if ([platformStr isEqualToString:@"platform_a_2_ps3_88x88"]) {
//        
//        num = 1;
//    }
//    else if ([platformStr isEqualToString:@"platform_a_1_ps4_88x88"]) {
//        
//        num = 2;
//    }
//    else if ([platformStr isEqualToString:@"platform_a_4_x360_88x88"]) {
//        
//        num = 4;
//    }
//    else if ([platformStr isEqualToString:@"platform_a_3_x1_88x88"]) {
//        
//        num = 8;
//    }
//    
//    return num;
//}



#pragma mark - choseGamePlatform
- (IBAction)choseGamePlatform:(UIButton *)sender {
    
    NSString *imgName;
    
    switch (sender.tag) {
            
        case 90: //Xbox360
            imgName = @"platform_a_4_x360_88x88";
            platformInt = 4;
            break;
        case 91: //XboxOne
            imgName = @"platform_a_3_x1_88x88";
            platformInt = 8;
            break;
        case 92: //PS4
            imgName = @"platform_a_1_ps4_88x88";
            platformInt = 2;
            break;
        case 93: //PS3
            imgName = @"platform_a_2_ps3_88x88";
            platformInt = 1;
            break;
        default:
            break;
            
    }

    currentMarcoObj.marcoPlatformImgStr = [NSString stringWithFormat:@"%d",platformInt];
    
    self.gamePlatformImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgName]];
    
    self.gamePlatformImgView.hidden = NO;
    
    self.platformBts.hidden = YES;
    
    self.marcoFileName.hidden = NO;
    
    self.hotkeySettingitem.hidden = NO;
    self.macroHotkeyView.hidden = NO;
    
    //新增資料時防呆用
    isCreateAndHadInit = YES;
    
    for (int i = 0; i < ary_settingView.count; i++) {
        
        //新增時,選擇platform, settingView 顯示
        ary_settingView[i].hidden = NO;
    }
    
    for ( int j = 0; j < ary_delayBt.count; j++) {
        
        //新增時,選擇platform, ary_delayBt 顯示
        ary_delayBt[j].hidden = NO;
    }
    
    
    //saveBt 有效
    [self.main_save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.main_save.userInteractionEnabled = YES;
    
}





#pragma mark - 顯示 SettingWindow 與 大的 Listening
-(void)showSettingWindow {
    
    NSLog(@"showSettingWindow");
    
//    [macroResponseTimer invalidate];
    
    self.settingWindow.hidden = NO;
    
    self.sw_listeningLabel.hidden = NO;
    
    
    _timeSaveBt.hidden = YES;
    
    _isSettingViewCallKeyCodeResponse = YES;
    
    _isMacroHotkeyCallKeyCodeResponse = NO;
    
    [[ProtocolDataController sharedInstance] startListeningResponse];
//    macroResponseTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startResponseMode) userInfo:nil repeats:YES];
}

#pragma mark - 顯示 Keyboard, mouseLeft, mouseRight
-(void)showKeyType:(int)index {
    
    self.sw_listeningLabel.hidden = YES;
    
    switch (index) {
            
        case 0://顯示 keyboard
            [self hiddenKeyboard:NO mouseLeft:YES mouseRight:YES];
            break;
        case 1://顯示 mouseLeft
            [self hiddenKeyboard:YES mouseLeft:NO mouseRight:YES];
            break;
        case 2://顯示 mouseRight
            [self hiddenKeyboard:YES mouseLeft:YES mouseRight:NO];
            break;
        default:
            break;
            
    }
    
    int settingViewIndex = [self determineSelectedBtIndex:ary_settingView];
    
    if (settingViewIndex == ary_settingView.count - 1) {
        //如果是最後一個settingView,三種組合鍵都不能選
        //Tag:1002 -> keyboard 組合鍵
        //Tag:1005 -> mouseLeft 組合鍵
        //Tag:1008 -> mouseRight 組合鍵
        
        [self.view viewWithTag:1002].userInteractionEnabled = NO;
        [self.view viewWithTag:1005].userInteractionEnabled = NO;
        [self.view viewWithTag:1008].userInteractionEnabled = NO;
    }
    else {
        
        [self.view viewWithTag:1002].userInteractionEnabled = YES;
        [self.view viewWithTag:1005].userInteractionEnabled = YES;
        [self.view viewWithTag:1008].userInteractionEnabled = YES;
        
    }
    
//    //隱藏所有的小 listening
//    for (int listenIndex = 0;listenIndex < ary_listening.count; listenIndex++) {
//        
//        ary_listening[listenIndex].hidden = YES;
//    }
//    
}



-(int)determineSelectedBtIndex:(NSMutableArray<MCSettingView *> *)theViews {
    
    //判斷是哪一個 settingView 被觸發
    int num = 0;
    
    for (int viewIndex = 0; viewIndex < ary_settingView.count; viewIndex++) {
        
        if (theViews[viewIndex].isSelected == YES) {
            
            num = viewIndex;
        }
    }
    
    return num;
}


#pragma mark - 是否隱藏Keyboard, mouseLeft,mouseRight
-(void)hiddenKeyboard:(BOOL)bool_0 mouseLeft:(BOOL)bool_1 mouseRight:(BOOL)bool_2 {
    
    self.setting_keyboard.hidden = bool_0;
    
    self.setting_mouseLeft.hidden = bool_1;
    
    self.setting_mouseRight.hidden = bool_2;
    
}

- (IBAction)closeSettingWindow:(id)sender {
    
    [[ProtocolDataController sharedInstance] stopListeningResponse];
//    [macroResponseTimer invalidate];
    
    [UIView animateWithDuration:0.38 animations:^{
        
        [self dismissSelectView:sender];
        
        self.hotKey_saveBt.hidden = YES;
        
    }];
    
    //selectedSettingBts 底色還原
    for(int i = 0; i < ary_selectedSettingBts.count; i++) {
        
        [ary_selectedSettingBts[i] setImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item2_btn_up"] forState:UIControlStateNormal];
    }

    
}

#pragma mark - dismissSelectView
- (void)dismissSelectView:(id)sender {
    
    
    [self hiddenKeyboard:YES mouseLeft:YES mouseRight:YES];
    
    for (int i = 0; i < ary_settingView.count; i++) {
        
        ary_settingView[i].isSelected = NO;
    }
    _settingWindow.hidden = YES;
    
    _listenLabel.hidden = YES;
    
     _setting_delayTime.hidden = YES;
    
    self.delaytimeMark.hidden = YES;
    
}


#pragma mark - 設定連續動作延遲時間
- (IBAction)showTimeSetting:(id)sender {

    UIButton *delayBt = (UIButton *)sender;
    
    _sw_listeningLabel.hidden = YES;
    
    _settingWindow.hidden = NO;
    
    _setting_delayTime.hidden = NO;
    
    _setting_delayTime.mySuperVC = self;
    
    self.delaytimeMark.hidden = NO;
    
    self.timeSaveBt.hidden = NO;
    
    self.hotKey_saveBt.hidden = YES;
    
    
    for (int i = 0; i < 15; i++) {
        
        if (delayBt.tag == i) {
            
            chosedTimeBtIndex = i;
            
            self.setting_delayTime.seconds = [currentMarcoObj.marco_ary_delayTime[i] intValue];
            
            [self.setting_delayTime returnTimeType:self.setting_delayTime.seconds];
        
        }
        
    }

}

#pragma mark - 儲存延遲時間
-(void)saveDelayTime:(int)seconds {
    
    currentMarcoObj.marco_ary_delayTime[chosedTimeBtIndex] = [NSNumber numberWithInt:seconds];
    
    self.settingWindow.hidden = YES;
    self.setting_delayTime.hidden = YES;
    self.timeSaveBt.hidden = YES;
    
    NSLog(@"save DelayTime");
    
    NSLog(@"=== delayTimeAry:%@",currentMarcoObj.marco_ary_delayTime);
}



#pragma mark - 回到主頁
- (IBAction)backToSuperVC:(id)sender {
    
    [[ProtocolDataController sharedInstance] stopListeningResponse];
//    [macroResponseTimer invalidate];
    
    if (self.superVC.isMarcoEdit == NO) {
        
        //新增
        if (isCreateAndHadInit) {
            //新增且有初始值
            
              self.saveChangeView.hidden = NO;
        }
        else {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    else {
        //編輯
        
        BOOL isAnyValueCange = [self isValueChanged];
        
        if (isAnyValueCange == YES) {
            
            self.saveChangeView.hidden = NO;
        }
        else {
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    
    
    
    
//    if (isCreateAndHadInit) {
//        
//        //新增且有設定初始值 或 編輯
//        BOOL isAnyValueCange = [self isValueChanged];
//        
//        if (isAnyValueCange == YES) {
//            //有值改變,跳出視窗
//            
//            NSLog(@"有值改變,跳出視窗");
//            self.saveChangeView.hidden = NO;
//        }
//        else {
//            
//            self.saveChangeView.hidden = YES;
//            [self dismissViewControllerAnimated:YES completion:nil];
//            
//        }
//
//    }
//    else {
//        
//        //新增但沒設定
//        [self dismissViewControllerAnimated:YES completion:nil];
//
//    }
    
}



#pragma mark - 顯示或隱藏垃圾桶
-(void)showTrashcanOrHidden:(BOOL)show {
    
    if (show == YES) {
        
        _trashcan.hidden = NO;
    }
    else {
        
        _trashcan.hidden = YES;
    }
    
}

- (IBAction)selectedSettingBtAcion:(UIButton *)sender {
    
    
    switch (sender.tag) {
        case 1000:
            //keyboard down
            selectedBtIndex = 2;
            isCombinationKeys = NO;
            choseIndex = 0;
            break;
        case 1001:
            //keyboard up
            selectedBtIndex = 3;
            isCombinationKeys = NO;
            choseIndex = 1;
            //會累加
            //public_keycode += 128;
            break;
        case 1002:
            //keyboard 組合鍵
            selectedBtIndex = 2;
            isCombinationKeys = YES;
            choseIndex = 2;
            break;
        case 1003:
            //mouseLeft down
            selectedBtIndex = 4;
            isCombinationKeys = NO;
            choseIndex = 3;
            break;
        case 1004:
            //mouseLeft up
            selectedBtIndex = 5;
            isCombinationKeys = NO;
            choseIndex = 4;
            //會累加
            //public_keycode += 128;
            break;
        case 1005:
            //mouseLeft 組合鍵
            selectedBtIndex = 4;
            isCombinationKeys = YES;
            choseIndex = 5;
            break;
        case 1006:
            //mouseRight down
            selectedBtIndex = 6;
            isCombinationKeys = NO;
            choseIndex = 6;
            break;
        case 1007:
            //mouseRight up
            selectedBtIndex = 7;
            isCombinationKeys = NO;
            choseIndex = 7;
            //會累加
            //public_keycode += 128;
            break;
        case 1008:
            //mouseRight 組合鍵
            selectedBtIndex = 6;
            isCombinationKeys = YES;
            choseIndex = 8;
            break;
        default:
            break;
    }
    
    NSLog(@"====== chose ======");
    
    //settingWindow 三個選項的底色
    for (int i = 0; i < ary_selectedSettingBts.count; i++) {
        
        if (i == choseIndex) {
            //變色
            
            [ary_selectedSettingBts[i] setImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item2_btn_down"] forState:UIControlStateNormal];
        }
        else {
            //還原
            [ary_selectedSettingBts[i] setImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item2_btn_up"] forState:UIControlStateNormal];
            
        }
    }
    

}

#pragma mark - keyboard,ML,MR setting儲存鍵
- (IBAction)onSaveBtAction:(UIButton *)sender {
    
    NSLog(@"====== save ==========");
    NSLog(@"onSaveBtAction-----selectedBtIndex = %i", selectedBtIndex);
    
    /*
     1.saveBt 觸發後 keyboard,mouseLeft,mouseRight 隱藏
     2.並根據選擇鍵改變 settingView 的圖示
     */
    
    if (selectedBtIndex == 0 || selectedBtIndex == 1) {
        return;
    }
    
    
    [self changeDelayTimeAfterSelected:ary_settingView];
    
    [self dismissSelectView:sender];
    
    [self closeSettingWindow:sender];
    
    self.delaytimeMark.hidden = YES;
    
    self.hotKey_saveBt.hidden = YES;
    
    
    //selectedSettingBts 底色還原
    for(int i = 0; i < ary_selectedSettingBts.count; i++) {
        
        [ary_selectedSettingBts[i] setImage:[UIImage imageNamed:@"bg_wordsquare_1_a_item2_btn_up"] forState:UIControlStateNormal];
    }
    
    
}


#pragma mark - 判斷 delayTime 紅色或灰色
-(void)changeDelayTimeAfterSelected:( NSMutableArray<MCSettingView *> *)theViews {
    
    if(choseIndex == 1 || choseIndex == 4 || choseIndex == 7){
        public_keycode += 128;
    }
    
    int index = [self determineSelectedBtIndex:ary_settingView];
    
    NSLog(@"changeDelayTimeAfterSelected-----index = %i", index);
    NSLog(@"changeDelayTimeAfterSelected-----isCombinationKeys = %i", isCombinationKeys);
    
    if (isCombinationKeys == NO) {
        
        //單鍵是index改變
        [theViews[index] showSettingViewAtIndex:selectedBtIndex];
        
        NSLog(@"changeDelayTimeAfterSelected-----(ary_settingView.count - 1) = %i", ary_settingView.count - 1);
        
        if (index == ary_settingView.count - 1) {
            
            if (public_keycode > KEYCODE_TOTALCOUNT) {
                
                ary_settingView[index].settingView_keycode = public_keycode;
                
                currentMarcoObj.marco_ary_key[index] = [NSNumber numberWithInt:public_keycode];

                //keyboardLabel 顯示或隱藏
                int imgTypeInt = [self returnKeyCodeImgType:public_keycode];
                [ary_settingView[index] showOrHideKeyboardLabel:imgTypeInt];
                public_keycode -= 128;
                
                //顯示 settingView 的 keycode
                ary_settingView[index].keyboardLabel.text = [keyCodeClass returnKeyboardKey:public_keycode];
                
            }
            else {
                
                //顯示 settingView 的 keycode
                ary_settingView[index].settingView_keycode = public_keycode;
                currentMarcoObj.marco_ary_key[index] = [NSNumber numberWithInt:public_keycode];
                ary_settingView[index].keyboardLabel.text = [keyCodeClass returnKeyboardKey:public_keycode];
                
                //keyboardLabel 顯示或隱藏
                int imgTypeInt = [self returnKeyCodeImgType:public_keycode];
                [ary_settingView[index] showOrHideKeyboardLabel:imgTypeInt];

            }
            
            //無delayTime
            return;
        }
        else {
            
            if (public_keycode > KEYCODE_TOTALCOUNT) {
                
                ary_settingView[index].settingView_keycode = public_keycode;
                currentMarcoObj.marco_ary_key[index] = [NSNumber numberWithInt:public_keycode];
                
                //keyboardLabel 顯示或隱藏
                int imgTypeInt = [self returnKeyCodeImgType:public_keycode];
                [ary_settingView[index] showOrHideKeyboardLabel:imgTypeInt];
                public_keycode -= 128;
                
                //顯示 settingView 的 keycode
                ary_settingView[index].keyboardLabel.text = [keyCodeClass returnKeyboardKey:public_keycode];
                
                
            }
            else {
                
                //顯示 settingView 的 keycode
                ary_settingView[index].settingView_keycode = public_keycode;
                currentMarcoObj.marco_ary_key[index] = [NSNumber numberWithInt:public_keycode];
                ary_settingView[index].keyboardLabel.text = [keyCodeClass returnKeyboardKey:public_keycode];
                
                //keyboardLabel 顯示或隱藏
                int imgTypeInt = [self returnKeyCodeImgType:public_keycode];
                [ary_settingView[index] showOrHideKeyboardLabel:imgTypeInt];
                
            }

            //顯示紅色 delayTime
            [ary_delayBt[index] setImage:[UIImage imageNamed:@"macro_edit_btn_a_+"] forState:UIControlStateNormal];
            
            ary_delayBt[index].userInteractionEnabled = YES;
        }

    }
    else {
        
        //組合鍵,是index和index+1改變
        [theViews[index] showSettingViewAtIndex:selectedBtIndex];
        
        [theViews[index+1] showSettingViewAtIndex:selectedBtIndex+1];
        
        if (index == ary_settingView.count - 2) {
         
            //顯示組合鍵 settingView 的 keycode
            ary_settingView[index].settingView_keycode = public_keycode;
            currentMarcoObj.marco_ary_key[index] = [NSNumber numberWithInt:public_keycode];
            ary_settingView[index].keyboardLabel.text = [keyCodeClass returnKeyboardKey:public_keycode];
            
            //keyboardLabel 顯示或隱藏
            int imgTypeInt = [self returnKeyCodeImgType:public_keycode];
            [ary_settingView[index] showOrHideKeyboardLabel:imgTypeInt];
            
            
            //顯示組合鍵+1
            public_keycode += 128;
            currentMarcoObj.marco_ary_key[index+1] = [NSNumber numberWithInt:public_keycode];
            ary_settingView[index+1].settingView_keycode = public_keycode;
            //keyboardLabel+1 顯示或隱藏
            int imgTypeIntTwo = [self returnKeyCodeImgType:public_keycode];
            [ary_settingView[index+1] showOrHideKeyboardLabel:imgTypeIntTwo];

            //顯示組合鍵+1 settingView 的 keycode
            public_keycode -= 128;
            ary_settingView[index+1].keyboardLabel.text = [keyCodeClass returnKeyboardKey:public_keycode];

            
            
            //顯示紅色 delayTime
            [ary_delayBt[index] setImage:[UIImage imageNamed:@"macro_edit_btn_a_+"] forState:UIControlStateNormal];
            
            ary_delayBt[index].userInteractionEnabled = YES;
        }
        else {
            
            //顯示組合鍵 settingView 的 keycode
            ary_settingView[index].settingView_keycode = public_keycode;
            currentMarcoObj.marco_ary_key[index] = [NSNumber numberWithInt:public_keycode];
            ary_settingView[index].keyboardLabel.text = [keyCodeClass returnKeyboardKey:public_keycode];
            
            //keyboardLabel 顯示或隱藏
            int imgTypeInt = [self returnKeyCodeImgType:public_keycode];
            [ary_settingView[index] showOrHideKeyboardLabel:imgTypeInt];
            
            
            //顯示組合鍵+1
            public_keycode += 128;
            currentMarcoObj.marco_ary_key[index+1] = [NSNumber numberWithInt:public_keycode];
            ary_settingView[index+1].settingView_keycode = public_keycode;
            
            //keyboardLabel+1 顯示或隱藏
            int imgTypeIntTwo = [self returnKeyCodeImgType:public_keycode];
            [ary_settingView[index+1] showOrHideKeyboardLabel:imgTypeIntTwo];
            
            //顯示組合鍵+1 settingView 的 keycode
            public_keycode -= 128;
            ary_settingView[index+1].keyboardLabel.text = [keyCodeClass returnKeyboardKey:public_keycode];
            

            
            //顯示紅色 index delayTime
            [ary_delayBt[index] setImage:[UIImage imageNamed:@"macro_edit_btn_a_+"] forState:UIControlStateNormal];
            
            ary_delayBt[index].userInteractionEnabled = YES;
            
            
            //顯示紅色 index+1 delayTime
            [ary_delayBt[index+1] setImage:[UIImage imageNamed:@"macro_edit_btn_a_+"] forState:UIControlStateNormal];
            
            ary_delayBt[index+1].userInteractionEnabled = YES;
        }
        
    }
    
    if (selectedBtIndex == 0 || selectedBtIndex == 1) {
        
        //如果未選擇,save鍵無效
        self.hotKey_saveBt.userInteractionEnabled = NO;
    }
    else {
        
        self.hotKey_saveBt.userInteractionEnabled = YES;
    }
    
    selectedBtIndex = 0;
}




#pragma mark - 判斷 DelayBt 的顏色
-(void)checkDelayBtColor {
    
    for (int i = 0; i < ary_delayBt.count; i++) {
        
        if (ary_settingView[i].ary_imgView[0].hidden == NO || ary_settingView[i].ary_imgView[1].hidden == NO) {
            
            [ary_delayBt[i] setImage:[UIImage imageNamed:@"macro_edit_btn_a_+_gray"] forState:UIControlStateNormal];
            
            ary_delayBt[i].userInteractionEnabled = NO;
        }
        else {
            
            [ary_delayBt[i] setImage:[UIImage imageNamed:@"macro_edit_btn_a_+"] forState:UIControlStateNormal];
            
            ary_delayBt[i].userInteractionEnabled = YES;
        }
    
    }
    
}

#pragma mark - mainSaveAction
- (IBAction)mainSaveAction:(UIButton *)sender {
    
    [[ProtocolDataController sharedInstance] stopListeningResponse];
//    [macroResponseTimer invalidate];
    
    if (isCreateAndHadInit) {
        
        //儲存
        [self saveChangeDataOrNot:YES];
    }
    else {
        
        //新增無初始資料
        return;
        
    }
    

}

#pragma mark - mainCancelAction
- (IBAction)mainCancelAction:(UIButton *)sender {

    //回到 marco 主頁
    [[ProtocolDataController sharedInstance] stopListeningResponse];
//    [macroResponseTimer invalidate];
    
    currentMarcoObj = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(bool)checkHotKeyRangeF1F10:(int)keyCode{
    //keycode 在 F1 ~ F10 範圍外
    if (keyCode < 58 || keyCode > 67) {
        return true;
    }
    return false;
}

//#pragma mark - 熱鍵重覆
//-(void)hotkeyRepeat{
//    
//    //如果熱鍵重覆會跳出警告視窗
//    WaringViewController *waring = [self.storyboard instantiateViewControllerWithIdentifier:@"Key_WaringViewController"];
//    waring.parentObj = self;
//    waring.waring_message = NSLocalizedString(@"HotKey repeat", nil);//@"熱鍵重覆";
//    waring.waring_description = NSLocalizedString(@"please change another one", nil);//@"已有相同熱鍵,請更換";
//   
//    [self presentViewController:waring animated:YES completion:nil];
//    
//}


#pragma mark - 熱鍵有誤跳出警告畫面
-(void)resetMacroHotkeyStatus:(NSString *)macroHotKeyStr Type:(int)type{
    
    //self.hotketSettingLabel.text = macroHotKeyStr;
    
    [self.macroHotkeyView.keyBt setTitle:macroHotKeyStr forState:UIControlStateNormal];
    
    if(type == 0) {
        
         [self showWarningViewTitle:NSLocalizedString(@"Incorrect HotKey", nil)  Description:NSLocalizedString(@"Please check range to F1~F10", nil)];
    }
    else if (type == 1){
        
        [self showWarningViewTitle:NSLocalizedString(@"HotKey Repeat", nil) Description:NSLocalizedString(@"Please change another one", nil)];
    }
    else {
        
        [self showWarningViewTitle:NSLocalizedString(@"Please set HotKey", nil) Description:NSLocalizedString(@" ", nil)];
    }
    
}

-(void)showWarningViewTitle:(NSString *)title Description:(NSString *)description{
    //顯示熱鍵重覆 alertView
    WaringViewController *waringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Key_WaringViewController"];
    waringVC.parentObj = self;
    waringVC.waring_message = title;
    //@"熱鍵重覆"
    waringVC.waring_description = description;
    //@"已有相同熱鍵,請更換"
    [self presentViewController:waringVC animated:YES completion:nil];
    
}

#pragma mark - 檔名重覆
-(void)checkMacroFileNameRepeat {
    
    if ([self.marcoFileName.text isEqualToString:@""]){
        
        self.marcoFileName.text = currentMarcoObj.marcoFileName;
    }
    else {
        
        //檔名不論是 config 或 macro 都不可重覆
        //先判斷是否與 config 檔名重覆
        BOOL isConfigRepeat = NO;
        NSMutableArray *configAry = [[ConfigMacroData sharedInstance] getConfigArray];
        
        NSMutableDictionary *configFileNameDic;
        
        for (int cInt = 0; cInt < configAry.count; cInt++) {
            
            configFileNameDic = configAry[cInt];
            
            NSString *configIntName = (NSString *)[configFileNameDic objectForKey:@"configName"];
            
            if ([configIntName isEqualToString:self.marcoFileName.text]) {
                
                isConfigRepeat = YES;
                
                break;
            }
            
        }
        
        //再判斷是否與其他 macro 檔名重覆
        BOOL isMacroRepeat = NO;
        NSMutableArray *macroAry = [[ConfigMacroData sharedInstance] getMacroArray];
        NSMutableDictionary *macroFileNameDict;
        
        for (int mInt = 0; mInt < macroAry.count; mInt++) {
            
            macroFileNameDict = macroAry[mInt];
            
            NSString *macorIntName = (NSString *)[macroFileNameDict objectForKey:@"macroName"];
            
            NSNumber *num = [NSNumber numberWithInteger:self.indexPathRow];
            int numInt = [num intValue];
            
            if ([macorIntName isEqualToString:self.marcoFileName.text]) {
                
                if (mInt == numInt) {
                    
                    isMacroRepeat = NO;
                    
                    continue;
                }
                else {
                    
                    isMacroRepeat = YES;
                    
                    break;
                }
                
            }
            
            
        }
        
        
        if (isConfigRepeat == YES || isMacroRepeat == YES) {
            
            [self showWarningViewTitle:@"FileName repeat" Description:@"Please change other Name"];
            
            self.marcoFileName.text = currentMarcoObj.marcoFileName;
            
        }
        else {
            
            currentMarcoObj.marcoFileName = self.marcoFileName.text;
            
        }

    }
    
}

#pragma mark - UITextFieldDelegate

//settingWindow
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.setting_delayTime.delay_textField) {
        
        self.settingWindow.frame = CGRectMake(0,0 - 2*textField.frame.size.height, self.settingWindow.frame.size.width, self.settingWindow.frame.size.height);
    }

    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField == self.setting_delayTime.delay_textField) {
        
        if ([textField.text intValue] <= 100) {
            
            textField.text = @"100";
        }
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
//    if ([self.marcoFileName.text isEqualToString:@""]) {
//        
//        self.marcoFileName.text = currentMarcoObj.marcoFileName;
//    }
    
    
    [self.marcoFileName resignFirstResponder];
    
    [self checkMacroFileNameRepeat];
    
    return YES;

    
}

-(void)textFieldDidChange :(UITextField *) textField {
    
    
    
    
    if (textField == self.marcoFileName) {
        
        [self checkTextViewTextLength];
    }
    
    
    
    if (textField == self.setting_delayTime.delay_textField) {
        
        if (textField.text.length > 0){
            
            if ([[textField.text substringToIndex:1] intValue] == 0) {
                
                textField.text = @"100";
            }
            
            if (textField.text.length == 4) {
                
                if ([[textField.text substringWithRange:NSMakeRange(0, 4)] intValue] >= 5000) {
                    
                    textField.text = [textField.text substringWithRange:NSMakeRange(0, 4)];
                    
                    textField.text = @"5000";
                    
                }
                
            }
            
            if (textField.text.length > 4) {
                
                textField.text = @"5000";
            }
        
        }
   
    }

}



//計算字元長度
-(void)checkTextViewTextLength {
    
    if (self.marcoFileName.text.length != 0) {
        
        NSString *infoStr = self.marcoFileName.text;
        
        NSUInteger charCount = 0;
        
        for(int i=0 ; i < self.marcoFileName.text.length ;i++){
            
            NSString *checkStr = [infoStr substringWithRange:NSMakeRange(i, 1)];
            
            NSUInteger bytes = [checkStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            
            if(bytes == 1) {
                //英文
                charCount += 1;
            }
            
            if(bytes == 3) {
                //中文
                charCount += 2;
            }
            
            if (charCount > 20) {
                self.marcoFileName.text = [self.marcoFileName.text substringWithRange:NSMakeRange(0, self.marcoFileName.text.length-1)];
            }
            
        }
        
    }
    
}


- (IBAction)saveChangeViewBtAction:(UIButton *)sender {
    
    [[ProtocolDataController sharedInstance] stopListeningResponse];
    
    if (sender == _saveChanges_cancelBt) {
        //取消
    
//        [macroResponseTimer invalidate];
        _saveChangeView.hidden = YES;
    }
    else if (sender == _saveChanges_noBt) {
        //不儲存 回主畫面
        
//        [macroResponseTimer invalidate];
        
        _saveChangeView.hidden = YES;
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else if (sender == _saveChanges_saveBt) {
        //儲存 並回主畫面
        //轉圈圈畫面
        
        [self saveChangeDataOrNot:YES];
    
    }
    
    
}




#pragma mark - 是否儲存已變更資料
-(void)saveChangeDataOrNot:(BOOL)save {
    
    if (save == YES) {
        
        //先檢查熱鍵是否有設置
        BOOL isHotKeySetting = [self checkHotkeyValueAction];
        
        if (isHotKeySetting == NO) {
            
            [self resetMacroHotkeyStatus:currentMarcoObj.marcoHotKey Type:2];
            
            return;
        }
        
        //顯示等待畫面
        updateView = [[ConnectLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [updateView setStatusLabel:NSLocalizedString(@"Saving...", nil)];//儲存中...
        [self.view addSubview:updateView];
        
        //儲存(硬體資料更新)
        //marcoFileName
        if([currentMarcoObj.marcoFileName isEqualToString:@""]) {
            
            currentMarcoObj.marcoFileName = @"MacroFileName";
        }
        
        currentMarcoObj.marcoFileName = [NSString stringWithFormat:@"%@",self.marcoFileName.text];
        
        [marcoData setMacroName: currentMarcoObj.marcoFileName];
        
        //hotkey
        int hotkeyInt = [currentMarcoObj.marcoHotKey intValue];
        [marcoData setHotkey:hotkeyInt];
        
        //platform
        int marcoPlatformInt = [currentMarcoObj.marcoPlatformImgStr intValue];
        [marcoData setPlatform:marcoPlatformInt];

        //keyAry
        for (int i = 0; i < ary_settingView.count; i++) {
            
            currentMarcoObj.marco_ary_key[i] = [NSNumber numberWithInt:ary_settingView[i].settingView_keycode];
        }
        
        [marcoData setKeyArr:currentMarcoObj.marco_ary_key];
        NSLog(@"keyAry:%@",currentMarcoObj.marco_ary_key);
        
        
        //delayTime
        
        [marcoData setDelayArr:currentMarcoObj.marco_ary_delayTime];
        NSLog(@"delayTime:%@",currentMarcoObj.marco_ary_delayTime);
        
        
        if (self.superVC.isMarcoEdit == YES) {
            //編輯
            //本機資料更新
            
            NSNumber *indexNum =[NSNumber numberWithUnsignedInteger:self.indexPathRow];
            
            int indexInt = [indexNum intValue];
            
            [[ProtocolDataController sharedInstance] saveMacro:indexInt :marcoData];
            
        }
        else {
            
            //新增一筆
            NSNumber *createIndex = [NSNumber numberWithUnsignedInteger:[[[ConfigMacroData sharedInstance] getMacroArray] count]];
            
            int newInt = [createIndex intValue];
            
            [[ProtocolDataController sharedInstance] saveMacro:newInt :marcoData];
        }
        
    }

}


#pragma  mark - protocol  onResponseSaveMacro
-(void)onResponseSaveMacro:(bool)isSuccess {
    
    if (isSuccess) {
        
        //儲存至硬體成功後,再傳給本機暫存檔
        NSMutableArray *macroAry = [[ConfigMacroData sharedInstance] getMacroArray];
        
        NSMutableDictionary *macroDict;
        
        if (macroAry.count != 0 && self.superVC.isMarcoEdit == YES) {
        
            //編輯
            macroDict = [macroAry objectAtIndex:self.indexPathRow];
        }
        else{
            
            //新增一筆
            macroDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                         currentMarcoObj.marcoFileName,@"macroName",
                         currentMarcoObj.marcoPlatformImgStr,@"macroPlatform",
                         currentMarcoObj.marcoHotKey,@"macroHotkey",
                         currentMarcoObj.marco_ary_key,@"macroKeyArr",
                         currentMarcoObj.marco_ary_delayTime,@"macroDelayArr",
                          nil];
        
        }
        
        //macro fileName
        [macroDict setObject:currentMarcoObj.marcoFileName forKey:@"macroName"];
        
        //macro hotkey
        NSLog(@"hotkey:%@",currentMarcoObj.marcoHotKey);
        [macroDict setObject:currentMarcoObj.marcoHotKey forKey:@"macroHotkey"];
        
        //macro platform
        NSLog(@"macroPlatform:%@",currentMarcoObj.marcoPlatformImgStr);
        [macroDict setObject:currentMarcoObj.marcoPlatformImgStr forKey:@"macroPlatform"];
        
        if (currentMarcoObj.marco_ary_key) {
            
            //key_ary
            [macroDict setObject:currentMarcoObj.marco_ary_key forKey:@"macroKeyArr"];
        }
        NSLog(@"marco_ary_key:%@",currentMarcoObj.marco_ary_key);
        
        
        if (currentMarcoObj.marco_ary_delayTime) {
            
            //delayTime_ary
            [macroDict setObject:currentMarcoObj.marco_ary_delayTime forKey:@"macroDelayArr"];
        }
         NSLog(@"marco_ary_delayTime:%@",currentMarcoObj.marco_ary_delayTime);
        
        
        if (self.superVC.isMarcoEdit == NO) {
            //新增
            [macroAry addObject:macroDict];
            [[ConfigMacroData sharedInstance] setMacroArray:macroAry];
        }
        else {
            //編輯
            [macroAry replaceObjectAtIndex:self.indexPathRow withObject:macroDict];
            [[ConfigMacroData sharedInstance] setMacroArray:macroAry];
            
        }
        
        
        //saveing 畫面移除
        [updateView removeFromSuperview];
        updateView = nil;
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else {
        
        [[ProtocolDataController sharedInstance] saveMacro:(int)self.indexPathRow :marcoData];
        
    }
    
}


#pragma mark - touchEvent 
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //marco fileName
    if ([self.marcoFileName.text isEqualToString:@""]) {
        
        self.marcoFileName.text = currentMarcoObj.marcoFileName;
    }
    
    [self.marcoFileName resignFirstResponder];

    
    //setting_delayTime textField
    [ self.setting_delayTime.delay_textField resignFirstResponder];

    [self settingWindowBackToOrigin];
    
}

-(void)settingWindowBackToOrigin {
    
    NSLog(@"回原位");
    self.settingWindow.frame = CGRectMake(0,0,self.settingWindow.frame.size.width, self.settingWindow.frame.size.height);
}


#pragma mark - 分辨 keyboard - mouseLeft - mouseRight (up or down)
-(int)returnKeyCodeImgType:(int)keyCode {
    
    int KeyCodeImgType;
    
    if (keyCode > KEYCODE_TOTALCOUNT) {
        
        if (keyCode == 233) {
            //mouseLeft up
            KeyCodeImgType = 5;
        }
        else if (keyCode == 234) {
            //mouseRight up
            KeyCodeImgType = 7;
        }
        else {
            //keyboard up
            KeyCodeImgType = 3;
        }
    
    }
    else if (keyCode > 0 && keyCode <= KEYCODE_TOTALCOUNT) {
        
        if (keyCode == 105) {
            //mouse Left down
            KeyCodeImgType = 4;
        }
        else if (keyCode == 106) {
            //mouse Right down
            KeyCodeImgType = 6;
        }
        else {
            //keyboard down
            KeyCodeImgType = 2;
        }
        
    }
    else {
        
        KeyCodeImgType = 0;
    }
    
    return KeyCodeImgType;
}


#pragma mark - settingView 觸發方法
- (IBAction)hotkeySettingAction:(UIButton *)sender {
    
//    [macroResponseTimer invalidate];
    
    //先顯示Listening
    //self.hotketSettingLabel.text = NSLocalizedString(@"Listening", nil);

    [self.macroHotkeyView.keyBt setTitle:NSLocalizedString(@"Listening", nil) forState:UIControlStateNormal];
    
    
    _isMacroHotkeyCallKeyCodeResponse = YES;
    _isSettingViewCallKeyCodeResponse = NO;
    
    [[ProtocolDataController sharedInstance] startListeningResponse];
//    macroResponseTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startResponseMode) userInfo:nil repeats:YES];
    
}


//keyboard 觸發事件
-(void)startResponseMode{
    
    [[ProtocolDataController sharedInstance] responseMode];
}

-(void)onResponseResponseMode:(int)keyCode{
    
    NSLog(@" MARCO keyCode(代碼) = %d",keyCode);
    
    if (keyCode == -1 || keyCode == 255 || keyCode == 0) {
        return;
    }
    
    [[ProtocolDataController sharedInstance] stopListeningResponse];
    
    if (_isMacroHotkeyCallKeyCodeResponse == YES) {
        
        NSMutableArray *configArray = [[ConfigMacroData sharedInstance] getConfigArray];
        NSString *keyCodeStr = [keyCodeClass returnKeyboardKey:keyCode];
        NSString *macroHotKeyStr = [keyCodeClass returnKeyboardKey:[currentMarcoObj.marcoHotKey intValue]];
        
        
        //keycode 在 F1 ~ F10 範圍內
        if (![self checkHotKeyRangeF1F10:keyCode]) {
            
            [self resetMacroHotkeyStatus:macroHotKeyStr Type:0];

            return;
        }
        
        
        //不可以與Config---Breath & Anti Recoil & keyboard重覆
        for (int i = 0; i < configArray.count; i++) {
            
            NSDictionary *configDic = configArray[i];
            
            NSString *breathStr = [configDic objectForKey:@"sniperBreathHotKey"];
            NSString *antiRecoilStr = [configDic objectForKey:@"antiRecoilHotkey"];
            NSMutableArray *ary_keyMap = [configDic objectForKey:@"keyMapArray"];
            
            if (keyCode == [breathStr intValue] || keyCode == [antiRecoilStr intValue]) {
                
                [self resetMacroHotkeyStatus:macroHotKeyStr Type:1];
                
                isCreateAndHadInit = YES;
                
                break;
            }
            
            //不可以與 Config keyboard 重覆
            for (int j = 0; j < ary_keyMap.count; j++) {
                
                if (keyCode == [ary_keyMap[j] intValue]) {
                    
                    isCreateAndHadInit = YES;
                    
                    [self resetMacroHotkeyStatus:macroHotKeyStr Type:1];
                    
                    return;
                }
                
            }
            
        }
        
        
        NSMutableArray *macroAry = [[ConfigMacroData sharedInstance] getMacroArray];
        if (self.superVC.isMarcoEdit == NO) {
            self.indexPathRow = macroAry.count;
        }
        
        // 判斷 hotkey 是否重覆
        
        for (int i = 0; i < macroAry.count; i++) {
            
            NSMutableDictionary *macroDic = macroAry[i];
            
            NSString *hotkeyStr = (NSString *)[macroDic objectForKey:@"macroHotkey"];
            int hotkeyNum = [hotkeyStr intValue];
            
            if (keyCode == hotkeyNum) {
                
                if (i == self.indexPathRow) {
                    continue;
                }else{
                    [self resetMacroHotkeyStatus:macroHotKeyStr Type:1];
                    
                    return;
                }
            }
        }
        
        
        //hotkey 儲存 keycode
        currentMarcoObj.marcoHotKey = [[NSString alloc] initWithFormat:@"%i", keyCode];
        
        //self.hotketSettingLabel.text = keyCodeStr;
        [self.macroHotkeyView.keyBt setTitle:keyCodeStr forState:UIControlStateNormal];
        
        [self.macroHotkeyView changeKeyColor:keyCode];
        
        if (keyCode == 0) {
            
            [self.macroHotkeyView.keyBt setBackgroundImage:[UIImage imageNamed:@"config_icon_a_kb_2"] forState:UIControlStateNormal];
            
            [self.macroHotkeyView.keyBt setTitleColor:[UIColor colorWithRed:0.0 green:0.72 blue:0.95 alpha:1.0] forState:UIControlStateNormal];
            
            self.macroHotkeyView.keyImgView.image = [UIImage imageNamed:@"config_icon_a_kb_1"];
            
        }
        
        
        
    }else if (_isSettingViewCallKeyCodeResponse == YES) {
        
        /*
         key_type = 0: keyboard
         key_type = 1: 滑鼠左鍵
         key_type = 2: 滑鼠右鍵
         */
        
        int  settingViewNum = 0;
        
        for (int i = 0; i < ary_settingView.count; i++) {
            
            if (ary_settingView[i].isSelected == YES) {
                
                settingViewNum = i;
                
                NSLog(@"%d",settingViewNum);
            }
        }
        
        
        if (keyCode == 105) {
            //mouse left
            
            ary_settingView[settingViewNum].key_type = 1;
            
            public_keycode = keyCode;
        }
        else if (keyCode == 106) {
            //mouse right
            
            ary_settingView[settingViewNum].key_type = 2;
            
            public_keycode = keyCode;
        }
        else {
            //keyboard
            
            ary_settingView[settingViewNum].key_type = 0;
            
            public_keycode = keyCode;
            
            NSString *keyStr = [keyCodeClass returnKeyboardKey:keyCode];
            
            [self.settingView_keyboard_key_0 setTitle:keyStr forState:UIControlStateNormal];
            
            [self settingView_keyboard_keyBtnCustom:self.settingView_keyboard_key_0];
            
            [self.settingView_keyboard_key_1 setTitle:keyStr forState:UIControlStateNormal];
            
            [self settingView_keyboard_keyBtnCustom:self.settingView_keyboard_key_1];
            
            [self.settingView_keyboard_key_2 setTitle:keyStr forState:UIControlStateNormal];
            
            [self settingView_keyboard_keyBtnCustom:self.settingView_keyboard_key_2];
            
            [self.settingView_keyboard_key_3 setTitle:keyStr forState:UIControlStateNormal];
            
            [self settingView_keyboard_keyBtnCustom:self.settingView_keyboard_key_3];
        }
        
        [self showKeyType:ary_settingView[settingViewNum].key_type];
        
        self.hotKey_saveBt.hidden = NO;
        
    }

    
    _isMacroHotkeyCallKeyCodeResponse = NO;
    _isSettingViewCallKeyCodeResponse = NO;
    
}

-(void)settingView_keyboard_keyBtnCustom:(UIButton *)bt {
    
    bt.titleLabel.font = [UIFont systemFontOfSize:8.0];
    bt.titleLabel.textAlignment = NSTextAlignmentCenter;
    bt.titleLabel.numberOfLines = 0;
    
}

- (void) onResponseDeviceStatus:(DeviceStatus*) ds{
    
}

-(void) onResponseMoveConfig:(bool)isSuccess{
    
}

-(void) onResponseMoveMacro:(bool)isSuccess{
    
}


#pragma mark - Protocal Delegate
-(void)onBtStateChanged:(bool)isEnable{
    
}


-(void)onConnectionState:(ConnectState)state{
    
    //ScanFinish,掃描結束
    //Connected,連線成功
    //Disconnected,斷線
    //ConnectTimeout連線超時
    
    [[ConfigMacroData sharedInstance] changeBLEConnectedState:state];
    
    switch (state) {
        case Disconnect: {
            
            NSLog(@"啊~斷線");
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


-(void)changeLanguesImediately {
    
    if (self.superVC.isMarcoEdit == YES) {
        
        self.createNewLabel.text = NSLocalizedString(@"Edit  Macro", nil);//編輯 巨集
    }
    else {
        
        self.createNewLabel.text = NSLocalizedString(@"Create  Macro", nil);//新增 巨集
        
    }
    
    
    [self.hotKey_saveBt setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal]; //儲存
    
    [self.timeSaveBt setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];//儲存
    
    [self.delay_continueBt setTitle:NSLocalizedString(@" Follow ", nil) forState:UIControlStateNormal];//接續
    
    [self.delay_syncBt setTitle:NSLocalizedString(@" Sync ", nil) forState:UIControlStateNormal];//同步
    
    self.delayLabel.text = NSLocalizedString(@" Delay ", nil);//接續且延遲
    
    self.msecLabel.text = NSLocalizedString(@"ms", nil);//毫秒
    
    
    [self.main_save setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];//儲存
    
    [self.main_cancel setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];//取消
    
    [self.saveChanges_saveBt setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];//儲存
    
    [self.saveChanges_noBt setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];//取消
    
    self.saveChangesLabel.text = NSLocalizedString(@"Save Changes?", nil);//儲存變更 ?
    
}


@end
