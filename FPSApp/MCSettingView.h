

#import <UIKit/UIKit.h>
#import "MCCreateViewController.h"

@interface MCSettingView : UIView

/*
 1.此物件包含 8 個圖片 (每次動作或設定只會顯示其中一個圖示)
 2.兩種觸碰手勢: tap 與 longPress
*/


/*
 key_type = 0: keyboard
 key_type = 1: 滑鼠左鍵
 key_type = 2: 滑鼠右鍵
 */
@property int key_type;

@property BOOL isSelected;//判斷是否被使用者選擇

@property BOOL canMove;//是否可移動

@property (strong ,nonatomic) id parentObj;

@property CGPoint oriCenterPoint;

@property  NSMutableArray<UIImageView *> *ary_imgView; //存放8種圖片的陣列

//顯示對應的鍵盤按鍵,只有在keyboard down - keyboard up 才會顯示
@property (strong, nonatomic) UILabel *keyboardLabel;

@property int settingView_keycode;


-(void)refreshSettingView;

-(void)showSettingViewAtIndex:(int)index;

-(void)showOrHideKeyboardLabel:(int)type;

@end
