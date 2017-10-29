
//#import "IdeabusSDK.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "CommProcess.h"
#import "MyBluetoothLE.h"

#import "DeviceStatus.h"
#import "FPSConfigData.h"
#import "FPSMacroData.h"


@protocol ConnectStateDelegate

/**
 * 開啟設備BLE事件
 * @param isEnable 藍牙是否開啟
 */
- (void) onBtStateChanged:(bool) isEnable;

/**
 * 返回掃描到的藍牙
 * @param uuid mac address
 * @param name 名稱
 * @param rssi 訊號強度
 */
- (void) onScanResultUUID:(NSString*) uuid Name:(NSString*) name RSSI:(int) rssi;

/**
 * 連線狀態
 * ScanFinish,			//掃描結束
 * Connected,			//連線成功
 * Disconnected,		//斷線
 * ConnectTimeout,		//連線超時
 */
- (void) onConnectionState:(ConnectState) state;

@end

@protocol DataResponseDelegate

//*********************************
// FPS protocol

/**
 *  驗證成功，則isSuccess應等於true
 *
 */
//- (void) onResponseCheckDevice:(bool) isSuccess;

/**
 *  傳回 device週邊狀態，得知手把、鍵盤、滑鼠是否接上及當前使用那組configHotKey
 *
 */
- (void) onResponseDeviceStatus:(DeviceStatus*) ds;

///**
// *  傳回 韌體版本
// *
// */
//- (void) onResponseFWEdition:( NSString*) edition;

/**
 *  isSuccess=true, 儲存成功。 false:失敗
 
 *
 */
-(void) onResponseSaveConfig:(bool)isSuccess;


/**
 *  是否儲存成功
 *
 */
-(void) onResponseSaveMacro:(bool)isSuccess;



/**
 *   回傳config的內容
 *   
 *  @param  no 
 *  @param  configData  config的內容,  若該位置無資料，則為null
 *
 */
-(void) onResponseLoadConfig:(int)no :(FPSConfigData*)configData;


/**
 *   回傳macro的內容
 *
 *  @param  no
 *  @param  macroData  macro的內容,  若該位置無資料，則為null
 *
 */
-(void) onResponseLoadMacro:(int)no :(FPSMacroData*)macroData;


/**
 *    是否移動成功
 *
 */
-(void) onResponseMoveConfig:(bool)isSuccess;
/**
 *    是否移動成功
 *
 */
-(void) onResponseMoveMacro:(bool)isSuccess;

/**
 *    是否刪除成功
 *
 */
-(void) onResponseDelConfig:(bool)isSuccess :(int)no;
/**
 *    是否刪除成功
 *
 */
-(void) onResponseDelMacro:(bool)isSuccess :(int)no;

/**
 *   回傳玩家按下的按鍵碼
 *
 */
-(void) onResponseResponseMode:(int)keyCode;
/**
 *  是否即時變更某項config設定值成功  
 *
 */
-(void) onResponseLiveMode:(bool)isSuccess;





/**
 *   硬體通知清除到那個page，每頁2048 byte
    硬體要清出空間存FW檔
 
   @param   pageCnt     總頁數
   @param   packetNum    目前清到第幾頁
 */
-(void) onResponseFWUpdateResult:(int)pageCnt :(int)packetNum;
/**
 *  是否成功儲存FW檔到硬體
 *
 */
-(void) onResponseFWUpdateResult2: (bool)isSuccess;


-(void)onResponseMacroConfigFunctionSet:(bool)isSuccess;

@end


@interface FPSProtocol : CommProcess <MyBluetoothLEDelegate>{
}

@property (strong) id<ConnectStateDelegate> connectStateDelegate;
@property (strong) id<DataResponseDelegate> dataResponseDelegate;


//初始化
//@param simulation 是否開啟模擬數據
//@param printLog 是否印出SDK Log
- (id) getInstanceSimulation:(bool)simulation PrintLog:(bool)printLog;

//檢查是否支援藍牙LE。如果是,彈出詢問使用者是否開啟藍牙視窗
- (void)enableBluetooth;

//開始掃瞄,透過onScanResultMac傳回掃描到的藍牙資訊
//@param timeout 掃描時間(sec)
- (void) startScanTimeout:(int)timeout;

//停止掃瞄
- (void) stopScan;

//連線,透過onConnectionState返回連線狀態
- (void) connectUUID:(NSString *)uuid;

//斷線,透過onConnectionState返回斷線狀態
- (void) disconnect;

//-----------------------------------------------
//  FPS  protocol

/**
 *  藍芽連線成功時，進行簡易驗證
 *
 */
//- (void) checkDevice ;

/**
 *讀取device週邊狀態，得知手把、鍵盤、滑鼠是否接上及當前使用那組configHotKey
 */
- (void) getDeviceStatus;

- (NSString *)getFwVersion;
-(void)startListeningResponse;
-(void)stopListeningResponse;

/**
 *  取得韌體版本
 *
 */
//- (void) getFWEdition;

/**
 *通知硬體即將傳送的FW檔的大小
 * @param fwFile
 */

-(void) updateFW:(NSData*) fwFile;


/**
 *
 *傳送韌體檔到硬體
 *
 */
- (void) updateFW2: (NSData*) fwFile;

- (void) updateFWPacket:(int) packetNum :(NSString*) packetHexStr;

- ( NSString*) fill_FF: (NSString*) lastPacket  :(int)packetLength;
    
-( NSString*) convertBytesToHexString: (unsigned char *) data;


/**
 * save config to 硬體
 *  @param  no    想儲存的config檔的編號
 *  @param  configData   config檔的內容
 */
- (void) saveConfig:(int)no  :(FPSConfigData*)configData;

-(NSArray*) splitToPacket:(NSString*)hexString  :( int) byteNum;


/**
 * load config from 硬體
 *  @param  no    想載入的config檔的編號
 *
 */
-(void)loadConfig: (int)no ;


/**
 * del  config  at  硬體
 *  @param  no     config檔的編號
 *
 */
-(void)delConfig:(int)no;


/**
 * save Macro to 硬體
 *  @param  no    想儲存的macro檔的編號
 *  @param  macroData   macro檔的內容
 */
-(void) saveMacro:(int)no :(FPSMacroData*)macroData ;

/**
 * load Macro from 硬體
 *  @param  no    想載入的Macro檔的編號
 *
 */
-(void)loadMacro: (int)no ;

/**
 * del  Macro  at  硬體
 *  @param  no     Macro檔的編號
 *
 */
-(void)delMacro:(int)no ;


/**
 *  取得玩家按下的按鍵，需定時下達指令，直到獲得按鍵為止
 *
 *  用於熱鍵設定 或 巨集設定 
 *
 */
-(void)responseMode ;


/**
 *
 *  修改config設定值時
 *  即時將config某項設定值的變更傳到硬體中
 *
 *
 *  @param  changedFieldID  被變更的設定值
 
    參考： ConfigData.h中的常數定義，以  CHANGE_  開頭
    如：  CHANGE_LED_COLOR
         CHANGE_HIP_SENSITIVITY
 
 *  @param  configData  config內容，需包含被更動的設定值
 *
 */
-(void)liveMode:(int)changedFieldID :(FPSConfigData*)configData ;

-(void) resetLiveMode;

-(NSString*)fillPreZero:(NSString*)hexStr;


/**
 *  移動config檔的位置，from及to上的config會被互換
 * @param  from    config  no
 * @param  to      config  no
 *
 */
-(void)moveConfig: (int)from  :(int)to;


/**
 *  移動macro檔的位置，from及to上的macro會被互換
 * @param  from    macro  no
 * @param  to      macro  no
 *
 */
-(void)moveMacro: (int)from  :(int)to;

-(void )MacroConfigFunctionSet: (int)keycode;

-(void)MacroConfigFunctionEnable;
-(void)MacroConfigFunctionDisable;
//////////////////////////////////////////////
  

@end
