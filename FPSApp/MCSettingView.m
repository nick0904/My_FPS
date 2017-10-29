

#import "MCSettingView.h"

@implementation MCSettingView {
    
    CGRect m_frame;
    
    UITapGestureRecognizer *tap; //點擊手勢
    
    UILongPressGestureRecognizer *lp; //長按觸發手勢
    
    CGPoint currentPoint; //settingView 目前座標

}

@synthesize key_type,parentObj,isSelected,canMove,ary_imgView,keyboardLabel;

#pragma mark - refreshSettingView
-(void)refreshSettingView {
    
    m_frame = self.frame;
    
    //=============  tap gesture  ==============
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:tap];
    
    
    //=============  lp  gesture  ==============
    lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    
    [self addGestureRecognizer:lp];
    
    lp.minimumPressDuration = 0.5;
    
    
    //=============  ary_imgView  ==============
    ary_imgView = [NSMutableArray new];
    
    for (int imgViewIndex = 0; imgViewIndex < 8; imgViewIndex++) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        
        imgView.frame =  [self imageViewFrame:imgViewIndex];
        
        imgView.hidden = YES;
        
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self choseImageName:imgViewIndex]]];
        
        [self addSubview:imgView];
        
        [ary_imgView addObject:imgView];
        
        imgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    }
    
    //原設定顯示  ary_imgView[0],其他隱藏
    ary_imgView[0].hidden = NO;
    
    //未被使用者選者
    self.isSelected = NO;
    
    
    //顯示鍵盤按鍵的label
    keyboardLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.05, 0, self.frame.size.width * 0.8, self.frame.size.height * 0.85)];
    keyboardLabel.textColor = [UIColor blackColor];
    keyboardLabel.textAlignment = NSTextAlignmentCenter;
    keyboardLabel.hidden = NO;
    keyboardLabel.backgroundColor = [UIColor clearColor];
    keyboardLabel.font = [UIFont systemFontOfSize:keyboardLabel.frame.size.width/4];
    keyboardLabel.numberOfLines = 0;
    keyboardLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //keyboardLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:keyboardLabel];
    
    
    //===========  key_type 預設 keyboard ============
    key_type = 0;

    //===========  儲存每個 settingView 的 keycode  =============
    self.settingView_keycode = 0;
}

#pragma mark - 圖片名稱
-(NSString *)choseImageName:(int)index {
    
    NSString *imgName;
    
    switch (index) {
            
        case 0://編輯鍵 up
            imgName = @"macro_edit_btn_a_blank_up.png";
            break;
        case 1://編輯鍵 down
            imgName = @"macro_edit_btn_a_blank_down.png";
            break;
        case 2://keyboard down
            imgName = @"macro_edit_btn_a_kb_down.png";
            break;
        case 3://keyboard up
            imgName = @"macro_edit_btn_a_kb_up.png";
            break;
        case 4://mouseLeft down
            imgName = @"macro_edit_btn_a_ms_l_down.png";
            break;
        case 5://mouseLeft up
            imgName = @"macro_edit_btn_a_ms_l_up.png";
            break;
        case 6://mouseRight down
            imgName = @"macro_edit_btn_a_ms_r_down.png";
            break;
        case 7://mouseRight up
            imgName = @"macro_edit_btn_a_ms_r_up.png";
            break;
        default:
            break;
            
    }
    
    return imgName;
}


#pragma mark - 顯示 keyboardLabel 或 隱藏
-(void)showOrHideKeyboardLabel:(int)type {
    
    if (type == 2 || type == 3) {
        
        keyboardLabel.hidden = NO;
        
        switch (type) {
            case 2:
                keyboardLabel.frame = CGRectMake(self.frame.size.width * 0.05, 0, self.frame.size.width * 0.9, self.frame.size.height * 0.9);
                break;
            case 3:
                keyboardLabel.frame = CGRectMake(self.frame.size.width * 0.05, 0 - self.frame.size.height * 0.1, self.frame.size.width * 0.9, self.frame.size.height * 0.9);
                break;
            default:
                break;
        }
        
    }
    else {
        
        keyboardLabel.hidden = YES;
    }
    
}


#pragma mark - 圖片大小
-(CGRect)imageViewFrame:(int)index {
    
    CGRect frame;
    
    switch (index) {
        case 0://編輯鍵 up
            frame = CGRectMake(0, 0, m_frame.size.width*0.95, m_frame.size.width*0.95/1.6);
            break;
        case 1://編輯鍵 down
            frame = CGRectMake(0, 0, m_frame.size.width*0.95, m_frame.size.width*0.95/1.6);
            break;
        case 2://keyboard down
            frame = CGRectMake(0, 0, m_frame.size.width*0.95, m_frame.size.width*0.95);
            break;
        case 3://keyboard up
            frame = CGRectMake(0, 0, m_frame.size.width*0.95, m_frame.size.width*0.95);
            break;
        case 4://mouseLeft down
            frame = CGRectMake(0, 0, m_frame.size.width*0.95/1.38, m_frame.size.width*0.95);
            break;
        case 5://mouseLeft up
            frame = CGRectMake(0, 0, m_frame.size.width*0.95/1.38, m_frame.size.width*0.95);
            break;
        case 6://mouseRight down
            frame = CGRectMake(0, 0, m_frame.size.width*0.95/1.38, m_frame.size.width*0.95);
            break;
        case 7://mouseRight up
            frame = CGRectMake(0, 0, m_frame.size.width*0.95/1.38, m_frame.size.width*0.95);
            break;
        default:
            break;
    }
    
    return frame;
}

#pragma mark - tapAction
-(void)tapAction:(UITapGestureRecognizer *)tap {
    /*
     1.先判斷是哪個 settingView 被選擇
     2.settingView 對應的 listening 顯示
     3.需判斷是 keyboard, 滑鼠mouseLeft, mouseRight
     4.點擊彈跳 keyboard ,mouseLeft, mouseRight 視窗
     */
    
    self.isSelected = YES;
    
    [self showTheSettingWindow];
}

-(void)showTheSettingWindow {
    
    MCCreateViewController *vc = (MCCreateViewController *)parentObj;
    
    vc.isSettingViewCallKeyCodeResponse = YES;
    
    [vc showSettingWindow];
    
    //[self performSelector:@selector(bufferZoneToCallSettingWindow) withObject:nil afterDelay:1.5];
    
}


-(void)bufferZoneToCallSettingWindow {
    
    [self selectedKeyType:key_type];

}

#pragma mark - 分辨 keyType
-(void)selectedKeyType:(int)type {
    
    MCCreateViewController *vc = (MCCreateViewController *)self.parentObj;
    
    switch (type) {
        case 0:
            NSLog(@"keyboard");
            [vc showKeyType:type];
            break;
        case 1:
            NSLog(@"mouseLeft");
            [vc showKeyType:type];
            break;
        case 2:
            NSLog(@"mouseRight");
            [vc showKeyType:type];
            break;
        default:
            break;
    }
    
}

#pragma mark - 顯示選擇的 keyType 其餘則隱藏
-(void)showSettingViewAtIndex:(int)index {
    
    for (int i = 0; i < ary_imgView.count; i++) {
        
        if (index == i) {
            
            ary_imgView[i].hidden = NO;
        }
        else {
            
            ary_imgView[i].hidden = YES;
        }
        
    }
    
}


#pragma mark - longPressAction
-(void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    /*
     長按拖拉丟垃圾桶
     */
    
    UIGestureRecognizerState state = gesture.state;
    
    MCCreateViewController *vc = (MCCreateViewController *)self.parentObj;
    
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
            //如果是顯示 ary_imgView[0]或 ary_imgView[1],則不能移動
            if (ary_imgView[0].hidden == NO || ary_imgView[1].hidden == NO) {
                
                self.canMove = NO;
            }
            else {

                self.canMove = YES;
                
                [vc showTrashcanOrHidden:YES];
            }
            
            break;
            
        case UIGestureRecognizerStateChanged:
            
            if (self.canMove == NO) {
                
                return;
            }
            else {
                
                currentPoint = [lp locationInView:vc.view];
                
                self.center = currentPoint;
                
            }
            
            if (CGRectContainsPoint(vc.trashcan.frame, currentPoint)) {
                
                vc.trashcanImgView.image = [UIImage imageNamed:@"icon_a_trashcan_down"];
            }
            else {
                
                vc.trashcanImgView.image = [UIImage imageNamed:@"icon_a_trashcan_up"];
            }
            
            break;
            
        case UIGestureRecognizerStateEnded:
            
            self.canMove = NO;
            
            //KEN
            CGPoint endPoint = [lp locationInView:vc.view];
            
            if (CGRectContainsPoint(vc.trashcan.bounds, endPoint)) {
                
                //(inside Trashcan)
                for (int imgIndex = 0; imgIndex < 8; imgIndex++) {
                    
                    if (imgIndex == 0) {
                        
                        ary_imgView[imgIndex].hidden = NO;
                        keyboardLabel.hidden = YES;
                    }
                    else {
                        
                        ary_imgView[imgIndex].hidden = YES;
        
                    }
                    
                }
                
                self.center = self.oriCenterPoint;
                
                self.settingView_keycode = 0;
            }
            else {
                
                //(outside Trashcan)
                self.center = self.oriCenterPoint;
            }
            
            vc.trashcanImgView.image = [UIImage imageNamed:@"icon_a_trashcan_up"];
            
            [vc showTrashcanOrHidden:NO];
            
            [vc checkDelayBtColor];
            
            //self.settingView_keycode = 0;
            
            break;
            
        default:
            break;
    }
    
    
}




@end
