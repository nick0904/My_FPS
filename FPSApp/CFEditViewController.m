

#import "CFEditViewController.h"
#import "BallisticCurveView.h"
#import "FingerView.h"
#import "WaringViewController.h"
#import "LandingViewController.h"
#import "KeyCodeView.h"
//#import "NonRotatingUIImagePickerController.h"

@interface CFEditViewController () <UITextFieldDelegate> {
    
    //指紋
    CGPoint minPoint; //移動之最小點
    CGPoint maxPoint; //移動之最大點
    CGFloat moveDistance;//每次移動距離
    CGFloat fp_centerY; //固定 Y 軸
    CGFloat singleValue;//每一種顏色的間距
    BOOL isColorBarAction; //判斷 colorBar 是否已被觸發
    
    NSMutableArray *fp_animation_pics; //存放指紋動畫圖片的陣列
    NSMutableArray *fp_outline_pics; //存放指紋動畫外筐的陣列
    NSMutableArray *changeColorBt_pics; //存放colorBarBt圖片的陣列
    
    UIImageView *finger;
    
    
    //UILongPressGestureRecognizer *lp_fingerPrint; //長按指紋觸發
    UIPanGestureRecognizer *pan_gesture;
    
    
    CGPoint minimumP;
    CGPoint maximumP;
    CGFloat pinY;
    
    //儲存 mouse & keyboard & preference 是否被選擇
    NSMutableArray *ary_isSelected;
    int tempValue;
    NSMutableArray <UIButton *> *ary_showFingerBt;
    
    //rightView的原始位置
    CGPoint rightViewPoint;
    
    
    //遙感按鈕陣列
    NSMutableArray<UIButton *> *ary_keymap;
    NSMutableArray *ary_keymapIsSelected;
    NSMutableArray <KeyCodeView *> *ary_keymapView;
    KeyCodeFile *keyCodeClass;
    
    //PS3 遙桿畫面原設定鍵位置
    CGPoint ori_NoneBt_center;
    CGPoint ori_EscBt_center;
    CGPoint ori_Enter_center;
    CGPoint ori_QBt_center;
    CGPoint ori_GBt_center;
    CGPoint ori_RightBt_center;
    CGPoint ori_LeftBt_center;
    CGPoint ori_TabBt_center;
    CGPoint ori_ArrowBt_center;
    CGPoint ori_WASDBt_center;
    
    
    //判斷 Mouse or Perference cell 是否打開
    BOOL isCellOpen;
    
    
    //盲區
    int xPointValue;    //X值
    float yPointValue;  //Y值
    BallisticCurveView *curveView;
    
    //ads Toggle
    BOOL isADSToggle;
    
    //Sync
    BOOL isSync;
    
    //shootingSpeed
    BOOL isShootingSpeed;
    
    //inverted
    BOOL isInverted;
    
    //sniperBreath
    BOOL isSniperBreath;
    
    //antiRecoil
    BOOL isAntiRecoil;
    
    // YES:edit 頁面 , NO:keyboard 頁面
    BOOL isEditOrKeyboard;
    
    
    //處理目前所想編輯的 config 資料
    CFTableViewCellObject *currentConfigData;
    
    //CFMainViewController
    CFMainViewController *cfMainVC;
    
    
    //硬體
    FPSConfigData *configData;
    //    NSTimer *responseTimer;
    
    
    //顯示等待畫面
    ConnectLoadingView *updateView;
    
    
    //判斷是哪個 hotkey 呼叫 onResponseResponseMode
    BOOL isConfigHotKeyCallResponseMode;
    BOOL isKeyboardCallResponseMode;
    BOOL isSniperBreathCallResponseMode;
    BOOL isAntiRecoilCallResponseMode;
    
    LandingViewController *landingVC;
    
    UIImage *tempImg;
    
    
    //(本機圖片)
    //    NSMutableArray *configImgAry;
    
    
    
    //RightView 原本位置
    CGPoint rightViewOriLoaction;
    
    //LeftView 原本位置
    CGPoint leftViewOriLocation;
    
    
    //辦認指紋滑動圖是否展開
    BOOL isFingerCase0open;
    BOOL isFingerCase1open;
    BOOL isfingerCase2open;
    BOOL isFingerCase3open;
    BOOL isFingerCase4open;
    
    
    //判斷是否點擊兩次
    BOOL isTapTwice;
}



@property (strong, nonatomic) IBOutlet UIImageView *firstColorSign;

@property (strong, nonatomic) IBOutlet UIImageView *colorSign;

@property (strong, nonatomic) IBOutlet UIImageView *fingerPrint;

@property (strong, nonatomic) IBOutlet UIImageView *colorBar_bgView;

@property (strong, nonatomic) IBOutlet UIView *colorBar;//(LED_Color)

@property (strong, nonatomic) IBOutlet UIButton *changeColorBt;

@property (strong, nonatomic) IBOutlet UITextField *configFileName;

@property (strong, nonatomic) IBOutlet UIButton *configHotkey;




//儲存取消 View

@property (strong, nonatomic) IBOutlet UIView *saveCancelView;

@property (strong, nonatomic) IBOutlet UIButton *saveBt;

@property (strong, nonatomic) IBOutlet UIButton *cancelBt;



@property (strong, nonatomic) IBOutlet UIView *leftView;

@property (strong, nonatomic) IBOutlet UIView *rightView;

@property (strong, nonatomic) IBOutlet UIView *remoteControl;

@property (strong, nonatomic) IBOutlet UIImageView *gameIconView;

@property (strong, nonatomic) IBOutlet UIImageView *machineIconView;

@property (strong, nonatomic) IBOutlet UILabel *machine_label;

@property (strong, nonatomic) IBOutlet UIImageView *machine_bgView;


/*  scrollView 相關: Mouse,Keyboard, Perference  */
@property (strong, nonatomic) IBOutlet UIScrollView *setting_scrollView;

//========= mouse =========
@property (strong, nonatomic) IBOutlet UIView *mouseView;

@property (strong, nonatomic) IBOutlet UIView *mouse_0_0_view;

@property (strong, nonatomic) IBOutlet UIView *mouse_0_1_view;

@property (strong, nonatomic) IBOutlet UIView *mouse_0_2_view;

@property (strong, nonatomic) IBOutlet UIView *mouse_0_3_view;

@property (strong, nonatomic) IBOutlet UIView *mouse_0_4_view;


@property (strong, nonatomic) IBOutlet UIButton *syncBt;

@property (strong, nonatomic) IBOutlet UILabel *syncLabel;


@property (strong, nonatomic) IBOutlet UIButton *adsToggleBt;

@property (strong, nonatomic) IBOutlet UILabel *adsToggleLabel;


//========== keyboard ==========
@property (strong, nonatomic) IBOutlet UIView *keyboardView;


//========= perference =========
@property (strong, nonatomic) IBOutlet UIView *preferenceView;

@property (strong, nonatomic) IBOutlet UIView *preference_0_0_view;

@property (strong, nonatomic) IBOutlet UILabel *preference_0_1_view;

@property (strong, nonatomic) IBOutlet UIView *preference_0_2_view;

@property (strong, nonatomic) IBOutlet UIView *preference_0_3_view;

@property (strong, nonatomic) IBOutlet FingerView *mouseFingerView;


@property (strong, nonatomic) IBOutlet UIButton *shootingSpeedBt;


@property (strong, nonatomic) IBOutlet UIButton *invertedBt;


@property (strong, nonatomic) IBOutlet UIButton *sniperBreathBt;

@property (strong, nonatomic) IBOutlet UIButton *antiRecoilBt;

@property (strong, nonatomic) IBOutlet UIButton *sniperBreathHotkey;

@property (strong, nonatomic) IBOutlet UIImageView *sniperBreathHotKeyImgView;

@property (strong, nonatomic) IBOutlet KeyCodeView *sniperBreathHotkeyView;


@property (strong, nonatomic) IBOutlet UIButton *antiRecoilHotkey;

@property (strong, nonatomic) IBOutlet UIImageView *antiRecoilHotkeyImgView;

@property (strong, nonatomic) IBOutlet KeyCodeView *antiRecoilHotkeyView;




//TextField 手動調整值
@property (strong, nonatomic) IBOutlet UITextField *textField_0;//HIP

@property (strong, nonatomic) IBOutlet UITextField *textField_1;//ADS

@property (strong, nonatomic) IBOutlet UITextField *textField_2;//DeadZone

@property (strong, nonatomic) IBOutlet UITextField *textField_3;//Shooting speed

@property (strong, nonatomic) IBOutlet UITextField *textField_4;//Anti Recoil offset


//顯示指紋調整的按鍵
@property (strong, nonatomic) IBOutlet UIButton *showFingerBt_0;//HIP

@property (strong, nonatomic) IBOutlet UIButton *showFingerBt_1;//ADS

@property (strong, nonatomic) IBOutlet UIButton *showFingerBt_2;//DeadZone

@property (strong, nonatomic) IBOutlet UIButton *showFingerBt_3;//shooting speed

@property (strong, nonatomic) IBOutlet UIButton *showFingerBt_4;//Anti Recoil offset

//指紋移動
@property (strong, nonatomic) IBOutlet UIView *fingerView;

@property (strong, nonatomic) IBOutlet UIImageView *fingerAnimationView;

@property (strong, nonatomic) IBOutlet UIImageView *fingerRuler;


/* 遙桿上的控制扭 */
@property (strong, nonatomic) IBOutlet UIButton *keymap_0;

@property (strong, nonatomic) IBOutlet UIButton *keymap_1;

@property (strong, nonatomic) IBOutlet UIButton *keymap_2;

@property (strong, nonatomic) IBOutlet UIButton *keymap_3;

@property (strong, nonatomic) IBOutlet UIButton *keymap_4;

@property (strong, nonatomic) IBOutlet UIButton *keymap_5;

@property (strong, nonatomic) IBOutlet UIButton *keymap_6;

@property (strong, nonatomic) IBOutlet UIButton *keymap_7;

@property (strong, nonatomic) IBOutlet UIButton *keymap_8;

@property (strong, nonatomic) IBOutlet UIButton *keymap_9;

@property (strong, nonatomic) IBOutlet UIButton *keymap_10;

@property (strong, nonatomic) IBOutlet UIButton *keymap_11;

@property (strong, nonatomic) IBOutlet UIButton *keymap_12;

@property (strong, nonatomic) IBOutlet UIButton *keymap_13;

@property (strong, nonatomic) IBOutlet UIButton *keymap_14;

@property (strong, nonatomic) IBOutlet UIButton *keymap_15;

@property (strong, nonatomic) IBOutlet UIButton *keymap_16;

@property (strong, nonatomic) IBOutlet UIButton *keymap_17;

@property (strong, nonatomic) IBOutlet UIButton *keymap_18;

@property (strong, nonatomic) IBOutlet UIButton *keymap_19;

@property (strong, nonatomic) IBOutlet UIButton *keymap_20;

@property (strong, nonatomic) IBOutlet UIButton *keymap_21;

@property (strong, nonatomic) IBOutlet UIImageView *arrowUp;

@property (strong, nonatomic) IBOutlet UIImageView *arrowLeft;

@property (strong, nonatomic) IBOutlet UIImageView *arrowRight;

@property (strong, nonatomic) IBOutlet UIImageView *arrowDown;

/* 遙桿上的控制扭圖片 */
@property (strong, nonatomic) IBOutlet UIImageView *noneImgView;

@property (strong, nonatomic) IBOutlet UIImageView *enterImgView;

@property (strong, nonatomic) IBOutlet UIImageView *QImgView;


//tabImgView
//escImgView
@property (strong, nonatomic) IBOutlet UIImageView *escImgView;

@property (strong, nonatomic) IBOutlet UIImageView *tabImgView;

@property (strong, nonatomic) IBOutlet UIImageView *GImgView;

@property (strong, nonatomic) IBOutlet UIImageView *mouseRImgView;

@property (strong, nonatomic) IBOutlet UIImageView *mouseLImgView;

@property (strong, nonatomic) IBOutlet UIImageView *changeWeponImgView;

@property (strong, nonatomic) IBOutlet UIImageView *reloadImgView;

@property (strong, nonatomic) IBOutlet UIImageView *crouchImgView;

@property (strong, nonatomic) IBOutlet UIImageView *jumpImgView;

@property (strong, nonatomic) IBOutlet UIImageView *meleeImgView;

@property (strong, nonatomic) IBOutlet UIImageView *inventoryUpImgView;

@property (strong, nonatomic) IBOutlet UIImageView *inventoryLeftImgView;

@property (strong, nonatomic) IBOutlet UIImageView *inventoryRightImgView;

@property (strong, nonatomic) IBOutlet UIImageView *inventoryDownImgView;

@property (strong, nonatomic) IBOutlet UIImageView *sprintImgView;

@property (strong, nonatomic) IBOutlet UIImageView *arrowUpImgView;

@property (strong, nonatomic) IBOutlet UIImageView *arrowLeftImgView;

@property (strong, nonatomic) IBOutlet UIImageView *arrowRightImgView;

@property (strong, nonatomic) IBOutlet UIImageView *arrowDownImgView;



/* 依據不同遙桿畫面會變更位置的設定鍵 */
@property (strong, nonatomic) IBOutlet KeyCodeView *NoneBt_View;

@property (strong, nonatomic) IBOutlet KeyCodeView *EnterBt_view;

@property (strong, nonatomic) IBOutlet KeyCodeView *Qbt_view;


//EscBt_view
//TabBt_view
@property (strong, nonatomic) IBOutlet KeyCodeView *EscBt_view;

@property (strong, nonatomic) IBOutlet KeyCodeView *TabBt_view;

@property (strong, nonatomic) IBOutlet KeyCodeView *GBt_view;

@property (strong, nonatomic) IBOutlet KeyCodeView *changeWeaponView;

@property (strong, nonatomic) IBOutlet KeyCodeView *reloadView;

@property (strong, nonatomic) IBOutlet KeyCodeView *crouchView;

@property (strong, nonatomic) IBOutlet KeyCodeView *jumpView;

@property (strong, nonatomic) IBOutlet KeyCodeView *meleeView;

@property (strong, nonatomic) IBOutlet KeyCodeView *inventoryUpView;

@property (strong, nonatomic) IBOutlet KeyCodeView *inventoryLeftView;

@property (strong, nonatomic) IBOutlet KeyCodeView *inventoryRightView;

@property (strong, nonatomic) IBOutlet KeyCodeView *inventoryDownView;

@property (strong, nonatomic) IBOutlet KeyCodeView *sprintView;

@property (strong, nonatomic) IBOutlet KeyCodeView *arrowUpView;

@property (strong, nonatomic) IBOutlet KeyCodeView *arrowLeftView;

@property (strong, nonatomic) IBOutlet KeyCodeView *arrowRightView;

@property (strong, nonatomic) IBOutlet KeyCodeView *arrowDownView;

@property (strong, nonatomic) IBOutlet KeyCodeView *RightBt_view;

@property (strong, nonatomic) IBOutlet KeyCodeView *LeftBt_view;


@property (strong, nonatomic) IBOutlet UIView *ArrowBt_view;

@property (strong, nonatomic) IBOutlet UIView *WASDBt_view;

//盲區相關
@property (weak, nonatomic) IBOutlet UIImageView *ballisticsView;

@property (weak, nonatomic) IBOutlet UITextField *yValueLabel;

@property (weak, nonatomic) IBOutlet UITextField *xValueLabel;

@property (strong, nonatomic) IBOutlet UIView *resetWindow;



//******  saveChanges  ******
@property (strong, nonatomic) IBOutlet UIView *saveChangesView;

@property (strong, nonatomic) IBOutlet UIButton *saveChanges_saveBt;

@property (strong, nonatomic) IBOutlet UIButton *saveChanges_noBt;

@property (strong, nonatomic) IBOutlet UIButton *saveChanges_cancelBt;



@property (strong, nonatomic) IBOutlet UILabel *editConfigLabel;

@property (strong, nonatomic) IBOutlet UILabel *mouseLabel;

@property (strong, nonatomic) IBOutlet UILabel *keyboardLabel;

@property (strong, nonatomic) IBOutlet UILabel *preferenceLabel;

@property (strong, nonatomic) IBOutlet UILabel *sensitivityLabel;

@property (strong, nonatomic) IBOutlet UILabel *HipLabel;

@property (strong, nonatomic) IBOutlet UILabel *AdsLabel;

@property (strong, nonatomic) IBOutlet UILabel *ballisticLabel;

@property (strong, nonatomic) IBOutlet UILabel *deadZoneLabel;

@property (strong, nonatomic) IBOutlet UILabel *shootingSpeedLabel;

@property (strong, nonatomic) IBOutlet UILabel *invertedYLabel;

@property (strong, nonatomic) IBOutlet UILabel *sniperBreathLabel;

@property (strong, nonatomic) IBOutlet UILabel *antiRecoilLabel;

@property (strong, nonatomic) IBOutlet UILabel *saveChangesLabel;






@end

@implementation CFEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //configFileName
    self.configFileName.keyboardType = UIKeyboardTypeDefault;
    
    self.configFileName.delegate = self;
    
    [self.configFileName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _textField_0.delegate = self;
    
    _textField_1.delegate = self;
    
    _textField_2.delegate = self;
    
    _textField_3.delegate = self;
    
    _textField_4.delegate = self;
    
    [_textField_0 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_textField_1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_textField_2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_textField_3 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_textField_4 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    //colorBarBt圖片陣列
    changeColorBt_pics = [NSMutableArray new];
    for (int btIndex = 1; btIndex <=10 ; btIndex++) {
        
        [changeColorBt_pics addObject:[NSString stringWithFormat:@"config_color_a_%d",btIndex]];
    }
    
    //外筐圖片陣列
    fp_outline_pics = [NSMutableArray new];
    for (int outlineIndex = 1; outlineIndex <= 10; outlineIndex++) {
        
        [fp_outline_pics addObject:[NSString stringWithFormat:@"config_ani_a_fingerprint_outline_%d",outlineIndex]];
    }
    
    //動畫圖片陣列
    fp_animation_pics = [NSMutableArray new];
    for (int picIndex = 1; picIndex <= 21; picIndex++) {
        
        [fp_animation_pics addObject:[UIImage imageNamed:[NSString stringWithFormat:@"config_ani_a_fingerprint_%d",picIndex]]];
    }
    
    finger = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _fingerPrint.frame.size.width, _fingerPrint.frame.size.height)];
    finger.center = _fingerPrint.center;
    finger.animationImages = fp_animation_pics;
    [_leftView addSubview:finger];
    
    //預設顏色
    _fingerPrint.image = [UIImage imageNamed:@"config_ani_a_fingerprint_outline_1"];
    
    _fingerPrint.alpha = 0.0;
    _colorBar.alpha = 0.0;
    _colorBar_bgView.alpha = 0.0;
    
    //每次移動距離
    moveDistance = _colorSign.frame.size.width/2;
    
    //固定 Y 軸
    fp_centerY = _fingerPrint.center.y;
    
    //取得最大最小可移動點座標
    minPoint = CGPointMake(CGRectGetMinX(self.colorBar.frame) + moveDistance, fp_centerY);
    
    maxPoint = CGPointMake(CGRectGetMaxX(self.colorBar.frame) - moveDistance, fp_centerY);
    
    //每一種顏色的間距
    singleValue =_colorBar.frame.size.width/10;
    
    //ColorBar一開始設定未被觸發
    isColorBarAction = NO;
    
    //長按手勢
    pan_gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToMoveFinger:)];
    //lp_fingerPrint.minimumPressDuration = 0.05;
    finger.userInteractionEnabled = YES;
    [finger addGestureRecognizer:pan_gesture];
    
    
    
    //remoteContrl 搖桿畫面先隱藏
    _remoteControl.userInteractionEnabled = NO;
    _remoteControl.alpha =0.0;
    
    
    //遙感按鈕陣列
    //    ary_keymap = [NSMutableArray arrayWithObjects:_keymap_0,_keymap_1,_keymap_2,_keymap_3,_keymap_4,_keymap_5,_keymap_6,_keymap_7,_keymap_8,_keymap_9,_keymap_10,_keymap_11,_keymap_12,_keymap_13,_keymap_14,_keymap_15,_keymap_16,_keymap_17,_keymap_18,_keymap_19,_keymap_20,_keymap_21, nil];
    
    ary_keymap = [NSMutableArray arrayWithObjects:
                  _keymap_3,
                  _keymap_5,
                  _keymap_6,
                  _keymap_4,
                  _keymap_18,
                  _keymap_17,
                  _keymap_20,
                  _keymap_19,
                  _keymap_0,
                  _keymap_16,
                  _keymap_1,
                  _keymap_15,
                  _keymap_9,
                  _keymap_21,
                  _keymap_14,
                  _keymap_2,
                  _keymap_13,
                  _keymap_12,
                  _keymap_7,
                  _keymap_11,
                  _keymap_8,
                  _keymap_10,nil];
    
    ary_keymapIsSelected = [NSMutableArray new];
    for (int i = 0; i < ary_keymap.count; i++) {
        
        //0:未選, 1:被選
        NSString *selected = @"0";
        
        [ary_keymapIsSelected addObject:selected];
    }
    
    
    for (int i = 0; i < ary_keymap.count; i++) {
        
        ary_keymap[i].titleLabel.adjustsFontSizeToFitWidth = YES;
        
        //Fix
        [ary_keymap[i] addTarget:self action:@selector(keyMapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [ary_keymap[i] addTarget:self action:@selector(keyMapAction:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
        
    }
    
    
    //ary_keymapView
    ary_keymapView = [NSMutableArray arrayWithObjects:
                      self.arrowUpView,
                      self.arrowRightView,
                      self.arrowDownView ,
                      self.arrowLeftView,
                      self.reloadView,
                      self.changeWeaponView,
                      self.jumpView,
                      self.crouchView,
                      self.Qbt_view,
                      self.GBt_view,
                      self.RightBt_view,
                      self.LeftBt_view,
                      self.sprintView,
                      self.meleeView,
                      self.EnterBt_view,
                      self.NoneBt_View,
                      self.EscBt_view,
                      self.TabBt_view,
                      self.inventoryUpView  ,
                      self.inventoryDownView,
                      self.inventoryLeftView,
                      self.inventoryRightView,nil];
    
    //ary_keymapView - keyImgView
    ary_keymapView[0].keyImgView = self.arrowUpImgView;
    ary_keymapView[1].keyImgView = self.arrowRightImgView;
    ary_keymapView[2].keyImgView = self.arrowDownImgView;
    ary_keymapView[3].keyImgView = self.arrowLeftImgView;
    ary_keymapView[4].keyImgView = self.reloadImgView;
    ary_keymapView[5].keyImgView = self.changeWeponImgView;
    ary_keymapView[6].keyImgView = self.jumpImgView;
    ary_keymapView[7].keyImgView = self.crouchImgView;
    ary_keymapView[8].keyImgView = self.QImgView;
    ary_keymapView[9].keyImgView = self.GImgView;
    ary_keymapView[10].keyImgView = self.mouseRImgView;
    ary_keymapView[11].keyImgView = self.mouseLImgView;
    ary_keymapView[12].keyImgView = self.sprintImgView;
    ary_keymapView[13].keyImgView = self.meleeImgView;
    ary_keymapView[14].keyImgView = self.enterImgView;
    ary_keymapView[15].keyImgView = self.noneImgView;
    ary_keymapView[16].keyImgView = self.escImgView;
    ary_keymapView[17].keyImgView = self.tabImgView;
    ary_keymapView[18].keyImgView = self.inventoryUpImgView;
    ary_keymapView[19].keyImgView = self.inventoryDownImgView;
    ary_keymapView[20].keyImgView = self.inventoryLeftImgView;
    ary_keymapView[21].keyImgView = self.inventoryRightImgView;
    
    
    //ary_keymapView - keyBt
    ary_keymapView[0].keyBt = self.keymap_3;
    ary_keymapView[1].keyBt = self.keymap_5;
    ary_keymapView[2].keyBt = self.keymap_6;
    ary_keymapView[3].keyBt = self.keymap_4;
    ary_keymapView[4].keyBt = self.keymap_18;
    ary_keymapView[5].keyBt = self.keymap_17;
    ary_keymapView[6].keyBt = self.keymap_20;
    ary_keymapView[7].keyBt = self.keymap_19;
    ary_keymapView[8].keyBt = self.keymap_0;
    ary_keymapView[9].keyBt = self.keymap_16;
    ary_keymapView[10].keyBt = self.keymap_1;
    ary_keymapView[11].keyBt = self.keymap_15;
    ary_keymapView[12].keyBt = self.keymap_9;
    ary_keymapView[13].keyBt = self.keymap_21;
    ary_keymapView[14].keyBt = self.keymap_14;
    ary_keymapView[15].keyBt = self.keymap_2;
    ary_keymapView[16].keyBt = self.keymap_13;
    ary_keymapView[17].keyBt = self.keymap_12;
    ary_keymapView[18].keyBt = self.keymap_7;
    ary_keymapView[19].keyBt = self.keymap_11;
    ary_keymapView[20].keyBt = self.keymap_8;
    ary_keymapView[21].keyBt = self.keymap_10;
    
    
    //ary_keymapView - keyType
    ary_keymapView[0].keyType = 1;
    ary_keymapView[1].keyType = 1;
    ary_keymapView[2].keyType = 1;
    ary_keymapView[3].keyType = 1;
    ary_keymapView[4].keyType = 1;
    ary_keymapView[5].keyType = 1;
    ary_keymapView[6].keyType = 1;
    ary_keymapView[7].keyType = 1;
    ary_keymapView[8].keyType = 0;
    ary_keymapView[9].keyType = 0;
    ary_keymapView[10].keyType = 2;
    ary_keymapView[11].keyType = 2;
    ary_keymapView[12].keyType = 0;
    ary_keymapView[13].keyType = 0;
    ary_keymapView[14].keyType = 0;
    ary_keymapView[15].keyType = 3;
    ary_keymapView[16].keyType = 0;
    ary_keymapView[17].keyType = 0;
    ary_keymapView[18].keyType = 1;
    ary_keymapView[19].keyType = 1;
    ary_keymapView[20].keyType = 1;
    ary_keymapView[21].keyType = 1;
    
    
    
    //keycodeFile 初始化
    keyCodeClass = [[KeyCodeFile alloc] init];
    
    //先取得 PS3 遙桿設定鍵的位置
    ori_NoneBt_center = CGPointMake(_NoneBt_View.center.x, _NoneBt_View.center.y);
    ori_EscBt_center = CGPointMake(_EscBt_view.center.x, _EscBt_view.center.y);
    ori_Enter_center = CGPointMake(_EnterBt_view.center.x, _EnterBt_view.center.y);
    ori_QBt_center = CGPointMake(_Qbt_view.center.x, _Qbt_view.center.y);
    ori_GBt_center = CGPointMake(_GBt_view.center.x, _GBt_view.center.y);
    ori_RightBt_center = CGPointMake(_RightBt_view.center.x, _RightBt_view.center.y);
    ori_LeftBt_center = CGPointMake(_LeftBt_view.center.x, _LeftBt_view.center.y);
    ori_TabBt_center = CGPointMake(_TabBt_view.center.x, _TabBt_view.center.y);
    ori_ArrowBt_center = CGPointMake(_ArrowBt_view.center.x, _ArrowBt_view.center.y);
    ori_WASDBt_center = CGPointMake(_WASDBt_view.center.x, _WASDBt_view.center.y);
    
    
    //rightViewPoint
    rightViewPoint = _rightView.frame.origin;
    
    //
    _machine_label.adjustsFontSizeToFitWidth = YES;
    
    //一開始未點擊cell
    isCellOpen = NO;
    
    
    
    //將 mouse & keyboard & preference 加到 scrollview
    //mouse
    _mouseView.frame = CGRectMake(0, 0, _mouseView.frame.size.width, _mouseView.frame.size.height);
    
    [_setting_scrollView addSubview:_mouseView];
    
    //keyboard
    _keyboardView.frame = CGRectMake(0, CGRectGetMaxY(_mouseView.frame), _keyboardView.frame.size.width, _keyboardView.frame.size.height);
    
    [_setting_scrollView addSubview:_keyboardView];
    
    //perference
    _preferenceView.frame = CGRectMake(0, CGRectGetMaxY(_keyboardView.frame), _preferenceView.frame.size.width, _preferenceView.frame.size.height);
    
    [_setting_scrollView addSubview:_preferenceView];
    
    //scrollView contentSize
    _setting_scrollView.contentSize = CGSizeMake(_setting_scrollView.frame.size.width, _setting_scrollView.frame.size.height);
    
    //儲存 mouse & keyboard & preference 是否被選擇
    ary_isSelected = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        
        NSString *isClick = [NSString stringWithFormat:@"0"];
        [ary_isSelected addObject:isClick];
    }
    
    //指紋相關初始化設定
    self.mouseFingerView.superObject = self;
    
    self.mouseFingerView.m_fingerView = self.fingerView;
    
    self.mouseFingerView.animationImgView = self.fingerAnimationView;
    
    //尺標最大座標點
    self.mouseFingerView.minimumPoint = CGPointMake(CGRectGetMinX(self.fingerRuler.frame) + self.fingerRuler.frame.size.width/75, self.fingerRuler.center.y);
    
    //尺標最小座標點
    self.mouseFingerView.maxmumPoint = CGPointMake(CGRectGetMaxX(self.fingerRuler.frame) - self.fingerRuler.frame.size.width/30, self.fingerRuler.center.y);
    
    [self.mouseFingerView addLongPress];
    
    [self.mouseFingerView settingFingerAnimation];
    
    
    //ary_showFingerBt
    ary_showFingerBt = [NSMutableArray arrayWithObjects:_showFingerBt_0,_showFingerBt_1,_showFingerBt_2,_showFingerBt_3,_showFingerBt_4, nil];
    
    
    //ads Toggle
    isADSToggle = NO;
    
    //Sync
    isSync = NO;
    
    //shootingSpeed
    isShootingSpeed = NO;
    
    //inverted
    isInverted = NO;
    
    //sniperBreath
    isSniperBreath = NO;
    
    //antiRecoil
    isAntiRecoil = NO;
    
    
    
    
    
    //硬體
    configData = [[FPSConfigData alloc] init];
    [configData initParam];
    
    
    
    //判斷是哪個 hotkey 呼叫 onResponseResponseMode
    isConfigHotKeyCallResponseMode = NO;
    isKeyboardCallResponseMode = NO;
    isSniperBreathCallResponseMode = NO;
    isAntiRecoilCallResponseMode = NO;
    
    //Button 字體大小自動調整
    self.configHotkey.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.antiRecoilHotkey.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.sniperBreathHotkey.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.sniperBreathHotkeyView.keyType = 3;
    self.sniperBreathHotkeyView.keyImgView = self.sniperBreathHotKeyImgView;
    self.sniperBreathHotkeyView.keyBt = self.sniperBreathHotkey;
    
    self.antiRecoilHotkeyView.keyType = 3;
    self.antiRecoilHotkeyView.keyImgView = self.antiRecoilHotkeyImgView;
    self.antiRecoilHotkeyView.keyBt = self.antiRecoilHotkey;
    
    
    currentConfigData = [CFTableViewCellObject new];
    
    
    self.fingerViewHipTextField = self.textField_0;
    self.fingerViewADSTextField = self.textField_1;
    
    //改變gameIconView的圓角
    self.gameIconView.layer.cornerRadius = 2.5;
    self.gameIconView.layer.masksToBounds = YES;
    
    //鍵盤監聽事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkConfigFileNameRepeat) name:UIKeyboardDidHideNotification object:nil];
    
    
    
    //紀錄 RightView 原本位置
    rightViewOriLoaction = CGPointMake(self.rightView.frame.origin.x, self.rightView.frame.origin.y);
    
    //紀錄 LeftView 原本位置
    leftViewOriLocation = CGPointMake(self.leftView.frame.origin.x, self.leftView.frame.origin.y);
    
    
    isTapTwice = NO;
    
}


-(void)testSave
{
    configData = [[FPSConfigData alloc] init];
    [configData initParam];
    
    [configData setConfigName:currentConfigData.configFileName];
    
    NSLog(@"==>configname:%@",configData.getConfigName);
    
    [configData setConfigHotKey:22];
    
    
    [configData setLEDColor:2];
    
    
    [configData setPlatform:1];
    
    [configData setHIPSensitivity:1];
    
    [configData setADSSensitivity:1];
    
    [configData setFuncFlag_ADSSync:YES];
    
    [configData setFuncFlag_ADSToggle:YES];
    
    
    [configData setDeadZONE:1];
    
    [configData setFuncFlag_shootingSpeed:YES];
    
    [configData setShootingSpeed:1];
    
    [configData setFuncFlag_invertedYAxis:NO];
    
    [configData setFuncFlag_sniperBreath:NO];
    
    
    
    [configData setSniperBreathHotKey:5];
    
    
    
    [configData setFuncFlag_antiRecoil:YES];
    
    [configData setAntiRecoilHotkey:4];
    
    [configData setAntiRecoilOffsetValue:1];
    
    
    //currentConfigData.ballistics_Y_value = [curveView returnBallisticPoints];
    //currentConfigData.ballistics_changed = [curveView returnBallisticChange];
    
    //[configData setKeyMapArray:currentConfigData.keyMap];
    
    //NSMutableArray *map=[[NSMutableArray alloc]init];
    
    //[currentConfigData.keyMap removeAllObjects];
    
    //for(int i=0; i< 22; i++){
    //    [map addObject:[NSNumber numberWithInt:0]];
    //}
    
    //[configData setKeyMapArray:map];
    
    [[ProtocolDataController sharedInstance] saveConfig:0 :configData];
    
    //isOPen
    isFingerCase0open = NO;
    isFingerCase1open = NO;
    isfingerCase2open = NO;
    isFingerCase3open = NO;
    isFingerCase4open = NO;
    
    //sniperBreathBt tap twice
    [self.sniperBreathBt addTarget:self action:@selector(setSniperBreathBtTapTwiceAction:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
    
    //antiRecoilHotkey tap twice
    [self.antiRecoilHotkey addTarget:self action:@selector(setantiRecoilBtTapTwiceAction:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSLog(@"viewWillAppear   self.indexPathRow:%ld",(long)self.indexPathRow);
    
    
    //portocol delegate
    [ProtocolDataController sharedInstance].dataResponseDelegate = self;
    
    [ProtocolDataController sharedInstance].connectStateDelegate = self;
    
    
    
    if(_alreadyInitView){
        return;
    }
    _alreadyInitView = YES;
    
    
    if (self.isCreate == YES) {
        //新增
        [self copyEditObjToCurrentObj];
        
        //遊戲圖片
        self.gameIconView.image = [UIImage imageNamed:@"platform_a_5_custom_408x408"];
        
    }
    else {
        
        //編輯
        [self setConfigDataArrayTemporary];
        
        //遊戲圖片
        NSLog(@"viewWillAppear-----currentConfigData.configFileName = %@", currentConfigData.configFileName);
        NSMutableDictionary *configImgDic = [[ConfigMacroData sharedInstance] getConfigImageKey:currentConfigData.configFileName];
        NSData *imgData = [configImgDic objectForKey:@"configImage"];
        
        self.gameIconView.image = [UIImage imageWithData: imgData];
        
    }
    
    
    //遊戲 config 名稱
    _configFileName.text = currentConfigData.configFileName;
    
    //遊戲平台
    NSString *platfromStr = [self getPlatformNumToPic:[currentConfigData.configPlatformIcon intValue]];
    _machineIconView.image = [UIImage imageNamed:platfromStr];
    NSLog(@"======== platform:%@",currentConfigData.configPlatformIcon);
    
    //遊戲 LED_Color
    NSString *LEDColorStr = [self getNumTransformToLEDColor:[currentConfigData.configLEDColor intValue]];
    [_changeColorBt setImage:[UIImage imageNamed:LEDColorStr] forState:UIControlStateNormal];
    [self getPointFromLEDColor: LEDColorStr];
    
    //config hotkey
    NSString *configHotKeyStr = [keyCodeClass returnKeyboardKey:[currentConfigData.configHotKeyStr intValue]];
    [self.configHotkey setTitle:configHotKeyStr forState:UIControlStateNormal];
    NSLog(@"======== hotkey:%@",currentConfigData.configHotKeyStr);
    
    //=======  mouse  ==========
    //HIP
    _textField_0.text = currentConfigData.hipStr;
    
    //ADS (textField_1)
    _textField_1.text = currentConfigData.adsStr;
    
    //isSync
    isSync = currentConfigData.isSync;
    if (isSync) {
        
        [self.syncBt setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
        
        self.syncLabel.alpha = 1.0;
        
        
        //ADS 無效
        self.textField_1.text = self.textField_0.text;
        self.textField_1.textColor = [UIColor grayColor];
        self.textField_1.userInteractionEnabled = NO;
        self.showFingerBt_1.userInteractionEnabled = NO;
        [self.showFingerBt_1 setImage:[UIImage imageNamed:@"config_btn_a_rule_up"] forState:UIControlStateNormal];
        
        self.isSyncOrNot = YES;
        
        
        
    }
    else {
        
        [self.syncBt setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
        
        self.syncLabel.alpha = 0.6;
        
        
        
        //ADS 生效
        self.textField_1.textColor = [UIColor whiteColor];
        self.textField_1.userInteractionEnabled = YES;
        self.showFingerBt_1.userInteractionEnabled = YES;
        [self.showFingerBt_1 setImage:[UIImage imageNamed:@"config_btn_a_rule_up"] forState:UIControlStateNormal];
        self.isSyncOrNot = NO;
    }
    
    
    //ADS toggle
    isADSToggle = currentConfigData.isADStoggle;
    if (isADSToggle) {
        
        [self.adsToggleBt setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
        
        self.adsToggleLabel.alpha = 1.0;
    }
    else {
        
        [self.adsToggleBt setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
        
        self.adsToggleLabel.alpha = 0.6;
    }
    
    
    
    //DeadZone (textField_2)
    _textField_2.text = currentConfigData.deadZoneStr;
    
    
    
    //=======  keyboard  ==========
    //NSString *keyStr;
    for (int index = 0; index < ary_keymap.count; index++) {
        
        [ary_keymap[index] setTitle:[keyCodeClass returnKeyboardKey:currentConfigData.keyMap[index].intValue] forState:UIControlStateNormal];
        
        
        [ary_keymapView[index].keyBt setTitle:[keyCodeClass returnKeyboardKey:currentConfigData.keyMap[index].intValue] forState:UIControlStateNormal];
        
        //NSLog(@"====keycode====:%@",ary_keymapView[0].keyBt.titleLabel.text);
        //NSLog(@"====keycode====:%@",ary_keymapView[1].keyBt.titleLabel.text);
        
        [ary_keymapView[index] changeKeyColor:currentConfigData.keyMap[index].intValue];
        
    }
    
    //[self showkeyboardArrow];
    
    
    //=======  preference  ==========
    //Shooting speed (textField_3)
    isShootingSpeed = currentConfigData.isShootingSpeed;
    if (isShootingSpeed) {
        
        [self.shootingSpeedBt setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
    }
    else {
        
        [self.shootingSpeedBt setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
    }
    
    //shootingSpeedStr
    _textField_3.text = currentConfigData.shootingSpeedStr;
    
    
    //Inverted
    isInverted = currentConfigData.isInverted;
    if (isInverted) {
        
        [self.invertedBt setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
    }
    else {
        
        [self.invertedBt setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
    }
    
    
    //Sniper breath
    isSniperBreath = currentConfigData.isSniperBreath;
    if (isSniperBreath) {
        
        [self.sniperBreathBt setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
    }
    else {
        
        [self.sniperBreathBt setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
    }
    
    //Anti Recoil offset (textField_4)
    isAntiRecoil = currentConfigData.isAntiRecoil;
    if(isAntiRecoil) {
        
        [self.antiRecoilBt setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
        
    }
    else {
        
        [self.antiRecoilBt setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
    }
    
    
    //antiRecoilStr
    _textField_4.text = currentConfigData.antiRecoilStr;
    
    //antiRecoilHotkey
    NSString *antiRecoilHotkeyStr =[keyCodeClass returnKeyboardKey:[currentConfigData.antiRecoilHotkey intValue]];
    
    [self.antiRecoilHotkey setTitle:antiRecoilHotkeyStr forState:UIControlStateNormal];
    
    [self.antiRecoilHotkeyView changeKeyColor:[currentConfigData.antiRecoilHotkey intValue]];
    
    //sniperBreathHotkey
    NSString *sniperBreathHotkeyStr =[keyCodeClass returnKeyboardKey:[currentConfigData.sniperBreathHotkey intValue]];
    
    [self.sniperBreathHotkey setTitle:sniperBreathHotkeyStr forState:UIControlStateNormal];
    
    [self.sniperBreathHotkeyView changeKeyColor:[currentConfigData.sniperBreathHotkey intValue]];
    
    
    //判斷 platform
    if ([currentConfigData.configPlatformIcon isEqualToString:@"1"]) {
        
        _machine_bgView.image = [UIImage imageNamed:@"config_ps3_1334x750"];
        _machine_label.text = @"PS3";
        [self differentMachineCorrespondBts:_machine_label.text];
        
    }
    else if ([currentConfigData.configPlatformIcon isEqualToString:@"2"]) {
        
        _machine_bgView.image = [UIImage imageNamed:@"config_ps4_1334x750"];
        _machine_label.text = @"PS4";
        [self differentMachineCorrespondBts:_machine_label.text];
        
    }
    else if ([currentConfigData.configPlatformIcon isEqualToString:@"4"]) {
        
        _machine_bgView.image = [UIImage imageNamed:@"config_x360_1334x750"];
        _machine_label.text = @"Xbox 360";
        [self differentMachineCorrespondBts:_machine_label.text];
        
    }
    else {
        
        _machine_bgView.image = [UIImage imageNamed:@"config_xone_1334x750"];
        _machine_label.text = @"Xbox One";
        [self differentMachineCorrespondBts:_machine_label.text];
        
    }
    
    //初始化 YES: edit 頁面
    isEditOrKeyboard = YES;
    
    
    //盲區圖表
    //2016/07/27 Rex
    if (IS_IPHONE_4_OR_LESS) {
        
        self.ballisticsView.frame = CGRectMake(self.ballisticsView.frame.origin.x, self.ballisticsView.frame.origin.y, self.ballisticsView.frame.size.width, self.ballisticsView.frame.size.width);
    }
    
    NSMutableArray *configAry = [[ConfigMacroData sharedInstance] getConfigArray];
    
    NSDictionary *configDict;
    
    NSLog(@"isCreate  =%d",self.isCreate);
    
    if (configAry.count != 0) {
        
    }
    
    
    if(curveView != nil){
        [curveView removeFromSuperview];
    }
    
    if(self.isCreate){
        
        curveView = [[BallisticCurveView alloc] initWithFrame:CGRectMake(-1, 1, self.ballisticsView.frame.size.width-2, self.ballisticsView.frame.size.height-2) withData:nil];
        
        self.indexPathRow = configAry.count;
    }
    else{
        
        configDict = [configAry objectAtIndex:self.indexPathRow];
        //NSLog(@"configDict = %@",configDict);
        
        curveView = [[BallisticCurveView alloc] initWithFrame:CGRectMake(-1, 1, self.ballisticsView.frame.size.width-2, self.ballisticsView.frame.size.height-2) withData:configDict];
    }
    
    [curveView setXLinePosition:0];
    
    yPointValue = [curveView getYPointValue];
    
    self.xValueLabel.text = [NSString stringWithFormat:@"%d",xPointValue];
    
    self.yValueLabel.text = [NSString stringWithFormat:@"%.0f",yPointValue];
    
    self.xValueLabel.enabled = NO;
    
    self.yValueLabel.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.yValueLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.ballisticsView addSubview:curveView];
    
    
    //LED_LIVEMODE
    [self setFPSConfigData];
    [[ProtocolDataController sharedInstance] liveMode:0 :configData];
    
    
    [self.leftView bringSubviewToFront:self.saveCancelView];
    
    //即時變換語系
    [self changeLanguageImidiately];
}




-(void)viewDidAppear:(BOOL)animated {
    
    if (tempImg != nil) {
        
        self.gameIconView.image = tempImg;
        
        tempImg = nil;
    }
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    NSLog(@"CFEditViewController     viewWillDisappear");
    
    
    [self scollViewBackToOrigin];
    
    
    //mouse keyboard preference 歸零
    [self.view viewWithTag:3001].transform = CGAffineTransformMakeRotation(0);
    [self.view viewWithTag:3003].transform = CGAffineTransformMakeRotation(0);
    [self.view viewWithTag:4001].hidden = YES;
    [self.view viewWithTag:4002].hidden = YES;
    [self.view viewWithTag:4003].hidden = YES;
    
    for (int i = 0; i < ary_isSelected.count; i++) {
        
        ary_isSelected[i] = @"0";
    }
    
    
    if (cfMainVC == nil) {
        
        cfMainVC = (CFMainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFMainVC"];
    }
    
    //nick
    //cfMainVC.isSelectedConfig = YES;
    
    
    [[ProtocolDataController sharedInstance] stopListeningResponse];
    //    [self cancelTimer];
    
    //所有 hotkey response 取消
    //config hotkey
    int hotkeyInt = [currentConfigData.configHotKeyStr intValue];
    NSString *hotkeyStr = [keyCodeClass returnKeyboardKey:hotkeyInt];
    [self.configHotkey setTitle:hotkeyStr forState:UIControlStateNormal];
    
    //sniperBreath hotkey
    int sniperBreathInt = [currentConfigData.sniperBreathHotkey intValue];
    NSString *sniperBreathStr = [keyCodeClass returnKeyboardKey:sniperBreathInt];
    [self.sniperBreathHotkey setTitle:sniperBreathStr forState:UIControlStateNormal];
    
    
    //antirecoil hotkey
    int antiRecoilInt = [currentConfigData.antiRecoilHotkey intValue];
    NSString *antiRecoilStr = [keyCodeClass returnKeyboardKey:antiRecoilInt];
    [self.antiRecoilHotkey setTitle:antiRecoilStr forState:UIControlStateNormal];
    
    
    
    [self.configFileName resignFirstResponder];
    [_textField_0 resignFirstResponder];
    [_textField_1 resignFirstResponder];
    [_textField_2 resignFirstResponder];
    [_textField_3 resignFirstResponder];
    [_textField_4 resignFirstResponder];
    
    //LED_Color 隱藏 - saveCancel 顯示
    isColorBarAction = NO;
    finger.userInteractionEnabled = NO;
    [finger stopAnimating];
    
    [UIView animateWithDuration:0.38 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //colorBar 隱藏
        _colorBar.alpha = 0.0;
        _colorBar_bgView.alpha = 0.0;
        _fingerPrint.alpha = 0.0;
        
        
        //_saveCancelView 回原位
        _saveCancelView.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMaxY(self.view.frame) - _saveCancelView.frame.size.height, _saveCancelView.frame.size.width, _saveCancelView.frame.size.height);
        
    } completion:nil];

    
    //tempImg
    tempImg = nil;
    
    
    //isOPen
    isFingerCase0open = NO;
    isFingerCase1open = NO;
    isfingerCase2open = NO;
    isFingerCase3open = NO;
    isFingerCase4open = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 判斷所有值是否有改變
-(BOOL)isValueChanged {
    
    BOOL isChanged;
    
    int isChangedCount = 0;
    
    NSMutableArray *oriArray = [[ConfigMacroData sharedInstance] getConfigArray];
    
    NSMutableDictionary *configDict = [NSMutableDictionary new];
    
    configDict = [oriArray[_indexPathRow] mutableCopy];
    
    //configName
    if (![currentConfigData.configFileName isEqualToString:[configDict objectForKey:@"configName"]]) {
        
        isChangedCount += 1;
        
        NSLog(@"******** configFileName Changed");
        
    }
    
    
    //configLEDColor
    if ([currentConfigData.configLEDColor intValue] != [[configDict objectForKey:@"LEDColor"] intValue]) {
        
        isChangedCount += 1;
        
        NSLog(@"******** configLEDColor Changed");
    }
    
    
    
    //    //configGameIcon
    //    if(![currentConfigData.configGameIcon isEqualToString:_edit_configObj.configGameIcon]) {
    //
    //        isChangedCount += 1;
    //
    //        NSLog(@"******** configGameIcon Changed");
    //    }
    
    
    //configHotKeyStr
    if(![currentConfigData.configHotKeyStr isEqualToString:[configDict objectForKey:@"configHotKey"]]) {
        
        isChangedCount += 1;
        
        NSLog(@"******** configHotKeyStr Changed");
    }
    
    //isSync
    if (currentConfigData.isSync != [[configDict objectForKey:@"flagADSSync"] boolValue]) {
        
        isChangedCount += 1;
        
        NSLog(@"******** isSync Changed");
    }
    
    //isADStoggle
    if (currentConfigData.isADStoggle != [[configDict objectForKey:@"flagADSToggle"]boolValue]) {
        
        isChangedCount += 1;
        NSLog(@"******** isADStoggle Changed");
    }
    
    //isShootingSpeed
    if (currentConfigData.isShootingSpeed != [[configDict objectForKey:@"flagShootingSpeed"]boolValue]) {
        
        isChangedCount += 1;
        NSLog(@"******** isShootingSpeed Changed");
    }
    
    //isInverted
    if(currentConfigData.isInverted != [[configDict objectForKey:@"flagInvertedYAxis"]boolValue]) {
        
        isChangedCount += 1;
        NSLog(@"******** isInverted Changed");
    }
    
    //isSniperBreath
    if(currentConfigData.isSniperBreath != [[configDict objectForKey:@"flagSniperBreath"] boolValue]) {
        
        isChangedCount += 1;
        NSLog(@"******** isSniperBreath Changed");
    }
    
    //isAntiRecoil
    if (currentConfigData.isAntiRecoil != [[configDict objectForKey:@"flagAntiRecoil"]boolValue]) {
        
        isChangedCount += 1;
        NSLog(@"******** isAntiRecoil Changed");
    }
    
    //hipStr
    if(![currentConfigData.hipStr isEqualToString:[configDict objectForKey:@"HIPSensitivity"]]){
        
        isChangedCount += 1;
        NSLog(@"******** hipStr Changed");
    }
    
    //adsStr
    if(![currentConfigData.adsStr isEqualToString:[configDict objectForKey:@"ADSSensitivity"]]) {
        
        isChangedCount += 1;
        NSLog(@"******** adsStr Changed");
    }
    
    //deadZoneStr
    if (![currentConfigData.deadZoneStr isEqualToString:[configDict objectForKey:@"deadZONE"]]) {
        
        isChangedCount += 1;
        NSLog(@"******** deadZoneStr Changed");
    }
    
    //shootingSpeedStr
    if(![currentConfigData.shootingSpeedStr isEqualToString:[configDict objectForKey:@"shootingSpeed"]]) {
        
        isChangedCount += 1;
        NSLog(@"******** shootingSpeedStr Changed");
    }
    
    //antiRecoilStr
    if(![currentConfigData.antiRecoilStr isEqualToString: [configDict objectForKey:@"antiRecoilOffsetValue"]]) {
        
        isChangedCount += 1;
        NSLog(@"******** antiRecoilStr Changed");
    }
    
    //sniperBreathHotkey
    if(![(currentConfigData.sniperBreathHotkey) isEqualToString:[configDict objectForKey:@"sniperBreathHotKey"]]) {
        isChangedCount += 1;
        NSLog(@"******** sniperBreathHotkey Changed");
    }
    
    
    //antiRecoilHotkey
    if(![currentConfigData.antiRecoilHotkey isEqualToString:[configDict objectForKey:@"antiRecoilHotkey"]]) {
        
        isChangedCount += 1;
        NSLog(@"******** antiRecoilHotkey Changed");
    }
    
    //keyboard
    for (int keyboardIndex = 0; keyboardIndex < ary_keymap.count; keyboardIndex++) {
        
        if([currentConfigData.keyMap[keyboardIndex] intValue] != [[configDict objectForKey:@"keyMapArray"][keyboardIndex] intValue]) {
            
            isChangedCount += 1;
            NSLog(@"******** keyboard Changed");
        }
        
    }
    
    //ballistics
    for (int ballisticValueIndex = 0; ballisticValueIndex < currentConfigData.ballistics_Y_value.count ;ballisticValueIndex++) {
        
        if ([currentConfigData.ballistics_Y_value[ballisticValueIndex] intValue] != [[configDict objectForKey:@"ballisticsArray"][ballisticValueIndex]intValue]) {
            
            isChangedCount += 1;
            NSLog(@"******** ballisticsValue Changed");
        }
        
    }
    //
    //    //ballisticsChange
    //    for (int ballisticChangeIndex = 0; ballisticChangeIndex < currentConfigData.ballistics_changed.count; ballisticChangeIndex++) {
    //
    //        if(![currentConfigData.ballistics_changed[ballisticChangeIndex] isEqualToString:[configDict objectForKey:@"ballisticChanged"]]) {
    //
    //            isChangedCount += 1;
    //
    //            NSLog(@"******** ballisticschanged  Changed");
    //        }
    //    }
    //
    
    
    
    if (isChangedCount != 0) {
        
        isChanged = YES;
        
        NSLog(@"======= //// YES  //// ========");
    }
    else {
        
        isChanged = NO;
        NSLog(@"======= //// NO //// ========");
    }
    
    NSLog(@"***** isChangedCount: %d",isChangedCount);
    
    
    return isChanged;
}



#pragma mark - 回到 Config & Marco 主頁
- (IBAction)backToConfig:(UIButton *)sender {
    
    [[ProtocolDataController sharedInstance] stopListeningResponse];
    
    //隱藏鍵盤
    [self hiddeAllTextFieldKeyboard];
    
    
    if (self.isCreate == YES) {
        
        self.saveChangesView.hidden = NO;
        
    }else {
        
        BOOL change = [self isValueChanged];
        
        if (change == YES) {
            //有更動
            self.saveChangesView.hidden = NO;
        }
        else {
            self.saveChangesView.hidden = YES;
            
            [self saveChangeDataOrNot:NO];
            
            //無更動
            //[self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }
    
}

#pragma mark - Save or Cancel(儲存或取消)
- (IBAction)saveOrCancelAction:(UIButton *)sender {
    
    if (sender == self.saveBt) {
        
        [self saveChangeDataOrNot:YES];
        
    }else if (sender == self.cancelBt) {
        
//        [[ProtocolDataController sharedInstance] resetLiveMode];
//        
//        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        //[self saveChangeDataOrNot:NO];
        //如果有值改變 返回鍵 與 取消鍵 都要先跳出詢問視窗2016/10/24
        
        [[ProtocolDataController sharedInstance] stopListeningResponse];
        
        if (self.isCreate == YES) {
            
            self.saveChangesView.hidden = NO;
            
        }else {
        
            BOOL change = [self isValueChanged];
            
            if (change == YES) {
                //有更動
                self.saveChangesView.hidden = NO;
            }
            else {
                self.saveChangesView.hidden = YES;
                
                [self saveChangeDataOrNot:NO];
                
                //無更動
                //[self.navigationController popViewControllerAnimated:YES];
            }
            
            
        }

    }
    
}


#pragma mark - 觸發改變顏色按鈕
- (IBAction)onColorChangeAction:(UIButton *)sender {
    
    if (isColorBarAction == NO) {
        
        isColorBarAction = YES;
        [finger setAnimationDuration:2.5];
        [finger startAnimating];
        
        finger.userInteractionEnabled = YES;
        
        [UIView animateWithDuration:0.38 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            //colorBar 顯示
            _colorBar.alpha = 1.0;
            _colorBar_bgView.alpha = 1.0;
            _fingerPrint.alpha = 1.0;
            
            
            //_saveCancelView 往下移
            _saveCancelView.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMaxY(self.view.frame) - _saveCancelView.frame.size.height/6, _saveCancelView.frame.size.width, _saveCancelView.frame.size.height);
            
        } completion:nil];
        
    }
    else {
        
        isColorBarAction = NO;
        
        finger.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:0.38 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            //colorBar 隱藏
            _colorBar.alpha = 0.0;
            _colorBar_bgView.alpha = 0.0;
            _fingerPrint.alpha = 0.0;
            [finger stopAnimating];
            
            //_saveCancelView 回原位
            _saveCancelView.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMaxY(self.view.frame) - _saveCancelView.frame.size.height, _saveCancelView.frame.size.width, _saveCancelView.frame.size.height);
            
        } completion:nil];
        
    }
    
}

#pragma mark - 根據已存的 config LED_Color 轉換成對應座標
-(void)getPointFromLEDColor:(NSString *)LED_Color {
    
    int index;
    
    if ([LED_Color isEqualToString:@"config_color_a_1"]) {
        
        index = 0;
    }
    else if ([LED_Color isEqualToString:@"config_color_a_2"]) {
        
        index = 1;
    }
    else if ([LED_Color isEqualToString:@"config_color_a_3"]) {
        
        index = 2;
    }
    else if ([LED_Color isEqualToString:@"config_color_a_4"]) {
        
        index = 3;
    }
    else if ([LED_Color isEqualToString:@"config_color_a_5"]) {
        
        index = 4;
    }
    else if ([LED_Color isEqualToString:@"config_color_a_6"]) {
        
        index = 5;
    }
    else if ([LED_Color isEqualToString:@"config_color_a_7"]) {
        
        index = 6;
    }
    else if ([LED_Color isEqualToString:@"config_color_a_8"]) {
        
        index = 7;
    }
    else if ([LED_Color isEqualToString:@"config_color_a_9"]) {
        
        index = 8;
    }
    else {
        
        index = 9;
    }
    
    _fingerPrint.center = CGPointMake(minPoint.x + index*singleValue , fp_centerY);
    
    finger.center = _fingerPrint.center;
    
    _fingerPrint.image = [UIImage imageNamed:fp_outline_pics[index]];
    
}

#pragma  mark - 移動指紋選顏色
-(void)longPressToMoveFinger:(UIGestureRecognizer *)gesture {
    
    if (isColorBarAction == YES) {
        
        UIGestureRecognizerState theState = pan_gesture.state;
        
        CGPoint currentPoint = [pan_gesture locationInView:self.view];
        
        switch (theState) {
                
            case UIGestureRecognizerStateBegan:
                break;
                
            case UIGestureRecognizerStateChanged: {
                
                if (currentPoint.x <= minPoint.x) {
                    
                    currentPoint.x = minPoint.x;
                    
                }
                else if (currentPoint.x >= maxPoint.x) {
                    
                    currentPoint.x = maxPoint.x;
                }
                
                finger.center = CGPointMake(currentPoint.x, fp_centerY);
                
                CGFloat value_x = finger.center.x - CGRectGetMinX(_colorBar.frame);
                
                int index = value_x / singleValue;
                
                _fingerPrint.center = CGPointMake(minPoint.x + index*singleValue , fp_centerY);
                
                finger.center = _fingerPrint.center;
                
                _fingerPrint.image = [UIImage imageNamed:fp_outline_pics[index]];
                
                [_changeColorBt setImage:[UIImage imageNamed:changeColorBt_pics[index]] forState:UIControlStateNormal];
                
                int LEDColorInt = index + 1;
                
                currentConfigData.configLEDColor = [NSString stringWithFormat:@"%d",LEDColorInt];
                
                //currentConfigData.configLEDColor = changeColorBt_pics[index];
                
                //LEDColor for live mode
                [self setFPSConfigData];
                
            }
                
                break;
                
            case UIGestureRecognizerStateEnded:
                
                //LEDCOlor for live mode
                [[ProtocolDataController sharedInstance] liveMode:0 :configData];
                
                break;
                
            default:
                break;
        }
        
    }
    
}


#pragma mark - setFPSConfigData
-(FPSConfigData *)setFPSConfigData{
    
    //LED color
    int LEDNum = [currentConfigData.configLEDColor intValue];
    [configData setLEDColor:LEDNum];
    
    //2:HIP
    [configData setHIPSensitivity:[currentConfigData.hipStr intValue]];
    
    //3:ADS
    [configData setADSSensitivity:[currentConfigData.adsStr intValue]];
    
    //4:DeadZone
    [configData setDeadZONE:[currentConfigData.deadZoneStr intValue]];
    
    //5:SniperBreath Hotkey
    int sniperBreathHotkeyNum = [currentConfigData.configHotKeyStr intValue];
    [configData setSniperBreathHotKey:sniperBreathHotkeyNum];
    
    //7:AntiRecoil Hotkey
    int antiRecoilHotkeyNum =[currentConfigData.antiRecoilHotkey intValue];
    [configData setAntiRecoilHotkey:antiRecoilHotkeyNum];
    
    //8:AntiRecoil offsetValue
    [configData setAntiRecoilOffsetValue:[currentConfigData.antiRecoilStr intValue]];
    
    //9:Shooting speed
    [configData setShootingSpeed:[currentConfigData.shootingSpeedStr intValue]];
    
    //11:keyMap(0~4)
    //12:keyMap(5~20)
    //13:keyMap(21)
    [configData setKeyMapArray:currentConfigData.keyMap];
    
    
    //14:Ballistics(0~14)
    //15:Ballistics(15~19)
    [configData setBallistics:currentConfigData.ballistics_Y_value];
    
    
    //100:isADSToggle
    [configData setFuncFlag_ADSToggle:currentConfigData.isADStoggle];
    
    //101:isShootingSpeed
    [configData setFuncFlag_shootingSpeed:currentConfigData.isShootingSpeed];
    
    //102:isInverted
    [configData setFuncFlag_invertedYAxis:currentConfigData.isInverted];
    
    //103:isSniperBreath
    [configData setFuncFlag_sniperBreath:currentConfigData.isSniperBreath];
    
    //104:isAntiRecoil
    [configData setFuncFlag_antiRecoil:currentConfigData.isAntiRecoil];
    
    //105:isADSSync
    [configData setFuncFlag_ADSSync:currentConfigData.isSync];
    
    
    return configData;
}

-(void)copyEditObjToCurrentObj {
    
    //新增時用
    //gameIcon
    //currentConfigData.configGameIcon = [_edit_configObj.configGameIcon mutableCopy];
    
    //file Name
    currentConfigData.configFileName = [_edit_configObj.configFileName mutableCopy];
    
    NSLog(@"copyEditObjToCurrentObj-----%@", currentConfigData.configFileName);
    
    //hot key
    currentConfigData.configHotKeyStr = [_edit_configObj.configHotKeyStr mutableCopy];
    
    //LEDColor
    currentConfigData.configLEDColor = [_edit_configObj.configLEDColor mutableCopy];
    
    //platform
    currentConfigData.configPlatformIcon = [_edit_configObj.configPlatformIcon mutableCopy];
    
    //hipStr
    currentConfigData.hipStr = [_edit_configObj.hipStr mutableCopy];
    
    //adsStr
    currentConfigData.adsStr = [_edit_configObj.adsStr mutableCopy];
    
    //isSync
    currentConfigData.isSync = _edit_configObj.isSync;
    
    //isADStoggle
    currentConfigData.isADStoggle = _edit_configObj.isADStoggle;
    
    //deazone
    currentConfigData.deadZoneStr = [_edit_configObj.deadZoneStr mutableCopy];
    
    
    //=======  keyboard  ==========
    currentConfigData.keyMap = [[NSMutableArray alloc] initWithCapacity:0];
    currentConfigData.keyMap = [_edit_configObj.keyMap mutableCopy];
    
    
    
    //isShootingSpeed
    currentConfigData.isShootingSpeed = _edit_configObj.isShootingSpeed;
    
    
    //shootingSpeedStr
    currentConfigData.shootingSpeedStr = [_edit_configObj.shootingSpeedStr mutableCopy];
    
    //isInverted
    currentConfigData.isInverted = _edit_configObj.isInverted;
    
    //isSniperBreath
    currentConfigData.isSniperBreath = _edit_configObj.isSniperBreath;
    
    //isAntiRecoil
    currentConfigData.isAntiRecoil = _edit_configObj.isAntiRecoil;
    
    //anti RecoilStr offset
    currentConfigData.antiRecoilStr = [_edit_configObj.antiRecoilStr mutableCopy];
    
    //antiRecoilHotkey
    currentConfigData.antiRecoilHotkey = [_edit_configObj.antiRecoilHotkey mutableCopy];
    
    //sniperBreathHotkey
    currentConfigData.sniperBreathHotkey = [_edit_configObj.sniperBreathHotkey mutableCopy];
    
}

-(void)setConfigDataArrayTemporary{
    
    NSMutableArray *oriArray = [[ConfigMacroData sharedInstance] getConfigArray];
    
    NSMutableDictionary *configDict ; //= [NSMutableDictionary new];
    
    //NSLog(@"oriArray[_indexPathRow]:%@",oriArray[_indexPathRow]);
    
    configDict = oriArray[_indexPathRow]; //[oriArray[_indexPathRow] mutableCopy];
    
    
    //遊戲 config 名稱
    currentConfigData.configFileName = [[configDict objectForKey:@"configName"] copy];
    
    NSLog(@"setConfigDataArrayTemporary-----%@", currentConfigData.configFileName);
    
    //遊戲圖片
    currentConfigData.configGameIcon = [_edit_configObj.configGameIcon copy];
    
    //遊戲平台
    currentConfigData.configPlatformIcon = [[configDict objectForKey:@"platform"] copy];
    
    //遊戲 LED_Color
    currentConfigData.configLEDColor = [[configDict objectForKey:@"LEDColor"] copy];
    
    //config hotkey
    currentConfigData.configHotKeyStr  = [[configDict objectForKey:@"configHotKey"] copy];
    
    //=======  mouse  ==========
    //HIP
    currentConfigData.hipStr = [[configDict objectForKey:@"HIPSensitivity"] copy];
    
    //ADS (textField_1)
    currentConfigData.adsStr = [[configDict objectForKey:@"ADSSensitivity"] copy];
    
    //isSync
    currentConfigData.isSync = [[configDict objectForKey:@"flagADSSync"] boolValue];
    
    
    //ADS toggle
    currentConfigData.isADStoggle = [[configDict objectForKey:@"flagADSToggle"] boolValue];
    
    
    //DeadZone (textField_2)
    currentConfigData.deadZoneStr = [[configDict objectForKey:@"deadZONE"] copy];
    
    
    //=======  keyboard  ==========
    //keymap
    currentConfigData.keyMap = [[NSMutableArray alloc] initWithCapacity:0];
    currentConfigData.keyMap = [[configDict objectForKey:@"keyMapArray"] mutableCopy];
    
    
    //=======  preference  ==========
    //Shooting speed (textField_3)
    currentConfigData.isShootingSpeed = [[configDict objectForKey:@"flagShootingSpeed"] boolValue];
    
    
    //shootingSpeedStr
    currentConfigData.shootingSpeedStr = [[configDict objectForKey:@"shootingSpeed"] copy];
    
    
    //isInverted
    currentConfigData.isInverted = [[configDict objectForKey:@"flagInvertedYAxis"] boolValue];
    
    //is Sniper breath
    currentConfigData.isSniperBreath = [[configDict objectForKey:@"flagSniperBreath"] boolValue];
    
    //isAntiRecoil
    currentConfigData.isAntiRecoil = [[configDict objectForKey:@"flagAntiRecoil"] boolValue];
    
    //anti RecoilStr offset (textField_4)
    currentConfigData.antiRecoilStr = [[configDict objectForKey:@"antiRecoilOffsetValue"] copy];
    
    //antiRecoilHotkey
    currentConfigData.antiRecoilHotkey = [[configDict objectForKey:@"antiRecoilHotkey"] copy];
    
    //sniperBreathHotkey
    currentConfigData.sniperBreathHotkey = [[configDict objectForKey:@"sniperBreathHotKey"] copy];
}

/*
 Mouse,Preference
 scrollView 點擊各種方法
 */
#pragma mark - scrollView 點擊各種方法
- (IBAction)indicatorAction:(UIButton *)sender {
    
    if (sender.tag == 2001) {
        //mouse
        
        [self indicatorRotation:[self.view viewWithTag:3001]];
        
        if ([ary_isSelected[0] isEqualToString:@"0"]) {
            
            [self scollViewBackToOrigin];
            
            [self.view viewWithTag:4001].hidden = YES;
            
            [self hiddeAllTextFieldKeyboard];
        }
        else {
            
            [self refreshScrollViewInMouseOrigin];
            
            [self.view viewWithTag:4001].hidden = NO;
            
            _mouseFingerView.hidden = YES;
            
            [self hiddeAllTextFieldKeyboard];
        }
        
    }
    else if (sender.tag == 2002) {
        //keyboard
        
        [self scollViewBackToOrigin];
        ary_isSelected[0] = [NSString stringWithFormat:@"0"];
        ary_isSelected[2] = [NSString stringWithFormat:@"0"];
        
        [self.view viewWithTag:3001].transform = CGAffineTransformMakeRotation(0*M_PI/180);
        [self.view viewWithTag:3003].transform = CGAffineTransformMakeRotation(0*M_PI/180);
        [self.view viewWithTag:4001].hidden = YES;
        [self.view viewWithTag:4003].hidden = YES;
        [self.view viewWithTag:4002].hidden = NO;
        [self hiddeAllTextFieldKeyboard];
        
        //搖桿淡出
        [self slideOut:_leftView RightView:_rightView];
        
    }
    else if (sender.tag == 2003) {
        //preference
        
        [self indicatorRotation:[self.view viewWithTag:3003]];
        
        if ([ary_isSelected[2]isEqualToString:@"0"]) {
            
            [self scollViewBackToOrigin];
            
            [self.view viewWithTag:4003].hidden = YES;
            
            [self hiddeAllTextFieldKeyboard];
        }
        else {
            
            [self refreshScrollViewInPreferenceOrigin];
            
            [self.view viewWithTag:4003].hidden = NO;
            
            [self hiddeAllTextFieldKeyboard];
            
        }
        
    }
    
    
}

-(void)indicatorRotation:(UIImageView *)imgView {
    
    NSString *num = @"0";
    
    switch (imgView.tag) {
            
        case 3001:
            num = ary_isSelected[0];
            break;
        case 3002:
            num = ary_isSelected[1];
            break;
        case 3003:
            num = ary_isSelected[2];
            break;
        default:
            break;
            
    }
    
    //判斷 1 or 0
    if ([num isEqualToString:@"0"]) {
        
        num = [NSString stringWithFormat:@"1"];
    }
    else {
        
        num = [NSString stringWithFormat:@"0"];
    }
    
    switch (imgView.tag) {
            
        case 3001:
            ary_isSelected[0] = num;
            break;
        case 3002:
            ary_isSelected[1] = num;
            break;
        case 3003:
            ary_isSelected[2] = num;
            break;
        default:
            break;
            
    }
    
    // indicator 旋轉
    if ([num isEqualToString:@"1"]) {
        
        [UIView animateWithDuration:0.38 animations:^{
            
            imgView.transform = CGAffineTransformMakeRotation(90*M_PI/180);
        }];
        
    }
    else if ([num isEqualToString:@"0"]) {
        
        [UIView animateWithDuration:0.38 animations:^{
            
            imgView.transform = CGAffineTransformMakeRotation(0*M_PI/180);
        }];
        
    }
    
}


-(void)scollViewBackToOrigin {
    //Mouse,keyboard,preference回復原始狀態
    
    _mouseView.frame = CGRectMake(0, 0, _mouseView.frame.size.width, _mouseView.frame.size.height);
    
    //keyboardView 接在 mouseView 下方
    _keyboardView.frame = CGRectMake(0, CGRectGetMaxY(_mouseView.frame), _keyboardView.frame.size.width, _keyboardView.frame.size.height);
    
    //preferenceView 接在 keyboardView 下方
    _preferenceView.frame = CGRectMake(0, CGRectGetMaxY(_keyboardView.frame), _preferenceView.frame.size.width, _preferenceView.frame.size.height);
    
    //重新定義 scrollView contentSize
    _setting_scrollView.contentSize = CGSizeMake(_setting_scrollView.frame.size.width, _mouseView.frame.size.height + _keyboardView.frame.size.height + _preferenceView.frame.size.height);
    
    _setting_scrollView.contentOffset = CGPointMake(0, 0);
    
    
    [self allMouseSubViewHidden:YES];
    [self allPreferenceSubViewHidden:YES];
    _mouseFingerView.hidden = YES;
    
    
    for (int i = 0; i < ary_showFingerBt.count; i++) {
        
        [ary_showFingerBt[i] setImage:[UIImage imageNamed:@"config_btn_a_rule_up"] forState:UIControlStateNormal];
    }
    
}

//所有 mouse 的 subView 隱藏
-(void)allMouseSubViewHidden:(BOOL)theBool {
    
    _mouse_0_0_view.hidden = theBool;
    _mouse_0_1_view.hidden = theBool;
    _mouse_0_2_view.hidden = theBool;
    _mouse_0_3_view.hidden = theBool;
    _mouse_0_4_view.hidden = theBool;
}


//所有 preference 的 subview 隱藏
-(void)allPreferenceSubViewHidden:(BOOL)theBool {
    
    _preference_0_0_view.hidden = theBool;
    _preference_0_1_view.hidden = theBool;
    _preference_0_2_view.hidden = theBool;
    _preference_0_3_view.hidden = theBool;
}


//mouse 原始狀態 (指紋全部隱藏)
-(void)refreshScrollViewInMouseOrigin {
    //點擊 mouse 時
    [self scollViewBackToOrigin];
    
    
    //先將5個subview排序
    _mouse_0_0_view.frame = CGRectMake(_mouseView.frame.origin.x, CGRectGetMaxY(_mouseView.frame), _mouse_0_0_view.frame.size.width, _mouse_0_0_view.frame.size.height);
    
    _mouse_0_0_view.hidden = NO;
    
    _mouse_0_1_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_0_view.frame), _mouse_0_1_view.frame.size.width, _mouse_0_1_view.frame.size.height);
    
    _mouse_0_1_view.hidden = NO;
    
    _mouse_0_2_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_1_view.frame), _mouse_0_2_view.frame.size.width, _mouse_0_2_view.frame.size.height);
    
    _mouse_0_2_view.hidden = NO;
    
    _mouse_0_3_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_2_view.frame), _mouse_0_3_view.frame.size.width, _mouse_0_3_view.frame.size.height);
    
    _mouse_0_3_view.hidden = NO;
    
    _mouse_0_4_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_3_view.frame), _mouse_0_4_view.frame.size.width, _mouse_0_4_view.frame.size.height);
    
    _mouse_0_4_view.hidden = NO;
    
    CGFloat scrollView_height = _mouse_0_0_view.frame.size.height + _mouse_0_1_view.frame.size.height + _mouse_0_2_view.frame.size.height + _mouse_0_3_view.frame.size.height + _mouse_0_4_view.frame.size.height;
    
    
    //將 _keyboardView & _preferenceView 移到 _sc_mouse_0_view 下面
    _keyboardView.frame = CGRectMake(0, CGRectGetMaxY(_mouse_0_4_view.frame), _mouseView.frame.size.width, _mouseView.frame.size.height);
    
    _preferenceView.frame = CGRectMake(0, CGRectGetMaxY(_keyboardView.frame), _mouseView.frame.size.width, _mouseView.frame.size.height);
    
    //重新地義 contentSize
    _setting_scrollView.contentSize = CGSizeMake(_setting_scrollView.frame.size.width, _mouseView.frame.size.height + scrollView_height + _keyboardView.frame.size.height + _preferenceView.frame.size.height);
    
    //scrollView 返回原點
    _setting_scrollView.contentOffset = CGPointMake(0, 0);
    
    //preference indicator 歸位
    ary_isSelected[2] = [NSString stringWithFormat:@"0"];
    [self.view viewWithTag:3003].transform = CGAffineTransformMakeRotation(0*M_PI/180);
    
    [self.view viewWithTag:4003].hidden = YES;
    
}


//preference  原始狀態 (指紋全部隱藏)
-(void)refreshScrollViewInPreferenceOrigin {
    //點擊  preference 時
    
    //先將 keyboard,preference 歸位
    [self scollViewBackToOrigin];
    
    
    //需要判斷 是 custom 還是 Elite (0,1,2兩者皆有,elite 才有 3)
    _preference_0_0_view.frame = CGRectMake(0, CGRectGetMaxY(_preferenceView.frame), _preference_0_0_view.frame.size.width, _preference_0_0_view.frame.size.height);
    
    _preference_0_0_view.hidden = NO;
    
    
    _preference_0_1_view.frame = CGRectMake(CGRectGetMinX(_preference_0_0_view.frame), CGRectGetMaxY(_preference_0_0_view.frame), _preference_0_1_view.frame.size.width, _preference_0_1_view.frame.size.height);
    
    _preference_0_1_view.hidden = NO;
    
    _preference_0_2_view.frame = CGRectMake(CGRectGetMinX(_preference_0_0_view.frame), CGRectGetMaxY(_preference_0_1_view.frame), _preference_0_2_view.frame.size.width, _preference_0_2_view.frame.size.height);
    
    _preference_0_2_view.hidden = NO;
    
    
    CGFloat sc_preference_height;
    
    //2016.10.12 先以 custom 為主
    //_preference_0_3_view.hidden = YES;
    
    //sc_preference_height = _preference_0_0_view.frame.size.height + _preference_0_1_view.frame.size.height + _preference_0_2_view.frame.size.height;
    
    
    
    if ([currentConfigData.antiRecoilStr intValue] > 100) {
        //Custom
        
        _preference_0_3_view.hidden = YES;
        
        sc_preference_height = _preference_0_0_view.frame.size.height + _preference_0_1_view.frame.size.height + _preference_0_2_view.frame.size.height;

        
    }
    else {
        //Elite
        
        _preference_0_3_view.frame = CGRectMake(CGRectGetMinX(_preference_0_0_view.frame), CGRectGetMaxY(_preference_0_2_view.frame), _preference_0_3_view.frame.size.width, _preference_0_3_view.frame.size.height);
        
        _preference_0_3_view.hidden = NO;
        
        sc_preference_height = _preference_0_0_view.frame.size.height + _preference_0_1_view.frame.size.height + _preference_0_2_view.frame.size.height + _preference_0_3_view.frame.size.height;
        
    }
    
    
    
    
//    if (self.isCustom == YES) {
//        //如果是 Custom
//        _preference_0_3_view.hidden = YES;
//        
//        sc_preference_height = _preference_0_0_view.frame.size.height + _preference_0_1_view.frame.size.height + _preference_0_2_view.frame.size.height;
//    }
//    else if (self.isCustom == NO){
//        //如果是 Elite
//        
//        _preference_0_3_view.frame = CGRectMake(CGRectGetMinX(_preference_0_0_view.frame), CGRectGetMaxY(_preference_0_2_view.frame), _preference_0_3_view.frame.size.width, _preference_0_3_view.frame.size.height);
//        
//        _preference_0_3_view.hidden = NO;
//        
//        sc_preference_height = _preference_0_0_view.frame.size.height + _preference_0_1_view.frame.size.height + _preference_0_2_view.frame.size.height + _preference_0_3_view.frame.size.height;
//        
//    }
    
    

    //重新定義 contentSize
    _setting_scrollView.contentSize = CGSizeMake(_setting_scrollView.frame.size.width, _mouseView.frame.size.height + _keyboardView.frame.size.height + _preferenceView.frame.size.height + sc_preference_height);
    
    //scrollView 返回原點
    _setting_scrollView.contentOffset = CGPointMake(0, 0);
    
    //mouse indicator 歸位
    ary_isSelected[0] = [NSString stringWithFormat:@"0"];
    [self.view viewWithTag:3001].transform = CGAffineTransformMakeRotation(0*M_PI/180);
    [self.view viewWithTag:4001].hidden = YES;
    
}


- (IBAction)showFingerAction:(UIButton *)sender {
    
    if (sender == self.showFingerBt_0) {
        
        self.textFieldValue = _textField_0;
        
        [self fingerCase0];
        
        self.mouseFingerView.rulerIndex = 0;
        
    }
    else if (sender == self.showFingerBt_1) {
        
        self.textFieldValue = _textField_1;
        
        [self fingerCase1];
        
        self.mouseFingerView.rulerIndex = 1;
    }
    else if (sender == self.showFingerBt_2) {
        
        self.textFieldValue = _textField_2;
        
        [self fingerCase2];
        
        self.mouseFingerView.rulerIndex = 2;
    }
    else if (sender == self.showFingerBt_3) {
        
        self.textFieldValue = _textField_3;
        
        [self fingerCase3];
        
        self.mouseFingerView.rulerIndex = 3;
    }
    else if (sender == self.showFingerBt_4) {
        
        self.textFieldValue = _textField_4;
        
        [self fingerCase4];
        
        self.mouseFingerView.rulerIndex = 4;
    }
    
    
    tempValue = [self.textFieldValue.text intValue];
    
    [self.mouseFingerView getPointFrom:tempValue];
    
    
//    for (int i = 0; i < ary_showFingerBt.count; i++) {
//        
//        if (sender == ary_showFingerBt[i]) {
//            
//            [ary_showFingerBt[i] setImage:[UIImage imageNamed:@"config_btn_a_rule_down"] forState:UIControlStateNormal];
//            
//        }
//        else {
//            
//            [ary_showFingerBt[i] setImage:[UIImage imageNamed:@"config_btn_a_rule_up"] forState:UIControlStateNormal];
//        }
//        
//    }
    
    
}

//mouse-sensitivity-HIP
-(void)fingerCase0 {
    
    [self refreshScrollViewInMouseOrigin];
    
    isFingerCase0open = isFingerCase0open == YES ? NO : YES;
    isFingerCase1open = NO;
    isfingerCase2open = NO;
    isFingerCase3open = NO;
    isFingerCase4open = NO;
    
    if (isFingerCase0open) {
        
        //尺規0 icon 按下圖示
        [ary_showFingerBt[0] setImage:[UIImage imageNamed:@"config_btn_a_rule_down"] forState:UIControlStateNormal];
        
        //重新排序
        _mouse_0_0_view.frame = CGRectMake(_mouse_0_0_view.frame.origin.x,_mouse_0_0_view.frame.origin.y,_mouse_0_0_view.frame.size.width , _mouse_0_0_view.frame.size.height);
        
        _mouseFingerView.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_0_view.frame), _mouseFingerView.frame.size.width, _mouseFingerView.frame.size.height);
        
        _mouseFingerView.hidden = NO;
        
        _mouse_0_1_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouseFingerView.frame),_mouse_0_1_view.frame.size.width, _mouse_0_1_view.frame.size.height);
        
        _mouse_0_2_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_1_view.frame), _mouse_0_2_view.frame.size.width,_mouse_0_2_view.frame.size.height);
        
        _mouse_0_3_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_2_view.frame),  _mouse_0_3_view.frame.size.width, _mouse_0_3_view.frame.size.height);
        
        _mouse_0_4_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_3_view.frame),_mouse_0_4_view.frame.size.width,_mouse_0_4_view.frame.size.height);
        
        
        CGFloat normalHeight = CGRectGetHeight(_mouse_0_0_view.frame) + CGRectGetHeight(_mouse_0_1_view.frame) + CGRectGetHeight(_mouse_0_2_view.frame) + CGRectGetHeight(_mouse_0_3_view.frame) + CGRectGetHeight(_mouse_0_4_view.frame);
        
        CGFloat newHeight = normalHeight + CGRectGetHeight(_mouseFingerView.frame);
        
        
        //keyBoard & preference 位置
        _keyboardView.frame = CGRectMake(_keyboardView.frame.origin.x, CGRectGetMaxY(_mouse_0_4_view.frame), _keyboardView.frame.size.width, _keyboardView.frame.size.height);
        
        _preferenceView.frame = CGRectMake(CGRectGetMinX(_keyboardView.frame), CGRectGetMaxY(_keyboardView.frame), _preferenceView.frame.size.width, _preferenceView.frame.size.height);
        
        //重新定義 scrollView's contentSize
        _setting_scrollView.contentSize = CGSizeMake(_setting_scrollView.frame.size.width, _mouseView.frame.size.height + _keyboardView.frame.size.height + _preferenceView.frame.size.height + newHeight);

    }
    else {
        
        //尺規0 icon 未按圖示
        [ary_showFingerBt[0] setImage:[UIImage imageNamed:@"config_btn_a_rule_up"] forState:UIControlStateNormal];
        
        [self refreshScrollViewInMouseOrigin];
    }
   
}

//mouse-sensitivity-ADS
-(void)fingerCase1 {
    
    [self refreshScrollViewInMouseOrigin];
    
    isFingerCase1open = isFingerCase1open == YES ? NO : YES;
    isFingerCase0open = NO;
    isfingerCase2open = NO;
    isFingerCase3open = NO;
    isFingerCase4open = NO;
    
    if (isFingerCase1open) {
        
        
        //尺規1 icon 按下圖示
        [ary_showFingerBt[1] setImage:[UIImage imageNamed:@"config_btn_a_rule_down"] forState:UIControlStateNormal];
        
        //重新排序
        _mouse_0_0_view.frame = CGRectMake(_mouse_0_0_view.frame.origin.x,_mouse_0_0_view.frame.origin.y,_mouse_0_0_view.frame.size.width , _mouse_0_0_view.frame.size.height);
        
        _mouse_0_0_view.hidden = NO;
        
        
        _mouse_0_1_view.frame = CGRectMake(_mouse_0_0_view.frame.origin.x, CGRectGetMaxY(_mouse_0_0_view.frame), _mouse_0_1_view.frame.size.width, _mouse_0_1_view.frame.size.height);
        
        _mouse_0_1_view.hidden = NO;
        
        _mouseFingerView.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_1_view.frame), _mouseFingerView.frame.size.width, _mouseFingerView.frame.size.height);
        
        _mouseFingerView.hidden = NO;
        
        _mouse_0_2_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouseFingerView.frame), _mouse_0_2_view.frame.size.width,_mouse_0_2_view.frame.size.height);
        
        _mouse_0_3_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_2_view.frame),  _mouse_0_3_view.frame.size.width, _mouse_0_3_view.frame.size.height);
        
        _mouse_0_4_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_3_view.frame),_mouse_0_4_view.frame.size.width,_mouse_0_4_view.frame.size.height);
        
        CGFloat normalHeight = CGRectGetHeight(_mouse_0_0_view.frame) + CGRectGetHeight(_mouse_0_1_view.frame) + CGRectGetHeight(_mouse_0_2_view.frame) + CGRectGetHeight(_mouse_0_3_view.frame) + CGRectGetHeight(_mouse_0_4_view.frame);
        
        CGFloat newHeight = normalHeight + CGRectGetHeight(_mouseFingerView.frame);
        
        //keyBoard & preference 位置
        _keyboardView.frame = CGRectMake(_keyboardView.frame.origin.x, CGRectGetMaxY(_mouse_0_4_view.frame), _keyboardView.frame.size.width, _keyboardView.frame.size.height);
        
        _preferenceView.frame = CGRectMake(CGRectGetMinX(_keyboardView.frame), CGRectGetMaxY(_keyboardView.frame), _preferenceView.frame.size.width, _preferenceView.frame.size.height);
        
        //重新定義 scrollView's contentSize
        _setting_scrollView.contentSize = CGSizeMake(_setting_scrollView.frame.size.width, _mouseView.frame.size.height + _keyboardView.frame.size.height + _preferenceView.frame.size.height + newHeight);
        
        _setting_scrollView.contentOffset = CGPointMake(0, _mouseView.frame.size.height + _mouse_0_0_view.frame.size.height);
    }
    else {
        
        
        //尺規1 icon 未按圖示
        [ary_showFingerBt[1] setImage:[UIImage imageNamed:@"config_btn_a_rule_up"] forState:UIControlStateNormal];
        
        [self refreshScrollViewInMouseOrigin];
        
    }
    
}

//mouse-Ballistics
-(void)fingerCase2 {
    
    [self refreshScrollViewInMouseOrigin];
    
    [self allMouseSubViewHidden:NO];
    
    _mouseFingerView.hidden = NO;
    
    isfingerCase2open = isfingerCase2open == YES ? NO : YES;
    isFingerCase0open = NO;
    isFingerCase1open = NO;
    isFingerCase3open = NO;
    isFingerCase4open = NO;
    
    if (isfingerCase2open) {
        
        
        //尺規2 icon 按下圖示
        [ary_showFingerBt[2] setImage:[UIImage imageNamed:@"config_btn_a_rule_down"] forState:UIControlStateNormal];
        
        
        //重新排序
        _mouse_0_0_view.frame = CGRectMake(_mouse_0_0_view.frame.origin.x,_mouse_0_0_view.frame.origin.y,_mouse_0_0_view.frame.size.width , _mouse_0_0_view.frame.size.height);
        
        
        _mouse_0_1_view.frame = CGRectMake(_mouse_0_0_view.frame.origin.x, CGRectGetMaxY(_mouse_0_0_view.frame), _mouse_0_1_view.frame.size.width, _mouse_0_1_view.frame.size.height);
        
        
        _mouse_0_2_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_1_view.frame), _mouse_0_2_view.frame.size.width,_mouse_0_2_view.frame.size.height);
        
        
        _mouse_0_3_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_2_view.frame),  _mouse_0_3_view.frame.size.width, _mouse_0_3_view.frame.size.height);
        
        _mouseFingerView.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouse_0_3_view.frame), _mouseFingerView.frame.size.width, _mouseFingerView.frame.size.height);
        
        
        _mouse_0_4_view.frame = CGRectMake(CGRectGetMinX(_mouse_0_0_view.frame), CGRectGetMaxY(_mouseFingerView.frame),_mouse_0_4_view.frame.size.width,_mouse_0_4_view.frame.size.height);
        
        CGFloat normalHeight = CGRectGetHeight(_mouse_0_0_view.frame) + CGRectGetHeight(_mouse_0_1_view.frame) + CGRectGetHeight(_mouse_0_2_view.frame) + CGRectGetHeight(_mouse_0_3_view.frame) + CGRectGetHeight(_mouse_0_4_view.frame);
        
        CGFloat newHeight = normalHeight + CGRectGetHeight(_mouseFingerView.frame);
        
        //keyBoard & preference 位置
        _keyboardView.frame = CGRectMake(_keyboardView.frame.origin.x, CGRectGetMaxY(_mouse_0_4_view.frame), _keyboardView.frame.size.width, _keyboardView.frame.size.height);
        
        _preferenceView.frame = CGRectMake(CGRectGetMinX(_keyboardView.frame), CGRectGetMaxY(_keyboardView.frame), _preferenceView.frame.size.width, _preferenceView.frame.size.height);
        
        //重新定義 scrollView's contentSize
        _setting_scrollView.contentSize = CGSizeMake(_setting_scrollView.frame.size.width, _mouseView.frame.size.height + _keyboardView.frame.size.height + _preferenceView.frame.size.height + newHeight);
        
        _setting_scrollView.contentOffset = CGPointMake(0, _mouseView.frame.size.height + _mouse_0_0_view.frame.size.height + _mouse_0_1_view.frame.size.height + _mouse_0_2_view.frame.size.height);

    }
    else {
        
        //尺規2 icon 未按圖示
        [ary_showFingerBt[2] setImage:[UIImage imageNamed:@"config_btn_a_rule_up"] forState:UIControlStateNormal];
        
        [self refreshScrollViewInMouseOrigin];
        
        self.setting_scrollView.contentOffset = CGPointMake(0, _mouseView.frame.size.height + _mouse_0_0_view.frame.size.height + _mouse_0_1_view.frame.size.height + _mouse_0_2_view.frame.size.height);
        
    }
    
    
}

//preference-shootingSpeed下方
-(void)fingerCase3 {
    
    [self refreshScrollViewInPreferenceOrigin];
    
    [self allPreferenceSubViewHidden:NO];
    
    _mouseFingerView.hidden = NO;
    
    isFingerCase3open = isFingerCase3open == YES ? NO : YES;
    isFingerCase0open = NO;
    isFingerCase1open = NO;
    isfingerCase2open = NO;
    isFingerCase4open = NO;
    
    
    if (isFingerCase3open) {
        
        //尺規3 icon 按下圖示
        [ary_showFingerBt[3] setImage:[UIImage imageNamed:@"config_btn_a_rule_down"] forState:UIControlStateNormal];
        
        
        //keyBoard & preference 位置
        _keyboardView.frame = CGRectMake(_mouseFingerView.frame.origin.x, CGRectGetMaxY(_mouseView.frame), _keyboardView.frame.size.width, _keyboardView.frame.size.height);
        
        _preferenceView.frame = CGRectMake(CGRectGetMinX(_keyboardView.frame), CGRectGetMaxY(_keyboardView.frame), _preferenceView.frame.size.width, _preferenceView.frame.size.height);
        
        
        //重新排序
        _preference_0_0_view.frame = CGRectMake(_preferenceView.frame.origin.x, CGRectGetMaxY(_preferenceView.frame), _preference_0_0_view.frame.size.width, _preference_0_0_view.frame.size.height);
        
        _mouseFingerView.frame = CGRectMake(CGRectGetMinX(_preference_0_0_view.frame), CGRectGetMaxY(_preference_0_0_view.frame), _mouseFingerView.frame.size.width, _mouseFingerView.frame.size.height);
        
        _preference_0_1_view.frame = CGRectMake(CGRectGetMinX(_preference_0_0_view.frame), CGRectGetMaxY(_mouseFingerView.frame), _preference_0_1_view.frame.size.width, _preference_0_1_view.frame.size.height);
        
        _preference_0_2_view.frame = CGRectMake(CGRectGetMinX(_preference_0_0_view.frame), CGRectGetMaxY(_preference_0_1_view.frame), _preference_0_2_view.frame.size.width, _preference_0_2_view.frame.size.height);
        
        _preference_0_3_view.frame = CGRectMake(CGRectGetMinX(_preference_0_0_view.frame), CGRectGetMaxY(_preference_0_2_view.frame), _preference_0_3_view.frame.size.width, _preference_0_3_view.frame.size.height);
        
        CGFloat normalHeight = CGRectGetHeight(_preference_0_0_view.frame) + CGRectGetHeight(_preference_0_1_view.frame) + CGRectGetHeight(_preference_0_2_view.frame) + CGRectGetHeight(_preference_0_3_view.frame);
        
        CGFloat newHeight = normalHeight + CGRectGetHeight(_mouseFingerView.frame);
        
        
        //重新定義 scrollView's contentSize
        _setting_scrollView.contentSize = CGSizeMake(_setting_scrollView.frame.size.width, _mouseView.frame.size.height + _keyboardView.frame.size.height + _preferenceView.frame.size.height + newHeight);
        
        _setting_scrollView.contentOffset = CGPointMake(0, _mouseView.frame.size.height + _keyboardView.frame.size.height);
        
    }
    else {
        
        //尺規3 icon 未按圖示
        [ary_showFingerBt[3] setImage:[UIImage imageNamed:@"config_btn_a_rule_up"] forState:UIControlStateNormal];
        
        [self refreshScrollViewInPreferenceOrigin];

    }
    
   
    
}

//preference-Anti recoil 下方
-(void)fingerCase4 {
    
    [self refreshScrollViewInPreferenceOrigin];
    
    [self allPreferenceSubViewHidden:NO];
    
    _mouseFingerView.hidden = NO;
    
    isFingerCase4open = isFingerCase4open == YES ? NO : YES;
    isFingerCase0open = NO;
    isFingerCase1open = NO;
    isfingerCase2open = NO;
    isFingerCase3open = NO;
    
    
    if (isFingerCase4open) {
        
        //尺規4 icon 按下圖示
        [ary_showFingerBt[4] setImage:[UIImage imageNamed:@"config_btn_a_rule_down"] forState:UIControlStateNormal];

        //keyBoard & preference 位置
        _keyboardView.frame = CGRectMake(_mouseFingerView.frame.origin.x, CGRectGetMaxY(_mouseView.frame), _keyboardView.frame.size.width, _keyboardView.frame.size.height);
        
        _preferenceView.frame = CGRectMake(CGRectGetMinX(_keyboardView.frame), CGRectGetMaxY(_keyboardView.frame), _preferenceView.frame.size.width, _preferenceView.frame.size.height);
        
        
        //重新排序
        _preference_0_0_view.frame = CGRectMake(_preferenceView.frame.origin.x, CGRectGetMaxY(_preferenceView.frame), _preference_0_0_view.frame.size.width, _preference_0_0_view.frame.size.height);
        
        _preference_0_1_view.frame = CGRectMake(CGRectGetMinX(_preference_0_0_view.frame), CGRectGetMaxY(_preference_0_0_view.frame), _preference_0_1_view.frame.size.width, _preference_0_1_view.frame.size.height);
        
        _preference_0_2_view.frame = CGRectMake(CGRectGetMinX(_preference_0_0_view.frame), CGRectGetMaxY(_preference_0_1_view.frame), _preference_0_2_view.frame.size.width, _preference_0_2_view.frame.size.height);
        
        _preference_0_3_view.frame = CGRectMake(CGRectGetMinX(_preference_0_0_view.frame), CGRectGetMaxY(_preference_0_2_view.frame), _preference_0_3_view.frame.size.width, _preference_0_3_view.frame.size.height);
        
        _mouseFingerView.frame = CGRectMake(CGRectGetMinX(_preference_0_0_view.frame), CGRectGetMaxY(_preference_0_3_view.frame), _mouseFingerView.frame.size.width, _mouseFingerView.frame.size.height);
        
        CGFloat normalHeight = CGRectGetHeight(_preference_0_0_view.frame) + CGRectGetHeight(_preference_0_1_view.frame) + CGRectGetHeight(_preference_0_2_view.frame) + CGRectGetHeight(_preference_0_3_view.frame);
        
        CGFloat newHeight = normalHeight + CGRectGetHeight(_mouseFingerView.frame);
        
        
        //重新定義 scrollView's contentSize
        _setting_scrollView.contentSize = CGSizeMake(_setting_scrollView.frame.size.width, _mouseView.frame.size.height + _keyboardView.frame.size.height + _preferenceView.frame.size.height + newHeight);
        
        _setting_scrollView.contentOffset = CGPointMake(0, _mouseView.frame.size.height + _keyboardView.frame.size.height + _preferenceView.frame.size.height + _preference_0_0_view.frame.size.height + 15);
        
        
    }
    else {
        
        
        //尺規4 icon 未按圖示
        [ary_showFingerBt[4] setImage:[UIImage imageNamed:@"config_btn_a_rule_up"] forState:UIControlStateNormal];
        
        [self refreshScrollViewInPreferenceOrigin];

        self.setting_scrollView.contentOffset = CGPointMake(0, _mouseView.frame.size.height + _keyboardView.frame.size.height);
        
    }
    
    
}

//only for fingerView class
-(void)rulerIndex:(int)index {
    
    switch (index) {
        case 0:
            isFingerCase0open = NO;
            [self refreshScrollViewInMouseOrigin];
            break;
        case 1:
            isFingerCase1open = NO;
            [self refreshScrollViewInMouseOrigin];
            break;
        case 2:
            isfingerCase2open = NO;
            [self refreshScrollViewInMouseOrigin];
            self.setting_scrollView.contentOffset = CGPointMake(0, _mouseView.frame.size.height + _mouse_0_0_view.frame.size.height + _mouse_0_1_view.frame.size.height + _mouse_0_2_view.frame.size.height);
            break;
        case 3:
            isFingerCase3open = NO;
            [self refreshScrollViewInPreferenceOrigin];
            break;
        case 4:
            isFingerCase4open = NO;
            [self refreshScrollViewInPreferenceOrigin];
            self.setting_scrollView.contentOffset = CGPointMake(0, _mouseView.frame.size.height + _keyboardView.frame.size.height);
            break;
        default:
            break;
    }
    
}


-(void)getAllFingerValue {
    
    currentConfigData.hipStr = self.textField_0.text;
    currentConfigData.adsStr = self.textField_1.text;
    currentConfigData.deadZoneStr = self.textField_2.text;
    currentConfigData.shootingSpeedStr = self.textField_3.text;
    currentConfigData.antiRecoilStr = self.textField_4.text;
    
}


- (IBAction)syncBtAction:(UIButton *)sender {
    
    isSync = isSync == YES ? NO : YES;
    
    if (isSync == YES) {
        
        [sender setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
        
        self.syncLabel.alpha = 1.0;
        
        //ADS 無效
        self.textField_1.text = self.textField_0.text;
        self.textField_1.textColor = [UIColor grayColor];
        self.textField_1.userInteractionEnabled = NO;
        self.showFingerBt_1.userInteractionEnabled = NO;
        [self.showFingerBt_1 setImage:[UIImage imageNamed:@"config_btn_a_rule_up"] forState:UIControlStateNormal];
        
        self.isSyncOrNot = YES;
        
        [self refreshScrollViewInMouseOrigin];
    }
    else {
        
        [sender setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
        
        self.syncLabel.alpha = 0.6;
        
        //ADS 生效
        self.textField_1.textColor = [UIColor whiteColor];
        self.textField_1.userInteractionEnabled = YES;
        self.showFingerBt_1.userInteractionEnabled = YES;
        [self.showFingerBt_1 setImage:[UIImage imageNamed:@"config_btn_a_rule_up"] forState:UIControlStateNormal];
        self.isSyncOrNot = NO;
        
        
    }
    
    currentConfigData.isSync = isSync;
    
    //live mode
    [self setFPSConfigData];
    [[ProtocolDataController sharedInstance] liveMode:105 :configData];
    
}


- (IBAction)adsToggleBtAction:(UIButton *)sender {
    
    isADSToggle = isADSToggle == YES ? NO : YES;
    
    if (isADSToggle == YES) {
        
        [sender setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
        
        self.adsToggleLabel.alpha = 1.0;
        
    }
    else {
        
        [sender setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
        
        self.adsToggleLabel.alpha = 0.6;
    }
    
    currentConfigData.isADStoggle = isADSToggle;
    
    //live mode
    [self setFPSConfigData];
    [[ProtocolDataController sharedInstance] liveMode:100 :configData];
}


- (IBAction)shootSpeedAction:(UIButton *)sender {
    
    isShootingSpeed = isShootingSpeed == YES ? NO : YES;
    
    if (isShootingSpeed == YES) {
        
        [sender setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
        
    }
    else {
        
        [sender setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
        
    }
    
    currentConfigData.isShootingSpeed = isShootingSpeed;
    
    //live mode
    [self setFPSConfigData];
    [[ProtocolDataController sharedInstance] liveMode:101 :configData];
}


- (IBAction)invertedAction:(UIButton *)sender {
    
    isInverted = isInverted == YES ? NO : YES;
    
    
    if (isInverted == YES) {
        
        [sender setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
        
    }
    else {
        
        [sender setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
        
    }
    
    currentConfigData.isInverted = isInverted;
    
    //live mode
    [self setFPSConfigData];
    [[ProtocolDataController sharedInstance] liveMode:102 :configData];
}


- (IBAction)sniperBreathAction:(UIButton *)sender {
    
    isSniperBreath = isSniperBreath == YES ? NO : YES;
    
    
    if (isSniperBreath == YES) {
        
        [sender setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
        
    }
    else {
        
        [sender setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
        
    }
    
    currentConfigData.isSniperBreath = isSniperBreath;
    
    //live mode
    [self setFPSConfigData];
    [[ProtocolDataController sharedInstance] liveMode:103 :configData];
}


- (IBAction)antiRecoilAction:(UIButton *)sender {
    
    isAntiRecoil = isAntiRecoil == YES ? NO : YES;
    
    if (isAntiRecoil == YES) {
        
        [sender setImage:[UIImage imageNamed:@"select_icon_a_02"] forState:UIControlStateNormal];
        
    }
    else {
        
        [sender setImage:[UIImage imageNamed:@"select_icon_a_01"] forState:UIControlStateNormal];
        
    }
    
    currentConfigData.isAntiRecoil = isAntiRecoil;
    
    //live mode
    [self setFPSConfigData];
    [[ProtocolDataController sharedInstance] liveMode:104 :configData];
}



#pragma mark - 點擊 keyboard 畫面分割往兩側滑出
-(void)slideOut:(UIView *)theLeftView RightView:(UIView *)theRightView {
    
    //NO: keyboard 頁面
    isEditOrKeyboard = NO;
    
    [UIView animateWithDuration:2.0 animations:^{
        
        //左邊的view 向左滑出畫面
        theLeftView.frame = CGRectMake(CGRectGetMinX(self.view.frame) - 1.5*theLeftView.frame.size.width, 0, theLeftView.frame.size.width, theLeftView.frame.size.height);
        
        //右邊的view 向右滑出畫面
        theRightView.frame = CGRectMake(self.view.frame.size.width + 1.5*theRightView.frame.size.width, 0, theRightView.frame.size.width, theRightView.frame.size.height);
        
        //遙桿畫面出現
        _remoteControl.alpha = 1.0;
        _remoteControl.userInteractionEnabled = YES;
        
        
    } completion:nil];
    
}

#pragma mark - 從 keyboard 返回 edit 頁面
- (IBAction)backToEditVC:(UIButton *)sender {
    
    
    [[ProtocolDataController sharedInstance] stopListeningResponse];
    //    [self cancelTimer];
    
    for (int j = 0; j < ary_keymap.count; j++) {
        
        if ([ary_keymapIsSelected[j] isEqualToString:@"1"]) {
            
            int oriKeycodeInt = [currentConfigData.keyMap[j] intValue];
            
            NSString *oriKetcodeStr = [keyCodeClass returnKeyboardKey:oriKeycodeInt];
            
            [ary_keymap[j]setTitle:oriKetcodeStr forState:UIControlStateNormal];
            
            ary_keymapIsSelected[j] = @"0";
        }
        
    }
    
    
    
    
    isEditOrKeyboard = YES;
    
    //遙感畫面淡出
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.view viewWithTag:4002].hidden = YES;
        
        //遙桿畫面淡出
        _remoteControl.alpha = 0.0;
        _remoteControl.userInteractionEnabled = NO;
        
        //左邊的view 滑進畫面
        _leftView.frame = CGRectMake(CGRectGetMinX(self.view.frame), 0, _leftView.frame.size.width, _leftView.frame.size.height);
        
        //右邊的view 滑進畫面
        _rightView.frame = CGRectMake(rightViewPoint.x, rightViewPoint.y, _rightView.frame.size.width, _rightView.frame.size.height);
        
    } completion:nil];
    
    
    
    // }
    
}


/*
 各遙桿頁面 與 設定鍵 配置,storyboard 中以 PS4 為基礎:
 1.PS3 -> PS4:多一個tab鍵,且原 PS3 的 Esc 鍵與 tab 鍵對調
 2.PS3 -> Xbox 360 或 Xbox One: 多一個 tab鍵
 a.原 PS3 的 None鍵 消失,由 PS3 的 Enter鍵 取代
 b.原 PS3 的 Enter鍵 被 新增的 tab鍵 取代
 c.原 PS3 的 Right鍵 與 Q鍵 互換
 d.原 PS3 的 Left鍵 與 G鍵 互換
 e.原 PS3 的 wasd鍵 與 上下左右箭頭鍵 互換
 以上為舊版
 */
#pragma mark - 不同遙桿畫面所對應的設定按鈕
-(void)differentMachineCorrespondBts:(NSString *)machineName {
    
    //依 2016.10.06 客戶bug 修正
    //ps4 -> ps3: None 隱藏,由 Tab 取代
    //ps4 -> ps3: Esc位置 變成 Tab位置
    
    //ps4 -> One or 360: None 隱藏,由 Tab 取代
    //ps4 -> One or 360: Esc位置 變成 Tab位置
    //ps4 -> One or 360: wasd位置 與 上下左右 互換
    //ps4 -> One or 360: Q 與 Right 互換, G 與 Left 互換
    
    if ([machineName isEqualToString:@"PS3"]) {
        
        //ps4 -> ps3: None 隱藏,由 Tab 取代
        _NoneBt_View.hidden = YES;
        
        _TabBt_view.center = ori_NoneBt_center;
        
        
        //ps4 -> ps3: Esc位置 變成 Tab位置
        _EscBt_view.center = ori_TabBt_center;
        
        
        //PS3 有 None鍵 ,但無 Tab鍵
        //_TabBt_view.alpha = 0.0;
        //_TabBt_view.userInteractionEnabled = NO;
        
        //_NoneBt_View.alpha = 1.0;
        //_NoneBt_View.userInteractionEnabled = YES;
        
        //a.原 PS3 的 None鍵
        //_NoneBt_View.center = ori_NoneBt_center;
        
        //b.原 PS3 的 Enter鍵
        //_EnterBt_view.center = ori_Enter_center;
        
        //c.原 PS3 的 Right鍵 與 Q鍵
        _RightBt_view.center = ori_RightBt_center;
        _Qbt_view.center = ori_QBt_center;
        
        //d.原 PS3 的 Left鍵 與 G鍵
        _LeftBt_view.center = ori_LeftBt_center;
        _GBt_view.center = ori_GBt_center;
        
        //e.原 PS3 的 wasd鍵 與 上下左右箭頭鍵
        _ArrowBt_view.center = ori_ArrowBt_center;
        _WASDBt_view.center = ori_WASDBt_center;
        
        //原 PS3 的 Esc 鍵與 tab
        //_EscBt_view.center = ori_TabBt_center;
        //_TabBt_view.center = ori_EscBt_center;
        
        
    }
    else if ([machineName isEqualToString:@"PS4"]) {
        
        //PS4 有 None鍵
        _NoneBt_View.hidden = NO;
        _NoneBt_View.center = ori_NoneBt_center;
        
        //Tab 與 Esc 歸原位
        _TabBt_view.center = ori_TabBt_center;
        
        _EscBt_view.center = ori_EscBt_center;
        
        
        //_TabBt_view.alpha = 1.0;
        //_TabBt_view.userInteractionEnabled = YES;
        
        //_NoneBt_View.alpha = 1.0;
        //_NoneBt_View.userInteractionEnabled = YES;
        
        //a.原 PS3 的 None鍵
       // _NoneBt_View.center = ori_NoneBt_center;
        
        //b.原 PS3 的 Enter鍵
       // _EnterBt_view.center = ori_Enter_center;
        
        //c.原 PS3 的 Right鍵 與 Q鍵
        _RightBt_view.center = ori_RightBt_center;
        _Qbt_view.center = ori_QBt_center;
        
        //d.原 PS3 的 Left鍵 與 G鍵
        _LeftBt_view.center = ori_LeftBt_center;
        _GBt_view.center = ori_GBt_center;
        
        //e.原 PS3 的 wasd鍵 與 上下左右箭頭鍵
        _ArrowBt_view.center = ori_ArrowBt_center;
        _WASDBt_view.center = ori_WASDBt_center;
        
        //原 PS3 的 Esc 鍵與 tab 鍵對調
        //nick
        //_EscBt_view.center = ori_EscBt_center;
        //_TabBt_view.center = ori_TabBt_center;
        
    }
    else if ([machineName isEqualToString:@"Xbox 360"]) {
        
        //ps4 -> One or 360: None 隱藏,由 Tab 取代
        _NoneBt_View.hidden = YES;
        
        _TabBt_view.center = ori_NoneBt_center;
        
        
        //ps4 -> One or 360: Esc位置 變成 Tab位置
        _EscBt_view.center = ori_TabBt_center;
        
        
        
        //360 有 Tab鍵 ,但無 None鍵
        //_TabBt_view.alpha = 1.0;
        //_TabBt_view.userInteractionEnabled = YES;
        
        //_NoneBt_View.alpha = 0.0;
        //_NoneBt_View.userInteractionEnabled = NO;
        
        //a.原 PS3 的 None鍵 消失,由 PS3 的 Enter鍵 取代
        //_EnterBt_view.center = ori_NoneBt_center;
        
        //b.原 PS3 的 Enter鍵 被 新增的 tab鍵 取代
        //_TabBt_view.center = ori_Enter_center;
        
        //c.原 PS3 的 Right鍵 與 Q鍵 互換
        _RightBt_view.center = ori_QBt_center;
        _Qbt_view.center = ori_RightBt_center;
        
        //d.原 PS3 的 Left鍵 與 G鍵 互換
        _LeftBt_view.center = ori_GBt_center;
        _GBt_view.center = ori_LeftBt_center;
        
        //e.原 PS3 的 wasd鍵 與 上下左右箭頭鍵 互換
        _ArrowBt_view.center = CGPointMake(ori_WASDBt_center.x + 30, ori_WASDBt_center.y + 15);
        _WASDBt_view.center = ori_ArrowBt_center;
        
        //原 PS3 的 Esc 鍵
        //_EscBt_view.center = ori_TabBt_center;
        
        
    }
    else if ([machineName isEqualToString:@"Xbox One"]) {
        
        //ps4 -> One or 360: None 隱藏,由 Tab 取代
        _NoneBt_View.hidden = YES;
        
        _TabBt_view.center = _NoneBt_View.center;
        
        //ps4 -> One or 360: Esc位置 變成 Tab位置
        _EscBt_view.center = ori_TabBt_center;
        
        
        //One 有 Tab鍵 ,但無 None鍵
        //_TabBt_view.alpha = 1.0;
        //_TabBt_view.userInteractionEnabled = YES;
        
        //_NoneBt_View.alpha = 0.0;
        //_NoneBt_View.userInteractionEnabled = NO;
        
        //a.原 PS3 的 None鍵 消失,由 PS3 的 Enter鍵 取代
        //_EnterBt_view.center = ori_NoneBt_center;
        
        //b.原 PS3 的 Enter鍵 被 新增的 tab鍵 取代
        //_TabBt_view.center = ori_Enter_center;
        
        //c.原 PS3 的 Right鍵 與 Q鍵 互換
        _RightBt_view.center = ori_QBt_center;
        _Qbt_view.center = ori_RightBt_center;
        
        //d.原 PS3 的 Left鍵 與 G鍵 互換
        _LeftBt_view.center = ori_GBt_center;
        _GBt_view.center = ori_LeftBt_center;
        
        //e.原 PS3 的 wasd鍵 與 上下左右箭頭鍵 互換
        _ArrowBt_view.center = CGPointMake(ori_WASDBt_center.x + 30, ori_WASDBt_center.y + 15);
        _WASDBt_view.center = ori_ArrowBt_center;
        
        //原 PS3 的 Esc 鍵
        //_EscBt_view.center = ori_TabBt_center;
        
    }
    else {
        
        return;
    }
    
}

#pragma mark - 點擊遙桿按鈕觸發方法
-(void)keyMapAction:(UIButton *)bt withEvent:(UIEvent*)event {
    
    UITouch* touch = [[event allTouches] anyObject];
    
    
    if (touch.tapCount == 2) {
        //當bt連續點擊兩下時

        isTapTwice = YES;
        
        [[ProtocolDataController sharedInstance] stopListeningResponse];
        
        isConfigHotKeyCallResponseMode = NO;
        isKeyboardCallResponseMode = NO;
        isSniperBreathCallResponseMode = NO;
        isAntiRecoilCallResponseMode = NO;
        
        //
        for (int i = 0; i < ary_keymap.count; i++) {
            
            if ([ary_keymapIsSelected[i] isEqualToString:@"1"]) {
                
                currentConfigData.keyMap[i] = [NSNumber numberWithInt:0];
                
                NSString *keyCodeStr = [keyCodeClass returnKeyboardKey:0];
                
                [ary_keymap[i] setTitle:keyCodeStr forState:UIControlStateNormal];
                
                [ary_keymapView[i] changeKeyColor:0];
                
                
                break;
            }
            
        }
        
        
        //
        for (int i = 0; i < ary_keymap.count; i++) {
            
            ary_keymapIsSelected[i] = @"0";
            
        }
        
    }
    
}

-(void)keyMapAction:(UIButton *)bt {
    
    //    [self cancelTimer];
    
    if (isTapTwice) {
        
        isTapTwice = NO;
        
        return;
    }
    
    
    
    for (int j = 0; j < ary_keymap.count; j++) {
        
        if ([ary_keymapIsSelected[j] isEqualToString:@"1"]) {
            
            int oriKeycodeInt = [currentConfigData.keyMap[j] intValue];
            
            NSString *oriKetcodeStr = [keyCodeClass returnKeyboardKey:oriKeycodeInt];
            
            [ary_keymap[j]setTitle:oriKetcodeStr forState:UIControlStateNormal];
            
            ary_keymapIsSelected[j] = @"0";
        }
        
    }
    
    
    
    for (int i = 0; i < ary_keymap.count; i++) {
        
        if (bt == ary_keymap[i]) {
            
            ary_keymapIsSelected[i] = @"1";
        }
        else {
            
            ary_keymapIsSelected[i] = @"0";
        }
    }
    
    [bt setTitle:NSLocalizedString(@"Listening", nil) forState:UIControlStateNormal];
    
    //    [self cancelTimer];
    
    //Keyboard Call ResponseMode ,其他 hotkey設NO
    isConfigHotKeyCallResponseMode = NO;
    isKeyboardCallResponseMode = YES;
    isSniperBreathCallResponseMode = NO;
    isAntiRecoilCallResponseMode = NO;
    
    
    
    [[ProtocolDataController sharedInstance] startListeningResponse];
    //    responseTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startResponseMode) userInfo:nil repeats:YES];
    
}

//- (void)cancelTimer{
//    if(responseTimer != nil){
//        [responseTimer invalidate];
//        responseTimer = nil;
//    }
//}

//keyboard 觸發事件
-(void)startResponseMode{
    
    [[ProtocolDataController sharedInstance] responseMode];
}

-(void)onResponseResponseMode:(int)keyCode{
    
    NSLog(@"config keyCode(代碼) = %d",keyCode);
    
    
    if (keyCode == -1 || keyCode == 255) {
        
        return;
    }
    
    
    [[ProtocolDataController sharedInstance] stopListeningResponse];
    
    
    int breathHotKeyInt = [currentConfigData.sniperBreathHotkey intValue];
    int antiRecoilHotKeyInt = [currentConfigData.antiRecoilHotkey intValue];
    
    NSString *keyCodeStr = [keyCodeClass returnKeyboardKey:keyCode];
    NSString *configHotKeyStr = [keyCodeClass returnKeyboardKey:[currentConfigData.configHotKeyStr intValue]];
    NSString *breathStr = [keyCodeClass returnKeyboardKey:breathHotKeyInt];
    NSString *antiRecoilStr = [keyCodeClass returnKeyboardKey:antiRecoilHotKeyInt];
    
    if ([breathStr isEqualToString:@" "]) {
        breathStr = @"None";
    }
    if ([antiRecoilStr isEqualToString:@" "]) {
        antiRecoilStr = @"None";
    }
    
    
    if (isConfigHotKeyCallResponseMode == YES) {
        
        //keycode 在 F1 ~ F8 範圍外
        if([self checkHotKeyRangeF1F8:keyCode]){
            
            [self resetConfigHotkeyStatus:configHotKeyStr Type:0];
            
            return;
        }
        
        // 判斷 hotkey 是否重覆
        NSMutableArray *configAry = [[ConfigMacroData sharedInstance] getConfigArray];
        
        for (int i = 0; i < configAry.count; i++) {
            
            NSMutableDictionary *configDic = configAry[i];
            
            NSString *hotkeyStr = (NSString *)[configDic objectForKey:@"configHotKey"];
            int hotkeyNum = [hotkeyStr intValue];
            
            if (keyCode == hotkeyNum) {
                
                if (i == self.indexPathRow) {
                    continue;
                }else{
                    [self resetConfigHotkeyStatus:configHotKeyStr Type:1];
                    
                    return;
                }
            }
        }
        
        
        //hotkey 儲存 keycode
        currentConfigData.configHotKeyStr = [[NSString alloc] initWithFormat:@"%i", keyCode];
        [self.configHotkey setTitle:keyCodeStr forState:UIControlStateNormal];
        
    }else if (isSniperBreathCallResponseMode == YES) {
        
        //keycode 在 F1 ~ F10 範圍內
        if (![self checkHotKeyRangeF1F10:keyCode]) {
            
            [self resetBreathHotkeyStatus:breathStr Type:0];
            
            return;
        }
        
        //不能和 keyboard 重覆
        for (int i = 0; i < currentConfigData.keyMap.count; i++) {
            
            if ([currentConfigData.keyMap[i] intValue] == keyCode) {
                
                [self resetBreathHotkeyStatus:breathStr Type:1];
                
                return;
            }
            
        }
        
        //不能和 Anti Recoil 重覆
        if (keyCode == antiRecoilHotKeyInt) {
            
            [self resetBreathHotkeyStatus:breathStr Type:1];
            
            return;
        }
        
        currentConfigData.sniperBreathHotkey = [NSString stringWithFormat:@"%i",keyCode];
        [self.sniperBreathHotkey setTitle:keyCodeStr forState:UIControlStateNormal];
        
        [self.sniperBreathHotkeyView changeKeyColor:keyCode];
        
    }else if (isAntiRecoilCallResponseMode == YES) {
        //config anti recoil hotkey
        
        //keycode 在 F1 ~ F10 範圍內
        if (![self checkHotKeyRangeF1F10:keyCode]) {
            
            [self resetantiRecoilHotkeyStatus:antiRecoilStr Type:0];
            
            return;
        }
        
        //不能和keyboard 重覆
        for (int i = 0; i < currentConfigData.keyMap.count; i++) {
            
            if ([currentConfigData.keyMap[i] intValue] == keyCode) {
                
                [self resetantiRecoilHotkeyStatus:antiRecoilStr Type:1];
                
                return;
            }
        }
        
        //不能和 Sniper Breath重覆
        if (keyCode == breathHotKeyInt) {
            
            [self resetantiRecoilHotkeyStatus:antiRecoilStr Type:1];
            
            return;
            
        }
        
        
        currentConfigData.antiRecoilHotkey = [NSString stringWithFormat:@"%i",keyCode];
        [self.antiRecoilHotkey setTitle:keyCodeStr forState:UIControlStateNormal];
        
        [self.antiRecoilHotkeyView changeKeyColor:keyCode];
        
    }else if (isKeyboardCallResponseMode == YES) {
        //遙感 - keyboard
        
        int keyboardLiveModeNum = 0;
        
        for (int i = 0; i < ary_keymap.count; i++) {
            
            if ([ary_keymapIsSelected[i] isEqualToString:@"1"]) {
                
                int currentKeyboardKeyCode = [currentConfigData.keyMap[i] intValue];
                NSString *KeyboardKeyCodeStr = [keyCodeClass returnKeyboardKey:currentKeyboardKeyCode];
                if ([KeyboardKeyCodeStr isEqualToString:@" "]) {
                    KeyboardKeyCodeStr = @"None";
                }
                
                //keycode 在 F1 ~ F10 範圍內
                if (![self checkHotKeyRangeF1F10:keyCode]) {
                    
                    [self resetantiKeyboardHotKeyStatus:KeyboardKeyCodeStr Type:0 Index:i];
                    
                    return;
                }
                
                //不可以與 sniperBreathHotKey 重覆
                if (keyCode == breathHotKeyInt) {
                    
                    [self resetantiKeyboardHotKeyStatus:KeyboardKeyCodeStr Type:1 Index:i];
                    
                    return;
                }
                
                //不可以與Anti Recoil 重覆
                if(keyCode == antiRecoilHotKeyInt) {
                    
                    [self resetantiKeyboardHotKeyStatus:KeyboardKeyCodeStr Type:1 Index:i];
                    
                    return;
                }
                
                //不可以與 macro 快捷鍵重覆
                NSMutableArray *macroArray = [[ConfigMacroData sharedInstance] getMacroArray];
                
                for (int j = 0; j < macroArray.count; j++) {
                    
                    NSString *macroHotkey = [macroArray[j] objectForKey:@"macroHotkey"];
                    
                    if (keyCode == [macroHotkey intValue]) {
                        
                        //keyCode = currentKeyboardKeyCode;
                        
                        [self resetantiKeyboardHotKeyStatus:KeyboardKeyCodeStr Type:1 Index:i];
                        return;
                    }
                    
                }
                
                //22個熱鍵彼此之間也不可重覆
                for (int j = 0; j < ary_keymap.count; j++) {
                    
                    if([currentConfigData.keyMap[j] intValue] == keyCode) {
                        //重新設定到原本的值
                        if (j == i) {
                            
                            //keyboardLiveModeNum = j;
                            
                            [ary_keymapView[j] changeKeyColor:keyCode];
                            
                        }else {
                            
                            ary_keymapIsSelected[i] = @"0";
                            
                            [self resetantiKeyboardHotKeyStatus:KeyboardKeyCodeStr Type:1 Index:i];
                            
                        }
                        
                        return;
                    }
                }
                
                keyboardLiveModeNum = i;
                
                
                currentConfigData.keyMap[keyboardLiveModeNum] = [NSNumber numberWithInt:keyCode];
                [ary_keymap[keyboardLiveModeNum] setTitle:keyCodeStr forState:UIControlStateNormal];
                
                ary_keymapIsSelected[keyboardLiveModeNum] = @"0";
                
                [ary_keymapView[keyboardLiveModeNum] changeKeyColor:keyCode];
            }
            
        }
        
        [self setFPSConfigData];
        
        //live mode
        if (keyboardLiveModeNum >= 0 && keyboardLiveModeNum < 5) {
            
            [[ProtocolDataController sharedInstance]liveMode:11 :configData];
            
            
        }else if (keyboardLiveModeNum >= 5 && keyboardLiveModeNum < 21) {
            
            [[ProtocolDataController sharedInstance]liveMode:12 :configData];
            

            
        }else {
            
            [[ProtocolDataController sharedInstance]liveMode:13 :configData];
        
        }
        
    }
    
    
    //成功選定熱鍵後
    isConfigHotKeyCallResponseMode = NO;
    isKeyboardCallResponseMode = NO;
    isSniperBreathCallResponseMode = NO;
    isAntiRecoilCallResponseMode = NO;
    
}


#pragma mark - 上下左右箭頭
-(void)showkeyboardArrow {
    
    //arrow up
    if (currentConfigData.keyMap[0].intValue == 82) {
        
        [ary_keymap[0] setTitle:@"" forState:UIControlStateNormal];
        
        self.arrowUp.hidden = NO;
    }
    else {
        
        self.arrowUp.hidden = YES;
    }
    
    //arrow left
    if (currentConfigData.keyMap[3].intValue == 80) {
        
        [ary_keymap[3] setTitle:@"" forState:UIControlStateNormal];
        
        self.arrowLeft.hidden = NO;
    }
    else {
        
        self.arrowLeft.hidden = YES;
    }
    
    //arrow right
    if (currentConfigData.keyMap[1].intValue == 79) {
        
        [ary_keymap[1] setTitle:@"" forState:UIControlStateNormal];
        
        self.arrowRight.hidden = NO;
    }
    else {
        
        self.arrowRight.hidden = YES;
    }
    
    //arrow down
    if (currentConfigData.keyMap[2].intValue == 81) {
        
        [ary_keymap[2] setTitle:@"" forState:UIControlStateNormal];
        
        self.arrowDown.hidden = NO;
    }
    else {
        
        self.arrowDown.hidden = YES;
    }
    
}


#pragma mark - Ballistics action
- (IBAction)xLeftAction:(id)sender {
    if (xPointValue > 0) {
        xPointValue --;
        [self xValueIschanged:xPointValue];
    }
}

- (IBAction)xRightAction:(id)sender {
    if (xPointValue < 20) {
        xPointValue ++;
        [self xValueIschanged:xPointValue];
    }
}

- (IBAction)yDownAction:(id)sender {
    if (yPointValue > 0 && xPointValue != 0) {
        yPointValue --;
        [self yValueIschanged:yPointValue];
        currentConfigData.ballistics_Y_value = [curveView returnBallisticPoints];
        currentConfigData.ballistics_changed = [curveView returnBallisticChange];
    }
}

- (IBAction)yUpAction:(id)sender {
    if (yPointValue < 100 && xPointValue != 0) {
        yPointValue ++;
        [self yValueIschanged:yPointValue];
        currentConfigData.ballistics_Y_value = [curveView returnBallisticPoints];
        currentConfigData.ballistics_changed = [curveView returnBallisticChange];
    }
}

//詢問是否歸零
- (IBAction)askForReset:(UIButton *)sender {
    
    //詢問視窗彈出
    self.resetWindow.hidden = NO;
    
}

- (IBAction)resetOrNot:(UIButton *)sender {
    
    if (sender.tag == 1) {
        
        [self reset:sender];
        
        self.resetWindow.hidden = YES;
    }
    else if (sender.tag == 2) {
        
        self.resetWindow.hidden = YES;
    }
    
}


//初始化曲線
-(void)reset:(UIButton *)sender {
    
    [curveView initPointsData:nil];
    
    xPointValue = 0;
    yPointValue = 0;
    
    [self xValueIschanged:xPointValue];
    [self yValueIschanged:yPointValue];
    
    self.xValueLabel.text = [NSString stringWithFormat:@"%d",xPointValue];
    self.yValueLabel.text = [NSString stringWithFormat:@"%.0f",yPointValue];
    
    [curveView setNeedsDisplay];
    
}

//傳X值給圖表切換X指標線位置
-(void)xValueIschanged:(int)xPointInt{
    
    [curveView setXLinePosition:xPointInt];
    
    yPointValue = [curveView getYPointValue];
    
    self.xValueLabel.text = [NSString stringWithFormat:@"%d",xPointValue*5];
    
    self.yValueLabel.text = [NSString stringWithFormat:@"%.0f",yPointValue];
    
}

//傳Y值給圖表並重畫曲線
-(void)yValueIschanged:(float)yPointFloat{
    
    self.yValueLabel.text = [NSString stringWithFormat:@"%.0f",yPointValue];
    
    NSNumber *pointX = [NSNumber numberWithFloat:xPointValue];
    NSNumber *pointY = [NSNumber numberWithFloat:yPointValue];
    
    NSMutableDictionary *pointDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      pointX,@"xPoint",
                                      pointY,@"yPoint",nil];
    
    [curveView setYPointValue:pointDict];
    
    [curveView setNeedsDisplay];
}

#pragma mark - Touch Event
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if(!isEditOrKeyboard)
        return;
    
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(finger.frame, point)) {
        
        return;
    }
    
    //LED_Color 隱藏 - saveCancel 顯示
    isColorBarAction = NO;
    finger.userInteractionEnabled = NO;
    [finger stopAnimating];
    
    [UIView animateWithDuration:0.38 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //colorBar 隱藏
        _colorBar.alpha = 0.0;
        _colorBar_bgView.alpha = 0.0;
        _fingerPrint.alpha = 0.0;
        
        
        //_saveCancelView 回原位
        _saveCancelView.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMaxY(self.view.frame) - _saveCancelView.frame.size.height, _saveCancelView.frame.size.width, _saveCancelView.frame.size.height);
        
    } completion:nil];
    
    
    
    [self hiddeAllTextFieldKeyboard];
    
    //mouse & preference 指紋
    if ([self.textFieldValue isFirstResponder]) {
        
        int value = [self getvalueFormTextField:self.textFieldValue];
        
        [self.mouseFingerView getPointFrom:value];
        
        [self.textFieldValue resignFirstResponder];
    }
    
    
    //盲區
    
    self.yValueLabel.text = [NSString stringWithFormat:@"%.0f",yPointValue];
    
    [self.yValueLabel resignFirstResponder];
    
}






//mouse & keyboard
-(int)getvalueFormTextField:(UITextField *)textField {
    
    int value = [textField.text intValue];
    
    return value;
}

#pragma mark - liveModeForFingerView
-(void)liveModeForFingerView {
    
    if(!isEditOrKeyboard)
        return;
    
    /*
     live mode
     2:HIP
     3:ADS
     4:DeadZone
     9:ShootingSpeed
     8:AntiRecoil
     */
    [self setFPSConfigData];
    [[ProtocolDataController sharedInstance]liveMode:2 :configData];
    [[ProtocolDataController sharedInstance]liveMode:3 :configData];
    [[ProtocolDataController sharedInstance]liveMode:4 :configData];
    [[ProtocolDataController sharedInstance]liveMode:9 :configData];
    [[ProtocolDataController sharedInstance]liveMode:8 :configData];
}


#pragma  mark - textFieldDidChange
-(void)textFieldDidChange :(UITextField *) textField {
    
    if(textField == self.configFileName) {
        
        [self checkTextViewTextLength];
    }
    
    
    
    if (textField == _textField_0 || textField == _textField_1 || textField == _textField_2 || textField == _textField_3 || textField == _textField_4) {
        
        if (textField.text.length > 0) {
            
            if ([[textField.text substringToIndex:1] intValue] == 0) {
                
                textField.text = @"1";
            }
            
            if (textField.text.length >= 3) {
                
                if ([[textField.text substringWithRange:NSMakeRange(0, 3)] intValue] >= 100) {
                    
                    textField.text = @"100";
                }
                
            }
            
        }
        
        
        if (self.isSyncOrNot == YES) {
            
            _textField_1.text = _textField_0.text;
            
        }
        
    }
    
    
    //盲區
    if (textField == self.yValueLabel) {
        
        if (textField.text.length > 0) {
            
            if (xPointValue == 0) {
                textField.text = @"0";
                return;
            }
            
            if ([[textField.text substringToIndex:1] intValue] == 0) {
                textField.text = @"0";
            }
            
            if (textField.text.length >= 3) {
                if([[textField.text substringWithRange:NSMakeRange(0, 3)]intValue] == 100){
                    
                    textField.text = [textField.text substringWithRange:NSMakeRange(0, 3)];
                }
            }
            
            if ([textField.text intValue] >100) {
                
                textField.text = [textField.text substringWithRange:NSMakeRange(0, 2)];
            }
            
            yPointValue = [textField.text intValue];
            
            [self yValueIschanged:yPointValue];
            
            self.yValueLabel.text = [NSString stringWithFormat:@"%.0f",yPointValue];
            
            [curveView setNeedsDisplay];
        }
        
    }
    
}


//計算字元長度
-(void)checkTextViewTextLength {
    
    if (self.configFileName.text.length != 0) {
        
        NSString *infoStr = self.configFileName.text;
        
        NSUInteger charCount = 0;
        
        for(int i=0 ; i < self.configFileName.text.length ;i++){
            
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
                
                self.configFileName.text = [self.configFileName.text substringWithRange:NSMakeRange(0, self.configFileName.text.length-1)];
            }
            
        }
        
    }
    
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.configFileName.text isEqualToString:@""]) {
        
        self.configFileName.text = currentConfigData.configFileName;
    }
    
    
    [textField resignFirstResponder];
    
    self.rightView.frame = CGRectMake(rightViewOriLoaction.x, rightViewOriLoaction.y, self.rightView.frame.size.width, self.rightView.frame.size.height);
    
    self.leftView.frame = CGRectMake(leftViewOriLocation.x, leftViewOriLocation.y, self.leftView.frame.size.width, self.leftView.frame.size.height);
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.textField_4 || textField == self.textField_3) {
        
        self.rightView.frame = CGRectMake(rightViewOriLoaction.x, rightViewOriLoaction.y - self.rightView.frame.size.height/2.5, self.rightView.frame.size.width, self.rightView.frame.size.height);
    }
    else if (textField == self.configFileName) {
        
        self.leftView.frame = CGRectMake(leftViewOriLocation.x, leftViewOriLocation.y - 20, self.leftView.frame.size.width, self.leftView.frame.size.height);
    }
    
    
    return YES;
}


#pragma mark - 快捷鍵設定(只限 F1 ~ F8)
- (IBAction)hotKeySetting:(UIButton *)sender {
    
    //    [self cancelTimer];
    
    int hotkeyInt = [currentConfigData.configHotKeyStr intValue];
    NSString *hotkeyStr = [keyCodeClass returnKeyboardKey:hotkeyInt];
    [self.configHotkey setTitle:hotkeyStr forState:UIControlStateNormal];
    
    
    [sender setTitle:@"Listening" forState:UIControlStateNormal];
    
    //configHotkey call ResonseMode,其他 hotkey設NO
    isConfigHotKeyCallResponseMode = YES;
    isKeyboardCallResponseMode = NO;
    isSniperBreathCallResponseMode = NO;
    isAntiRecoilCallResponseMode = NO;
    
    
    [[ProtocolDataController sharedInstance] startListeningResponse];
    //    responseTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startResponseMode) userInfo:nil repeats:YES];
    
}

#pragma mark - sniperBreathHotkeyAction
- (IBAction)sniperBreathHotkeyAction:(UIButton *)sender {
    
    //    [self cancelTimer];
    
    if (isTapTwice) {
        
        isTapTwice = NO;
        return;
    }
    
    
    
    int sniperBreathInt = [currentConfigData.sniperBreathHotkey intValue];
    NSString *sniperBreathStr = [keyCodeClass returnKeyboardKey:sniperBreathInt];
    [self.sniperBreathHotkey setTitle:sniperBreathStr forState:UIControlStateNormal];
    
    
    [self.sniperBreathHotkey setTitle:NSLocalizedString(@"Listening", nil)  forState:UIControlStateNormal];
    
    //SniperBreath Call ResponseMode ,其他 hotkey設NO
    isConfigHotKeyCallResponseMode = NO;
    isKeyboardCallResponseMode = NO;
    isSniperBreathCallResponseMode = YES;
    isAntiRecoilCallResponseMode = NO;
    
    
    [[ProtocolDataController sharedInstance] startListeningResponse];
    //    responseTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startResponseMode) userInfo:nil repeats:YES];
    
}

-(void)setSniperBreathBtTapTwiceAction:(UIButton *)bt withEvent:(UIEvent*)event {
    
    UITouch *touch = [[event allTouches] anyObject];

    if (touch.tapCount == 2) {
        
        isTapTwice = YES;
        
        [[ProtocolDataController sharedInstance] stopListeningResponse];
        
        isConfigHotKeyCallResponseMode = NO;
        isKeyboardCallResponseMode = NO;
        isSniperBreathCallResponseMode = NO;
        isAntiRecoilCallResponseMode = NO;

        currentConfigData.sniperBreathHotkey = [NSString stringWithFormat:@"0"];
        
        NSString *sniperBreathStr = [keyCodeClass returnKeyboardKey:0];
        
        [self.sniperBreathHotkey setTitle:sniperBreathStr forState:UIControlStateNormal];
        
        [self.sniperBreathHotkeyView changeKeyColor:0];
        
    }
    
}



#pragma mark - antiRecoilHotkeyAction
- (IBAction)antiRecoilHotkeyAction:(UIButton *)sender {
    
    //    [self cancelTimer];
    
    
    if (isTapTwice) {
        
        isTapTwice = NO;
        return;
    }
    
    int antiRecoilInt = [currentConfigData.antiRecoilHotkey intValue];
    NSString *antiRecoilStr = [keyCodeClass returnKeyboardKey:antiRecoilInt];
    [self.antiRecoilHotkey setTitle:antiRecoilStr forState:UIControlStateNormal];
    
    
    [self.antiRecoilHotkey setTitle:@"Listening" forState:UIControlStateNormal];
    
    //Anti Recoil Call ResponseMode ,其他 hotkey設NO
    isConfigHotKeyCallResponseMode = NO;
    isKeyboardCallResponseMode = NO;
    isSniperBreathCallResponseMode = NO;
    isAntiRecoilCallResponseMode = YES;
    
    
    [[ProtocolDataController sharedInstance] startListeningResponse];
    //    responseTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startResponseMode) userInfo:nil repeats:YES];
    
}

-(void)setantiRecoilBtTapTwiceAction:(UIButton *)bt withEvent:(UIEvent*)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (touch.tapCount == 2) {
        
        isTapTwice = YES;
        
        [[ProtocolDataController sharedInstance] stopListeningResponse];
        
        isConfigHotKeyCallResponseMode = NO;
        isKeyboardCallResponseMode = NO;
        isSniperBreathCallResponseMode = NO;
        isAntiRecoilCallResponseMode = NO;
        
        currentConfigData.antiRecoilHotkey = [NSString stringWithFormat:@"0"];
        
        NSString *antiRecoilStr = [keyCodeClass returnKeyboardKey:0];
        
        [self.sniperBreathHotkey setTitle:antiRecoilStr forState:UIControlStateNormal];
        
        [self.antiRecoilHotkeyView changeKeyColor:0];
        
    }
    
}


#pragma mark - saveChanges
- (IBAction)saveChangesAction:(UIButton *)sender {
    
    [[ProtocolDataController sharedInstance] stopListeningResponse];
    
    if (sender == self.saveChanges_cancelBt) {
        
        self.saveChangesView.hidden = YES;
        
        //是否儲存,點擊 "X"後,維持在編輯頁
        //[self saveChangeDataOrNot:NO];
        
        return;
        
    }
    else if (sender == self.saveChanges_noBt) {
        
        self.saveChangesView.hidden = YES;
        
        if (isEditOrKeyboard == NO) {
            //在 keyboard 畫面
            
            //遙感畫面淡出
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                [self.view viewWithTag:4002].hidden = YES;
                
                //遙桿畫面淡出
                _remoteControl.alpha = 0.0;
                _remoteControl.userInteractionEnabled = NO;
                
                //左邊的view 滑進畫面
                _leftView.frame = CGRectMake(CGRectGetMinX(self.view.frame), 0, _leftView.frame.size.width, _leftView.frame.size.height);
                
                //右邊的view 滑進畫面
                _rightView.frame = CGRectMake(rightViewPoint.x, rightViewPoint.y, _rightView.frame.size.width, _rightView.frame.size.height);
                
                
            } completion:nil];
            
            //YES: edit頁面
            isEditOrKeyboard = YES;
            
        }
        else {
            
            //在 Edit 頁面
            [self saveChangeDataOrNot:NO];
            
        }
        
    }else if(sender == self.saveChanges_saveBt) {
        
        if(isEditOrKeyboard == NO) {
            //keyboard 頁面
            //儲存變更
            
            
            //YES: edit頁面
            isEditOrKeyboard = YES;
            
        }else {
            
            //Edit 頁面
            //儲存變更
            self.saveChangesView.hidden = YES;
            [self saveChangeDataOrNot:YES];
            
        }
        
    }
    
}

-(void)saveChangeDataOrNot:(BOOL)save {
    
    
    [[ProtocolDataController sharedInstance] stopListeningResponse];
    
    if (save == YES) {
        
        //硬體資料更新
        //configFileName
        
        [configData setConfigName:currentConfigData.configFileName];
        
        NSLog(@"==>configData configname:%@",configData.getConfigName);
        
        
        //config hotKey
        int hotKeyNum = currentConfigData.configHotKeyStr.intValue;
        
        [configData setConfigHotKey:hotKeyNum];
        
        
        //LEDColor 圖片名稱轉換對應數字
        int LEDNum = [currentConfigData.configLEDColor intValue];
        
        [configData setLEDColor:LEDNum];
        
        
        //platform
        int platformNum = [currentConfigData.configPlatformIcon intValue];
        NSLog(@"platformNum:%d",platformNum);
        [configData setPlatform:platformNum];
        
        //盲區
        currentConfigData.ballistics_Y_value = [curveView returnBallisticPoints];
        [configData setBallistics:currentConfigData.ballistics_Y_value];
        
        currentConfigData.ballistics_changed = [curveView returnBallisticChange];
        
        [configData setBallisticsChanged:currentConfigData.ballistics_changed];
        //        NSMutableArray *changeAry = [[NSMutableArray alloc]initWithCapacity:0];
        //        for (int i = 0; i < currentConfigData.ballistics_changed.count; i++) {
        //
        //           int change =  [currentConfigData.ballistics_changed[i] intValue];
        //
        //            NSNumber *num = [NSNumber numberWithInt:change];
        //
        //            [changeAry addObject:num];
        //        }
        //
        //        [configData setBallisticsChanged:changeAry];
        
        //NSLog(@"ballistics_Y_value =%@",currentConfigData.ballistics_Y_value);
        //NSLog(@"ballistics_changed =%@",currentConfigData.ballistics_changed);
        
        
        
        //mouse
        NSLog(@"[currentConfigData.hipStr intValue]:%d",[currentConfigData.hipStr intValue]);
        NSLog(@"[currentConfigData.adsStr intValue]:%d",[currentConfigData.adsStr intValue]);
        NSLog(@"currentConfigData.isSync:%d",currentConfigData.isSync);
        NSLog(@"currentConfigData.isADStoggle:%d",currentConfigData.isADStoggle);
        
        
        [configData setHIPSensitivity:[currentConfigData.hipStr intValue]];
        [configData setADSSensitivity:[currentConfigData.adsStr intValue]];
        [configData setFuncFlag_ADSSync:currentConfigData.isSync];
        [configData setFuncFlag_ADSToggle:currentConfigData.isADStoggle];
        [configData setDeadZONE:[currentConfigData.deadZoneStr intValue]];
        [configData setBallistics:currentConfigData.ballistics_Y_value];
        [configData setBallisticsChanged:currentConfigData.ballistics_changed];
        
        
        //        [configData setBallistics:currentConfigData.ballistics_Y_value];
        //        [configData setBallisticsChanged:currentConfigData.ballistics_changed];
        
        //keyboard
        //NSLog(@"==currentConfigData.keyMap==>%@",currentConfigData.keyMap);
        [configData setKeyMapArray:currentConfigData.keyMap];
        
        
        //prference
        [configData setFuncFlag_shootingSpeed:currentConfigData.isShootingSpeed];
        [configData setShootingSpeed:[currentConfigData.shootingSpeedStr intValue]];
        [configData setFuncFlag_invertedYAxis:currentConfigData.isInverted];
        [configData setFuncFlag_sniperBreath:currentConfigData.isSniperBreath];
        
        NSLog(@"sniperBreathHotkey:%d",[currentConfigData.sniperBreathHotkey intValue]);
        [configData setSniperBreathHotKey:[currentConfigData.sniperBreathHotkey intValue]];
        
        
        [configData setFuncFlag_antiRecoil:currentConfigData.isAntiRecoil];
        
        NSLog(@"antiRecoilHotkey:%d",[currentConfigData.antiRecoilHotkey intValue]);
        [configData setAntiRecoilHotkey:[currentConfigData.antiRecoilHotkey intValue]];
        
        
        [configData setAntiRecoilOffsetValue:[currentConfigData.antiRecoilStr intValue]];
        
        
        if (_isCreate) {
            //新增
            
            NSNumber *createIndex = [NSNumber numberWithUnsignedInteger:[[[ConfigMacroData sharedInstance] getConfigArray] count]];
            
            int newInt = [createIndex intValue];
            
            NSLog(@"%d",newInt);
            
            [[ProtocolDataController sharedInstance] saveConfig:newInt :configData];
            
        }else {
            //編輯
            
            NSNumber *indexInteger = [NSNumber numberWithInteger:self.indexPathRow];
            
            int indexInt = [indexInteger intValue];
            
            [[ProtocolDataController sharedInstance] saveConfig:indexInt:configData];
            
        }
        
        //顯示等待畫面
        updateView = [[ConnectLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [updateView setStatusLabel:NSLocalizedString(@"Saving...", nil)];//儲存中...
        [self.view addSubview:updateView];
        
        if (cfMainVC == nil) {
            
            cfMainVC = (CFMainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CFMainVC"];
        }
        
        cfMainVC.ary_configObj[_indexPathRow] = currentConfigData;
        
    }else {
        //取消
        
        NSMutableDictionary *usingConfig = [[ConfigMacroData sharedInstance] getUsingConfig];
        
        int configHotKey = [[usingConfig objectForKey:@"configHotKey"] intValue];
        
        
        NSLog(@"==>configHotKey==>%@", [usingConfig objectForKey:@"configHotKey"]);
        
        //判斷要load config or reset config
        if([self checkHotKeyRangeF1F8:configHotKey]){
            [[ProtocolDataController sharedInstance] resetLiveMode];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else
            [[ProtocolDataController sharedInstance] MacroConfigFunctionSet:configHotKey];
        
        
        //[self.navigationController popToRootViewControllerAnimated:YES];
        
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void)onResponseSaveConfig:(bool)isSuccess{
    
    NSLog(@"==>onResponseSaveConfig==>%d",isSuccess);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self doSave:isSuccess];
    });
    
}

-(void)doSave:(bool)isSuccess{
    
    if (isSuccess) {
        
        NSMutableArray *configAry = [[ConfigMacroData sharedInstance] getConfigArray];
        
        NSMutableDictionary *configDict;
        
        
        NSData *imgData = UIImageJPEGRepresentation(self.gameIconView.image, 1.0);
        
        NSMutableDictionary *configImgDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              currentConfigData.configHotKeyStr,@"configHotKey",
                                              imgData,@"configImage", nil];
        
        if (configAry.count != 0 && !_isCreate) {
            //編輯
            
            configDict = [configAry objectAtIndex:self.indexPathRow];
            
            //(本機圖片)
            //[configImgAry replaceObjectAtIndex:self.indexPathRow withObject:configImgDict];
            
        }else{
            //新增一筆
            
            
            NSMutableDictionary *temp= [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        currentConfigData.configHotKeyStr,@"configHotKey",
                                        currentConfigData.configPlatformIcon,@"platform",
                                        currentConfigData.configFileName,@"configName",
                                        currentConfigData.configLEDColor,@"LEDColor",
                                        @(currentConfigData.isADStoggle),@"flagADSToggle",
                                        @(currentConfigData.isShootingSpeed),@"flagShootingSpeed",
                                        @(currentConfigData.isInverted),@"flagInvertedYAxis",
                                        @(currentConfigData.isSniperBreath),@"flagSniperBreath",
                                        @(currentConfigData.isAntiRecoil),@"flagAntiRecoil",
                                        @(currentConfigData.isSync),@"flagADSSync",
                                        currentConfigData.hipStr,@"HIPSensitivity",
                                        currentConfigData.adsStr,@"ADSSensitivity",
                                        currentConfigData.deadZoneStr,@"deadZONE",
                                        currentConfigData.sniperBreathHotkey,@"sniperBreathHotKey",
                                        currentConfigData.antiRecoilHotkey,@"antiRecoilHotkey",
                                        currentConfigData.antiRecoilStr,@"antiRecoilOffsetValue",
                                        [currentConfigData.shootingSpeedStr mutableCopy],@"shootingSpeed",
                                        [currentConfigData.keyMap mutableCopy],@"keyMapArray",
                                        [currentConfigData.ballistics_Y_value mutableCopy],@"ballisticsArray",
                                        [currentConfigData.ballistics_changed mutableCopy],@"ballisticChanged",nil];
            
            configDict=temp;
            
            //[configImgAry addObject:configImgDict];
            
        }
        
        
        //configFileName
        [configDict setObject:currentConfigData.configFileName forKey:@"configName"];
        
        
        //config Hotkey
        [configDict setObject:currentConfigData.configHotKeyStr forKey:@"configHotKey"];
        
        //LEDColor 取得圖片名稱轉換對應數字
        int LEDNum = [currentConfigData.configLEDColor intValue];
        [configDict setObject:[NSString stringWithFormat:@"%d",LEDNum] forKey:@"LEDColor"];
        
        //platform 取得圖片轉換成對應的數字
        int platformNum = [currentConfigData.configPlatformIcon intValue];
        [configDict setObject:[NSString stringWithFormat:@"%d",platformNum] forKey:@"platform"];
        
        //mouse
        [configDict setObject:currentConfigData.hipStr forKey:@"HIPSensitivity"];
        [configDict setObject:currentConfigData.adsStr forKey:@"ADSSensitivity"];
        [configDict setObject:[NSString stringWithFormat:@"%d",currentConfigData.isSync] forKey:@"flagADSSync"];
        NSLog(@"isSync %d",currentConfigData.isSync);
        
        [configDict setObject:[NSString stringWithFormat:@"%d",currentConfigData.isADStoggle] forKey:@"flagADSToggle"];
        NSLog(@"isADStoggle %d",currentConfigData.isADStoggle);
        
        [configDict setObject:currentConfigData.deadZoneStr forKey:@"deadZONE"];
        
        //keyboard
        if(currentConfigData.keyMap) {
            
            [configDict setObject:[currentConfigData.keyMap mutableCopy] forKey:@"keyMapArray"];
        }
        
        //盲區
        if (currentConfigData.ballistics_Y_value) {
            
            [configDict setObject:[currentConfigData.ballistics_Y_value mutableCopy] forKey:@"ballisticsArray"];
            
            NSLog(@"===== ballisticsArray: %@",[configDict objectForKey:@"ballisticsArray"]);
        }
        
        
        if (currentConfigData.ballistics_changed) {
            
            [configDict setObject:[currentConfigData.ballistics_changed mutableCopy] forKey:@"ballisticChanged"];
            
            NSLog(@"===== ballisticChanged: %@",[configDict objectForKey:@"ballisticChanged"]);
        }
        
        
        
        //preference
        [configDict setObject:[NSString stringWithFormat:@"%d",currentConfigData.isShootingSpeed] forKey:@"flagShootingSpeed"];
        [configDict setObject:currentConfigData.shootingSpeedStr forKey:@"shootingSpeed"];
        [configDict setObject:[NSString stringWithFormat:@"%d",currentConfigData.isInverted] forKey:@"flagInvertedYAxis"];
        [configDict setObject:[NSString stringWithFormat:@"%d",currentConfigData.isSniperBreath] forKey:@"flagSniperBreath"];
        
        //sniperBreathHotKey
        //        NSLog(@"TT5==>%@",currentConfigData.sniperBreathHotkey);
        //        int sniperBreathHotKeyint = [keyCodeClass returnKeyNum:currentConfigData.sniperBreathHotkey];
        //        NSNumber *sniperBreathHotKeyNum = [NSNumber numberWithInt:sniperBreathHotKeyint];
        [configDict setObject:currentConfigData.sniperBreathHotkey forKey:@"sniperBreathHotKey"];
        
        
        [configDict setObject:[NSString stringWithFormat:@"%d",currentConfigData.isAntiRecoil] forKey:@"flagAntiRecoil"];
        
        
        //antiRecoilHotkey
        //        NSLog(@"TT6==>%@",currentConfigData.antiRecoilHotkey);
        //        int antiRecoilHotkeyint = [keyCodeClass returnKeyNum:currentConfigData.antiRecoilHotkey];
        //        NSNumber *antiRecoilHotkeyNum = [NSNumber numberWithInt:antiRecoilHotkeyint];
        [configDict setObject:currentConfigData.antiRecoilHotkey forKey:@"antiRecoilHotkey"];
        
        
        [configDict setObject:currentConfigData.antiRecoilStr forKey:@"antiRecoilOffsetValue"];
        
        
        NSLog(@"onResponseSaveConfig-----self.indexPathRow = %li", (long)self.indexPathRow);
        NSLog(@"onResponseSaveConfig-----configData = %@", currentConfigData.configFileName);
        if (self.isCreate) {
            //新增
            
            [configAry addObject:configDict];
            [[ConfigMacroData sharedInstance] setConfigArray:configAry];
            
            //移除等待畫面
            [updateView removeFromSuperview];
            updateView = nil;
            
            
            //(本機圖片)
            [[ConfigMacroData sharedInstance] saveConfigImage:configImgDict Key:currentConfigData.configFileName];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            //編輯
            [configAry replaceObjectAtIndex:self.indexPathRow withObject:configDict];
            
            [[ConfigMacroData sharedInstance]setConfigArray:configAry];
            
            //移除等待畫面
            [updateView removeFromSuperview];
            updateView = nil;
            
            //(本機圖片)
            [[ConfigMacroData sharedInstance] saveConfigImage:configImgDict Key:currentConfigData.configFileName];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    }
    else {
        
        [[ProtocolDataController sharedInstance] saveConfig:(int)self.indexPathRow :configData];
    }
}

-(bool)checkHotKeyRangeF1F8:(int)keyCode{
    //keycode 在 F1 ~ F8 範圍外
    if (keyCode < 58 || keyCode > 65) {
        return true;
    }
    return false;
}

-(bool)checkHotKeyRangeF1F10:(int)keyCode{
    //keycode 在 F1 ~ F10 範圍外
    if (keyCode < 58 || keyCode > 67) {
        return true;
    }
    return false;
}

-(void)resetConfigHotkeyStatus:(NSString *)configHotKeyStr Type:(int)type{
    
    [self.configHotkey setTitle:configHotKeyStr forState:UIControlStateNormal];
    
    if(type == 0)
        [self showWarningViewTitle:@"Incorrect HotKey" Description:@"Please check range to F1~F8"];
    else
        [self showWarningViewTitle:@"HotKey Repeat" Description:@"please change another one"];
}

-(void)resetBreathHotkeyStatus:(NSString *)breathStr Type:(int)type{
    
    [self.sniperBreathHotkey setTitle:breathStr forState:UIControlStateNormal];
    
    if(type == 0)
        [self showWarningViewTitle:@"Incorrect HotKey" Description:@"Please check range to F1~F10"];
    else
        [self showWarningViewTitle:@"HotKey Repeat" Description:@"please change another one"];
}

-(void)resetantiRecoilHotkeyStatus:(NSString *)antiRecoilStr Type:(int)type{
    
    [self.antiRecoilHotkey setTitle:antiRecoilStr forState:UIControlStateNormal];
    
    if(type == 0)
        [self showWarningViewTitle:@"Incorrect HotKey" Description:@"Please check range to F1~F10"];
    else
        [self showWarningViewTitle:@"HotKey Repeat" Description:@"please change another one"];
}

-(void)resetantiKeyboardHotKeyStatus:(NSString *)keyboardStr Type:(int)type Index:(int)i{
    
    NSLog(@"resetantiKeyboardHotKeyStatus keyboardStr = %@",keyboardStr);
    [ary_keymap[i] setTitle:keyboardStr forState:UIControlStateNormal];
    
    if(type == 0)
        [self showWarningViewTitle:@"Incorrect HotKey" Description:@"Please check range to F1~F10"];
    else
        [self showWarningViewTitle:@"HotKey Repeat" Description:@"please change another one"];
}



-(void)showWarningViewTitle:(NSString *)title Description:(NSString *)description{
    //顯示熱鍵重覆 alertView
    WaringViewController *waringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Key_WaringViewController"];
    waringVC.parentObj = self;
    waringVC.waring_message = NSLocalizedString(title, nil);
    //@"熱鍵重覆"
    waringVC.waring_description = NSLocalizedString(description, nil);
    //@"已有相同熱鍵,請更換"
    [self presentViewController:waringVC animated:YES completion:nil];
    
}

#pragma mark - int 轉 LEDColor (config_color)
-(NSString *)getNumTransformToLEDColor:(int)colorNum {
    
    NSString *colorStr;
    
    switch (colorNum) {
        case 1:
            colorStr = @"config_color_a_1";
            break;
        case 2:
            colorStr = @"config_color_a_2";
            break;
        case 3:
            colorStr = @"config_color_a_3";
            break;
        case 4:
            colorStr = @"config_color_a_4";
            break;
        case 5:
            colorStr = @"config_color_a_5";
            break;
        case 6:
            colorStr = @"config_color_a_6";
            break;
        case 7:
            colorStr = @"config_color_a_7";
            break;
        case 8:
            colorStr = @"config_color_a_8";
            break;
        case 9:
            colorStr = @"config_color_a_9";
            break;
        case 10:
            colorStr = @"config_color_a_10";
            break;
        default:
            break;
    }
    
    return colorStr;
}


#pragma mark - LED_COLOR 圖片轉換
-(NSString *)transformplatformColorToLEDColor:(NSString *)platformColor {
    
    NSString *LED_ColorStr;
    
    if ([platformColor isEqualToString:@"platform_btn_a_colorlable_1"]){
        
        LED_ColorStr = @"config_color_a_1";
    }
    else if ([platformColor isEqualToString:@"platform_btn_a_colorlable_2"]) {
        
        LED_ColorStr = @"config_color_a_2";
    }
    else if ([platformColor isEqualToString:@"platform_btn_a_colorlable_3"]) {
        
        LED_ColorStr = @"config_color_a_3";
    }
    else if ([platformColor isEqualToString:@"platform_btn_a_colorlable_4"]) {
        
        LED_ColorStr = @"config_color_a_4";
    }
    else if ([platformColor isEqualToString:@"platform_btn_a_colorlable_5"]) {
        
        LED_ColorStr = @"config_color_a_5";
    }
    else if ([platformColor isEqualToString:@"platform_btn_a_colorlable_6"]) {
        
        LED_ColorStr = @"config_color_a_6";
    }
    else if ([platformColor isEqualToString:@"platform_btn_a_colorlable_7"]) {
        
        LED_ColorStr = @"config_color_a_7";
    }
    else if ([platformColor isEqualToString:@"platform_btn_a_colorlable_8"]) {
        
        LED_ColorStr = @"config_color_a_8";
    }
    else if ([platformColor isEqualToString:@"platform_btn_a_colorlable_9"]) {
        
        LED_ColorStr = @"config_color_a_9";
    }
    else {
        
        LED_ColorStr = @"config_color_a_10";
    }
    
    return LED_ColorStr;
    
}


-(NSString *)transformLEDColorToPlatformColor:(NSString *)LED_Color {
    
    NSString *platformColor;
    
    if ([LED_Color isEqualToString:@"config_color_a_1"]){
        
        platformColor = @"platform_btn_a_colorlable_1";
    }
    else if ([LED_Color isEqualToString:@"config_color_a_2"]) {
        
        platformColor = @"platform_btn_a_colorlable_2";
    }
    else if ([LED_Color isEqualToString:@"config_color_a_3"]) {
        
        platformColor = @"platform_btn_a_colorlable_3";
    }
    else if ([LED_Color isEqualToString:@"config_color_a_4"]) {
        
        platformColor = @"platform_btn_a_colorlable_4";
    }
    else if ([LED_Color isEqualToString:@"config_color_a_5"]) {
        
        platformColor = @"platform_btn_a_colorlable_5";
    }
    else if ([LED_Color isEqualToString:@"config_color_a_6"]) {
        
        platformColor = @"platform_btn_a_colorlable_6";
    }
    else if ([LED_Color isEqualToString:@"config_color_a_7"]) {
        
        platformColor = @"platform_btn_a_colorlable_7";
    }
    else if ([LED_Color isEqualToString:@"config_color_a_8"]) {
        
        platformColor = @"platform_btn_a_colorlable_8";
    }
    else if ([LED_Color isEqualToString:@"config_color_a_9"]) {
        
        platformColor = @"platform_btn_a_colorlable_9";
    }
    else {
        
        platformColor = @"platform_btn_a_colorlable_10";
    }
    
    return platformColor;
}



#pragma mark - platform 取得圖片轉換成對應的數字
-(int)getPlatformNumTransformIcon:(NSString *)platformStr {
    
    int num;
    
    if ([platformStr isEqualToString:@"platform_a_2_ps3_88x88"]) {
        
        num = 1;
    }
    else if ([platformStr isEqualToString:@"platform_a_1_ps4_88x88"]) {
        
        num = 2;
    }
    else if ([platformStr isEqualToString:@"platform_a_4_x360_88x88"]) {
        
        num = 4;
    }
    else if ([platformStr isEqualToString:@"platform_a_3_x1_88x88"]) {
        
        num = 8;
    }
    
    return num;
}

#pragma mark -  platform 取得數字轉換成對應的圖片
-(NSString *)getPlatformNumToPic:(int)platformNum {
    
    NSString *platfromStr;
    
    switch (platformNum) {
        case 1:
            platfromStr = @"platform_a_2_ps3_88x88";
            break;
        case 2:
            platfromStr = @"platform_a_1_ps4_88x88";
            break;
        case 4:
            platfromStr = @"platform_a_4_x360_88x88";
            break;
        case 8:
            platfromStr = @"platform_a_3_x1_88x88";
            break;
        default:
            break;
    }
    
    return platfromStr;
}


#pragma mark - LED_Color 取得圖片轉換成對應的數字
-(int)getLEDColorNumTrasformToLEDPic:(NSString *)LEDStr {
    
    int num;
    
    if ([LEDStr isEqualToString:@"platform_btn_a_colorlable_1"]) {
        
        num = 1;
    }
    else if ([LEDStr isEqualToString:@"platform_btn_a_colorlable_2"]) {
        
        num = 2;
    }
    else if ([LEDStr isEqualToString:@"platform_btn_a_colorlable_3"]) {
        
        num = 3;
    }
    else if ([LEDStr isEqualToString:@"platform_btn_a_colorlable_4"]) {
        
        num = 4;
    }
    else if ([LEDStr isEqualToString:@"platform_btn_a_colorlable_5"]) {
        
        num = 5;
    }
    else if ([LEDStr isEqualToString:@"platform_btn_a_colorlable_6"]) {
        
        num = 6;
    }
    else if ([LEDStr isEqualToString:@"platform_btn_a_colorlable_7"]) {
        
        num = 7;
    }
    else if ([LEDStr isEqualToString:@"platform_btn_a_colorlable_8"]) {
        
        num = 8;
    }
    else if ([LEDStr isEqualToString:@"platform_btn_a_colorlable_9"]) {
        
        num = 9;
    }
    else if ([LEDStr isEqualToString:@"platform_btn_a_colorlable_10"]) {
        
        num = 10;
    }
    
    return num;
}

-(void)onResponseLiveMode:(bool)isSuccess{
    NSLog(@"Live mode 成功");
}

-(void)onResponseMacroConfigFunctionSet:(bool)isSuccess{
    NSLog(@"Function Set 成功");
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)onBtStateChanged:(bool)isEnable{
    
}

-(void) onResponseMoveConfig:(bool)isSuccess{
    
}

-(void) onResponseMoveMacro:(bool)isSuccess{
    
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


#pragma mark - 呼叫相簿事件
- (IBAction)changeImg:(UIButton *)sender {
    
    if(!isEditOrKeyboard)
        return;
    
    /*
     分辨是 iphone 還是 ipad
     */
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        picker.delegate = self;
        
        picker.allowsEditing = YES;
        
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        //tempImg
        tempImg = [[UIImage alloc] init];
        tempImg = [UIImage imageNamed:@"platform_a_5_custom_104x104"];
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    else if ([deviceType isEqualToString:@"iPad"]) {
        
        UIPopoverPresentationController *ipadPopOver;
        UIImagePickerController *ipadPicker = [[UIImagePickerController alloc] init];
        
        //取得行動裝置相簿
        ipadPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        ipadPicker.delegate = self;
        ipadPicker.allowsEditing = YES;
        
        //設定顯示模式
        ipadPicker.modalPresentationStyle = UIModalPresentationPopover;
        ipadPopOver = ipadPicker.popoverPresentationController;
        
        ipadPopOver.sourceView = sender;
        ipadPopOver.sourceRect = sender.bounds;
        ipadPopOver.permittedArrowDirections = UIPopoverArrowDirectionUp;
        
        //tempImg
        tempImg = [[UIImage alloc] init];
        tempImg = [UIImage imageNamed:@"platform_a_5_custom_104x104"];
        
        [self presentViewController:ipadPicker animated:YES completion:nil];
        
    }
    
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *new_image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    tempImg = new_image;
    
    self.gameIconView.image = tempImg;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//#pragma mark - Screen Rotation
//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//
//    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationMaskPortraitUpsideDown) {
//
//        return NO;
//    }
//
//    return YES;
//}
//
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//
//    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//}



#pragma mark - 檔名重覆
-(void)checkConfigFileNameRepeat {
    
    if(!isEditOrKeyboard)
        return;
    
    self.rightView.frame = CGRectMake(rightViewOriLoaction.x, rightViewOriLoaction.y, self.rightView.frame.size.width, self.rightView.frame.size.height);
    
    //判斷textField是否有文字
    //configFileName
    if ([self.configFileName.text isEqualToString:@""]) {
        
        self.configFileName.text = currentConfigData.configFileName;
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
            
            //integer 轉 int
            NSNumber *num = [NSNumber numberWithInteger:self.indexPathRow];
            int numInt = [num intValue];
            
            if ([configIntName isEqualToString:self.configFileName.text]) {
                
                if (cInt == numInt) {
                    
                    isConfigRepeat = NO;
                    
                    continue;
                }
                else {
                    
                    isConfigRepeat = YES;
                    
                    break;
                }
                
            }
            
        }
        
        //再判斷是否與其他 macro 檔名重覆
        BOOL isMacroRepeat = NO;
        NSMutableArray *macroAry = [[ConfigMacroData sharedInstance] getMacroArray];
        NSMutableDictionary *macroFileNameDict;
        
        for (int mInt = 0; mInt < macroAry.count; mInt++) {
            
            macroFileNameDict = macroAry[mInt];
            
            NSString *macorIntName = (NSString *)[macroFileNameDict objectForKey:@"macroName"];
            
            if ([macorIntName isEqualToString:self.configFileName.text]) {
                
                isMacroRepeat = YES;
                
                break;
            }
            
        }
        
        
        if (isConfigRepeat == YES || isMacroRepeat == YES) {
            
            [self showWarningViewTitle:@"FileName repeat" Description:@"please change other Name"];
            
            self.configFileName.text = currentConfigData.configFileName;
            
        }
        else {
            
            currentConfigData.configFileName = self.configFileName.text;
        }
        
    }
    
    NSLog(@"hidden keyboard");
}



-(void)hiddeAllTextFieldKeyboard {
    
    if(!isEditOrKeyboard)
        return;
    
    [self checkConfigFileNameRepeat];
    [self.configFileName resignFirstResponder];
    
    //有值才需 liveMode
    int isLiveModeCount = 0;
    
    
    //hipStr
    if ([_textField_0.text isEqualToString:@""]) {
        
        _textField_0.text = currentConfigData.hipStr;
    }
    else {
        
        if (![_textField_0.text isEqualToString:currentConfigData.hipStr]) {
            
            isLiveModeCount += 1;
            
            currentConfigData.hipStr = _textField_0.text;
        }
    
    }
    [_textField_0 resignFirstResponder];
    
    
    //adsStr
    if ([_textField_1.text isEqualToString:@""]) {
        
        _textField_1.text = currentConfigData.adsStr;
    }
    else {
        
        if (![_textField_1.text isEqualToString:currentConfigData.adsStr]) {
            
            isLiveModeCount += 1;
            
            currentConfigData.adsStr = _textField_1.text;
        }
    
    }
    [_textField_1 resignFirstResponder];
    
    
    //deadZoneStr
    if ([_textField_2.text isEqualToString:@""]) {
        
        _textField_2.text = currentConfigData.deadZoneStr;
    }
    else {
        
        if (![_textField_2.text isEqualToString:currentConfigData.deadZoneStr]) {
            
            isLiveModeCount += 1;
            
            currentConfigData.deadZoneStr = _textField_2.text;
        }
        
    }
    [_textField_2 resignFirstResponder];
    
    //shootingSpeedStr
    if ([_textField_3.text isEqualToString:@""]) {
        
        _textField_3.text = currentConfigData.shootingSpeedStr;
    }
    else {
        
        if (![_textField_3.text isEqualToString:currentConfigData.shootingSpeedStr]) {
            
            isLiveModeCount += 1;
            
            currentConfigData.shootingSpeedStr = _textField_3.text;
            
        }
        
    }
    [_textField_3 resignFirstResponder];
    
    //antiRecoilStr
    if ([_textField_4.text isEqualToString:@""]) {
        
        _textField_4.text = currentConfigData.antiRecoilStr;
    }
    else {
        
        if (![_textField_4.text isEqualToString:currentConfigData.antiRecoilStr]) {
            
            isLiveModeCount += 1;
            
            currentConfigData.antiRecoilStr = _textField_4.text;
        }
        
        
    }
    [_textField_4 resignFirstResponder];
    
    
    //live mode
    if (isLiveModeCount >= 1) {
        
        [self liveModeForFingerView];
    }
    
    
    self.rightView.frame = CGRectMake(rightViewOriLoaction.x, rightViewOriLoaction.y, self.rightView.frame.size.width, self.rightView.frame.size.height);
    
    self.leftView.frame = CGRectMake(leftViewOriLocation.x, leftViewOriLocation.y, self.leftView.frame.size.width, self.leftView.frame.size.height);
    
}


#pragma mark - 即時切換語系
-(void)changeLanguageImidiately {
    
    self.editConfigLabel.text = NSLocalizedString(@"Edit Config", nil);//編輯 Config
    
    self.mouseLabel.text = NSLocalizedString(@"Mouse", nil);//滑鼠
    
    self.keyboardLabel.text = NSLocalizedString(@"Keyboard", nil);//鍵盤
    
    self.preferenceLabel.text = NSLocalizedString(@"Preferences", nil);//偏好設定
    
    [self.saveBt setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];//儲存
    
    [self.cancelBt setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];//取消
    
    
    self.sensitivityLabel.text = NSLocalizedString(@"Sensitivity", nil);//靈敏度
    
    self.HipLabel.text = NSLocalizedString(@"HIP", nil);//滑鼠
    
    self.AdsLabel.text = NSLocalizedString(@"ADS", nil);//瞄準射擊
    
    self.syncLabel.text = NSLocalizedString(@"Sync", nil); //同步
    
    self.ballisticLabel.text = NSLocalizedString(@"Ballistics", nil);//曲線
    
    self.deadZoneLabel.text = NSLocalizedString(@"Dead Zone", nil);//盲區
    
    self.shootingSpeedLabel.text = NSLocalizedString(@"Shooting Speed Strengthen", nil);//射 速 加 強
    
    self.invertedYLabel.text = NSLocalizedString(@"Inverted Y Axis", nil);//反 轉 Y 軸
    
    self.sniperBreathLabel.text = NSLocalizedString(@"Sniper Breath", nil);//狙擊屏息
    
    self.antiRecoilLabel.text = NSLocalizedString(@"Anti Recoil", nil);//反後座力
    
    
    [self.saveChanges_saveBt setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];//儲存
    
    [self.saveChanges_noBt setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];//取消
    
    self.saveChangesLabel.text = NSLocalizedString(@"Save Changes?", nil);//儲存變更 ?
    
}

@end
