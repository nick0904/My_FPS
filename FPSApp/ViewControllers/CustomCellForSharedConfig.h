//
//  CustomCellForSharedConfig.h
//  FPSApp
//
//  Created by 曾偉亮 on 2016/10/12.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFBackupViewController.h"

@interface CustomCellForSharedConfig : UITableViewCell

@property NSInteger sharedConfigIndexPathRow;

@property (strong, nonatomic) UIButton *downloadBt;

@property (strong, nonatomic) CFBackupViewController *m_superVC;


-(void)downloadBtAddAction;


@end
