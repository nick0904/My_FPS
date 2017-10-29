

#import "MViewController.h"
#import "FingerPrintImageView.h"
#import "CFTableViewCellObject.h"
#import "CFMainViewController.h"
#import "KeyCodeFile.h"
#import "ConfigMacroData.h"
#import "ConnectLoadingView.h"

@interface CFEditViewController : MViewController <ConnectStateDelegate,DataResponseDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) UITextField *textFieldValue;

//儲放 Config tableVieCell 的物件
@property (strong, nonatomic) CFTableViewCellObject *edit_configObj;

@property NSInteger indexPathRow;

@property BOOL isCustom;
@property BOOL isCreate;

//開啟提示視窗後再回來有些UI設定會被reset成預設值
@property BOOL alreadyInitView;


@property (strong, nonatomic) UITextField *fingerViewHipTextField;
@property (strong, nonatomic) UITextField *fingerViewADSTextField;

//同步不同步
@property BOOL isSyncOrNot;

-(void)rulerIndex:(int)index;

-(void)liveModeForFingerView;

-(void)getAllFingerValue ;

@end
