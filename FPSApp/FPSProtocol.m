
#import "FPSProtocol.h"
#import "CommandType.h"
 
FPSProtocol *instance;

int CMD_LENGTH_INDEX_START = 2;
int CMD_CMD_INDEX_START = 0;
float FREQUESCY = 0.3;
//float FREQUESCY_SHORT = 0.2;
//float FREQUESCY_LONG = 1.0;


@implementation FPSProtocol{
    bool isSimulation;
    bool isPrintLog;
    
    //Simulation----------------------------------
    NSTimer *simulationTimer;
    
    NSString *bleName;
    NSString *bleMac;
    
    NSMutableArray *simulationMacArray,*simulationNameArray;
    int simulationPosition;
    //Simulation----------------------------------
    
    NSString *allReceivedCommand;
    int RECEIVED_ERROR_COUNT;
    int receiveErrorCount;
    
    int connectStatus;
    
    //暫存
    int pageTotalNum;
    NSUInteger totalPacketNum;
    
    NSMutableArray* packetArr;
    NSMutableArray* cmdStrArr;
    int FWReSendCount;
    int FWErrPacketNO;
    NSMutableString* FWAllErrPacketNoStr;

    int lastPacketNo;
    int lastPageSizeForFW;
    int lastPacketSizeForFW;
    
    NSString *fwVersion;
    NSTimer *listeningResponseTimer;
    
}
//@synthesize commandDelegate;

//初始化
//@param simulation 是否開啟模擬數據
//@param printLog 是否印出SDK Log
- (id)getInstanceSimulation:(bool)simulation PrintLog:(bool)printLog{
    isSimulation = simulation;
    isPrintLog = printLog;
    
    [Function setPrintLog:isPrintLog];
    
    
    allReceivedCommand = @"";
    RECEIVED_ERROR_COUNT = 10;
    receiveErrorCount = 0;
    
    
    if(isSimulation){
        bleName = @"Fuel";
        bleMac = @"1234567890";
        simulationPosition = 0;
      
        
        simulationMacArray = [[NSMutableArray alloc] initWithCapacity:10];
        simulationNameArray = [[NSMutableArray alloc] initWithCapacity:10];
        for(int i = 1 ; i < 11 ; i++){
            [simulationNameArray addObject:[NSString stringWithFormat:@"%@-%i", bleName, i]];
            [simulationMacArray addObject:[NSString stringWithFormat:@"%@%i", bleMac, (i - 1)]];
        }
        return self;
    }
    
    [self init ];
    return self;
    
//    if(instance == nil)
//        instance = [[FuelProtocol alloc] init];
//    return instance;
}

- (id)init{
    self = [super init];
    if(self){
        NSNumber *type = [NSNumber numberWithInt:cpAndFF];
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setValue:@"FFF0" forKey:@"serviceUUID"];
        [info setValue:@"FFF2" forKey:@"writeUUID"];
        [info setValue:@"FFF1" forKey:@"notifyUUID"];
        [info setValue:@"-1" forKey:@"header"];
        [info setValue:@"-1" forKey:@"end"];
        [info setValue:[[NSString alloc] initWithFormat:@"%f", FREQUESCY] forKey:@"frequency"];
        [info setValue:type forKey:@"checksumType"];
        
        [self initWithInfo:info PrintLog:isPrintLog];
        
        self.myBluetooth.myBLEDelegate = self;
    }
    return self;
}

//檢查是否支援藍牙LE。如果是,彈出詢問使用者是否開啟藍牙視窗
- (void)enableBluetooth{
    [self.myBluetooth enableBluetooth];
}

//開始掃瞄,透過onScanResultMac傳回掃描到的藍牙資訊
//@param timeout 掃描時間(sec)
- (void) startScanTimeout:(int)timeout{
    [self stopScan];
    [Function printLog:@"開始掃描"];
    if(isSimulation){
        simulationTimer = [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(simulationScan) userInfo:nil repeats:YES];
        return;
    }
    
//  @[[CBUUID UUIDWithString:@"49535343-1E4D-4BD9-BA61-23C647249616"]]
//    @[[CBUUID UUIDWithString:@"49535343-FE7D-4AE5-8FA9-9FAFD205E455"]]
//    NSArray *uuids = [NSArray arrayWithObject:[CBUUID UUIDWithString:@"49535343-FE7D-4AE5-8FA9-9FAFD205E455"]];
    [self.myBluetooth imStartScanUUIDs:nil Timeout:timeout];
}

//停止掃瞄
- (void)stopScan{
    [Function printLog:@"停止掃描"];
    if(isSimulation){
        [self cancelTimer];
        return;
    }
    [self.myBluetooth imStopScan];
}

- (BOOL) isSupportBLE{
    return [self.myBluetooth isSupportBLE];
}

- (void) connectUUID:(NSString *)uuid{
    [self stopScan];
    [Function printLog:@"連線"];
    if(isSimulation){
        [_connectStateDelegate onConnectionState:Connected];
        return;
    }
    NSArray *array = [[NSArray alloc] initWithObjects:uuid, nil];
    [self.myBluetooth imConnectUUIDs:array];
}

//斷線,透過onConnectionState返回斷線狀態
- (void) disconnect{
    [Function printLog:@"斷線"];
    if(isSimulation){
        [self cancelTimer];
        [_connectStateDelegate onConnectionState:Disconnect];
        return;
    }
    [self commTimerStop];
    [self.myBluetooth imDisconnect];
}

//--------------------------------------------------------------------------------------------------------------------

- (NSString *)getFwVersion{
    return fwVersion;
}

/**
 *  藍芽連線成功時，進行簡易驗證
 *
 */
- (void) checkDevice{
    if(isSimulation){
        return;
    }
    
    NSString* command = @"01";
    NSString* data =  @"896656" ;
    
    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
    NSString *newComm = [self calcChecksum:commandStr];

    [self addCommArray:newComm RemoveAllComm:false];
}

/**
 *讀取device週邊狀態，得知手把、鍵盤、滑鼠是否接上及當前使用那組configHotKey
 *
 */
- (void) getDeviceStatus{
    if(isSimulation){
        return;
    }
    if(!connectStatus)
        return;
    
    NSString* command = @"03";
    NSString* data =  @"0301" ;
    
    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
    
    NSString *newComm = [self calcChecksum:commandStr];
    [self addCommArray:newComm RemoveAllComm:false];
}


/**
 *
 */
- (void) getFWEdition{
    if(isSimulation){
        return;
    }
    
    NSString* command = @"02";
    NSString* data = @"02";
    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
    NSString *newComm = [self calcChecksum:commandStr];
    [self addCommArray:newComm RemoveAllComm:false];}



/**
 *通知FW檔大小
 * @param fwFile
 */

-(void) updateFW:(NSData*) fwFile{
    if(isSimulation ){
        return;
    }
    
   
    
    NSMutableArray* packetArr2 = [self  readHexString:fwFile ];
    int len = [self countByteNum: packetArr2];
//    BaseGlobal.printLog("d", TAG, "len byte = " + len);
    
    int packetSize = 16;//byte
    NSString* lastPacket = (NSString*)[packetArr2 objectAtIndex:[packetArr2 count]-1];
    if([lastPacket length] < packetSize*2  )
    {
        lastPacket = [self fill_FF: lastPacket :packetSize*2];
    }

    [packetArr2 replaceObjectAtIndex:[packetArr2 count]-1 withObject:lastPacket];

     packetArr = packetArr2;
    
    
    
    NSString* command = @"10";//告知檔案大小

    int pageSize = 2048;//bytes
//    int len = (int)[fwFile length];
     pageTotalNum = len/pageSize ;  //是無條件捨去 小數
     pageTotalNum = (len % pageSize != 0)?   pageTotalNum+1 :  pageTotalNum;

    [Function printLog:[NSString stringWithFormat:@" len  %d",  len ]];

    [Function printLog:[NSString stringWithFormat:@" pageTotalNum  %d",  pageTotalNum ]];

    totalPacketNum = [packetArr count];
    
 
    NSString* data =  [NSString stringWithFormat:@"%04X%08X" , totalPacketNum, len] ;

    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
    NSString *newComm = [self calcChecksum:commandStr];
    [self addCommArray:newComm RemoveAllComm:false];

}

-( int) countByteNum:(NSArray*) packetArr
{
    
    int byteNum = 0;
    for (int i = 0; i < [packetArr count]; i++)
    {
        byteNum = byteNum+ [(NSString*)[packetArr objectAtIndex:i ] length];
    }
    
    return byteNum/2;
}

- (void) updateFW2: (NSData*) fwFile {
    if(isSimulation){
        return;
    }
   
    FWReSendCount= 0 ;
    FWErrPacketNO=0;
    FWAllErrPacketNoStr = [[NSMutableString alloc] init];

    //frequency
    //[self setFrequency:FREQUESCY_SHORT];
    //[self commTimerStart];
    
    
    [Function printLog: [NSString stringWithFormat:@" packetArr description  %@", [packetArr description]]];

    cmdStrArr = [self convertToCmdStrArr: packetArr];
    
    
    for (int i = 0; i <  [cmdStrArr count]; i++) {
        if(i==10){
//            11000A48918882C3B481C9F30AC623FE46577A
//            [self updateFWPacket:i : [NSString stringWithFormat:@"48918882C3B481C9F30AC623"]];

//            [self updateFWPacket:i :[NSString stringWithFormat:@"%@%@", [cmdStrArr objectAtIndex:i],@"ee" ]];
//            break;
        }
        
        [self updateFWPacket:i :[cmdStrArr objectAtIndex:i]];
    }
    
 
}

- (NSMutableArray*) convertToCmdStrArr:(NSMutableArray*) packetArr2
{
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:[packetArr2 count]];
    
    for (int i = 0; i < [packetArr2 count]; i++) {
        NSString*  command = @"11";//下載檔案到設備
        
        NSString* data = @"";
        data = [NSString stringWithFormat:@"%04X%@", i, [packetArr2 objectAtIndex:i]];
 
        
        NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
        NSString *newComm = [self calcChecksum:commandStr];
        
        [arr addObject:newComm];
        
      
    }
    
    return arr;
}


- (void) updateFWPacket:(int) packetNum :(NSString*) packetHexStr {
    if(isSimulation){
        return;
    }
    
//    NSString* command = @"11";//下載檔案到設備
    
//    NSString* data = @"";
//     data =  [NSString stringWithFormat:@"%04X%@", packetNum , packetHexStr ];
    
//    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
//    NSString *newComm = [self calcChecksum:commandStr];
    
    [self addCommArray:packetHexStr RemoveAllComm:false];
}


- (NSArray*) readHexString:(NSData*) nsData
{
    NSString *fileContents = [[NSString alloc]initWithData:nsData encoding:NSUTF8StringEncoding];
    
    NSMutableArray* allLinedStrings =
    [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    for(int i =0; i < [allLinedStrings count];  )
    {
        if([(NSString*)[allLinedStrings objectAtIndex:i] isEqualToString:@""])
        {
            [allLinedStrings removeObjectAtIndex:i];
        }
        else{
            i++;
        }
        
    }
    
    //[Function printLog:[NSString stringWithFormat:@"allLinedStrings  %@",  [allLinedStrings description] ]];

    
    return allLinedStrings;
}



- ( NSString*) fill_FF: (NSString*) lastPacket  :(int)packetLength {
    int offset = packetLength - [lastPacket length];
    
    NSMutableString* sb = [[NSMutableString alloc] initWithString:lastPacket];
    for (int i = 0; i < offset; i++) {
        [sb appendString:@"F"];
    }

    return sb;
}

-( NSString*) convertBytesToHexString: (unsigned char *) data{
    NSMutableString* hexString = [[NSMutableString alloc] init];// StringBuilder();
    
    for (int i = 0; i < sizeof(data) ; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%02X" , data[i] ]];
    }
    return hexString ;
}




- (void) saveConfig: (int)no :(FPSConfigData*)configData{
    if(isSimulation){
        return;
    }
    
    NSString* command = @"04";
    NSString* hexStr;
    
    // dell config
    if(configData == nil){
        hexStr =  CONFIG_ALL_FF_STRING;
        
    }
    else{
        hexStr = [configData toHexString];
        
    }
    
    [Function printLog:[NSString stringWithFormat:@"saveConfig  packet hexStr : %@", hexStr]];
    
    
    NSArray* packets = [self splitToPacket:hexStr :16];
    
    [Function printLog:[NSString stringWithFormat:@"saveConfig  packet  count: %d", (unsigned long)[packets count]]];
    
    NSString* data;
    
    for (int i = 0; i < [packets count]  ; i++) {
//        data = (Integer.toHexString(no)+ Integer.toHexString(i) + packets[i]);
        data = [NSString stringWithFormat:@"%01lx%01lx%@",no, i, [packets objectAtIndex:i] ];
        [Function printLog:[NSString stringWithFormat:@"saveConfig  packet  data : %@", data]];
    
        NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
        NSString *newComm = [self calcChecksum:commandStr];
        [self addCommArray:newComm RemoveAllComm:false];
    }
    
    
}


-(NSArray*) splitToPacket:(NSString*) hexString :( int) byteNum {
    
    int splitLength = byteNum*2;
    int start =0;
    //int end = splitLength;
    int loopCount = ([hexString length]/splitLength)+1;
    
    //[Function printLog:[NSString stringWithFormat:@"splitToPacket  loop count:%d", loopCount]];
    
    NSMutableArray*  packets = [[NSMutableArray alloc ] init];//string array
    
    //[Function printLog:[NSString stringWithFormat:@"splitToPacket  packets count:%lu",(unsigned long)[packets count]]];
    
    for (int i = 0; i < loopCount -1; i++) {
        //[Function printLog:[NSString stringWithFormat:@"splitToPacket   i:%d", i]];
        //[Function printLog:[NSString stringWithFormat:@"splitToPacket   start:%d", start]];
       
        NSString* s = [hexString substringWithRange:NSMakeRange(start, splitLength)];
        //[Function printLog:[NSString stringWithFormat:@"splitToPacket   str: %@", s]];

        [packets addObject:  s];
        start +=splitLength;
        //[Function printLog:@"splitToPacket   packet count===:"];
        //[Function printLog:[NSString stringWithFormat:@"splitToPacket   packets count :%lu",(unsigned long)[packets count]]];
        
        //[Function printLog:[NSString stringWithFormat:@"splitToPacket   hexString  :%@", hexString]];
        
        //[Function printLog:[NSString stringWithFormat:@"splitToPacket   packets description : %@", [packets description]]];

        
        //end +=splitLength;
    }
    [packets addObject:[hexString substringFromIndex:start ]];
    //[Function printLog:@"splitToPacket  packet count===:"];
    //[Function printLog:[NSString stringWithFormat:@"splitToPacket  packets count : %lu",(unsigned long)[packets count]]];

    return packets;
}


 

/**
 * 載入全部設定檔
 * @param no   0~7
 */
-(void)loadConfig: (int)no {
    if(isSimulation){
        return;
    }
    
    //new version  protocol
    NSString* command = @"06";
    int configDataLength = 75;
    NSString* data = @"";
    
    data = [NSString stringWithFormat:@"%1x000", no];
    
    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
    NSString *newComm = [self calcChecksum:commandStr];
    [self addCommArray:newComm RemoveAllComm:false];
}




-(void)delConfig:(int)no {
    if(isSimulation){
        return;
    }
    //[self saveConfig:no :nil ];
    
    
    //new version  protocol
    
    NSString* command = @"0B";
    NSString* data = @"";
    
    data = [NSString stringWithFormat:@"%02x", no ];
    
    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
    NSString *newComm = [self calcChecksum:commandStr];
    [self addCommArray:newComm RemoveAllComm:false];
}




-(void) saveMacro:(int)no :(FPSMacroData*)macroData {
    if(isSimulation){
        return;
    }

    NSString* command = @"05";
    NSString* hexStr;

    if(macroData == nil)
    {
        hexStr =   MACRO_ALL_FF_STRING ;
    }
    else
    {
        hexStr = [macroData toHexString];
    }

    

    [Function printLog:[NSString stringWithFormat:@"saveMacro  packet hexStr : %@", hexStr]];
    

    NSArray* packets = [self splitToPacket: hexStr  :16];
     [Function printLog:[NSString stringWithFormat:@"saveMacro  packet  count: %lu", (unsigned long)[packets count]]];
    
    NSString* data = @"";

    for (int i = 0; i < [packets count] ; i++) {
        //data = (Integer.toHexString(no)+ Integer.toHexString(i) + packets[i]);
        data = [NSString stringWithFormat:@"%01x%01x%@", no, i, [packets objectAtIndex:i]];
          
        [Function printLog:[NSString stringWithFormat:@"saveMacro  packet data : %@", data]];

        NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
        NSString *newComm = [self calcChecksum:commandStr];
        [self addCommArray:newComm RemoveAllComm:false];
    }
}
 


-(void)loadMacro: (int)no {
    if(isSimulation ){
        return;
    }


    //new version  protocol
    NSString* command = @"07";
    NSString* data = @"";
 
    data = [NSString stringWithFormat:@"%1x000", no ];
    
    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
    NSString *newComm = [self calcChecksum:commandStr];
    [self addCommArray:newComm RemoveAllComm:false];}

 

-(void)delMacro:(int)no {
    if(isSimulation){
        return;
    }
    //[self saveMacro:no :nil];
    
    
    //new version  protocol
    NSString* command = @"0D";
    NSString* data = @"";
    
    data = [NSString stringWithFormat:@"%02x", no ];
    
    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
    NSString *newComm = [self calcChecksum:commandStr];
    [self addCommArray:newComm RemoveAllComm:false];
}
 

-(void)startListeningResponse{
    [self stopListeningResponse];
    listeningResponseTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(responseMode) userInfo:nil repeats:YES];
}

- (void)stopListeningResponse{
    if(listeningResponseTimer != nil){
        [listeningResponseTimer invalidate];
        listeningResponseTimer = nil;
    }
}

-(void)responseMode {
    if(isSimulation){
        return;
    }
    
    if(!connectStatus){
        [self stopListeningResponse];
        return;
    }
    
    NSString* command = @"08";

    NSString* data = @"01";

    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
    NSString *newComm = [self calcChecksum:commandStr];
    [self addCommArray:newComm RemoveAllComm:false];
}
 

/**
 *
 * @param changedFieldID   view   ConfigData  常數
 * @param configData
 */
-(void)liveMode:(int)changedFieldID   :(FPSConfigData*)configData {
    if(isSimulation ){
        return;
    }
    
     NSLog(@"liveMode-----changedFieldID = %i , configData = %@", changedFieldID, configData);
    
    
    NSString* command = @"09";
    int packetNum = [configData getChangedFieldPacketNum:changedFieldID ];
    
    //NSString* hexStr = [configData toHexString:changedFieldID];
    NSString* hexStr = [configData toHexString: changedFieldID];
    
    [Function printLog:[NSString stringWithFormat:@"liveMode  packetNum  %d",packetNum]];
    [Function printLog:[NSString stringWithFormat:@"liveMode  hexStr  %@",hexStr]];

    NSString* data = [NSString stringWithFormat:@"%02x%@" , packetNum,  hexStr];
 
    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
    NSString *newComm = [self calcChecksum:commandStr];
    [self addCommArray:newComm RemoveAllComm:false];

}
  
	/**
	 * 複原作用中的config 到上一次設定值
	 *
	 */
-(void) resetLiveMode {
    
    if(isSimulation){
        return;
    }


    FPSConfigData* data = [[FPSConfigData alloc] init];
    [data initParam];
    
    [data setPlatform:CONFIG_PLATFORM_PS3];
    
    [data setLEDColor:0];
    [data setFuncFlag_ADSSync:false];
    [data setFuncFlag_ADSToggle:false];
    [data setFuncFlag_antiRecoil:false];
    [data setFuncFlag_invertedYAxis:false];
    [data setFuncFlag_shootingSpeed:false];
    [data setFuncFlag_sniperBreath:false];
    [data setHIPSensitivity:40];
    [data setADSSensitivity:40];
    [data setDeadZONE:1];
    [data setSniperBreathHotKey:255];
    [data setSniperBreathMapkey:0];
    [data setAntiRecoilHotkey:255];
    [data setAntiRecoilOffsetValue:0];
    [data setShootingSpeed:40];
    
    
    NSNumber* arr1[22] ={
        [NSNumber numberWithInt:0x52 ],
        [NSNumber numberWithInt:0x4f ],
        [NSNumber numberWithInt:0x51 ],
        [NSNumber numberWithInt:0x50 ],
        [NSNumber numberWithInt:0x15 ],
        [NSNumber numberWithInt: 0x1E],
        [NSNumber numberWithInt:0x2c],
        [NSNumber numberWithInt:0x06],
        [NSNumber numberWithInt:0x14],
        [NSNumber numberWithInt:0x0A],
        [NSNumber numberWithInt:0x6A],
        [NSNumber numberWithInt:0x69],
        [NSNumber numberWithInt:0x71],
        [NSNumber numberWithInt:0x08],
        [NSNumber numberWithInt:0x28],
        [NSNumber numberWithInt:0x2A],
        [NSNumber numberWithInt:0x29],
        [NSNumber numberWithInt:0x2B],
        [NSNumber numberWithInt:0x1A],
        [NSNumber numberWithInt:0x16],
        [NSNumber numberWithInt:0x04],
        [NSNumber numberWithInt:0x07]
    };
    
    NSArray* arr2 = [NSArray arrayWithObjects: arr1 count:22];
    
    [data setKeyMapArray:arr2 ];
    
    
    NSNumber* arr3[20] ={
        [NSNumber numberWithInt:5],
        [NSNumber numberWithInt:10],
        [NSNumber numberWithInt:15],
        [NSNumber numberWithInt:20],
        [NSNumber numberWithInt:25],
        [NSNumber numberWithInt:30],
        [NSNumber numberWithInt:35],
        [NSNumber numberWithInt:40],
        [NSNumber numberWithInt:45],
        [NSNumber numberWithInt:50],
        
        [NSNumber numberWithInt:55],
        [NSNumber numberWithInt:60],
        [NSNumber numberWithInt:65],
        [NSNumber numberWithInt:70],
        [NSNumber numberWithInt:75],
        [NSNumber numberWithInt:80],
        [NSNumber numberWithInt:85],
        [NSNumber numberWithInt:90],
        [NSNumber numberWithInt:95],
        [NSNumber numberWithInt:100]
    };
    NSArray* arr4 = [NSArray arrayWithObjects: arr3 count:20];
    [data setBallistics:arr4];
    
    
    
    
    
    
    
    NSString* command = @"09";
    
    //    NSString* hexStr = @"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";//16 byte
    //    NSString* lastHexStr = @"FFFFFFFFFF";//5 byte
    
    NSString* data0 = [NSString stringWithFormat:@"%02x%@" , 0,  [data toHexStringImp:0]];
    NSString* data1 = [NSString stringWithFormat:@"%02x%@" , 1,   [data toHexStringImp:1]];
    NSString* data2 = [NSString stringWithFormat:@"%02x%@" , 2,   [data toHexStringImp:2]];
    NSString* data3 = [NSString stringWithFormat:@"%02x%@" , 3,   [data toHexStringImp:3]];
    
    
    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data0];
    NSString *newComm = [self calcChecksum:commandStr];
    [self addCommArray:newComm RemoveAllComm:false];
    
    
    NSString *commandStr1 = [NSString stringWithFormat:@"%@%@", command, data1];
    NSString *newComm1 = [self calcChecksum:commandStr1];
    [self addCommArray:newComm1 RemoveAllComm:false];
    
    NSString *commandStr2 = [NSString stringWithFormat:@"%@%@", command, data2];
    NSString *newComm2 = [self calcChecksum:commandStr2];
    [self addCommArray:newComm2 RemoveAllComm:false];
    
    NSString *commandStr3 = [NSString stringWithFormat:@"%@%@", command, data3];
    NSString *newComm3 = [self calcChecksum:commandStr3];
    [self addCommArray:newComm3 RemoveAllComm:false];
}

-(NSString*)fillPreZero:(NSString*)hexStr {
    if([ hexStr length ] == 1){
        hexStr = [NSString stringWithFormat:@"0%@", hexStr];//"0" + hexStr;
    }
    return hexStr;

}
 
         
 -(void)moveConfig: (int)from  :(int)to {
     if(isSimulation ){
         return;
     }
     
     [Function printLog: @"call func: move Config "  ];
     
     NSString* command = @"0A";
     
    
     NSString* data = [NSString stringWithFormat:@"%02X%02X" , from, to];
     
     NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
     NSString *newComm = [self calcChecksum:commandStr];
     [self addCommArray:newComm RemoveAllComm:false];
 }

         
-(void)moveMacro: (int)from  :(int)to {
    if(isSimulation ){
        return;
    }
    
    [Function printLog: @"call func: move Macro "  ];
    
    NSString* command = @"0C";
    NSString* data = [NSString stringWithFormat:@"%02X%02X" , from, to];
    
    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
    NSString *newComm = [self calcChecksum:commandStr];
    [self addCommArray:newComm RemoveAllComm:false];
}

-(void )MacroConfigFunctionSet: (int)keycode {
    if(isSimulation ){
        return;
    }
    
    [Function printLog: @"call func: MacroConfigFunctionSet "  ];
    
    NSString* command = @"0E";
    NSString* data = [NSString stringWithFormat:@"%02X" , keycode];
    
    NSString *commandStr = [NSString stringWithFormat:@"%@%@", command, data];
    NSString *newComm = [self calcChecksum:commandStr];
    [self addCommArray:newComm RemoveAllComm:false];
    
}

-(void)MacroConfigFunctionEnable{
    [self MacroConfigFunctionSet:1];
    [self MacroConfigFunctionSet:3];
}
-(void)MacroConfigFunctionDisable{
    [self MacroConfigFunctionSet:0];
    [self MacroConfigFunctionSet:2];
}


////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////




//-------------MyBluetoothLEDelegate---------------------------------------
//連線狀態 IMBluetoothLE 回調

//設備BLE事件
//@param isOpen 藍牙開啟
- (void)onBtStateEnable:(bool)isEnable{
    [_connectStateDelegate onBtStateChanged:isEnable];
}

- (void)onConnectionState:(ConnectState)state{
    connectStatus = state;
    if(state == Connected){
        [self removeAllComm];
        [self commTimerStart];
        [self checkDevice];
        return;
    }else if(state == Disconnect){
        [self commTimerStop];
    }
    [_connectStateDelegate onConnectionState:state];
}

//接收字串
- (void)onDataResultMessage:(NSString *)message{
//    message = [self calcReceivedMessage:message];
    [Function printLog:[NSString stringWithFormat:@"接收字串 === message = %@",message]];
    
   [self resolution:message];
    
}

- (void)onScanResultUUID:(NSString *)uuid Name:(NSString *)name RSSI:(int)rssi{
    [_connectStateDelegate onScanResultUUID:uuid Name:name RSSI:rssi];
}



//-------------IMBluetoothLEDelegate---------------------------------------

//-------------模擬數據------------------------------------------------------
- (void)simulationConnect{
    [_connectStateDelegate onConnectionState:Connected];
}

- (void)simulationScan{
    [_connectStateDelegate onScanResultUUID:simulationMacArray[simulationPosition]
                                  Name:simulationNameArray[simulationPosition]
                                  RSSI:-50 + simulationPosition];
    simulationPosition++;
    if(simulationPosition >= 10){
        simulationPosition = 0;
        [self cancelTimer];
        [_connectStateDelegate onConnectionState:ScanFinish];
    }
}


- (void)cancelTimer{
    if(simulationTimer != nil){
        [simulationTimer invalidate];
        simulationTimer = nil;
    }
}
//-------------模擬數據------------------------------------------------------

- (void)resolution:(NSString *)message{
    
    message = message.uppercaseString;
    
    if([message isEqualToString:@""]){
        //for save config&macro
        //分幾個封包送，最後一個封包才會有回應，中間封包不回應
          [Function printLog:[NSString stringWithFormat:@"resolution message save config&macro continue"]];
        return;
    }
    
    if(allReceivedCommand.length > 0){
        allReceivedCommand = [[NSString alloc] initWithFormat:@"%@%@", allReceivedCommand, message];
    }else{
        allReceivedCommand = [[NSString alloc] initWithFormat:@"%@", message];
    }
    
    message = allReceivedCommand;
    
    bool headerCorrect = [self isCorrectHeader:message];
    bool endCorrect = [self isCorrectEnd:message];
    int lengthCorrect = [self getCorrectLength:message];
    
    //2016.09.13
    if(lengthCorrect == -1){
        allReceivedCommand = @"";
        return;
    }
    
    
    if(headerCorrect && endCorrect && message.length >= lengthCorrect){
        
        receiveErrorCount = 0;
        
        [Function printLog:[NSString stringWithFormat:@"Protocol Class 全部接收完 message -> %@", message]];
        
        while(allReceivedCommand.length != 0){
            
            //重新取一次message
            message = allReceivedCommand;
            //因為如果一次收到2筆Command，每次都要重新取得當筆Command的Length
            lengthCorrect = [self getCorrectLength:message];
            [Function printLog:[NSString stringWithFormat:@"Protocol Class lengthCorrect -> %i", lengthCorrect]];
            
            //2016.09.13
            if(lengthCorrect == -1){
                allReceivedCommand = @"";
                break;
            }
            
            //為了硬體Bug，正式版可以拿掉
//            int testCmd = [self hexStringToInt:[message substringWithRange:NSMakeRange(CMD_CMD_INDEX_START, 2)]];
//            if(testCmd == 0xBC){
//                lengthCorrect += 2;
//            }
            
            
            message = [allReceivedCommand substringToIndex:lengthCorrect];
            [Function printLog:[NSString stringWithFormat:@"Protocol Class message -> %@", message]];
            
            
            @try {
                //----------計算Checksum是否正確----------
                NSString *receiveChecksum = [message substringWithRange:NSMakeRange(lengthCorrect - 2, 2)];
                NSString *cmd = [message substringWithRange:NSMakeRange(0, 2)];
                NSString *len = [message substringWithRange:NSMakeRange(2, 4)];
                NSString *data = [message substringWithRange:NSMakeRange(4, lengthCorrect - 6)];
                
                
                NSString * calcChecksum = [[[NSString alloc] initWithFormat:@"%02x",
                [self computationCheckSum2:[NSString stringWithFormat:@"%@%@",cmd, data]]] uppercaseString];

                [Function printLog:[NSString stringWithFormat:@"Protocol Class receiveChecksum -> %@", receiveChecksum]];
                [Function printLog:[NSString stringWithFormat:@"Protocol Class calcChecksum -> %@", calcChecksum]];
                //----------計算Checksum是否正確----------
                
                
                //Checksum正確
                if([calcChecksum isEqualToString:receiveChecksum]){
                    
                    //因為是APP主動傳送，所以要比對Write Command
                    //如果有待發送的CMD，則比對是否跟已回傳的CMD相同，如果是，則比對是哪一個CMD，再把它刪除，代表發送成功
                    if([self getCommArrayCount] > 0){
                        
                        //發送出去的CMD, 發送是0xA?, 接收是0xB?, 所以要加0x10
                        int writeCmd = [self hexStringToInt:[[self getFirstComm] substringWithRange:NSMakeRange(CMD_CMD_INDEX_START, 2)]] ;
                        //接收到的CMD
                        int receiveCmd = [self hexStringToInt:[message substringWithRange:NSMakeRange(CMD_CMD_INDEX_START, 2)]];
                        
                        [Function printLog:[NSString stringWithFormat:@"Protocol Class writeCmd -> %02x , receiveCmd -> %02x", writeCmd, receiveCmd]];

                        
                        //比對接收到的CMD跟發送出去的CMD是否相同，如果是，就是收到剛剛發送的CMD的回覆了，刪掉發送陣列裡的CMD
                        if(writeCmd == receiveCmd) {
                            
                            [Function printLog:[NSString stringWithFormat:@"Protocol Class removeComm -> %@", [self getFirstComm]]];
                            
                            [self initSendCount];
                            [self removeComm];
                            
                            allReceivedCommand = [allReceivedCommand substringFromIndex:lengthCorrect];
                            [self handleReceived:message];
                            continue;
                        }
                    }
                    
                    //因為是硬體主動回覆，不用比對Write Command  or
                    //Write Command沒有比對到接收到的Command
                    allReceivedCommand = [allReceivedCommand substringFromIndex:lengthCorrect];
                    [self handleReceived:message];
                    
                }else{
                    //Checksum錯誤
                    [Function printLog:[NSString stringWithFormat:@"Protocol Class === Checksum錯誤 = %@", receiveChecksum]];
                    [self receiveError:message];
                }
                
                
            }
            @catch (NSException *exception) {
                NSLog(@"NSException = %@", [exception debugDescription]);
                //[self receiveError:message];
            }
        }
    }else {
        [Function printLog:[NSString stringWithFormat:@"Protocol Class 未接收完 message -> %@", message]];
        
         //預防機制
        ++receiveErrorCount;
        if(receiveErrorCount > RECEIVED_ERROR_COUNT){
            [self receiveError:message];
        }
    }
}

- (void)handleReceived:(NSString* )message{
    [Function printLog:[NSString stringWithFormat:@"Protocol Class handleReceived message -> %@", message]];
    
    bool isSuccess;
    DeviceStatus* ds;
    
    //取得接收到的CMD
    int cmd = [self hexStringToInt:[message substringWithRange:NSMakeRange(CMD_CMD_INDEX_START, 2)]];
    
    //去除  length & cmd & checksum
    NSString* data = [message substringWithRange:NSMakeRange(4, message.length - 6)];
    
    
    
    switch(cmd){
        case 0x01://check device
            isSuccess = [data isEqualToString:@"896656"];
            
            
            if(isSuccess)
                [[ProtocolDataController sharedInstance] getFWEdition];
            else
                [_connectStateDelegate onConnectionState:Disconnect];
            
            break;
        case 0x03://device status
            
             ds = [DeviceStatus parse: data];
            [_dataResponseDelegate onResponseDeviceStatus: ds];
            
            break;
        case 0x02://FW  edition
        {
            
            NSMutableString *str = [NSMutableString stringWithCapacity:100];
            
            [str appendString: data];
            [str insertString:@"." atIndex:1];
            
            fwVersion = str;
            
            [_connectStateDelegate onConnectionState:Connected];
            
           
            break;

        }
        case 0x04://save config
            [Function printLog:[NSString stringWithFormat:@"handleReceived  save config  packet  data =%@", data]];
             //新規格只回應一個封包
            if(  [data isEqualToString:@"FF"]  || [data isEqualToString:@"FE"] ) {
                 [_dataResponseDelegate onResponseSaveConfig: false];
                //onDataResponseListener.onResponseSaveConfig(false);
                break;
            }
            
           // int dataNo = [[data substringToIndex:1] intValue ];
           // int packetNo =[[data substringFromIndex:1] intValue];
            
            [_dataResponseDelegate onResponseSaveConfig: true];
            
            break;
        case 0x05://save macro
             [Function printLog:[NSString stringWithFormat:@"handleReceived  SAVE_MACRO    data  =%@", data]];
            
            //新規格只回應一個封包
            if( [data isEqualToString:@"FF"]  || [data isEqualToString:@"FE"] ) {
                [_dataResponseDelegate onResponseSaveMacro: false];
                break;
            }
          
            [_dataResponseDelegate onResponseSaveMacro: true];
            
            break;
        case 0x06://load config
            [Function printLog:[NSString stringWithFormat:@"handleReceived  LOAD_CONFIG   data =%@", data]];
            
            //new version protocol
            if([data isEqualToString:@"FF"]  || [data isEqualToString:@"FE"] ) {
                [_dataResponseDelegate onResponseLoadConfig:-1 :nil];
                break;
            }
            else
            {
                NSString* packetNum2 = [data substringToIndex: 2];
                //dataNo = Integer.parseInt(String.valueOf(packetNum2.charAt(0)));
                int dataNo = [[packetNum2 substringToIndex:1] intValue ];
                // int dataNo = [[data substringToIndex:1] intValue ];
                // int packetNo =[[data substringFromIndex:1] intValue];
                
                NSString* dataHexStr = [data substringFromIndex:2];
                
                FPSConfigData* cd  = [[FPSConfigData alloc ] init];
                [cd  initParam];
                
                if([cd isAll_FF:dataHexStr])
                {
                    
                    //not save data, or deleted data
                     [_dataResponseDelegate onResponseLoadConfig:dataNo:nil];
                    
                }else
                {
                    NSString* hexStr = dataHexStr;
                    [cd importHexString:hexStr];
                    [_dataResponseDelegate onResponseLoadConfig:dataNo  :cd];
 
                }
            }
            
            break;
            
        case 0x07:// load macro
            
            [Function printLog:[NSString stringWithFormat:@"handleReceived  load macro data: %@", data]];
            
            //new version protocol
            if([data isEqualToString:  @"FF"] || [data isEqualToString: @"FE"] ) {
                 [_dataResponseDelegate onResponseLoadMacro:-1 :nil];
                 
                break;
                
            }
            else
            {
                NSString*  packetNum2 =[data substringToIndex:2];
         
                int macroNo = [[packetNum2 substringToIndex:1] intValue ];
                
                
                NSString* dataHexStr = [data substringFromIndex:2];
                
                FPSMacroData* md  =[[FPSMacroData alloc] init ];
                [md initParam];
                
                if([md isAll_FF:dataHexStr])
                {

                    //not save data, or deleted data
                    [_dataResponseDelegate onResponseLoadMacro:macroNo :nil];

                    
                }
                else
                {
                    NSString* hexStr = dataHexStr;
                    [md importHexString:hexStr];
                    [_dataResponseDelegate onResponseLoadMacro:macroNo :md];
                    
                }
                
            }
            
            break;
            
            
        case 0x0A://move config
        {
            [Function printLog:[NSString stringWithFormat:@"handleReceived  move config  data  =%@", data]];
            
            if([data isEqualToString:  @"FF"] || [data isEqualToString: @"FE"] ) {
                [_dataResponseDelegate onResponseMoveConfig:false];
                
                break;
            }
            else{
                
                [_dataResponseDelegate onResponseMoveConfig:true ];
                
            }
            break;
            
        }
            
        case 0x0B://del config
        {
            [Function printLog:[NSString stringWithFormat:@"handleReceived  del config  data  =%@", data]];
            
             int  no =  [self hexStringToInt:data];
            
            
            if([data isEqualToString:  @"FF"] || [data isEqualToString: @"FE"] ) {
                [_dataResponseDelegate onResponseDelConfig:false :-1];
                
                break;
            }
            else{
                [_dataResponseDelegate onResponseDelConfig:true : no];
                
            }
            break;
        }
            
            
            
        case 0x0C://  move macro
        {
            [Function printLog:[NSString stringWithFormat:@"handleReceived  move macro  data  =%@", data]];
            
            if([data isEqualToString:  @"FF"] || [data isEqualToString: @"FE"] ) {
                [_dataResponseDelegate onResponseMoveMacro:false];
                
                break;
            }
            else{
                
                [_dataResponseDelegate onResponseMoveMacro:true ];
                
            }
            break;
        }
            
        case 0x0D://del macro
        {
            [Function printLog:[NSString stringWithFormat:@"handleReceived  del macro  data  =%@", data]];
            
            
            int  no =  [self hexStringToInt:data];
            
            
            if([data isEqualToString:  @"FF"] || [data isEqualToString: @"FE"] ) {
                [_dataResponseDelegate onResponseDelMacro:false :-1];
                
                break;
            }
            else{
                
                [_dataResponseDelegate onResponseDelMacro: true : no];
                
            }
            break;
        }
   
            
            
        case 0x08://response mode
        {
            int  keyCode =  [self hexStringToInt:data];
           
            if(keyCode == 0xFF){
                keyCode = -1;
            }
            
            NSLog(@"Protocol-----_dataResponseDelegate = %@", _dataResponseDelegate);
            [_dataResponseDelegate onResponseResponseMode:keyCode ];
            
            break;
            
        }
        case 0x09://live mode
            
            if([data isEqualToString:  @"FF"] || [data isEqualToString: @"FE"] ) {
                //onDataResponseListener.onResponseLiveMode(false);
                [_dataResponseDelegate onResponseLiveMode:false ];

                break;
            }
            //onDataResponseListener.onResponseLiveMode(true);
            [_dataResponseDelegate onResponseLiveMode:true ];

             break;
            
        case 0x0E:{ //MacroConfigFunctionSet
            int keycode =  [self hexStringToInt:data];
            [Function printLog:[NSString stringWithFormat:@"handleReceived  keycode = %d", keycode]];

//            if(keycode == 0xFF)
//            {
//                [_dataResponseDelegate onResponseMacroConfigFunctionSet:false ];
//                return;
//            }
            
            [_dataResponseDelegate onResponseMacroConfigFunctionSet:true ];
            
            
            break;
        }
        case 0x10:{ //fw update     device 回報已清除至那個page
            int pageNum =  [self hexStringToInt:data]; 
            
            [_dataResponseDelegate onResponseFWUpdateResult: pageTotalNum  :pageNum ];
 
            break;
        }
        case 0x11:{//fw update2
         
            
            int responseCode = [self hexStringToInt:[data substringToIndex:4]];
 
 
            if( responseCode  == 0x01 ) // save ok
            {
                //[self setFrequency:FREQUESCY_SHORT];
                //[self commTimerStart];
                [_dataResponseDelegate onResponseFWUpdateResult2: true ];
 
            }
            else
            {
                FWReSendCount++;
                
                if(FWErrPacketNO >= responseCode)
                {
                    
                    [FWAllErrPacketNoStr appendString:@", "];
                    [FWAllErrPacketNoStr appendFormat:@"%d", responseCode];
                    
                    [Function printLog:[NSString stringWithFormat:@"handleReceived  FWAllErrPacketNoStr = %@", FWAllErrPacketNoStr]];
                    
                }
                else
                {
 
                    [FWAllErrPacketNoStr appendString:@", "];
                    [FWAllErrPacketNoStr appendFormat:@"%d", responseCode];
                    
                    [Function printLog:[NSString stringWithFormat:@"handleReceived  FWAllErrPacketNoStr = %@", FWAllErrPacketNoStr]];
                    
                     FWErrPacketNO = responseCode;
                    
                    if( FWReSendCount < 10000)
                    {
                       [self removeAllComm];
                        for (int i = responseCode; i <  [cmdStrArr count]; i++) {
                            [self updateFWPacket:i :[cmdStrArr objectAtIndex:i]];
                        }
                        
                    }
                }
              
                
            }
            
            
            break;
        }
            
         default:
            [self receiveError:message];
            return;//break;
    }
    receiveErrorCount = 0;
    
}

- (bool)isCorrectHeader:(NSString *)message{
    bool hasHeader = ![[self getHeader] isEqualToString:@"-1"];
    bool isCorrect = [message hasPrefix:[self getHeader]];
    if(hasHeader){
        if(isCorrect)
            return true;
        else
            return false;
    }else
        return true;
}

- (bool)isCorrectEnd:(NSString *)message{
    bool hasEnd = ![[self getEnd] isEqualToString:@"-1"];
    bool isCorrect = [message hasSuffix:[self getEnd]];
    if(hasEnd){
        if(isCorrect)
            return true;
        else
            return false;
    }else
        return true;
}

- (int)getCorrectLength:(NSString *)message{
    
    //2016.09.13
    int totalLength = -1;
    
    if(CMD_LENGTH_INDEX_START + 2 < message.length){
        int length = [self hexStringToInt:[message substringWithRange:NSMakeRange(CMD_LENGTH_INDEX_START, 2)]];
        //  & Length &
        
        if(length == 0)
            return totalLength;
        
        totalLength = (2 + length) * 2;
        
        [Function printLog:[NSString stringWithFormat:@"Protocol Class dataResult totalLength -> %i", totalLength]];
    }
    
    return totalLength;
}

- (void)receiveError:(NSString *)message{
    [Function printLog:[NSString stringWithFormat:@"Protocol Class 接收錯誤 message -> %@", message]];
    [Function printLog:[NSString stringWithFormat:@"Protocol Class receiveErrorCount -> %d", receiveErrorCount ]];
    
    ++receiveErrorCount;
    int allLength = allReceivedCommand.length;
    
    //預防一堆錯誤訊息一直累積，RECEIVED_ERROR_COUNT數值待確認，因為可能有很多筆資料會一次傳回來
    if(receiveErrorCount > RECEIVED_ERROR_COUNT){
        receiveErrorCount = 0;
        //接收錯誤超過次數，代表都是錯的，刪除所有CMD
        allReceivedCommand = @"";
    }else{
        //預設是刪到CMD下一個Header的地方
        NSString *headerIndexStr = [[NSString alloc] initWithFormat:@"%@%@", [self getEnd], [self getHeader]];
        unsigned long headerIndex = [message rangeOfString:headerIndexStr].location;
        
        allReceivedCommand = [allReceivedCommand substringToIndex:headerIndex == NSNotFound ? allLength : headerIndex + 2];
    }
    [Function printLog:[NSString stringWithFormat:@"Protocol Class 接收錯誤 allReceivedCommand -> %@", allReceivedCommand]];
    
    
//    
//    [Function printLog:[NSString stringWithFormat:@"Protocol Class 接收錯誤 message -> %@", message]];
//    
//    unsigned long errorIndex = [errorMsg rangeOfString:[self getHeader]].location;
//    [Function printLog:[NSString stringWithFormat:@"Protocol Class 接收錯誤 errorIndex -> %lu", errorIndex]];
//    
//    if(errorIndex == NSNotFound){
//        allReceivedCommand = @"";
//    }else{
//        allReceivedCommand = [allReceivedCommand substringToIndex:errorIndex];
//    }
//    [Function printLog:[NSString stringWithFormat:@"Protocol Class 接收錯誤 allReceivedCommand -> %@", allReceivedCommand]];
    
    //測試時註解
    //		++receiveErrorCount;
    //		CustomVariable.printLog("e", TAG, "dataResult  receiveErrorCount = " + receiveErrorCount);
    //		if(receiveErrorCount > RECEIVED_ERROR_COUNT){
    //			CustomVariable.printLog("e", TAG, "接收錯誤 = " + message + " 斷線!");
    //			receiveErrorCount = 0;
    //			myBluetooth.disconnect(BluetoothLEClass.DISCONNECTED);
    //		}
}

- (int)hexStringToInt:(NSString *)hexString{
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
//    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&result];
    return result;
}

- (NSString *) hexStringToAscii:(NSString *)hexString{
    NSMutableString * newString = [[NSMutableString alloc] init];
    int i = 0;
    unsigned long length = [hexString length];
    
    while (i < length){
        NSString * hexChar = [hexString substringWithRange: NSMakeRange(i, 2)];
        int value = 0;
        sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        [newString appendFormat:@"%c", (char)value];
        i+=2;
    }
    return newString;
}

- (NSString *) getIntToHexString:(int)i Digit:(int)digit{
    NSString *hexString = [[NSString alloc] initWithFormat:@"%x", i];
    
    while(hexString.length < digit)
        hexString = [[NSString alloc] initWithFormat:@"0%@", hexString];
    
    return hexString;
}

- (NSString*)convertHexToBinary:(NSString*)hexString {
    
    NSMutableString *returnString = [NSMutableString string];
    for(int i = 0; i < [hexString length]; i++) {
        char c = [[hexString lowercaseString] characterAtIndex:i];
        switch(c) {
            case '0':
                [returnString appendString:@"0000"];
                break;
            case '1':
                [returnString appendString:@"0001"];
                break;
            case '2':
                [returnString appendString:@"0010"];
                break;
            case '3':
                [returnString appendString:@"0011"];
                break;
            case '4':
                [returnString appendString:@"0100"];
                break;
            case '5':
                [returnString appendString:@"0101"];
                break;
            case '6':
                [returnString appendString:@"0110"];
                break;
            case '7':
                [returnString appendString:@"0111"];
                break;
            case '8':
                [returnString appendString:@"1000"];
                break;
            case '9':
                [returnString appendString:@"1001"];
                break;
            case 'a':
                [returnString appendString:@"1010"];
                break;
            case 'b':
                [returnString appendString:@"1011"];
                break;
            case 'c':
                [returnString appendString:@"1100"];
                break;
            case 'd':
                [returnString appendString:@"1101"];
                break;
            case 'e':
                [returnString appendString:@"1110"];
                break;
            case 'f':
                [returnString appendString:@"1111"];
                break;
            default :
                break;
        }
    }
    return returnString;
}

@end
