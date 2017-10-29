

#import <Foundation/Foundation.h>


@interface MCTableViewCellObject : NSObject

/*
 
 hotKeyImgStr:快捷鍵圖示
 marcoHotKey:marco快捷鍵名稱
 marcoFileName:marco檔名
 marcoPlatformImgStr:遊戲主機
 ary_key:巨集按鍵
 ary_delayTime:延遲時間
 
 */
@property (strong, nonatomic) NSString *hotKeyImgStr;
@property (strong, nonatomic) NSString *marcoHotKey;
@property (strong, nonatomic) NSString *marcoFileName;
@property (strong, nonatomic) NSString *marcoPlatformImgStr;
@property (strong, nonatomic) NSMutableArray <NSNumber *> *marco_ary_key;//16個
@property (strong, nonatomic) NSMutableArray <NSNumber *>*marco_ary_delayTime;//15個



@end
