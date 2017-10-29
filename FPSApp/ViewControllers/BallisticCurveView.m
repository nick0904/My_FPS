//
//  BallisticCurveView.m
//  ballisticTest
//
//  Created by Rex on 2016/7/1.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "BallisticCurveView.h"

@interface BallisticCurveView()

@end

@implementation BallisticCurveView

@synthesize linePointsArray;

-(id)initWithFrame:(CGRect)frame withData:(NSDictionary*)dataArray{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initParameter];
        [self initPointsData:dataArray];
        [self initInterface];
    }
    
    return self;
}

-(void)initInterface{
    
    xLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
    
    xLineView.backgroundColor = [UIColor yellowColor];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:xLineView];
}

-(void)initParameter{
    
    linePointsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    scaleSize = self.frame.size.width/100;

}

-(void)initPointsData:(NSDictionary*)dataArray{
    
    NSLog(@"dataArray = %@",dataArray);
    
    if (dataArray == nil) {
        
        [linePointsArray removeAllObjects];
        
        float xPoint = 0;
        float yPoint = 0;
        
        for (int i=0; i<=20; i++) {
            
            xPoint = i*5;
            yPoint = i*5;
            
            NSNumber *xNumber = [NSNumber numberWithInt:xPoint];
            NSNumber *yNumber = [NSNumber numberWithInt:yPoint];
            NSNumber *changed;
            
            changed = [NSNumber numberWithBool:NO];
            
            if (i==0 || i == 20) {
                changed = [NSNumber numberWithBool:YES];
            }
            
            NSMutableDictionary *pointsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               xNumber,@"xPoint",
                                               yNumber,@"yPoint",
                                               changed,@"changed",nil];
            
            [linePointsArray addObject:pointsDict];
            //NSLog(@"linePointsArray new =%@",linePointsArray);
        }
    }else{
        
        NSLog(@"dataArray.count = %d",dataArray.count);
        
        NSMutableArray *ballisticAry = [dataArray objectForKey:@"ballisticsArray"];
        
        NSMutableArray *ballisticChange = [dataArray objectForKey:@"ballisticChanged"];
        
        if (ballisticAry.count <= 20) {
            [ballisticAry insertObject:@"0" atIndex:0];
            [ballisticChange insertObject:@"1" atIndex:0];
        }
        
        
        
        for (int i=0; i<dataArray.count+1; i++) {
            
            NSNumber *xNumber = [NSNumber numberWithInt:i*5];
            NSNumber *yNumber = [NSNumber numberWithInt:[[ballisticAry objectAtIndex:i] intValue]];
            
            NSNumber *changed = [NSNumber numberWithBool:[[ballisticChange objectAtIndex:i] boolValue]];
            
            //NSLog(@"yNumber.floatValue = %f",yNumber.floatValue);
            //NSLog(@"changed = %d",changed.boolValue);
            
            
            if (i==0 || i == 20) {
                changed = [NSNumber numberWithBool:YES];
            }
            
            NSMutableDictionary *pointsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               xNumber,@"xPoint",
                                               yNumber,@"yPoint",
                                               changed,@"changed",nil];
            
            [linePointsArray addObject:pointsDict];
        }
        
        //NSLog(@"linePointsArray edit =%@",linePointsArray);
    }
    
    pointIndex = 0;
    
}

-(void)setXLinePosition:(int)xPoint{
    
    pointIndex = xPoint;
    
    nowXPosition = xPoint*5*scaleSize;
    
    nowYPosition = [[[linePointsArray objectAtIndex:xPoint] objectForKey:@"xPoint"] floatValue];
    
    xLineView.frame = CGRectMake(nowXPosition, 0, 1, self.frame.size.height);
    
}

-(float)getYPointValue{
    
    return  round([[[linePointsArray objectAtIndex:pointIndex] objectForKey:@"yPoint"] floatValue]);
}

-(void)setYPointValue:(NSMutableDictionary *)value{
    
    NSMutableDictionary *changePointDict = [linePointsArray objectAtIndex:pointIndex];
    
    NSNumber *yPointValue = [NSNumber numberWithFloat:round([[value objectForKey:@"yPoint"] floatValue])];
    
    //NSLog(@"yPointValue = %@",yPointValue);
    
    [changePointDict setObject:yPointValue forKey:@"yPoint"];
    
    NSNumber *changed = [NSNumber numberWithBool:YES];
    
    [changePointDict setObject:changed forKey:@"changed"];
    
    [linePointsArray replaceObjectAtIndex:pointIndex withObject:changePointDict];
    
    NSMutableArray *changedIndexAry = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=0; i < linePointsArray.count; i++) {
        
        BOOL changed = [[[linePointsArray objectAtIndex:i] objectForKey:@"changed"] boolValue];
        
        if(changed){
            
            NSNumber *indexNumb = [NSNumber numberWithInt:i];
            
            [changedIndexAry addObject:indexNumb];
        }
        
    }
    
    for (int i=0; i<changedIndexAry.count; i++) {
        
        if (i+1 == changedIndexAry.count) {
            return;
        }
        
        int index = [[changedIndexAry objectAtIndex:i] intValue];
        
        int nextIndex = [[changedIndexAry objectAtIndex:i+1] intValue];
        
        NSMutableDictionary *startPointsDict = [linePointsArray objectAtIndex:index];
        
        NSMutableDictionary *endPointsDict = [linePointsArray objectAtIndex:nextIndex];
        
        CGPoint startPoint = CGPointMake([[startPointsDict objectForKey:@"xPoint"] intValue], [[startPointsDict objectForKey:@"yPoint"] intValue]);
        
        CGPoint endPoint = CGPointMake([[endPointsDict objectForKey:@"xPoint"] intValue], [[endPointsDict objectForKey:@"yPoint"] intValue]);
        
        float slope = [self calculateSlope:startPoint endPoint:endPoint];
        
        for (int i=index; i<nextIndex; i++) {
            
            NSNumber *endPointNum = [[linePointsArray objectAtIndex:i] objectForKey:@"xPoint"];
            
            NSNumber *changedY = [NSNumber numberWithFloat:[self startPoint:startPoint endPointX:endPointNum.floatValue slope:slope]];
            
            [[linePointsArray objectAtIndex:i] setObject:changedY forKey:@"yPoint"];
        }
        
    }
    
    
}

-(void)setDataPoints:(int)index pointDict:(NSMutableDictionary*)pointDict{
    
    int nextIndex = index;
    
    if (index == 0) {
        index += 1;
    }else{
        index -= 1;
    }
    
    if (nextIndex == linePointsArray.count-1) {
        nextIndex -= 1;
    }else{
        nextIndex += 1;
    }
    
    CGPoint startPoint = CGPointMake([[pointDict objectForKey:@"xPoint"] intValue], [[pointDict objectForKey:@"yPoint"] intValue]);
    
    NSNumber *prevPointX = [[linePointsArray objectAtIndex:index] objectForKey:@"xPoint"];
    
    NSNumber * prevPointY = [[linePointsArray objectAtIndex:index] objectForKey:@"yPoint"];
    
    CGPoint prevPoint = CGPointMake(prevPointX.floatValue, prevPointY.floatValue);
    
    float prevSlope = [self calculateSlope:startPoint endPoint:prevPoint];
    
    NSLog(@"prevPointX.intValue = %d",prevPointX.intValue);
    NSLog(@"startPoint.x = %f",startPoint.x);
    
    for (int i=prevPointX.intValue; i<startPoint.x; i++) {
        
        NSNumber *endPoint = [[linePointsArray objectAtIndex:i] objectForKey:@"xPoint"];
        
        NSNumber *changedY = [NSNumber numberWithFloat:[self startPoint:startPoint endPointX:endPoint.floatValue slope:prevSlope]];
        
        if (changedY.intValue == -0) {
            changedY = [NSNumber numberWithInt:0];
        }
        
        [[linePointsArray objectAtIndex:i] setObject:changedY forKey:@"yPoint"];
    }
    
    NSNumber *nextPointX = [[linePointsArray objectAtIndex:nextIndex] objectForKey:@"xPoint"];
    
    NSNumber * nextPointY = [[linePointsArray objectAtIndex:nextIndex] objectForKey:@"yPoint"];
    
    CGPoint nextPoint = CGPointMake(nextPointX.floatValue, nextPointY.floatValue);
    
    float nextSlope = [self calculateSlope:startPoint endPoint:nextPoint];
    

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    //不可變預設曲線
    CGContextRef defaultLine = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(defaultLine, 255.0/255.0, 255.0/255.0, 255.0/255.0, 0.5);
    CGContextMoveToPoint(defaultLine, 0*scaleSize, 100*scaleSize);
    CGContextAddLineToPoint(defaultLine, 100*scaleSize, 0*scaleSize);
    CGContextSetLineWidth(defaultLine, 2.0);
    CGContextStrokePath(defaultLine);
    
    
    //可變曲線
    CGContextRef baseContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(baseContext, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1);
    CGContextSetLineWidth(baseContext, 2.0);
    
    CGContextSetLineCap(baseContext, kCGLineCapRound);
    
//    NSLog(@"linePointsArray draw =%@",linePointsArray);
    
    if (linePointsArray.count != 0) {
        
        for (int i=0; i<linePointsArray.count; i++) {
            
            float xPoint = [[[linePointsArray objectAtIndex:i] objectForKey:@"xPoint"] floatValue];
            float yPoint = 100-[[[linePointsArray objectAtIndex:i] objectForKey:@"yPoint"] floatValue];
            
            BOOL changed = [[[linePointsArray objectAtIndex:i] objectForKey:@"changed"] boolValue];
            
            
            if (changed) {
                if (i == 0) {
                    
                    CGContextMoveToPoint(baseContext, xPoint*scaleSize, yPoint*scaleSize);
                    
                }else{
                    
                    CGContextAddLineToPoint(baseContext, xPoint*scaleSize, yPoint*scaleSize);
                }
            }
        }
    }
    
    CGContextStrokePath(baseContext);

}

//回傳盲區參數
-(NSMutableArray *)returnBallisticPoints{
    
    NSMutableArray *ballisticAry = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=1; i<linePointsArray.count; i++) {
        
        int ballisticParam = round([[[linePointsArray objectAtIndex:i] objectForKey:@"yPoint"] floatValue]);
        
        NSNumber *ballisticParamNum = [NSNumber numberWithInt:ballisticParam];
        
        [ballisticAry addObject:ballisticParamNum];
    
    }
    
    return ballisticAry;
}

//回傳盲區移動參數
-(NSMutableArray *)returnBallisticChange{
    
    NSMutableArray *ballisticChange = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=1; i<linePointsArray.count; i++) {
        
        [ballisticChange addObject:[[linePointsArray objectAtIndex:i] objectForKey:@"changed"]];
        
    }
    
    return ballisticChange;

}

//計算斜率
-(CGFloat)calculateSlope:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    
    return (startPoint.y-endPoint.y)/(startPoint.x-endPoint.x);
}

//計算Y點
-(float)startPoint:(CGPoint)startPoint endPointX:(float)endPointX slope:(float)slope{
    
    return slope *(endPointX-startPoint.x)+startPoint.y;
}

@end
