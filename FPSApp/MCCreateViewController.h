

#import "MViewController.h"
#import "MCSettingView.h"
#import "WaringViewController.h"
#import "MCTableViewCellObject.h"
#import "ConfigMacroData.h"
#import "KeyCodeFile.h"

@class CFMainViewController;


@interface MCCreateViewController : MViewController <UITextFieldDelegate,ConnectStateDelegate,DataResponseDelegate>


@property (strong, nonatomic) IBOutlet UIView *trashcan;

@property (strong, nonatomic) IBOutlet UIImageView *trashcanImgView;

@property NSInteger indexPathRow;

@property (strong, nonatomic) MCTableViewCellObject *edit_marcoObj;

@property (strong, nonatomic) CFMainViewController *superVC;

//開啟提示視窗後再回來有些UI設定會被reset成預設值
@property BOOL alreadyInitView;

@property BOOL isMacroHotkeyCallKeyCodeResponse;
@property BOOL isSettingViewCallKeyCodeResponse;



-(void)showTrashcanOrHidden:(BOOL)show; //顯示或隱藏垃圾桶

-(void)showKeyType:(int)index;//顯示keyboard,ml,mr

-(void)hideSmalllisteningLabel:(BOOL)hide;

-(void)showSettingWindow;

-(void)checkDelayBtColor;

-(void)settingWindowBackToOrigin;

-(void)saveDelayTime:(int)seconds;

@end
