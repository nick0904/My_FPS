//
//  CustomizedTableView.h
//  CustomTableView
//
//  Created by 曾偉亮 on 2016/7/26.
//  Copyright © 2016年 TSENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizedCell.h"

@class CustomizedTableView;
@class CFMainViewController;

@protocol MovableTableViewDataSource <UITableViewDataSource>

@required

-(NSMutableArray *)dataSourceArrayInTableView:(CustomizedTableView *)tableView;

- (void)tableView:(CustomizedTableView *)tableView newDataSourceArrayAfterMove:(NSMutableArray *)newDataSourceArray;

@end

@protocol MovableTableViewDelegate <UITableViewDelegate>

@optional
//準備要開始移動indexPath位置的cell
- (void)tableView:(CustomizedTableView *)tableView willMoveCellAtIndexPath:(NSIndexPath *)indexPath;

//完成一次從 fromIndexPath cell 到 toIndexPath cell的移動
- (void)tableView:(CustomizedTableView *)tableView didMoveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;


//結束移動cell在indexPath
- (void)tableView:(CustomizedTableView *)tableView endMoveCellAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface CustomizedTableView: UITableView

@property (weak, nonatomic) id<MovableTableViewDataSource> dataSource;

@property (weak, nonatomic) id<MovableTableViewDelegate> delegate;

//長按手勢最小觸發時間，默認1.0，最小0.2
@property (nonatomic, assign) CGFloat gestureMinimumPressDuration;

@property (strong, nonatomic) CFMainViewController *m_superVC;

//自定義可移動cell的截圖樣式
@property (nonatomic, copy) void(^drawMovalbeCellBlock)(UIView *movableCell);


//是否允許托動到屏幕邊缘后，開啟邊缘滾動，默認YES
@property (nonatomic, assign) BOOL canEdgeScroll;


//邊緣滾動觸發範圍，默認150，越靠近邊緣移動速度越快
@property (nonatomic, assign) CGFloat edgeScrollRange;

- (void)addLongPressGesture;

-(void)removeLongPressGesture;

-(void)initData;

@end
