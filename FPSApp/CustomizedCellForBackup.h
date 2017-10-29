//
//  CustomizedCellForBackup.h
//  FPSApp
//
//  Created by 曾偉亮 on 2016/9/23.
//  Copyright © 2016年 Tom. All rights reserved.
//

@class CFBackupViewController;

#import <UIKit/UIKit.h>

@interface CustomizedCellForBackup : UITableViewCell

@property (strong, nonatomic) UIButton *cellDeleteBt;

@property (strong, nonatomic) UITableView *superTableView;

@property (strong, nonatomic) NSIndexPath *superIndexPath;

@property (strong, nonatomic) NSMutableArray *superAryList;

@property CGFloat theRowHeight;

@property (strong, nonatomic) CFBackupViewController *cellSuperVC;

-(void)createDeleteBt:(UITableView *)theTableView;


@end
