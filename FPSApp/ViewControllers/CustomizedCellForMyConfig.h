//
//  CustomizedCellForMyConfig.h
//  FPSApp
//
//  Created by 曾偉亮 on 2016/10/12.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CFBackupViewController;

@interface CustomizedCellForMyConfig : UITableViewCell

@property (strong, nonatomic) UIButton *myConfigDownloadBt;

@property (strong, nonatomic) UIButton *cellDeleteBt;

@property (strong, nonatomic) UITableView *superTableView;

@property (strong, nonatomic) NSIndexPath *superIndexPath;

@property (strong, nonatomic) NSMutableArray *superAryList;

@property CGFloat theRowHeight;

@property (strong, nonatomic) UIButton *myConfigSharedBt;

@property (strong, nonatomic) UIButton *myConfigWithDraBt;


@property (strong, nonatomic) CFBackupViewController *cellSuperVC;


-(void)createDeleteBt:(UITableView *)theTableView;

//cloud function
-(void)downloadBtAddAction;





@end
