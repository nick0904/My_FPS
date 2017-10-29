//
//  UserSettingViewController.h
//  FPSApp
//
//  Created by Rex on 2016/6/29.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "MViewController.h"
#import "mainLeftBar.h"

//typedef enum{
//    
//    English,
//    French,
//    Chinese_T,
//    Italian,
//    Chinese_S,
//    Korean,
//    Japanese,
//    Spanish,
//    German,
//    
//}languages;

typedef enum{
    
    English,
    Chinese_T

}languages;

@interface UserSettingViewController : MViewController<ConnectStateDelegate,DataResponseDelegate,MainLeftBarDelegate>{
    mainLeftBar *leftBar;
}
@property (strong,nonatomic)UIViewController *mainVC;
@property (weak, nonatomic) IBOutlet UIButton *configCloseBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *languageScroll;
@property (weak, nonatomic) IBOutlet UIImageView *selectLangImg;

@end
