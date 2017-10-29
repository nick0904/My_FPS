//
//  CustomizedCellForBackup.m
//  FPSApp
//
//  Created by 曾偉亮 on 2016/9/23.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "CustomizedCellForBackup.h"

@implementation CustomizedCellForBackup

@synthesize cellDeleteBt, superTableView, superIndexPath, superAryList,theRowHeight;

-(void)createDeleteBt:(UITableView *)theTableView {
    
    //cellDeleteBt 初始化
    // cellDeleteBt = [[UIButton alloc] initWithFrame: CGRectMake( theTableView.frame.size.width - theRowHeight*2.5, self.center.y, theRowHeight*2.5, theRowHeight/2)];
    
    
    cellDeleteBt = [[UIButton alloc] initWithFrame:CGRectMake(theTableView.frame.size.width-80, 10, 80, 32)];
    
    [cellDeleteBt setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
    
    [cellDeleteBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [cellDeleteBt setBackgroundImage:[UIImage imageNamed:@"btn_red_a_small_up.png"] forState:UIControlStateNormal];
    
    [cellDeleteBt setBackgroundImage:[UIImage imageNamed:@"btn_red_a_small_down.png"] forState:UIControlStateHighlighted];
    
    [cellDeleteBt addTarget:self action:@selector(onDeleteBtAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cellDeleteBt.alpha = 0;
    
    cellDeleteBt.userInteractionEnabled = NO;
    
    [self addSubview:cellDeleteBt];
    
    
}

#pragma mark - onDeleteBtAction
-(void)onDeleteBtAction:(UIButton *)bt {
    
    [self deleteObjFrom:superTableView atIndexPath:superIndexPath arrayList:superAryList];
    
}

#pragma mark - 刪除清單物件
-(void)deleteObjFrom:(UITableView *)theTableView atIndexPath:(NSIndexPath *)indexPath arrayList:(NSMutableArray *)aryList {
    
    //刪除 Array 某筆資料
    
    NSLog(@"del Before:%@",aryList);
    //
    //    NSMutableArray *oriArray = [[ConfigMacroData sharedInstance] getConfigArray];
    //    [oriArray removeObjectAtIndex:indexPath.row];
    //
    //    aryList=oriArray;
    
    [aryList removeObjectAtIndex:indexPath.row];
    
    NSLog(@"del after:%@",aryList);
    
    //刪除 tableviewCell 某筆資料
    [theTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    self.cellDeleteBt.alpha = 0.0;
    
    self.cellDeleteBt.userInteractionEnabled = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(tableViewReloadData) userInfo:nil repeats:NO];
}

-(void)tableViewReloadData {
    
    if (superTableView != nil) {
        
        
        NSLog(@"superIndexPath ======= %ld",(long)superIndexPath.row);
        //硬體 relaod data
        
        
        //暫存檔 relaod data
        [superTableView reloadData];
        
    }
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
