//
//  mainLeftBar.h
//  FPSApp
//
//  Created by Rex on 2016/6/24.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainLeftBarDelegate <NSObject>

-(void)DidPressControlButton;

@end

@interface mainLeftBar : UIImageView

@property (readwrite)int currentPage;

@property (strong,nonatomic)UIViewController *mainVC;

-(id)initWithFrame:(CGRect)frame currentPage:(int)page;

@property (weak) id<MainLeftBarDelegate> delegate;

@end
