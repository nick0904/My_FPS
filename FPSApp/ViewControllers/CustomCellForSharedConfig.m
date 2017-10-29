//
//  CustomCellForSharedConfig.m
//  FPSApp
//
//  Created by 曾偉亮 on 2016/10/12.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "CustomCellForSharedConfig.h"

@implementation CustomCellForSharedConfig

@synthesize sharedConfigIndexPathRow,downloadBt,m_superVC;


//add downlaod Action
-(void)downloadBtAddAction {
    
    if (downloadBt != nil){
        
        [downloadBt addTarget:self action:@selector(downloadCloudData) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}

//superVC download clould function
-(void)downloadCloudData {
    
    if (m_superVC != nil ) {
        
        [m_superVC downloadCloudDataForSharedConfig:sharedConfigIndexPathRow];
        
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
