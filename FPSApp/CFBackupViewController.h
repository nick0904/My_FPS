

#import "MViewController.h"
#import "ConfigMacroData.h"

@interface CFBackupViewController : MViewController < UITextFieldDelegate , UITableViewDelegate, UITableViewDataSource,FPCloudClassDelegate,ConnectStateDelegate,DataResponseDelegate>


@property NSInteger myConfigDeleteIndexPathRow;

//myConfig(個人)
-(void)downloadCloudDataForMyConfig:(NSInteger)indexPathRow;//下載方法

-(void)postDeleteFileAtIndexpath:(NSInteger)indexPathRow;//刪除方法

-(void)withdrawFileAtIndexPath:(NSInteger)indexPathRow;//回收方法

-(void)sharedMyConfigAtIndexPath:(NSInteger)indexPathRow;//分享方法



//sharedConfig(公開)
-(void)downloadCloudDataForSharedConfig:(NSInteger)indexPathRow;//下載方法




@end
