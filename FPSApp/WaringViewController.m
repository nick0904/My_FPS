

#import "WaringViewController.h"

@interface WaringViewController ()


@property (strong, nonatomic) IBOutlet UIImageView *redView;

@property (strong, nonatomic) IBOutlet UILabel *waringMessage;

@property (strong, nonatomic) IBOutlet UILabel *waringDescription;


@end

@implementation WaringViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     _waringMessage.text = self.waring_message;
    _waringDescription.text = self.waring_description;
    
    _waringMessage.adjustsFontSizeToFitWidth = YES;
    _waringDescription.adjustsFontSizeToFitWidth = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(waringAnimation:) userInfo:_redView repeats:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    // 隱藏狀態列
    return YES;
}

//紅色閃燈動畫
-(void)waringAnimation:(UIImageView *)theImgView {
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        
        _redView.alpha = 0.0;
        
    } completion:nil];
    
}

- (IBAction)dismissVC:(id)sender {
    
    if (_parentObj != nil) {
        
        [_parentObj dismissViewControllerAnimated:YES completion:nil];
    }
    
}

@end
