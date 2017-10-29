

#import "MViewController.h"
#import "CFTableViewCellObject.h"
#import "CFEditViewController.h"
#import "CFMainViewController.h"

@interface CFCreatViewController : MViewController <UITableViewDelegate,UITableViewDataSource,ConnectStateDelegate,DataResponseDelegate,FPCloudClassDelegate>

@property (strong, nonatomic) NSMutableArray *gameIcon;
@property (strong, nonatomic) NSMutableArray *gameDescription;
@property (strong, nonatomic) NSMutableArray *machineIcon;
@property (strong, nonatomic) NSMutableArray *markColor;

@property (strong, nonatomic) CFTableViewCellObject *configNewObj;


@end
