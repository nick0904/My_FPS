
@class CFMainViewController;

#import <Foundation/Foundation.h>

@interface BtAnimationCurve : NSObject


@property (strong, nonatomic) CFMainViewController *m_parentVC;
@property (strong, nonatomic) UIImageView *m_barView; //固定桿
@property (strong, nonatomic) UIButton *m_configBt; //config按鈕
@property (strong, nonatomic) UIButton *m_marcoBt; //按marco鈕
@property  CGFloat m_animationTime; //按鈕旋轉動畫時間
@property  CGFloat m_pathRadious; //路徑軌跡半徑
@property  BOOL configAnimFlag; //Button切換動畫用，判斷是 config 還是 marco
@property (strong, nonatomic) UIImageView *m_lineView; //連接按鈕與列表的line

-(void)btAnimationCurve:(UIButton *)bt;

-(CGPoint)getPositionFormAngles:(CGFloat)angel center:(CGPoint)theCenter radious:(CGFloat)theRadious;

-(void)bezierPath;

@end
