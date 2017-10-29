
#import "Function.h"
#import "MyBluetoothLE.h"

enum CheckSum{ none, cpAndFF, cpCRC16, cpCRC32};
#define POLY 0xa001

@interface CommProcess : NSObject{
    
}

@property (strong,nonatomic) MyBluetoothLE *myBluetooth;

- (void)initWithInfo:(NSDictionary *)info PrintLog:(BOOL)printLog;

//驗證received字串
- (NSString *)calcReceivedMessage:(NSString *)message;

//計算 CheckSum
- (unsigned int)computationCheckSum:(NSString *)comm;
- (unsigned int)computationCheckSum2:(NSString *)comm;  //for  reply cmd from device
- (NSString*) calcChecksum:(NSString*)message;
    
-(void) setFrequency: (float)second;

- (void)commTimerStart; //開始通訊迴圈
- (void)commTimerStop;  //結束通訊迴圈

- (void)addCommArray:(NSString *)comm RemoveAllComm:(BOOL)removeAllComm;

- (NSString *)getFirstComm;

- (int)getCommArrayCount;

//刪除命令
- (void)removeComm;
//刪除所有相同命令
- (void)removeSameComm:(NSString *)cmd;
//刪除所有命令
- (void)removeAllComm;

- (void)initSendCount;

- (NSString *)getHeader;
- (NSString *)getEnd;

@end
