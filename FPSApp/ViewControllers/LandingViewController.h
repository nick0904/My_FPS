//
//  LandingViewController.h
//  FPSApp
//
//  Created by Rex on 2016/8/5.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "MViewController.h"

@interface LandingViewController : MViewController<ConnectStateDelegate,DataResponseDelegate>{
    NSMutableArray *configArray;
    NSMutableArray *macroArray;
}

typedef enum{
    ConnectFail,
    Overwrite
    
}AlertButtonType;

@property (strong,nonatomic)UIViewController *mainVC;

@end
