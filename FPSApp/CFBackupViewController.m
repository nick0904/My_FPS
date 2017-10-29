

#import "CFBackupViewController.h"
#import "MyConfigCellObj.h"
#import "SharedConfigObj.h"
#import "CustomCellForSharedConfig.h"
#import "CustomizedCellForMyConfig.h"
#import "WaringViewController.h"
#import "ConnectLoadingView.h"
#import "CFTableViewCellObject.h"
#import "EliteObject.h"


//寫完一個功能一定要先進行完整測試

@interface CFBackupViewController () {
    
    BOOL isMyConfigActive; //判斷 My Config 頁面是否啟動(此為預設畫面)

    BOOL isSharedConfigActive; //判斷 Shared Config 頁面是否啟動
    
    BOOL isSearch_conditionActive; //判斷條件搜尋是否啟動
    
    CGRect oriSearchBarViewFrame;//紀錄原本searchBarView的大小
    
    //CustomizedCellforBackup 相關
    NSIndexPath *preIndexPath;
    UISwipeGestureRecognizer *cellSwipGestureLeft;
    UISwipeGestureRecognizer *cellSwipGestureRight;
    

    //MyConfig search
    NSMutableArray *ary_myConfig_search_img;
    NSMutableArray *ary_myConfig_search_platformStr;
    
    
    //SharedConfig search
    NSMutableArray *ary_sharedConfig_search_img;
    NSMutableArray *ary_sharedConfig_search_platformStr;

    
    //MyConfig Object
    NSMutableArray <MyConfigCellObj *> *ary_myConfigObj;
    
    //SharedConfig Object
    NSMutableArray <SharedConfigObj *> *ary_sharedConfigObj;
    
    //cloud 相關
    FPCloudClass *cloudClass;
    
    //索引
    NSInteger myConfigIndexPathRow;
    NSInteger sharedConfigIndexPathRow;
    
    //轉圈圈等待畫面
    ConnectLoadingView *loadingView;
    
    //硬體
    FPSConfigData *configData;
    
    //本機暫存
    CFTableViewCellObject *tempConfigData;
    
    //新增一筆
    int newInt;
    
    //下載索引
    NSInteger downloadIndex;
    
    //下載時判斷是 myConfig or sharedConfig
    BOOL isMyConfigDownload;
    
    //ary_gameList
    NSMutableArray<EliteObject *> *ary_gameList;
    
    //判斷是否觸發 select a game
    BOOL isGameListAction;
    
    //submit 索引
    NSInteger submitIndex;
    
    //myConfig platform 改變被選擇的 cell 背景顏色
    NSMutableArray *ary_myConfigBgView;
    
    //shared Config platform 改變被選擇的 cell 背景顏色
    NSMutableArray *ary_sharedConfigBgView;
    
    
}

@property (strong, nonatomic) IBOutlet UITableView *myConfigTableView;

@property (strong, nonatomic) IBOutlet UIView *search_conditionView;//條件搜尋頁面

@property (strong, nonatomic) IBOutlet UILabel *search_conditionLabel;//search for...標籤

@property (strong, nonatomic) IBOutlet UIView *searchBarView;

@property (strong, nonatomic) IBOutlet UIImageView *redImgView;

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;


@property (strong, nonatomic) IBOutlet UILabel *resultCount;


// submit  相關 ===============================
@property (strong, nonatomic) IBOutlet UIView *submitView;

@property (strong, nonatomic) IBOutlet UIScrollView *submitScrollView;

@property (strong, nonatomic) IBOutlet UILabel *submitTitle;

@property (strong, nonatomic) IBOutlet UILabel *submitContent;

@property (strong, nonatomic) IBOutlet UILabel *submitSperator;

@property (strong, nonatomic) IBOutlet UIView *submitGameView;

@property (strong, nonatomic) IBOutlet UIImageView *submitImgView;

@property (strong, nonatomic) IBOutlet UITextField *submitTextField;

@property (strong, nonatomic) IBOutlet UIButton *submitChoseBt;

@property (strong, nonatomic) IBOutlet UIView *submitFeatureView;

@property (strong, nonatomic) IBOutlet UITextView *submitFeatureTextView;

@property (strong, nonatomic) IBOutlet UIButton *submitBt;

@property (strong, nonatomic) IBOutlet UIButton *submitCancelBt;

@property (strong, nonatomic) IBOutlet UIView *submitGameListView;

@property (strong, nonatomic) IBOutlet UITableView *submitGameListTableView;

@property (strong, nonatomic) IBOutlet UIButton *submitGameListViewCancelBt;


@end

@implementation CFBackupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隱藏導覽列
    self.navigationController.navigationBarHidden = YES;
    
    //Bool value 初始化
    isMyConfigActive = YES;
    
    isSharedConfigActive = NO;
    
    isSearch_conditionActive = NO;  
    
    self.searchTextField.delegate = self;
    
    //紀錄原本searchBarView的大小
    oriSearchBarViewFrame = CGRectMake(CGRectGetMinX(self.searchBarView.frame), CGRectGetMinY(self.searchBarView.frame), self.searchBarView.frame.size.width, self.searchBarView.frame.size.height);
    

    //myConfigTableView
    self.myConfigTableView.dataSource = self;
    self.myConfigTableView.delegate = self;
    self.myConfigTableView.separatorStyle = UITableViewCellSeparatorStyleNone;


    //MyConfig search
    //遊戲機台名稱
    ary_myConfig_search_platformStr = [NSMutableArray arrayWithObjects:@"Xbox One",@"Xbox 360",@"PS4",@"PS3", nil];
    
    //圖片
    ary_myConfig_search_img = [NSMutableArray arrayWithObjects:
                                   [NSString stringWithFormat:@"platform_a_3_x1_88x88"],
                                   [NSString stringWithFormat:@"platform_a_4_x360_88x88"],
                                   [NSString stringWithFormat:@"platform_a_1_ps4_88x88"],
                                   [NSString stringWithFormat:@"platform_a_2_ps3_88x88"],nil];
    
    //ary_myConfigBgView
    ary_myConfigBgView = [[NSMutableArray alloc] init];
    for (int i = 0; i < ary_myConfig_search_img.count; i++) {
        
        NSString *selected = [NSString stringWithFormat:@"0"];
        
        [ary_myConfigBgView addObject:selected];
        
    }
    
    
    //SharedConfig search
    //遊戲機台名稱
    ary_sharedConfig_search_platformStr = [NSMutableArray arrayWithObjects:@"Xbox One",@"Xbox 360",@"PS4",@"PS3",@"Like",@"Downloads", nil];
    

    //圖片名稱應該用一下#define，不然到時候改檔名改到暈，還會改錯
    //圖片
    ary_sharedConfig_search_img = [NSMutableArray arrayWithObjects:
                                   [NSString stringWithFormat:@"platform_a_3_x1_88x88"],
                                   [NSString stringWithFormat:@"platform_a_4_x360_88x88"],
                                   [NSString stringWithFormat:@"platform_a_1_ps4_88x88"],
                                   [NSString stringWithFormat:@"platform_a_2_ps3_88x88"],
                                   [NSString stringWithFormat:@"searchfor_a_like_88x88"],
                                   [NSString stringWithFormat:@"searchfor_a_download_88x88"],nil];
   
    //ary_sharedConfig_search_img
    ary_sharedConfigBgView = [[NSMutableArray alloc] init];
    for (int i = 0; i < ary_sharedConfig_search_img.count; i++) {
        
        NSString *selected = [NSString stringWithFormat:@"0"];
        
        [ary_sharedConfigBgView addObject:selected];
        
    }
    
    
    
    
    //tableView data
    ary_myConfigObj = [[NSMutableArray alloc]init];
    ary_sharedConfigObj = [[NSMutableArray alloc] init];
    ary_gameList = [[NSMutableArray alloc] init];
    
    //cloud 初始化
    cloudClass = [[FPCloudClass alloc]init];
    cloudClass.delegate = self;
    
    
    //submitScrollView 初始化
    [self submitScrollViewOriginFrame];
    
    //submitCancelBt addAction
    [self.submitCancelBt addTarget:self action:@selector(submitCancelBtAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    //[self TempData]; //假資料
    
    [self addLeftAndRightSwipGesture];
    
    //硬體資料初始化
    configData = [[FPSConfigData alloc] init];
    [configData initParam];
    
    
    //暫存資料初始化
    tempConfigData = [[CFTableViewCellObject alloc] init];
    
    //submitChoseBt addAction
    [self.submitChoseBt addTarget:self action:@selector(showGameList) forControlEvents:UIControlEventTouchUpInside];
    
    //search TextField 鍵盤回收方法
    [self.searchTextField addTarget:self action:@selector(theTextFieldDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //portocol delegate
    [ProtocolDataController sharedInstance].dataResponseDelegate = self;
    [ProtocolDataController sharedInstance].connectStateDelegate = self;
    
    //一開始searchBar有顯示
    //tableView往下移
    self.searchBarView.frame = oriSearchBarViewFrame;
    
    self.myConfigTableView.frame = CGRectMake(self.myConfigTableView.frame.origin.x, CGRectGetMaxY(oriSearchBarViewFrame), self.myConfigTableView.frame.size.width, self.myConfigTableView.frame.size.height);
    
    self.redImgView.alpha = 0.0;
    
    [self postSyncConfigListAPI:@"" game:@"" seq:@"0"];
    
    isGameListAction = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 回上一頁
- (IBAction)backToSuperView:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 條件搜尋方法
- (IBAction)search_conditionBtAction:(UIButton *)sender {
    
    _search_conditionView.hidden = NO;
    
    isSearch_conditionActive = YES;
    
    [(UITableView *)[self.view viewWithTag:200] reloadData];

}

#pragma mark - 子畫面消失方法
- (IBAction)subViewDismissAction:(UIButton *)sender {
    
    if (isSearch_conditionActive == YES) {
        
        _search_conditionView.hidden = YES;
        
        isSearch_conditionActive = NO;
        
        //isMyConfigActive = YES;
        
        //search_condition 畫面消失回到 My Config 頁面
        [(UITableView *)[self.view viewWithTag:100] reloadData];
    }
    
}


#pragma mark - TableView DataSource & Delegete
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return  1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger num  = 0;
    
    if (isGameListAction) {
        
        num = ary_gameList.count;
        
        NSLog(@"ary_gameList.count:%lu",(unsigned long)ary_gameList.count);
        
        return num;
    }
    
    
    if (isMyConfigActive == YES && isSharedConfigActive == NO) {
        
        if (isSearch_conditionActive == YES) {
            
            //myConfig search platform
            num = ary_myConfig_search_platformStr.count;
            
        }
        else {
            
             num = ary_myConfigObj.count;
        }
        
    }
    else if (isMyConfigActive == NO && isSharedConfigActive == YES) {
        
        if (isSearch_conditionActive == YES) {
            
            //sharedConfig search platform
            num = ary_sharedConfig_search_platformStr.count;
            

        }
        else {
            
            num  = ary_sharedConfigObj.count;
        }

    }
    
    self.resultCount.text = [self returnResultCount:num];
    
    return num;
}

-(NSString *)returnResultCount:(NSInteger)count {
    
    NSString *about = [NSString stringWithFormat:@"about  "];
    
    NSString *countStr = [about stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)count]];
    
    NSString *results = [countStr stringByAppendingString:[NSString stringWithFormat:@"  results"]];
    
    return results;
    
}

//裡面可模組化嗎？>>>>>
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;
    
    if (isGameListAction == YES) {
        
         UITableViewCell *gameListCell = [tableView dequeueReusableCellWithIdentifier:@"submitGameListCell" forIndexPath:indexPath];
        
        UILabel *gameLabel = [gameListCell.contentView viewWithTag:30];
        
        gameLabel.text = ary_gameList[indexPath.row].elite_gameName;
        
        gameListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return gameListCell;
        
    }
    
    
    
    if (isMyConfigActive == YES && isSharedConfigActive == NO) {
        
        if (isSearch_conditionActive == YES) {
            
            //search_condition 啟動時
            tableView = [self.view viewWithTag:200];
            
            UITableViewCell *search_conditionCell = [tableView dequeueReusableCellWithIdentifier:@"myConfig_searchCell" forIndexPath:indexPath];
            
            cell = search_conditionCell;
            
            cell.textLabel.textColor = [UIColor whiteColor];
            
            cell.textLabel.text = ary_myConfig_search_platformStr[indexPath.row];
            
            cell.imageView.image = [UIImage imageNamed:ary_myConfig_search_img[indexPath.row]];
            
            [self fixSeparatorLine:cell];
            
            //改變背景顏色
            UIImageView *myConfigBgView = [cell.contentView viewWithTag:10];
            myConfigBgView.alpha = 0.0;
            NSString *myConfigBg = [ary_sharedConfigBgView objectAtIndex:indexPath.row];
            if ([myConfigBg isEqualToString:@"1"]) {
                
                myConfigBgView.alpha = 1.0;
            }
            else {
                
                myConfigBgView.alpha = 0.0;
            }
            
            
            return cell;
            
        }
        else {
            
            tableView = [self.view viewWithTag:100];
            
            //CustomizedCellForBackup *backupMyConfigCell = [tableView dequeueReusableCellWithIdentifier:@"backupMyConfigCell" forIndexPath:indexPath];
            
            CustomizedCellForMyConfig *backupMyConfigCell = [tableView dequeueReusableCellWithIdentifier:@"backupMyConfigCell" forIndexPath:indexPath];
            

            //客製化 tableViewCell
            backupMyConfigCell.superTableView = self.myConfigTableView;
            backupMyConfigCell.superIndexPath = indexPath;
            backupMyConfigCell.superAryList = ary_myConfigObj;
            backupMyConfigCell.theRowHeight = tableView.rowHeight;
            [backupMyConfigCell createDeleteBt:self.myConfigTableView];
            backupMyConfigCell.cellSuperVC = self;

            
            //Date
            UILabel *dateLabel = [backupMyConfigCell.contentView viewWithTag:501];
            dateLabel.text = ary_myConfigObj[indexPath.row].myConfig_date;
            
            //流水號
            UILabel *numLabel = [backupMyConfigCell.contentView viewWithTag:502];
            numLabel.text = ary_myConfigObj[indexPath.row].myConfig_num;
            
            //遊戲圖片
            UIImageView *gameIconImg = [backupMyConfigCell.contentView viewWithTag:503];
            gameIconImg.image = [UIImage imageWithData:ary_myConfigObj[indexPath.row].myConfig_gameIcon];
            
            
            //platform
            UIImageView *platformImg = [backupMyConfigCell.contentView viewWithTag:504];
            int platformNum = [ary_myConfigObj[indexPath.row].myConfig_platform intValue];
            platformImg.image = [UIImage imageNamed: [self returnPlatformImg:platformNum]];

            
            //Like
            UILabel *likeLabel = [backupMyConfigCell.contentView viewWithTag:505];
            likeLabel.text = ary_myConfigObj[indexPath.row].myConfig_like;
            
            //Dislike
            UILabel *dislikeLabel = [backupMyConfigCell.contentView viewWithTag:506];
            dislikeLabel.text = ary_myConfigObj[indexPath.row].myConfig_disLike;
            
            //Download
            UILabel *downloadLabel = [backupMyConfigCell.contentView viewWithTag:507];
            downloadLabel.text = ary_myConfigObj[indexPath.row].myConfig_download;
            
            //Title
            UILabel *titleLabel = [backupMyConfigCell.contentView viewWithTag:508];
            titleLabel.text = ary_myConfigObj[indexPath.row].myConfig_title;
            
            //Editor
            UILabel *editorLabel = [backupMyConfigCell.contentView viewWithTag:509];
            
            NSString *name = ary_myConfigObj[indexPath.row].myConfig_editor;
        
            NSString *mark = [NSString stringWithFormat:@""];
            
            NSString *fullName = [mark stringByAppendingString:name];
            
            editorLabel.text = mark;

            
            //Content
            UILabel *contentLabel = [backupMyConfigCell.contentView viewWithTag:510];
            contentLabel.text = ary_myConfigObj[indexPath.row].myConfig_content;
    
            
            //downloadBt
            UIButton *theDownloadBt = [backupMyConfigCell.contentView viewWithTag:512];
            
            backupMyConfigCell.myConfigDownloadBt = theDownloadBt;
            
            [backupMyConfigCell downloadBtAddAction];
            
            
            //sharedBt
            UIButton *sharedBt = [backupMyConfigCell.contentView viewWithTag:514];
            backupMyConfigCell.myConfigSharedBt = sharedBt;

            //withdrawBt
            UIButton *withDrawBt = [backupMyConfigCell.contentView viewWithTag:516];
            backupMyConfigCell.myConfigWithDraBt = withDrawBt;
            
            
            //sharedView & reviewingView & rejectedView & withdrawView
            UIView *sharedView = [backupMyConfigCell.contentView viewWithTag:513];
            UIView *withdrawView = [backupMyConfigCell.contentView viewWithTag:515];
            UIView *reviewingView = [backupMyConfigCell.contentView viewWithTag:517];
            UIView *rejectedView = [backupMyConfigCell.contentView viewWithTag:518];
            
            
            //status
            [self sharedStatus:[ary_myConfigObj[indexPath.row].myConfig_status intValue] sharedView:sharedView reviewingView:reviewingView rejectedView:rejectedView withdrawView:withdrawView];
    
            
            return backupMyConfigCell;
            
        }

    }
    else if (isSharedConfigActive == YES && isMyConfigActive == NO) {
        
        if (isSearch_conditionActive == YES) {
            //search_condition 啟動時
            
            NSLog(@"shared & search");
            
            //search_condition 啟動時
            tableView = [self.view viewWithTag:200];
            
            UITableViewCell *search_conditionCell = [tableView dequeueReusableCellWithIdentifier:@"myConfig_searchCell" forIndexPath:indexPath];
            
            cell = search_conditionCell;
            
            cell.textLabel.textColor = [UIColor whiteColor];
            
            cell.textLabel.text = ary_sharedConfig_search_platformStr[indexPath.row];
            
            cell.imageView.image = [UIImage imageNamed:ary_sharedConfig_search_img[indexPath.row]];
            
            [self fixSeparatorLine:cell];
            
            
            //改變背景顏色
            UIImageView *sharedConfigBgView = [cell.contentView viewWithTag:10];
            sharedConfigBgView.alpha = 0.0;
            NSString *sharedConfigBg = [ary_sharedConfigBgView objectAtIndex:indexPath.row];
            if ([sharedConfigBg isEqualToString:@"1"]) {
                
                sharedConfigBgView.alpha = 1.0;
            }
            else {
                
                sharedConfigBgView.alpha = 0.0;
            }

            
            return cell;
        
        }
        else {
            
            tableView = [self.view viewWithTag:100];
            
//            CustomizedCellForBackup *sharedConfigCell = [tableView dequeueReusableCellWithIdentifier:@"sharedConfigCells" forIndexPath:indexPath];
            //客製化 tableViewCell
//            sharedConfigCell.superTableView = self.myConfigTableView;
//            sharedConfigCell.superIndexPath = indexPath;
//            sharedConfigCell.superAryList = ary_sharedConfigObj;
//            sharedConfigCell.theRowHeight = tableView.rowHeight;
//            [sharedConfigCell createDeleteBt:self.myConfigTableView];
//            sharedConfigCell.cellSuperVC = self;
        //sharedConfig 沒有 刪除功能
            
            
            CustomCellForSharedConfig *sharedConfigCell = [tableView dequeueReusableCellWithIdentifier:@"sharedConfigCells" forIndexPath:indexPath];
            
            sharedConfigCell.m_superVC = self;
            
            sharedConfigCell.sharedConfigIndexPathRow = indexPath.row;
            
            //Date
            UILabel *dateLabel = [sharedConfigCell.contentView viewWithTag:601];
            dateLabel.text = ary_sharedConfigObj[indexPath.row].sharedConfig_date;
            
            //流水號
            UILabel *numLabel = [sharedConfigCell.contentView viewWithTag:602];
            numLabel.text = ary_sharedConfigObj[indexPath.row].sharedConfig_num;
            
            //platform
            UIImageView *platformImg = [sharedConfigCell.contentView viewWithTag:603];
            platformImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",ary_sharedConfigObj[indexPath.row].sharedConfig_platform]];
            
            //Like
            UILabel *likeLabel = [sharedConfigCell.contentView viewWithTag:604];
            likeLabel.text = [NSString stringWithFormat:@"%d",[ary_sharedConfigObj[indexPath.row].sharedConfig_like intValue]];
            
            //Dislike
            UILabel *dislikeLabel = [sharedConfigCell.contentView viewWithTag:605];
            dislikeLabel.text = [NSString stringWithFormat:@"%d",[ary_sharedConfigObj[indexPath.row].sharedConfig_disLike intValue]];
            
            //Download
            UILabel *downloadLabel = [sharedConfigCell.contentView viewWithTag:606];
            downloadLabel.text = [NSString stringWithFormat:@"%d",[ary_sharedConfigObj[indexPath.row].sharedConfig_download intValue]];
            
            //Title
            UILabel *titleLabel = [sharedConfigCell.contentView viewWithTag:607];
            titleLabel.text = ary_sharedConfigObj[indexPath.row].sharedConfig_title;
            
            //Editor
            UILabel *editorLabel = [sharedConfigCell.contentView viewWithTag:608];
            
            NSString *name = ary_sharedConfigObj[indexPath.row].sharedConfig_editor;
            
            NSString *mark = [NSString stringWithFormat:@""];
            
            NSString *fullName = [mark stringByAppendingString:name];
            
            editorLabel.text = fullName;
            
            //Content
            UILabel *contentLabel = [sharedConfigCell.contentView viewWithTag:609];
            contentLabel.text = ary_sharedConfigObj[indexPath.row].sharedConfig_content;
            
            //downloadBt
            UIButton *theDownloadBt = [sharedConfigCell.contentView viewWithTag:610];
            sharedConfigCell.downloadBt = theDownloadBt;
            [sharedConfigCell downloadBtAddAction];
            
            
            return sharedConfigCell;

        }
        
    }
    
    return cell;
}
//<<<<<

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isGameListAction) {
        
        self.submitTextField.text = ary_gameList[indexPath.row].elite_gameName;
        
        [self checkSubmitSelectGameTextColor];
        
        self.submitGameListView.hidden = YES;
        
        isGameListAction = NO;
        
        return;
    }
    
    
    
    //myConfig search platform
    if (isSearch_conditionActive == YES && isMyConfigActive) {
        
        
        for (int i = 0; i < ary_myConfigBgView.count; i++) {
            
            if (i == indexPath.row) {
                
                ary_myConfigBgView[i] = [NSString stringWithFormat:@"1"];
            }
            else {
                
                ary_myConfigBgView[i] = [NSString stringWithFormat:@"0"];
            }
        }
        
        
        
        //Search for ...紅色,其他白色
        if (![_search_conditionLabel.text isEqualToString:@"Search for ..."]) {
            
            _search_conditionLabel.textColor = [UIColor whiteColor];
        }
        else {
            
            _search_conditionLabel.textColor = [UIColor redColor];
        }
        
        _search_conditionView.hidden = YES;
        
        
        //搜尋條件
        _search_conditionLabel.text = ary_myConfig_search_platformStr [indexPath.row];
        
        int platformNum = [self returnIntfromImage:ary_myConfig_search_platformStr [indexPath.row]];
        
        if ([self.searchTextField.text isEqualToString:@""]) {
            //只有platform
            
            [self postSyncConfigListAPI:[NSString stringWithFormat:@"%d",platformNum] game:@"" seq:@"0"];
            
        }
        else {
            //platform + 關鍵字
            
            [self postSyncConfigListAPI:[NSString stringWithFormat:@"%d",platformNum] game:self.searchTextField.text seq:@"0"];
            
        }
        
        
        isMyConfigActive = YES;
        
        isSharedConfigActive = NO;
        
        isSearch_conditionActive = NO;
        
    }
    
    
    //myConfig delete
    if (isMyConfigActive == YES) {
        
        CustomizedCellForMyConfig *cell = [self.myConfigTableView cellForRowAtIndexPath:preIndexPath];
        [self cellShowDeleteBtOrClose:cell showDeleteBt:NO];
    }
    
    
    //sharedConfig search platform
    if (isSearch_conditionActive == YES && isSharedConfigActive == YES) {
        
        for (int i = 0; i < ary_sharedConfigBgView.count; i++) {
            
            //變換底色
            if (i == indexPath.row) {
                
                ary_sharedConfigBgView[i] = [NSString stringWithFormat:@"1"];
            }
            else {
                
                ary_sharedConfigBgView[i] = [NSString stringWithFormat:@"0"];
            }
            
        }
        
        
        
        //Search for ...紅色,其他白色
        if (![_search_conditionLabel.text isEqualToString:@"Search for ..."]) {
            
            _search_conditionLabel.textColor = [UIColor whiteColor];
        }
        else {
            
            _search_conditionLabel.textColor = [UIColor redColor];
        }
        
         _search_conditionView.hidden = YES;
        
        
        
        //搜尋條件
        _search_conditionLabel.text = ary_myConfig_search_platformStr [indexPath.row];
        
        int platformNum = [self returnIntfromImage:ary_myConfig_search_platformStr [indexPath.row]];
        
        if ([self.searchTextField.text isEqualToString:@""]) {
            //只有platform
            
            [self postSyncConfigListAPI:[NSString stringWithFormat:@"%d",platformNum] game:@"" seq:@"0"];
            
        }
        else {
            //platform + 關鍵字
            
            [self postSyncConfigListAPI:[NSString stringWithFormat:@"%d",platformNum] game:self.searchTextField.text seq:@"0"];
            
        }

        isMyConfigActive = NO;
        
        isSharedConfigActive = YES;
        
        isSearch_conditionActive = NO;

        

    }
    
}

//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView
//                  editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle: UITableViewRowActionStyleDefault title:@"Delete " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//    }];
//    
//    CGFloat theWidth = 0;
//    
//    if (IS_IPHONE_5) {
//        
//        theWidth =  tableView.frame.size.width/7;
//    }
//    else if (IS_IPHONE_6) {
//        
//        theWidth = tableView.frame.size.width/8;
//    }
//    else if (IS_IPHONE_6P) {
//        
//        theWidth = tableView.frame.size.width/8.5;
//    }
//    
//    
//    deleteAction.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"btn_red_a_small_up"] scaledToSize:CGSizeMake(theWidth, tableView.rowHeight/2) inTableView:tableView]];
//    
//
//    return @[deleteAction];
//}
//
//- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize inTableView:(UITableView *)tableView {
//    
//    UIGraphicsBeginImageContext(image.size);
//    [image drawInRect:CGRectMake(0,tableView.rowHeight/2 - newSize.height/3, newSize.width, newSize.height)];
//   
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//    
//}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat screenHeight = [self currentDevice_screenSize].height;
    
    CGFloat h=screenHeight/4;

    if (isMyConfigActive == YES) {
        
        if (isSearch_conditionActive ==  YES) {
            
            h = screenHeight/(320/55);
        }
        else {
            
            h = screenHeight/4;
        }
        
    }else if(isSharedConfigActive == YES){
        
        if (isSearch_conditionActive == YES) {
            
            h = screenHeight/(320/55);
        }
        else {
            
            h = screenHeight/4;
        }
    }
    else {
        
        h = screenHeight/8;
        
    }
    
    
    return h;
}

//偵測TableView 向上或向下滑動事件
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (scrollView == self.myConfigTableView) {
        
        if (velocity.y < 0) {
            
            //search_bar出現
            //tableView 往下移
            [UIView animateWithDuration:0.25 animations:^{
                
                self.searchBarView.userInteractionEnabled = YES;
                
                self.myConfigTableView.frame = CGRectMake(self.myConfigTableView.frame.origin.x, CGRectGetMaxY(oriSearchBarViewFrame), self.myConfigTableView.frame.size.width, self.myConfigTableView.frame.size.height);
                
                self.searchBarView.frame = oriSearchBarViewFrame;
                
                self.redImgView.alpha = 0.0;
                
            }];
            
        }
        else {
            //search_bar隱藏
            //tabelView 往上移
            [UIView animateWithDuration:0.25 animations:^{
                
                self.searchBarView.userInteractionEnabled = NO;
                
                
                self.searchBarView.frame = CGRectMake(oriSearchBarViewFrame.origin.x, oriSearchBarViewFrame.origin.y, oriSearchBarViewFrame.size.width, oriSearchBarViewFrame.size.height/8);
                
                self.myConfigTableView.frame = CGRectMake(self.myConfigTableView.frame.origin.x, CGRectGetMaxY(self.searchBarView.frame), self.myConfigTableView.frame.size.width, self.myConfigTableView.frame.size.height);
                
                self.redImgView.frame = self.searchBarView.frame;
                
                self.redImgView.alpha = 1.0;
                
            }];
            
        }
        
        
    }
    
}


#pragma mark - 選擇 My  Config 或 Shared Config
- (IBAction)configSelectAction:(UIButton *)sender {
    
    if (sender.tag == 11) {
        //選擇 My Config
        
        [(UIImageView *)[self.view viewWithTag:1]setImage:[UIImage imageNamed:@"backup_bk_a_title_myconfig_1"]];
        
        [(UIImageView *)[self.view viewWithTag:2]setImage:[UIImage imageNamed:@"backup_bk_a_title_myconfig_2"]];
        
        [(UIImageView *)[self.view viewWithTag:3]setImage:[UIImage imageNamed:@"backup_bk_a_title_myconfig_3"]];
        
        [(UIImageView *)[self.view viewWithTag:4]setImage:[UIImage imageNamed:@"backup_bk_a_title_myconfig_4"]];
        
        [(UIImageView *)[self.view viewWithTag:5]setImage:[UIImage imageNamed:@"backup_bk_a_title_myconfig_5"]];
        
        isMyConfigActive = YES;
        isSharedConfigActive = NO;
        isSearch_conditionActive = NO;

        [self postSyncConfigListAPI:@"" game:@"" seq:@"0"];
        
    }
    else if (sender.tag == 12) {
        //選擇 Shared Config
        
        [(UIImageView *)[self.view viewWithTag:1]setImage:[UIImage imageNamed:@"backup_bk_a_title_sharedconfig_1"]];
        
        [(UIImageView *)[self.view viewWithTag:2]setImage:[UIImage imageNamed:@"backup_bk_a_title_myconfig_4"]];
        
        [(UIImageView *)[self.view viewWithTag:3]setImage:[UIImage imageNamed:@"backup_bk_a_title_sharedconfig_3"]];
        
        [(UIImageView *)[self.view viewWithTag:4]setImage:[UIImage imageNamed:@"backup_bk_a_title_myconfig_2"]];
        
        [(UIImageView *)[self.view viewWithTag:5]setImage:[UIImage imageNamed:@"backup_bk_a_title_sharedconfig_5"]];

        isMyConfigActive = NO;
        isSharedConfigActive = YES;
        isSearch_conditionActive = NO;
        
        [self postSyncpConfigListAPI:@"" game:@"" seq:@"0"];
    }
    
    [self.myConfigTableView reloadData];
    
}


#pragma mark - fixSeparatorLine 修正 tableView 分隔線問題
-(void)fixSeparatorLine:(UITableViewCell *)cell {
    
    //修正 tableView 分隔線問題
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = customColorView;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;

}




/*
 向左滑動顯示刪除鍵
 向右滑動隱藏刪除鍵
 */
-(void)addLeftAndRightSwipGesture {
    
    //滑動手勢(左)
    cellSwipGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipAction:)];
    
    cellSwipGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    cellSwipGestureLeft.numberOfTouchesRequired = 1;
    
    [self.myConfigTableView addGestureRecognizer:cellSwipGestureLeft];
    
    //滑動手勢(右)
    cellSwipGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipAction:)];
    
    cellSwipGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    cellSwipGestureRight.numberOfTouchesRequired = 1;
    
    [self.myConfigTableView addGestureRecognizer:cellSwipGestureRight];
    
    //preIndexPath
    preIndexPath = nil;
}

//偵測tableView 上下滑動事件
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //當tableView 向上滑 或 向下滑
    //隱藏所有的 deleteBt
    
    if (preIndexPath == nil) {
        
        return;
    }
    else {
        
        CustomizedCellForMyConfig *cell = [self.myConfigTableView cellForRowAtIndexPath:preIndexPath];
        
        [self cellShowDeleteBtOrClose:cell showDeleteBt:NO];
        
        preIndexPath = nil;
        
        NSLog(@"上下滑動 隱藏cell -- backup");
    }
    
}


#pragma mark - cellSwipAction(cell 向右滑 - 向左滑)
-(void)cellSwipAction:(UISwipeGestureRecognizer *)gesture {
    
    //取得在 tableView 裡的手指座標
    CGPoint currentPoint = [gesture locationInView:self.myConfigTableView];
    
    //目前手指座標所對應的 tableView indexPath
    NSIndexPath *currentIndexPath = [self.myConfigTableView indexPathForRowAtPoint:currentPoint];
    
    //目前與使用者互動的 cell
    CustomizedCellForMyConfig *cell = [self.myConfigTableView cellForRowAtIndexPath:currentIndexPath];
    
    if ([gesture isEqual:cellSwipGestureLeft]) {
        
        if (preIndexPath == nil) {
            
            preIndexPath = currentIndexPath;
        }
        else if (preIndexPath != nil && ![preIndexPath isEqual:currentIndexPath]) {
            
            //先將上一個隱藏
            CustomizedCellForMyConfig *preCell = [self.myConfigTableView cellForRowAtIndexPath:preIndexPath];
            
            [self cellShowDeleteBtOrClose:preCell showDeleteBt:NO];
            
            preIndexPath = currentIndexPath;
        }
        
        [self cellShowDeleteBtOrClose:cell showDeleteBt:YES];
        
    }
    else if ([gesture isEqual:cellSwipGestureRight]) {
        
        [self cellShowDeleteBtOrClose:cell showDeleteBt:NO];
    }
    
}


#pragma mark - 顯示或隱藏 cell 的 刪除鍵
-(void)cellShowDeleteBtOrClose:(CustomizedCellForMyConfig *)theCell showDeleteBt:(BOOL)show {
    
    if (show) {
        
        [UIView animateWithDuration:0.28 animations:^{
            
            theCell.contentView.frame = CGRectMake(0 - self.myConfigTableView.frame.size.width/3, theCell.contentView.frame.origin.y, theCell.contentView.frame.size.width, theCell.contentView.frame.size.height);

            theCell.cellDeleteBt.alpha = 1.0;
            
            theCell.cellDeleteBt.userInteractionEnabled = YES;
            
        }];
    }
    else {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            theCell.contentView.frame = CGRectMake(0, theCell.contentView.frame.origin.y, theCell.contentView.frame.size.width, theCell.contentView.frame.size.height);
            
            theCell.cellDeleteBt.userInteractionEnabled = NO;
            
            theCell.cellDeleteBt.alpha = 0;
            
        }];
        
    }
    
}


#pragma mark - touchEvent
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.searchTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.searchTextField) {
        
        [self.searchTextField resignFirstResponder];
    }
    
    return YES;
}

#pragma  mark - theTextFieldDidEnd
-(void)theTextFieldDidEnd:(UITextField *) textField {
    
    if (textField == self.searchTextField) {
        
        if ([self.search_conditionLabel.text isEqualToString:@"Search for ..."]) {
            //只有關鍵字
            if (isMyConfigActive == YES) {
                
                [self postSyncConfigListAPI:@"" game:self.searchTextField.text seq:@"0"];
                
            }
            else if (isSharedConfigActive == YES) {
                
                [self postSyncpConfigListAPI:@"" game:self.searchTextField.text seq:@"0"];
            }
            
        }
        else {
            //關鍵字 + platform
            int platformInt = [self returnIntfromImage:self.search_conditionLabel.text];
            
            NSString *platformNumStr = [NSString stringWithFormat:@"%d",platformInt];
            
            if (isMyConfigActive == YES) {
                
                [self postSyncConfigListAPI:platformNumStr game:self.searchTextField.text seq:@"0"];
            }
            else if (isSharedConfigActive == YES) {
            
                [self postSyncpConfigListAPI:platformNumStr game:self.searchTextField.text seq:@"0"];
                
            }
            
        }
        
    }
    
}


#pragma mark - FPCloudResponse Delegate
-(void)FPCloudResponseData:(NSURLResponse *)response Data:(NSData *)data Error:(NSError *)error EventId:(int)eventid{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(data==nil) {
        
            NSLog(@"Error:%@",error.description);
            
            return ;
        }
        
        NSError *jsonError;
        
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        
        switch (eventid) {
                
            case CloudAPIEvent_syncconfiglist:
                //個人 MyConfig
                [self processSyncconfiglist:responseData Error:jsonError];
                break;
                
            case CloudAPIEvent_syncpconfiglist:
                //公開 sharedConfig
                [self processSyncpconfiglist:responseData Error:jsonError];
                break;
                
            case CloudAPIEvent_changestatus:
                //shared 狀態
                [self processchangestatus:responseData Error:jsonError];
                break;
                
            case CloudAPIEvent_delUserProfile:
                //刪除 config
                [self processDeleteFile:responseData Error:jsonError];
                break;
                
            case CloudAPIEvent_elitegamelist:
                //取得遊戲清單
                [self processGameList:responseData Error:jsonError];
                break;
                
            default:
                break;
        }
        
        
    });
    
}

#pragma mark - post & process syncConfigList 個人
-(void)processSyncconfiglist:(NSDictionary *)resopnseData Error:(NSError *)jsonError{
    
    NSNumber *code = [resopnseData objectForKey:@"ret"];
    
    if (code.intValue== 0) {
        //success
        NSLog(@"下載個人 config 成功");
        
        NSMutableArray *ary_syncConfigList = [[NSMutableArray alloc]init];
        
        ary_syncConfigList = [resopnseData objectForKey:@"list"];
        
        [ary_myConfigObj removeAllObjects];
        
        for (int i = 0; i < ary_syncConfigList.count; i++) {
            
            MyConfigCellObj *obj = [[MyConfigCellObj alloc] init];
            
            obj.myConfig_content = [ary_syncConfigList[i] objectForKey:@"Content"];//內文
            
            obj.myConfig_download = [ary_syncConfigList[i] objectForKey:@"download"];//下載次數
            
            obj.myConfig_num = [ary_syncConfigList[i] objectForKey:@"fid"];//流水編號
            
            obj.myConfig_title = [ary_syncConfigList[i] objectForKey:@"game"];//遊戲名稱
            
            obj.myConfig_like = [ary_syncConfigList[i] objectForKey:@"love"];//按讚次數
            
            //[ary_syncConfigList[i] objectForKey:@"name"];//
            
            obj.myConfig_disLike = [ary_syncConfigList[i] objectForKey:@"nogood"];//不喜歡次數
            
            //***************************
            NSString *urlStr = [ary_syncConfigList[i] objectForKey:@"pic"];//圖片
            [self getImgDataFromURL:urlStr index:i];
            
            //***************************
            
            obj.myConfig_platform = [ary_syncConfigList[i] objectForKey:@"platform"];//遊戲平台
            
            obj.myConfig_date = [ary_syncConfigList[i] objectForKey:@"upload_time"];//上傳時間
            
            //url
            obj.myConfig_url = [ary_syncConfigList[i] objectForKey:@"url"];//txt檔
            
            obj.myConfig_editor = [ary_syncConfigList[i] objectForKey:@"user"];//上傳者
            
            //status
            obj.myConfig_status = [NSNumber numberWithInt:[[ary_syncConfigList[i] objectForKey:@"status"] intValue]];

            [ary_myConfigObj addObject:obj];

        }
        
        [loadingView removeFromSuperview];
        loadingView = nil;
        
        isMyConfigActive = YES;
        
        [self.myConfigTableView reloadData];
        
    }
    else{
        //fail
         NSLog(@"下載個人 config 失敗");
    }
    
    NSLog(@"processSyncconfiglist.resopnseData = %@",resopnseData);
    
}

-(void)postSyncConfigListAPI:(NSString *)platform game:(NSString *)game seq:(NSString *)seq {
    
    int eventID = CloudAPIEvent_syncconfiglist;
    
    //uid
    NSString *uid = [ConfigMacroData sharedInstance].uid;
    
    //簽名 MD5(用戶編號+KEY+時間戳)
    NSString *ts = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
    
    NSString *sn = [NSString stringWithFormat:@"%@%@%@",uid,kAPIKey,ts];
    
    sn = [ShareCommon md5:sn];
    
    //platform
    NSString *m_platform = platform;
    
    //game
    NSString *m_game = game;
    
    //seq
    NSString *m_seq = seq;
    
    NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      uid,@"uid",
                                      m_platform,@"platform",
                                      m_game,@"game",
                                      m_seq,@"Seq",
                                      ts,@"ts",
                                      sn,@"sn",nil];
    
    [cloudClass postDataAsync:sendParam APIName:kAPI_syncconfiglist EventId:eventID];
    NSLog(@"post 個人");
}


#pragma mark - post & processs syncpConfiglist 公開
-(void)processSyncpconfiglist:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    NSNumber *code = [resopnseData objectForKey:@"ret"];
    
    [ary_sharedConfigObj removeAllObjects];
    
    if (code.intValue == 0) {
        //success
        NSLog(@"下載公開 config 成功");
        
        NSMutableArray *ary_syncpconfiglist = [[NSMutableArray alloc]init];
        
        ary_syncpconfiglist = [resopnseData objectForKey:@"list"];

        for (int i = 0; i < ary_syncpconfiglist.count; i++) {
            
            SharedConfigObj *obj = [[SharedConfigObj alloc] init];
            
            obj.sharedConfig_num = [ary_syncpconfiglist[i] objectForKey:@"fid"];//檔案編號
            
            obj.sharedConfig_platform = [ary_syncpconfiglist[i] objectForKey:@"platform"];//遊戲平台
            
            obj.sharedConfig_content = [ary_syncpconfiglist[i] objectForKey:@"content"];//內文
            
            obj.sharedConfig_like = [NSNumber numberWithInt:[[ary_syncpconfiglist[i] objectForKey:@"love"]intValue]];//按讚次數
            
            obj.sharedConfig_disLike = [NSNumber numberWithInt:[[ary_syncpconfiglist[i] objectForKey:@"nogood"]intValue]];//不喜歡次數
            
            obj.sharedConfig_download = [NSNumber numberWithInt:[[ary_syncpconfiglist[i] objectForKey:@"download"]intValue]];//下載次數
            
            obj.sharedConfig_editor = [ary_syncpconfiglist[i] objectForKey:@"user"];//Editor
            
            obj.sharedConfig_date = [ary_syncpconfiglist[i] objectForKey:@"upload_time"];//上傳時間
            
            obj.sharedConfig_title = [ary_syncpconfiglist[i] objectForKey:@"game"];//
            
            obj.sharedConfig_editor = [ary_syncpconfiglist[i] objectForKey:@"user"];//上傳者
            
            //url
            obj.sharedConfig_url = [ary_syncpconfiglist[i] objectForKey:@"url"];//txt檔
            
            [ary_sharedConfigObj addObject:obj];
        }
        
        [self.myConfigTableView reloadData];
    }
    else {
        //fail
        NSLog(@"下載公開 config 失敗");
        
        [self.myConfigTableView reloadData];
        
    }
    
    NSLog(@"responseData_公開:%@",resopnseData);

}


-(void)postSyncpConfigListAPI:(NSString *)chosePlatform game:(NSString *)Game seq:(NSString *)seq {
    
    int eventID = CloudAPIEvent_syncpconfiglist;
    
    NSString *uid = [ConfigMacroData sharedInstance].uid;
    NSString *platform = chosePlatform;
    NSString *game = Game;
    NSString *Seq = seq;
    NSString *Page = @"0";
    NSString *ts = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
    
    //簽名 MD5(用戶編號+KEY+時間戳)
    NSString *sn = [NSString stringWithFormat:@"%@%@%@",uid,kAPIKey,ts];
    
    
    sn = [ShareCommon md5:sn];
    
    NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      uid,@"uid",
                                      platform,@"platform",
                                      game,@"game",
                                      Seq,@"Seq",
                                      Page,@"Page",
                                      ts,@"ts",
                                      sn,@"sn",nil];
    
    [cloudClass postDataAsync:sendParam APIName:kAPI_syncpconfiglist EventId:eventID];
    
    NSLog(@"post 公開");
    
}


#pragma mark - submitScrollView
-(void)submitScrollViewOriginFrame {
    
    //submitTitle
    self.submitTitle.frame = CGRectMake(0, 0, self.submitTitle.frame.size.width, self.submitTitle.frame.size.height);
    
    //submitContent
    self.submitContent.frame = CGRectMake(CGRectGetMinX(self.submitTitle.frame), CGRectGetMaxY(self.submitTitle.frame), self.submitContent.frame.size.width, self.submitContent.frame.size.height);
    
    //submitSperator
    self.submitSperator.frame = CGRectMake(0, 0 , self.submitSperator.frame.size.width, self.submitSperator.frame.size.height);
    self.submitSperator.center = CGPointMake(self.submitScrollView.frame.size.width/2, CGRectGetMaxY(self.submitContent.frame)+ self.submitSperator.frame.size.height);
    
    //submitGameView
    self.submitGameView.frame = CGRectMake(CGRectGetMinX(self.submitSperator.frame), CGRectGetMaxY(self.submitSperator.frame)+self.submitSperator.frame.size.height, self.submitGameView.frame.size.width, self.submitGameView.frame.size.height);
    
    //submitFeatureView
    self.submitFeatureView.frame = CGRectMake(CGRectGetMinX(self.submitGameView.frame), CGRectGetMaxY(self.submitFeatureView.frame), self.submitFeatureView.frame.size.width, self.submitFeatureView.frame.size.height);
    
    //submitBt
    self.submitBt.frame = CGRectMake(0, 0, self.submitBt.frame.size.width, self.submitBt.frame.size.height);
    self.submitBt.center = CGPointMake(self.submitScrollView.frame.size.width/2, CGRectGetMaxY(self.submitFeatureView.frame)+1.5*self.submitBt.frame.size.height);
    [self.submitBt addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat contentSizeHeight = self.submitTitle.frame.size.height + self.submitContent.frame.size.height + self.submitSperator.frame.size.height*3 + self.submitGameView.frame.size.height + self.submitFeatureView.frame.size.height + self.submitBt.frame.size.height*4;
    
    self.submitScrollView.contentSize = CGSizeMake(self.submitScrollView.frame.size.width, contentSizeHeight);
    
}

#pragma mark - submitCancelBt Action & submit Action
-(void)submitCancelBtAction {
    
    self.submitView.hidden = YES;
    
    isGameListAction = NO;
}

-(void)submitAction {
    
    //檢查是否有網路
    if (![CheckNetwork isExistenceNetwork]) {
        
        //無網路時
        [self showAlert:NSLocalizedString(@"Connect fail", nil) message:NSLocalizedString(@"Please check your wifi", nil)];
        
        return;
    }

    
    [self ShowLoadingView:2 ishidden:NO];//2:Sharing...
    
    
    //changeStatus: 0 -> 1,shared -> reviewing
    [self postSharedConfig:@"1" content:self.submitFeatureTextView.text fid:ary_myConfigObj[submitIndex].myConfig_num platform:ary_myConfigObj[submitIndex].myConfig_platform game:self.submitTextField.text];
    
}


#pragma mark - sharedStatus
-(void)sharedStatus:(int)status sharedView:(UIView *)sharedView reviewingView:(UIView *)reviewingView rejectedView:(UIView *)rejectedView withdrawView:(UIView *)withdrawView {
    
    //0:shared(分享) 1:Reviewing(審核中) & 2:分享成功(Withdraw:收回) & 3:rejected(拒絕)
    switch (status) {
        case 0://shared
            sharedView.hidden = NO;
            reviewingView.hidden = YES;
            rejectedView.hidden = YES;
            withdrawView.hidden = YES;
            break;
        case 1://reviewing
            sharedView.hidden = YES;
            reviewingView.hidden = NO;
            rejectedView.hidden = YES;
            withdrawView.hidden = YES;
            break;
        case 2://withdraw
            sharedView.hidden = YES;
            reviewingView.hidden = YES;
            rejectedView.hidden = YES;
            withdrawView.hidden = NO;
            break;
        case 3://rejected
            sharedView.hidden = YES;
            reviewingView.hidden = YES;
            rejectedView.hidden = NO;
            withdrawView.hidden = YES;
            break;
        default:
            break;
    }
    
    
}


#pragma mark - post & process changeStatus
-(void)processchangestatus:(NSDictionary *)resopnseData Error:(NSError *)jsonError{
    
    NSNumber *code = [resopnseData objectForKey:@"ret"];
    
    if (code.intValue == 0) {
        //success
        
        self.submitView.hidden = YES;
        
        isGameListAction = NO;
        
        NSLog(@"change status 成功");
        
        [self postSyncConfigListAPI:@"" game:@"" seq:@"0"];
        
        
        
        
    }else{
        //fail
        
        
        NSLog(@"change status 失敗");
    }
    
    NSLog(@"changestatus.resopnseData = %@",resopnseData);
    
}


-(void)postSharedConfig:(NSString *)status content:(NSString *)content fid:(NSString *)fid platform:(NSString *)platform game:(NSString *)game {
    
    /*
     status
     1.shared -> submit: 0 -> 1
     2.withdraw -> shared: 2 -> 0
     所以程式這邊只能設定 0 或 1
    */
    
    
    int eventID = CloudAPIEvent_changestatus;
    
    NSString *m_content = content;
    NSString* m_status = status;
    //NSString *platform = @"2";//平台
    NSString* m_fid = fid;//檔案編號
    NSString *m_game = game;//遊戲名稱
    
    //簽名 MD5(用戶編號+KEY+時間戳)
    NSString *uid = [ConfigMacroData sharedInstance].uid;//用戶id
    NSString *ts = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];//時間戳
    NSString *sn = [NSString stringWithFormat:@"%@%@%@%@",uid,m_fid,kAPIKey,ts];
    sn = [ShareCommon md5:sn];//用戶編號+檔案編號+key+時間戳

    //數據包成 dictionary
    NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      uid,@"uid",
                                      m_content,@"Content",
                                      m_fid,@"fid",
                                      m_status,@"status",
                                      platform,@"platform",
                                      m_game,@"game",
                                      ts,@"ts",
                                      sn,@"sn",
                                      nil];
    
    //post 
    [cloudClass postDataAsync:sendParam APIName:kAPI_changestatus EventId:eventID];
    
}



#pragma mark - post & process DeleteUserfile
-(void)processDeleteFile:(NSDictionary *)resopnseData Error:(NSError *)jsonError{
    
    NSNumber *code = [resopnseData objectForKey:@"ret"];
    
    NSLog(@"delete code:%@",code);
    
    if (code.intValue == 0) {
        //success
        NSLog(@"delete configData 成功");
        
        [ary_myConfigObj removeObjectAtIndex:self.myConfigDeleteIndexPathRow];
        
        CustomizedCellForMyConfig *cell = [self.myConfigTableView cellForRowAtIndexPath:preIndexPath];
        
        [self cellShowDeleteBtOrClose:cell showDeleteBt:NO];
        
        [self postSyncConfigListAPI:@"" game:@"" seq:@"0"];
        
    }
    else{
        //fail
        
        NSLog(@"刪除失敗");
    }
    
    NSLog(@"delete.resopnseData = %@",resopnseData);
    
}

-(void)postDeleteFileAtIndexpath:(NSInteger)indexPathRow {
    
    
    [self ShowLoadingView:1 ishidden:NO];//1:刪除
    
    int eventID = CloudAPIEvent_delUserProfile;
    
    //uid
    NSString *uid = [ConfigMacroData sharedInstance].uid;//使用者id
    
    //fid
    NSString *fid = ary_myConfigObj[indexPathRow].myConfig_num;//檔案編號
    
    //ts //時間戳
    NSString *ts = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
    
    //sn 簽名MD5(用戶編號+檔案編號+KEY+時間戳)
    NSString *sn = [NSString stringWithFormat:@"%@%@%@%@",uid,fid,kAPIKey,ts];
    sn = [ShareCommon md5:sn];
    
    
    //數據包成 dictionary
    NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      uid,@"uid",
                                      fid,@"fid",
                                      ts,@"ts",
                                      sn,@"sn",
                                      nil];
    
    //post
    [cloudClass postDataAsync:sendParam APIName:KAPI_delUserProfile EventId:eventID];
    
}


#pragma mark - platform 數字轉換圖片
-(NSString *)returnPlatformImg:(int)num {
    
    NSString *platformImg;
    
    switch (num) {
            
        case 1://ps3
            platformImg = [NSString stringWithFormat:@"platform_a_2_ps3_88x88"];
            break;
        case 2://ps4
            platformImg = [NSString stringWithFormat:@"platform_a_1_ps4_88x88"];
            break;
        case 4://X360
            platformImg = [NSString stringWithFormat:@"platform_a_4_x360_88x88"];
            break;
        case 8://Xone
            platformImg = [NSString stringWithFormat:@"platform_a_3_x1_88x88"];
            break;
        default:
            break;
            
    }
    
    return platformImg;
    
}


#pragma mark - platform 圖片轉換數字 
-(int)returnIntfromImage:(NSString *)platform {
    
    int num = 0;
    
    if ([platform isEqualToString:@"PS3"]) {
        
        num = 1;
    }
    else if ([platform isEqualToString:@"PS4"]) {
        
        num = 2;
    }
    else if ([platform isEqualToString:@"Xbox 360"]){
        
        num = 4;
    }
    else if ([platform isEqualToString:@"Xbox One"]) {
        
        num = 8;
    }
    
    
    return num;
}




#pragma mark - getImgFromURL (從 url 抓取圖片)
-(void)getImgDataFromURL:(NSString *)urlStr index:(int)index {
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            
            NSLog(@"img Error:%@",error);
            
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ary_myConfigObj[index].myConfig_gameIcon = data;
        
            [self.myConfigTableView reloadData];
            
        });

    }];
    
    [dataTask resume];
    
}

#pragma mark - getTxtfileFromUrlAtIndexPathRow 從 url 抓取 txt 檔
-(void)getTxtfileFromUrlAtIndexPathRow:(NSInteger)indexPathRow {
    
    NSString *urlStr = ary_myConfigObj[indexPathRow].myConfig_url;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            
            NSLog(@"txt Error:%@",error);
            
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"str:%@",str);
            
            [self parseTxtFile:str];
            
        });
        
    }];
    
    [dataTask resume];
}

#pragma mrak - 解析 txt 檔
-(void)parseTxtFile:(NSString *)txtStr {
    
    if (tempConfigData == nil) {
        
        tempConfigData = [[CFTableViewCellObject alloc] init];
    }
    
    
    //configHotKey
    NSString *configHotKeyStrHex = [txtStr substringWithRange:NSMakeRange(1, 2)];
    NSLog(@"configHotKeyStrHex:%@",configHotKeyStrHex);
    int configHotKeyInt = [self hexStringToInt:configHotKeyStrHex];
    [configData setConfigHotKey:configHotKeyInt];
    tempConfigData.configHotKeyStr = [NSString stringWithFormat:@"%d",configHotKeyInt];
    
    
    //platform
    NSString *platformStrHex = [txtStr substringWithRange:NSMakeRange(4, 2)];
    NSLog(@"platformStrHex:%@",platformStrHex);
    int platformInt = [self hexStringToInt:platformStrHex];
    [configData setPlatform:platformInt];
    tempConfigData.configPlatformIcon = [NSString stringWithFormat:@"%d",platformInt];
    
    
    //ConfigName
    NSString *configNameStrHex = [txtStr substringWithRange:NSMakeRange(7, 99)];
    NSLog(@"configNameStrHex:%@",configNameStrHex);
    
    NSString *configNameTemp = [self stringDeleteString:configNameStrHex];
    
    NSLog(@"configNameTemp:%@",configNameTemp);
    
    NSMutableString *configName = [[NSMutableString alloc] init];
    
    for (int i = 0; i < 20; i++) {
        
        NSString *ch = [configNameTemp substringWithRange:NSMakeRange(i*4, 4)];
        
        if (![ch isEqualToString:@"FFFF"]) {
            
            int c = [self hexStringToInt:ch];
            
            [configName appendString:[NSString stringWithCharacters:(unichar *)&c length:1] ];
        }
        
    }
    
    [configData setConfigName:configName];
    tempConfigData.configFileName = configName;
    
    
    //LED
    NSString *LEDStrHex = [txtStr substringWithRange:NSMakeRange(107, 2)];
    NSLog(@"LEDStrHex:%@",LEDStrHex);
    int LEDInt = [self hexStringToInt:LEDStrHex];
    [configData setLEDColor:LEDInt];
    tempConfigData.configLEDColor = [NSString stringWithFormat:@"%d",LEDInt];
    
    
    
    //ConfigFuncFlag
    NSString *ConfigFuncFlagStrHex = [txtStr substringWithRange:NSMakeRange(110, 2)];
    NSLog(@"ConfigFuncFlagStrHex:%@",ConfigFuncFlagStrHex);
    int flag = [self hexStringToInt:[ConfigFuncFlagStrHex substringToIndex:2]];
    
    int adsToggleFlag = (flag & 1) == 1;
    int shootingSpeedFlag = (flag & 2) == 2;
    int invertedYFlag = (flag & 4) == 4;
    int sniperBreathFlag = (flag & 8) == 8;
    int antiRecoilFlag = (flag & 16) == 16;
    int adsSyncFlag = (flag & 32) == 32;

    [configData setFuncFlag_ADSToggle:adsToggleFlag];
    [configData setFuncFlag_shootingSpeed:shootingSpeedFlag];
    [configData setFuncFlag_invertedYAxis:invertedYFlag];
    [configData setFuncFlag_sniperBreath:sniperBreathFlag];
    [configData setFuncFlag_antiRecoil:antiRecoilFlag];
    [configData setFuncFlag_ADSSync:adsSyncFlag];
    
    
    tempConfigData.isADStoggle = adsToggleFlag;
    tempConfigData.isShootingSpeed = shootingSpeedFlag;
    tempConfigData.isInverted = invertedYFlag;
    tempConfigData.isSniperBreath = sniperBreathFlag;
    tempConfigData.isAntiRecoil = antiRecoilFlag;
    tempConfigData.isSync = adsSyncFlag;
    
    
    
    //Hip_SensitivityStrHex
    NSString *Hip_SensitivityStrHex = [txtStr substringWithRange:NSMakeRange(113, 2)];
    NSLog(@"Hip_SensitivityStrHex:%@",Hip_SensitivityStrHex);
    int Hip_SensitivityInt = [self hexStringToInt:Hip_SensitivityStrHex];
    [configData setHIPSensitivity:Hip_SensitivityInt];
    tempConfigData.hipStr = [NSString stringWithFormat:@"%d",Hip_SensitivityInt];
    
    
    
    //ADS_SensitivityStrHex
    NSString *ADS_SensitivityStrHex = [txtStr substringWithRange:NSMakeRange(116, 2)];
    NSLog(@"ADS_SensitivityStrHex:%@",ADS_SensitivityStrHex);
    int ADS_SensitivityInt = [self hexStringToInt:ADS_SensitivityStrHex];
    [configData setADSSensitivity:ADS_SensitivityInt];
    tempConfigData.adsStr = [NSString stringWithFormat:@"%d",ADS_SensitivityInt];
    
    
    
    //DeadZONEStrHex
    NSString *DeadZONEStrHex = [txtStr substringWithRange:NSMakeRange(119, 2)];
    NSLog(@"DeadZONEStrHex:%@",DeadZONEStrHex);
    int DeadZONEInt = [self hexStringToInt:DeadZONEStrHex];
    [configData setDeadZONE:DeadZONEInt];
    tempConfigData.deadZoneStr = [NSString stringWithFormat:@"%d",DeadZONEInt];
    
    
    //Sniperbreath_hotkeyStrHex
    NSString *Sniperbreath_hotkeyStrHex = [txtStr substringWithRange:NSMakeRange(122, 2)];
    NSLog(@"Sniperbreath_hotkeyStrHex:%@",Sniperbreath_hotkeyStrHex);
    int Sniperbreath_hotkeyInt = [self hexStringToInt:Sniperbreath_hotkeyStrHex];
    [configData setSniperBreathHotKey:Sniperbreath_hotkeyInt];
    tempConfigData.sniperBreathHotkey = [NSString stringWithFormat:@"%d",Sniperbreath_hotkeyInt];
    
    
    
    //Sniperbreath_mapkeyStHex (目前沒用到)
    NSString *Sniperbreath_mapkeyStHex = [txtStr substringWithRange:NSMakeRange(125, 2)];
    NSLog(@"Sniperbreath_mapkeyStHex:%@",Sniperbreath_mapkeyStHex);
    int Sniperbreath_mapkeyInt = [self hexStringToInt:Sniperbreath_mapkeyStHex];
    [configData setSniperBreathMapkey:Sniperbreath_mapkeyInt];
    
    
    //AntiRecoil_hotkeyStrHex
    NSString *AntiRecoil_hotkeyStrHex = [txtStr substringWithRange:NSMakeRange(128, 2)];
    NSLog(@"AntiRecoil_hotkeyStrHex:%@",AntiRecoil_hotkeyStrHex);
    int AntiRecoil_hotkeyInt = [self hexStringToInt:AntiRecoil_hotkeyStrHex];
    [configData setAntiRecoilHotkey:AntiRecoil_hotkeyInt];
    tempConfigData.antiRecoilHotkey = [NSString stringWithFormat:@"%d",AntiRecoil_hotkeyInt];
    
    
    
    //AntiRecoil_offsetValueStrHex
    NSString *AntiRecoil_offsetValueStrHex = [txtStr substringWithRange:NSMakeRange(131, 2)];
    NSLog(@"AntiRecoil_offsetValueStrHex:%@",AntiRecoil_offsetValueStrHex);
    int AntiRecoil_offsetValueInt = [self hexStringToInt:AntiRecoil_offsetValueStrHex];
    [configData setAntiRecoilOffsetValue:AntiRecoil_offsetValueInt];
    tempConfigData.antiRecoilStr = [NSString stringWithFormat:@"%d",AntiRecoil_offsetValueInt];
    
    
    
    //ShootingSpeedStrHex
    NSString *ShootingSpeedStrHex = [txtStr substringWithRange:NSMakeRange(134, 4)];
    NSLog(@"ShootingSpeedStrHex:%@",ShootingSpeedStrHex);
    int shootingSpeedInt = [self hexStringToInt:ShootingSpeedStrHex];
    [configData setShootingSpeed:shootingSpeedInt];
    tempConfigData.shootingSpeedStr = [NSString stringWithFormat:@"%d",shootingSpeedInt];
    
    NSLog(@"tempConfigData.shootingSpeedStr:%@",tempConfigData.shootingSpeedStr);

    
    //KeymapArrayStrHex
    NSString *KeymapArrayStrHex = [txtStr substringWithRange:NSMakeRange(139, 65)];
    NSLog(@"KeymapArrayStrHex:%@",KeymapArrayStrHex);
    
    NSString *KeymapTempArray = [self stringDeleteString:KeymapArrayStrHex];
    
    NSMutableArray *ary_keyMap = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 22; i++) {
        
        NSString *keyMap_ch = [KeymapTempArray substringWithRange:NSMakeRange(i*2, 2)];
        
        int keyMapInt = [self hexStringToInt:keyMap_ch];
        
        [ary_keyMap addObject:[NSString stringWithFormat:@"%d",keyMapInt]];
    }
    
    [configData setKeyMapArray:ary_keyMap];
    
    [tempConfigData.keyMap removeAllObjects];
    
    if (tempConfigData.keyMap == nil) {
        
        tempConfigData.keyMap = [[NSMutableArray alloc] init];
    }

    for (int i = 0; i < ary_keyMap.count; i++) {
        
        NSNumber *num = [NSNumber numberWithInt:[ary_keyMap[i] intValue]];
        
        [tempConfigData.keyMap addObject:num];
        
    }
    
    NSLog(@"tempConfigData.keyMap:%@",tempConfigData.keyMap);
    
    
    //BallisticsStrHex
    NSString *BallisticsStrHex = [txtStr substringWithRange:NSMakeRange(205, 59)];
    NSLog(@"BallisticsStrHex:%@",BallisticsStrHex);
    
    NSMutableArray *ary_ballistics = [[NSMutableArray alloc] init];
    
    NSString *ballisticStr = [self stringDeleteString:BallisticsStrHex];
    
    for (int i = 0; i < 20; i++) {
        
        NSString *ballistic_ch = [ballisticStr substringWithRange: NSMakeRange(i*2, 2)];
        
        int ballisticInt = [self hexStringToInt:ballistic_ch];
        
        [ary_ballistics addObject:[NSString stringWithFormat:@"%d",ballisticInt]];
        
    }
    
    [configData setBallistics:ary_ballistics];
    
    [tempConfigData.ballistics_Y_value removeAllObjects];
    
    if (tempConfigData.ballistics_Y_value == nil) {
        
        tempConfigData.ballistics_Y_value = [[NSMutableArray alloc]init];
    }
    
    for (int i = 0; i < ary_ballistics.count; i++) {
        
        NSNumber *num = [NSNumber numberWithInt:[ary_ballistics[i] intValue]];
        
        [tempConfigData.ballistics_Y_value addObject:num];
    }
    
    NSLog(@"tempConfigData.ballistics_Y_value:%@",tempConfigData.ballistics_Y_value);
    
    
    
    //BallisticsTempStrHex
    NSString *BallisticsTempStrHex = [txtStr substringWithRange:NSMakeRange(265, 8)];
    NSLog(@"BallisticsTempStrHex:%@",BallisticsTempStrHex);
    NSString *ballisticTemp = [self stringDeleteString:BallisticsTempStrHex];
    
    NSMutableArray *ary_ballisticTemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++) {
        
        [ary_ballisticTemp addObject:[NSNumber numberWithInt:0]];
    }
     
    NSNumber *ballisticNum = [NSNumber numberWithUnsignedInteger:[ballisticTemp length]];
    int ballisticInt = [ballisticNum intValue];
    
    [tempConfigData.ballistics_changed removeAllObjects];
    
    if(tempConfigData.ballistics_changed == nil) {
        
        tempConfigData.ballistics_changed = [[NSMutableArray alloc] init];
    }
    
    for (int i = 0; i < 20; i++) {
        
        [ary_ballisticTemp replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:(( ballisticInt >> i) & 0x1)] ];
    }
    
    for (int i = 0; i < 20; i++) {
        
        [tempConfigData.ballistics_changed addObject:[NSString stringWithFormat:@"%@",ary_ballisticTemp[i]]];
    }
    
     NSLog(@"ary_ballisticTemp:%@",ary_ballisticTemp);
    
    [configData setBallisticsChanged:ary_ballisticTemp];

    
    //硬體新增一筆資料
    NSNumber *indexNum = [NSNumber numberWithUnsignedInteger:[self checkConfigDataTotalCount]];
    newInt = [indexNum intValue];
    [[ProtocolDataController sharedInstance] saveConfig:newInt :configData];
    
}

#pragma mark - 16 轉 10 (int)
- (int)hexStringToInt:(NSString *)hexString{

    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&result];
    return result;
}


#pragma mark - 字串刪除","
-(NSString *)stringDeleteString:(NSString *)str {
    
    NSMutableString *oriStr = [NSMutableString stringWithString:str];
    
    for (int i = 0; i < oriStr.length; i++) {
        
        unichar c = [oriStr characterAtIndex:i];
        
        NSRange range = NSMakeRange(i, 1);
        
        if ( c == ',') {
            
            [oriStr deleteCharactersInRange:range];
            
            --i;
        }
        
    }
    
    NSString *newstr = [NSString stringWithString:oriStr];
    
    return newstr;
}



#pragma mark - 存回硬體是否成功
-(void)onResponseSaveConfig:(bool)isSuccess {
    
    NSLog(@"==>Backup onResponseSaveConfig==>%d",isSuccess);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self doSave:isSuccess];
    
    });

}

#pragma mark - 資料儲存至硬體成功後,暫存在本機
-(void)doSave:(bool)isSuccess {
    
    if (isSuccess) {
        
        //儲存 config
        NSMutableArray *configAry = [[ConfigMacroData sharedInstance] getConfigArray];
        
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    tempConfigData.configHotKeyStr,@"configHotKey",
                                    tempConfigData.configPlatformIcon,@"platform",
                                    tempConfigData.configFileName,@"configName",
                                    tempConfigData.configLEDColor,@"LEDColor",
                                    @(tempConfigData.isADStoggle),@"flagADSToggle",
                                    @(tempConfigData.isShootingSpeed),@"flagShootingSpeed",
                                    @(tempConfigData.isInverted),@"flagInvertedYAxis",
                                    @(tempConfigData.isSniperBreath),@"flagSniperBreath",
                                    @(tempConfigData.isAntiRecoil),@"flagAntiRecoil",
                                    @(tempConfigData.isSync),@"flagADSSync",
                                    tempConfigData.hipStr,@"HIPSensitivity",
                                    tempConfigData.adsStr,@"ADSSensitivity",
                                    tempConfigData.deadZoneStr,@"deadZONE",
                                    tempConfigData.sniperBreathHotkey,@"sniperBreathHotKey",
                                    tempConfigData.antiRecoilHotkey,@"antiRecoilHotkey",
                                    tempConfigData.antiRecoilStr,@"antiRecoilOffsetValue",
                                    [tempConfigData.shootingSpeedStr mutableCopy],@"shootingSpeed",
                                    [tempConfigData.keyMap mutableCopy],@"keyMapArray",
                                    [tempConfigData.ballistics_Y_value mutableCopy],@"ballisticsArray",
                                    [tempConfigData.ballistics_changed mutableCopy],@"ballisticChanged",nil];
        
        
        
        [configAry addObject:tempDic];
        
        [[ConfigMacroData sharedInstance] setConfigArray:configAry];
        
        
        //下載 MyConfig 有遊戲圖片,下載 sharedConfig 無遊戲圖片
        if (isMyConfigDownload) {
            
            //儲存圖片
            NSMutableDictionary *configImgDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                  tempConfigData.configHotKeyStr,@"configHotKey",
                                                  ary_myConfigObj[downloadIndex].myConfig_gameIcon,@"configImage",nil];
            
            [[ConfigMacroData sharedInstance] saveConfigImage:configImgDict Key:tempConfigData.configFileName];

            
        }
        
        
        
        //等待畫面消失
        [loadingView removeFromSuperview];
        loadingView = nil;
        
    }
    else {
        
       [[ProtocolDataController sharedInstance] saveConfig:newInt :configData];

    }
    
}



#pragma mark - downloadCloudDataForMyConfig (個人)
-(void)downloadCloudDataForMyConfig:(NSInteger)indexPathRow {
    
    isMyConfigDownload = YES;
    
    //檢查是否有網路
    if (![CheckNetwork isExistenceNetwork]) {
        
        //無網路時
        [self showAlert:NSLocalizedString(@"Connect fail", nil) message:NSLocalizedString(@"Please check your wifi", nil)];
        
        return;
    }

    //檢查config是否已滿8組
    if([self checkConfigDataTotalCount] >= 8) {
        
        [self waringVC];
        
        return;
    }

    [self ShowLoadingView:0 ishidden:NO];//0:Loading...
    
    
    //抓txt檔
    [self getTxtfileFromUrlAtIndexPathRow:indexPathRow];
    downloadIndex =  indexPathRow;

}


#pragma mark - downloadCloudDataForSharedConfig (公開)
-(void)downloadCloudDataForSharedConfig:(NSInteger)indexPathRow {
    
    isMyConfigDownload = NO;
    
    //檢查是否有網路
    if (![CheckNetwork isExistenceNetwork]) {
        
        //無網路時
        [self showAlert:NSLocalizedString(@"Connect fail", nil) message:NSLocalizedString(@"Please check your wifi", nil)];
        
        return;
    }

    
    //檢查config是否已滿8組
    if ([self checkConfigDataTotalCount] >= 8) {
        
        [self waringVC];
        
        return;
    }
    
    [self ShowLoadingView:0 ishidden:NO];//0:Loading...
    
    
    //抓txt檔
    [self getTxtfileFromUrlAtIndexPathRow:indexPathRow];
    
}


#pragma checkConfigDataTotalCount 下載前先檢查config是否已滿載
-(NSUInteger)checkConfigDataTotalCount {
    
    NSMutableArray *configArray = [[ConfigMacroData sharedInstance] getConfigArray];
    
    return configArray.count;
}

#pragma mark - 警告視窗(config 已滿八組)
-(void)waringVC {
    
    WaringViewController *waring = [self.storyboard instantiateViewControllerWithIdentifier:@"Key_WaringViewController"];
    waring.parentObj = self;
    waring.waring_message = NSLocalizedString(@"config limit 8", nil);// @"config上限為8組";
    
    //waring.waring_description = @"config上限為8組,請刪除\nconfig後，再繼續新增";
    [self presentViewController:waring animated:YES completion:nil];
    

}


#pragma mark - sharedMyConfigAtIndexPath 分享方法
-(void)sharedMyConfigAtIndexPath:(NSInteger)indexPathRow {
    
    //顯示 submitView
    self.submitView.hidden = NO;
    
    //submitScrollView 返回原始位置
    self.submitScrollView.contentOffset = CGPointMake(0, 0);
    
    //submitTextField(select a game)
    self.submitTextField.text = @"Select a game";
    [self checkSubmitSelectGameTextColor];
    
    //submitFeatureTextView
    self.submitFeatureTextView.text = @"Ex. Dead zone and ballistics curve are optimized for COD: BO!";
    
    //submitImgView(platform)
    NSString *platform =  ary_myConfigObj[indexPathRow].myConfig_platform;
    self.submitImgView.image = [UIImage imageNamed:[self returnPlatformImg:[platform intValue]]];
    
    //submitIndex
    submitIndex = indexPathRow;
    
    [self postGameListAPI];
    
}



#pragma mark - withdrawFile 回收方法
-(void)withdrawFileAtIndexPath:(NSInteger)indexPathRow {
    
    //檢查是否有網路
    if (![CheckNetwork isExistenceNetwork]) {
        
        //無網路時
        [self showAlert:NSLocalizedString(@"Connect fail", nil) message:NSLocalizedString(@"Please check your wifi", nil)];
        
        return;
    }
    
    
    [self ShowLoadingView:3 ishidden:NO];//3:WithDrawing...
    
    [self postSharedConfig:@"0" content:ary_myConfigObj[indexPathRow].myConfig_content fid:ary_myConfigObj[indexPathRow].myConfig_num platform:ary_myConfigObj[indexPathRow].myConfig_platform game:ary_myConfigObj[indexPathRow].myConfig_title];
}



#pragma mark - 等待畫面資訊
-(void)ShowLoadingView:(int)status ishidden:(BOOL)ishidden  {
 
    /*
     status 說明
     0:downlaod
     1:delete
     2:share
    */
    
    if (loadingView == nil) {
        
        loadingView = [[ConnectLoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        [self.view addSubview:loadingView];
        
    }
    
    switch (status) {
            
        case 0:
            [loadingView setStatusLabel:NSLocalizedString(@"Download...", nil)];
            break;//下載中...
        case 1:
            [loadingView setStatusLabel:NSLocalizedString(@"Delete...", nil)];
            break;//刪除...
        case 2:
            [loadingView setStatusLabel:NSLocalizedString(@"Sharing...", nil)];
            break;//分享中...
        case 3:
            [loadingView setStatusLabel:NSLocalizedString(@"WithDrawing...", nil)];
            break;//回收中...
        default:
            break;
            
    }
    
    [self.view bringSubviewToFront:loadingView];
    
    loadingView.hidden = ishidden;
    
    
}

#pragma mark - 沒網路時跳出預設 Alert
-(void)showAlert:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
    
    [alertView addAction:okAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}



#pragma mark - post  &  process GameListAPI
-(void)processGameList:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    NSNumber *code = [resopnseData objectForKey:@"ret"];
    
    if (code.intValue== 0) {
        //success
        
    
        NSLog(@"取得 遊戲清單 成功");
        
        NSLog(@"遊戲清單: %@",resopnseData);
        
        NSMutableArray *eliteAry = [[NSMutableArray alloc]init];
        
        eliteAry = [resopnseData objectForKey:@"list"];
        
        [ary_gameList removeAllObjects];
        
        for (int i = 0; i < eliteAry.count; i++) {
            
            EliteObject *obj = [[EliteObject alloc] init];
            
            obj.elite_gameName = [eliteAry[i] objectForKey:@"name"];//菁英名稱
            
            obj.elite_ID = [eliteAry[i] objectForKey:@"id"];//菁英 ID
            
            [ary_gameList addObject:obj];
            
        }
        
        
    }
    else {
        
        NSLog(@"取得 遊戲清單 失敗");
    }
    
}

-(void)postGameListAPI {
    
    int eventID = CloudAPIEvent_elitegamelist;
    
    NSMutableDictionary *sendParam = [[NSMutableDictionary alloc] init];
    
    [cloudClass postDataAsync:sendParam APIName:KAPI_elitegamelist EventId:eventID];
    
    isGameListAction = YES;
    
}


#pragma mark - checkGameTextColor
-(void)checkSubmitSelectGameTextColor {
    
    if ([self.submitTextField.text isEqualToString:@"Select a game"]) {
        
        self.submitTextField.textColor = [UIColor colorWithRed:0.9 green:0.0 blue:0.0 alpha:1.0];
    }
    else {
        
        self.submitTextField.textColor = [UIColor whiteColor];
    }
    
}


- (IBAction)gameListCancelAction:(id)sender {
    
    self.submitGameListView.hidden = YES;
    
    self.submitTextField.text = @"Select a game";
    
    [self checkSubmitSelectGameTextColor];
    
    isGameListAction = NO;
}


-(void)showGameList {
    
    self.submitGameListView.hidden = NO;
    
    [self.submitGameListTableView reloadData];
    
}






@end
