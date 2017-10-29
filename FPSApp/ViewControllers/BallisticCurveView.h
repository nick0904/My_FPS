//
//  BallisticCurveView.h
//  ballisticTest
//
//  Created by Rex on 2016/7/1.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallisticCurveView : UIView{
    
    UIView *xLineView;
    float nowXPosition;
    float nowYPosition;
    float scaleSize;                    //縮放倍率
    int pointIndex;                     //資料索引值
}

@property (strong, nonatomic)NSMutableArray *linePointsArray; //所有座標

-(id)initWithFrame:(CGRect)frame withData:(NSDictionary*)dataArray;

//變更指標線位置
-(void)setXLinePosition:(int)xPoint;

//取得當前X的Y值
-(float)getYPointValue;

//設定當前X的Y值
-(void)setYPointValue:(NSMutableDictionary *)value;

//回傳曲線值
-(NSMutableArray *)returnBallisticPoints;
-(NSMutableArray *)returnBallisticChange;

//初始化座標
-(void)initPointsData:(NSDictionary*)dataArray;



@end
