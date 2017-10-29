
#import <UIKit/UIKit.h>
#import "MViewController.h"
#import "CFEditViewController.h"
#import "CFCreatViewController.h"
#import "CFBackupViewController.h"
#import "CFTableViewCellObject.h"
#import "BtAnimationCurve.h"
#import "WaringViewController.h"
#import "MCCreateViewController.h"
#import "MCTableViewCellObject.h"
#import "ConnectLoadingView.h"
#import "AboutViewController.h"
#import "UserLoginViewController.h"
#import "HelpViewController.h"
#import "UserSettingViewController.h"
#import "CustomizedTableView.h"
#import "CustomizedCell.h"
#import "ConfigMacroData.h"

@interface CFMainViewController : MViewController <MovableTableViewDataSource,MovableTableViewDelegate,ConnectStateDelegate,DataResponseDelegate,FPCloudClassDelegate>

@property (strong,nonatomic)UIViewController *mainVC;

//儲放 Config tableVieCell 的物件
@property (strong, nonatomic) NSMutableArray<CFTableViewCellObject *> *ary_configObj;

//儲放 Marco tableVieCell 的物件
@property (strong, nonatomic) NSMutableArray<MCTableViewCellObject *> *ary_marocObj;

@property BOOL isMarcoEdit;//YES:Edit , NO:Create NEW

@property BOOL isSelectedConfig; // YES:Config, NO:Macro

//config頁面中列表已存在的遊戲被選取時,edit頁面才可點擊
@property BOOL isSeleced_config;

//marco頁面中列表已存在的遊戲被選取時,edit頁面才可點擊
@property BOOL isSeleced_marco;




-(void)showConfigOrMarcoObject;//tableView內容要顯示Config還是Marco

-(void)deleteConfigOrMacroData:(NSInteger)currentIndexPath;//cell 刪除用

-(void)moveConfigOrMacrodData:(NSInteger)fromIndexPath to:(NSInteger)toIndexPath;//cell 移動用

-(void)cellBackgroundReset;//tableViewCell 背景去色

-(void)changeBackgroundColorForCustomizedTableView:(NSInteger)selectedInteger ;

-(void)configOrMacroReloadData:(BOOL)configAction;

@end

