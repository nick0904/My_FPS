//
//  CustomizedCell.h
//  CustomTableView
//
//  Created by 曾偉亮 on 2016/7/26.
//  Copyright © 2016年 TSENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CFMainViewController;

@interface CustomizedCell : UITableViewCell

@property (strong, nonatomic) UIButton *cellDeleteBt;

@property (strong, nonatomic) UITableView *superTableView;

@property (strong, nonatomic) NSIndexPath *superIndexPath;

@property (strong, nonatomic) NSMutableArray *superAryList;

@property CGFloat theRowHeight;

@property (strong, nonatomic) CFMainViewController *cellSuperVC;

-(void)createDeleteBt:(UITableView *)theTableView;

@end
