//
//  HelpViewController.h
//  FPSApp
//
//  Created by Rex on 2016/6/29.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "MViewController.h"
#import "mainLeftBar.h"

@interface HelpViewController : MViewController<UITableViewDelegate, UITableViewDataSource,ConnectStateDelegate,DataResponseDelegate,MainLeftBarDelegate>{

    mainLeftBar *leftBar;
    UITableView *QATable;
    NSMutableArray *QACellArray;
    
}
@property (strong,nonatomic)UIViewController *mainVC;
@property (weak, nonatomic) IBOutlet UIButton *configCloseBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *helpScroll;

@property (weak, nonatomic) IBOutlet UISearchBar *helpSearchBar;

@end
