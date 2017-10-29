

#import "CustomizedTableView.h"
#import "CFMainViewController.h"

static NSTimeInterval movableCellAnimationTime = 0.25;

@interface CustomizedTableView() {
    
    UISwipeGestureRecognizer *cellSwipGestureLeft;
    
    UISwipeGestureRecognizer *cellSwipGestureRight;
    
    NSIndexPath *preIndexPath;
}

@property (nonatomic, strong) UILongPressGestureRecognizer *gesture;//長按手勢

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) UIView *tempView;//截圖

@property (nonatomic, strong) NSMutableArray *tempDataSource;

@property (nonatomic, strong) CADisplayLink *edgeScrollTimer;

@end

@implementation CustomizedTableView

@dynamic dataSource,delegate;


-(void)dealloc {
    
    self.drawMovalbeCellBlock = nil;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    
    if (!self) {
        
        return nil;
    }
    
    //[self initData];
    
    //[self addLongPressGesture];
    
    //[self addLeftAndRightSwipGesture];
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (!self) {
        
        return nil;
    }
    
    //[self initData];
        
    //[self addLongPressGesture];
    
    //[self addLeftAndRightSwipGesture];
    
    return self;
}

-(void)initData {
    
    self.gestureMinimumPressDuration = 0.5f;
    
    self.canEdgeScroll = YES;
    
    self.edgeScrollRange = 200;
}

//-(void)addLeftAndRightSwipGesture {
//    
//    //滑動手勢(左)
//    cellSwipGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipAction:)];
//    
//    cellSwipGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
//    
//    cellSwipGestureLeft.numberOfTouchesRequired = 1;
//    
//    [self addGestureRecognizer:cellSwipGestureLeft];
//    
//    //滑動手勢(右)
//    cellSwipGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipAction:)];
//    
//    cellSwipGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
//    
//    cellSwipGestureRight.numberOfTouchesRequired = 1;
//    
//    [self addGestureRecognizer:cellSwipGestureRight];
//
//    //preIndexPath
//    preIndexPath = nil;
//}

#pragma mark - addGesture(增加長按手勢)
- (void)addLongPressGesture {
    
    self.gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTypes:)];
    
    self.gesture.minimumPressDuration = self.gestureMinimumPressDuration;

    [self addGestureRecognizer:self.gesture];
    
    NSLog(@"增加");
}

#pragma mark - removeLongPressGesture(移除長按手勢)
-(void)removeLongPressGesture {
    
    if (self.gesture != nil) {
        
        [self removeGestureRecognizer:self.gesture];
        
        NSLog(@"移除");
    }
}

#pragma mark - GestureTypes(長按手勢狀態)
-(void)gestureTypes:(UILongPressGestureRecognizer *)gesture {
    
    switch (gesture.state) {
        
        case UIGestureRecognizerStateBegan: {
            
            [self gestureBegan:gesture];
            
        }
        break;
            
        case UIGestureRecognizerStateChanged: {
            
            if (!self.canEdgeScroll) {
                
                [self gestureChanged:gesture];

            }
        }
        break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
            [self gestureEndedOrCancelled:gesture];
            
        }
        break;
            
        default:
            break;
    }
    
}


#pragma mark - gestureBegan(長按手勢狀態開始方法)
-(void)gestureBegan:(UILongPressGestureRecognizer *)gesture {
    
    CGPoint currentPoint = [gesture locationInView:gesture.view];
    
    NSIndexPath *selectedIndexPath = [self indexPathForRowAtPoint:currentPoint];
    
    if (!selectedIndexPath) {
        
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:willMoveCellAtIndexPath:)]) {
        
        [self.delegate tableView:self willMoveCellAtIndexPath:selectedIndexPath];
    }
    
    if (self.canEdgeScroll) {
        //開始滾動邊緣
        
        [self startEdgeScroll];
        
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dataSourceArrayInTableView:)]) {
                
        //self.tempDataSource = [self.dataSource dataSourceArrayInTableView:self].mutableCopy;
        self.tempDataSource = [self.dataSource dataSourceArrayInTableView:self];
    }
    
    self.selectedIndexPath = selectedIndexPath;
    
    CustomizedCell *cell = [self cellForRowAtIndexPath:selectedIndexPath];
    
    UIImageView *bgView = [cell.contentView viewWithTag:10];
    bgView.alpha = 1.0;
    
    UIImageView *bg = [cell.contentView viewWithTag:111];
    bg.alpha = 1.0;
    
    //快捷鍵分隔線
    UIImageView *lineView = [cell.contentView viewWithTag:444];
    lineView.image = [UIImage imageNamed:@"config_icon_a_unchangable_4"];
    
    //快捷鍵按鍵圖案  //config_icon_a_unchangable_3
    UIImageView *hotKeyImgView = [cell.contentView viewWithTag:222];
    hotKeyImgView.image = [UIImage imageNamed:@"config_icon_a_unchangable_3"];
    
    //Config or Macro
    
    
    
    //截圖
    self.tempView = [self snapshotViewWithInputView:cell];
    
    if(self.drawMovalbeCellBlock) {
        //使用者自訂模式
        
        self.drawMovalbeCellBlock(self.tempView);
    }
    else {
        //預設樣式
        self.tempView.layer.shadowColor = [UIColor grayColor].CGColor;
        self.tempView.layer.masksToBounds = NO;
        self.tempView.layer.cornerRadius = 0;
        self.tempView.layer.shadowOffset = CGSizeMake(-5, 0);
        self.tempView.layer.shadowOpacity = 0.4;
        self.tempView.layer.shadowRadius = 5;
    }
    
    self.tempView.frame = cell.frame;
    
    //將截圖加到 tableView 上
    [self addSubview:self.tempView];
    
    cell.hidden = YES;
    
    [UIView animateWithDuration:movableCellAnimationTime animations:^{
        
        self.tempView.center = CGPointMake(self.tempView.center.x, currentPoint.y);
    }];
}

#pragma mark - gestureChanged(長按手勢狀態改變方法)
- (void)gestureChanged:(UILongPressGestureRecognizer *)gesture {
    
    CGPoint currentPoint = [gesture locationInView:gesture.view];
    
    NSIndexPath *currentIndexPath = [self indexPathForRowAtPoint:currentPoint];
    
    if (currentIndexPath && ![self.selectedIndexPath isEqual:currentIndexPath]) {
        
        [self updateDataSourceAndCellFromIndexPath:self.selectedIndexPath toIndexPath:currentIndexPath];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didMoveCellFromIndexPath:toIndexPath:)]) {
            
            [self.delegate tableView:self didMoveCellFromIndexPath:self.selectedIndexPath toIndexPath:currentIndexPath];
        }
        
        self.selectedIndexPath = currentIndexPath;
    }
    
    self.tempView.center = CGPointMake(self.tempView.center.x, currentPoint.y);
}

#pragma mark - gestureEndedOrCancelled(長按手勢狀態結束方法)
- (void)gestureEndedOrCancelled:(UILongPressGestureRecognizer *)gesture {
    
    if (self.canEdgeScroll) {
        
        [self stopEdgeScroll];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableView:newDataSourceArrayAfterMove:)]) {
        
        //[self.dataSource tableView:self newDataSourceArrayAfterMove:_tempDataSource.copy];
        
        [self.dataSource tableView:self newDataSourceArrayAfterMove:self.tempDataSource];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:endMoveCellAtIndexPath:)]) {
        
        [self.delegate tableView:self endMoveCellAtIndexPath:self.selectedIndexPath];
    }
    
    CustomizedCell *cell = [self cellForRowAtIndexPath:self.selectedIndexPath];
    
    [UIView animateWithDuration:movableCellAnimationTime animations:^{
        
        self.tempView.center = cell.center;
        
    } completion:^(BOOL finished) {
       
        cell.hidden = NO;
        
        [self.tempView removeFromSuperview];
        
        self.tempView = nil;
        
    }];
    
}

#pragma mark Private action 快照
- (UIView *)snapshotViewWithInputView:(UIView *)inputView {
    
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    
    return snapshot;
}


- (void)updateDataSourceAndCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    NSLog(@"updateDataSourceAndCellFromIndexPath-----fromIndexPath = %i , toIndexPath = %i", fromIndexPath.row, toIndexPath.row);
    
    NSLog(@"updateDataSourceAndCellFromIndexPath-----[self numberOfSections] = %i", [self numberOfSections]);
    NSLog(@"updateDataSourceAndCellFromIndexPath-----self.tempDataSource = %@", self.tempDataSource);
    
    if ([self numberOfSections] == 1) {
        
        //只有1個 section
        [self.tempDataSource exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
        
        [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
        
        
        [self.m_superVC moveConfigOrMacrodData:fromIndexPath.row to:toIndexPath.row];
        
//        NSMutableArray *configImgAry = [[ConfigMacroData sharedInstance] getConfigImage];
//        NSMutableArray *configAry = [[ConfigMacroData sharedInstance] getConfigArray];
//        
//        //本機圖片
//        if (configImgAry.count == configAry.count && configImgAry.count!=0) {
//            
//            [configImgAry exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
//            [[ConfigMacroData sharedInstance] saveConfigImage:configImgAry];
//        }
        
        
    }
    
}

#pragma mark - EdgeScroll (邊緣滾動)
-(void)startEdgeScroll {
    
    self.edgeScrollTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(processEdgeScroll)];
    
    [self.edgeScrollTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

}

-(void)processEdgeScroll {
    
    [self gestureChanged:self.gesture];
    
    CGFloat minOffsetY = self.contentOffset.y + self.edgeScrollRange;
    
    CGFloat maxOffsetY = self.contentOffset.y + self.bounds.size.height - self.edgeScrollRange;
    
    CGPoint touchPoint = self.tempView.center;
    
    //處理上下達到極限之後不可再滾動tableView，其中處理了滾動到最邊緣的时候，當前處於edgeScrollRange内，但是tableView還未顯示完，需要顯示完tableView才停止滾動
    if (touchPoint.y < self.edgeScrollRange) {
        
        if (self.contentOffset.y <= 0) {
            
            return;
        }
        else {
            
            if (self.contentOffset.y - 1 < 0) {
                
                return;
            }
            
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - 1) animated:NO];
            
            self.tempView.center = CGPointMake(self.tempView.center.x, self.tempView.center.y - 1);
        }
    
    }
    
    if (touchPoint.y > self.contentSize.height - self.edgeScrollRange) {
        
        if (self.contentOffset.y >= self.contentSize.height - self.bounds.size.height) {
            
            return;
        }
        else {
            
            if (self.contentOffset.y + 1 > self.contentSize.height - self.bounds.size.height) {
                
                return;
            }
       
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y + 1) animated:NO];
            
            self.tempView.center = CGPointMake(self.tempView.center.x, self.tempView.center.y + 1);
        }
    
    }
    
    //處理滾動
    CGFloat maxMoveDistance = 20;
    
    if (touchPoint.y < minOffsetY) {
        
        //cell 往上移
        CGFloat moveDistance = (minOffsetY - touchPoint.y) / self.edgeScrollRange * maxMoveDistance;
        
        [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - maxMoveDistance) animated:NO];
        
        self.tempView.center = CGPointMake(self.tempView.center.x, self.tempView.center.y - moveDistance);
        
    }
    else if (touchPoint.y > maxOffsetY) {
        
        //cell 往下移
        CGFloat moveDistance = (touchPoint.y - maxOffsetY) / self.edgeScrollRange * maxMoveDistance;
        
        [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y + moveDistance) animated:NO];
        
        self.tempView.center = CGPointMake(self.tempView.center.x, self.tempView.center.y + moveDistance);
    }

}

#pragma mark - 偵測停止
- (void)stopEdgeScroll
{
    if (self.edgeScrollTimer) {
        
        [self.edgeScrollTimer invalidate];
        
        self.edgeScrollTimer = nil;
    }
}

///*
// 
// 向左滑動顯示刪除鍵
// 向右滑動隱藏刪除鍵
// 
//*/
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    //當tableView 向上滑 或 向下滑
//    //隱藏所有的 deleteBt
//    
//    if (preIndexPath == nil) {
//        
//        return;
//    }
//    else {
//        
//        CustomizedCell *cell = [self cellForRowAtIndexPath:preIndexPath];
//        
//        [self cellShowDeleteBtOrClose:cell showDeleteBt:NO];
//        
//        NSLog(@"上下滾滾");
//        
//    }
//    
//}
//
//
//#pragma mark - cellSwipAction(cell 向右滑 - 向左滑)
//-(void)cellSwipAction:(UISwipeGestureRecognizer *)gesture {
//    
//    //取得在 tableView 裡的手指座標
//    CGPoint currentPoint = [gesture locationInView:self];
//    
//    //目前手指座標所對應的 tableView indexPath
//    NSIndexPath *currentIndexPath = [self indexPathForRowAtPoint:currentPoint];
//    
//    //目前與使用者互動的 cell
//    CustomizedCell *cell = [self cellForRowAtIndexPath:currentIndexPath];
//    
//    if ([gesture isEqual:cellSwipGestureLeft]) {
//        
//        if (preIndexPath == nil) {
//            
//            preIndexPath = currentIndexPath;
//        }
//        else if (preIndexPath != nil && ![preIndexPath isEqual:currentIndexPath]) {
//            
//            //先將上一個隱藏
//            CustomizedCell *preCell = [self cellForRowAtIndexPath:preIndexPath];
//            
//            [self cellShowDeleteBtOrClose:preCell showDeleteBt:NO];
//            
//            preIndexPath = currentIndexPath;
//        }
//        
//        [self cellShowDeleteBtOrClose:cell showDeleteBt:YES];
//        
//    }
//    else if ([gesture isEqual:cellSwipGestureRight]) {
//        
//        [self cellShowDeleteBtOrClose:cell showDeleteBt:NO];
//    }
//    
//}
//
//
//#pragma mark - 顯示或隱藏 cell 的 刪除鍵
//-(void)cellShowDeleteBtOrClose:(CustomizedCell *)theCell showDeleteBt:(BOOL)show {
//    
//    if (show) {
//        
//        [UIView animateWithDuration:0.28 animations:^{
//            
//            theCell.contentView.frame = CGRectMake(0 - self.frame.size.width/6, theCell.contentView.frame.origin.y, theCell.contentView.frame.size.width, theCell.contentView.frame.size.height);
//            
//            theCell.cellDeleteBt.alpha = 1.0;
//            
//            theCell.cellDeleteBt.userInteractionEnabled = YES;
//            
//        }];
//    }
//    else {
//        
//        [UIView animateWithDuration:0.1 animations:^{
//            
//            theCell.contentView.frame = CGRectMake(0, theCell.contentView.frame.origin.y, theCell.contentView.frame.size.width, theCell.contentView.frame.size.height);
//            
//            theCell.cellDeleteBt.userInteractionEnabled = NO;
//            
//            theCell.cellDeleteBt.alpha = 0;
//        }];
//        
//    }
//    
//}




@end
