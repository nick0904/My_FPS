
#import "Function.h"

@implementation Function

//@synthesize isPrintLog;
static BOOL isPrintLog = false;

#pragma mark - Math
//十六進位字串轉bytes
+ (NSData *) hexStrToNSData:(NSString *)hexStr{
    
    NSMutableData* data = [NSMutableData data];
    
    int idx;
    
    for (idx = 0; idx+2 <= hexStr.length; idx+=2) {
        
        NSRange range = NSMakeRange(idx, 2);
        
        NSString* ch = [hexStr substringWithRange:range];
        
        NSScanner* scanner = [NSScanner scannerWithString:ch];
        
        unsigned int intValue;
        
        [scanner scanHexInt:&intValue];
        
        [data appendBytes:&intValue length:1];
        
    }
    return data;
}

+ (int)hexStringToInt:(NSString *)hexString{
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    //    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&result];
    //    [Function printLog:[NSString stringWithFormat:@"SoleProtocol hexStringToInt  -> %i", result]];
    //    [Function printLog:[NSString stringWithFormat:@"SoleProtocol hexStringToInt  -> %x", result]];
    return result;
}

// 字串轉十六進制(轉換字串: string): int
+ (int)stringToHex:(NSString *)string{
    
    int nValue = 0;
    for (int i = 0; i < [string length]; i++)
    {
        int nLetterValue ;  //針對數字0〜9，A〜F
        switch ([string characterAtIndex:i])
        {
            case 'a':case 'A':
                nLetterValue = 10;
                break;
            case 'b':case 'B':
                nLetterValue = 11;
                break;
            case 'c': case 'C':
                nLetterValue = 12;
                break;
            case 'd':case 'D':
                nLetterValue = 13;
                break;
            case 'e': case 'E':
                nLetterValue = 14;
                break;
            case 'f': case 'F':
                nLetterValue = 15;
                break;
            default:
                nLetterValue = [string characterAtIndex:i] - '0';
                break;
                
        }
        nValue = nValue * 16 + nLetterValue; //16進制
    }
    
    return nValue;
}

//+ (MySingleton *) instance
//{
//    // Persistent instance.
//    static MySingleton *_default = nil;
//    if (_default == nil)
//    {
//        _default = [[MySingleton alloc] init];
//    }
//    return _default;
//}

+ (void)setPrintLog:(BOOL)printLog{
    isPrintLog = printLog;
}

+ (void)printLog:(NSString *)log{
    if(isPrintLog)
        NSLog(@"%@", log);
}

+ (int)getIntFromHexString:(NSString *)hexString ScanLocation:(int)scanLocation{
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    //unsigned = 正數 0 ~ 4,294,967,295
    unsigned int decimal = 0;
    [scanner setScanLocation:scanLocation]; // 從第幾個開始
    //& = 變數的位置 , * = 取得指標變數所指向的內容。
    [scanner scanHexInt:&decimal];
    return decimal;
}

+ (NSString *)getCurrentDateTimeWeek{
    //現在時間
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    //時間格式
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    //星期
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    long week = [components weekday] - 1;
    
    NSString *dateTimeWeek = [NSString stringWithFormat:@"%@-%li", [dateFormat stringFromDate:currentDate], week];
    return dateTimeWeek;
}

+ (long)getDayOfMonth{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
    
    long dayOfMonth = range.length;
    return dayOfMonth;
}


//Nick
+(NSData *)dataFromHexString:(NSString *)originalHexString
{
    NSString *hexString = [originalHexString stringByReplacingOccurrencesOfString:@"[ <>]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [originalHexString length])]; // strip out spaces (between every four bytes), "<" (at the start) and ">" (at the end)
    NSMutableData *data = [NSMutableData dataWithCapacity:[hexString length] / 2];
    for (NSInteger i = 0; i < [hexString length]; i += 2)
    {
        NSString *hexChar = [hexString substringWithRange: NSMakeRange(i, 2)];
        int value;
        sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        uint8_t byte = value;
        [data appendBytes:&byte length:1];
    }
    
    return data;
}

//Nick
+(NSString *)hexStringFromString:(NSString *)string {
    
    NSData *myData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    Byte *bytes = (Byte *)[myData bytes];
    
    //下面是Byte 转换为16进制
    
    NSString *hexStr=@"";
    
    for(int i=0;i<[myData length];i++) {
        
       NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];//16进制
        
        if([newHexStr length]==1) {
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else {
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
        
    }
    
    return hexStr;
}


//NICK
//----------------------------------
+(NSData *)hexToBytes:(NSString *)str {
    
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    
    return data;
}


//將10進制 int 轉16進制
+(NSString *)ToHex:(int)tmpid {
    
    NSString *nLetterValue;
    NSString *str =@"";
    int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        
        switch (ttmpig) {
                
            case 10:
                nLetterValue =@"A";
                break;
            case 11:
                nLetterValue =@"B";
                break;
            case 12:
                nLetterValue =@"C";
                break;
            case 13:
                nLetterValue =@"D";
                break;
            case 14:
                nLetterValue =@"E";
                break;
            case 15:
                nLetterValue =@"F";
                break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        
        str = [nLetterValue stringByAppendingString:str];
        
        if (tmpid == 0) {
            break;
        }
        
    }
    //不夠一節揍0
    if(str.length == 1) {
        
        return [NSString stringWithFormat:@"0%@",str];
    }
    else {
        
        return str;
    }
    
}




////2016/10/5 Nick
//+(NSString *)encodeToPercentEscapeString:(NSString *)input {
//    
//    // Encode all the reserved characters, per RFC 3986
//    
////    NSString *outputStr = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)input,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
//    
//    
//    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)input, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
//    
//    
//    return outputStr;
//    
//
//}

+(NSString *)configNameToHex:(NSString *)configName {
    
    NSMutableString* configNameHexStr = [[NSMutableString alloc] init];
    
    int len = [configName length];
    
    for (int i = 0; i < 20; i++) {
        
        if(i < len){
            
            int ch = [configName characterAtIndex:i];

            [configNameHexStr appendString:[NSString stringWithFormat: @"%04X", ch]];
        }
        else{
            
            [configNameHexStr appendString: [NSString stringWithFormat: @"FFFF"]];
        }
        
        [configNameHexStr appendString:[NSString stringWithFormat:@","]];
    }

    //最後一節多一個 "," 要刪掉
     NSString *finalHexStr = (NSString *)[configNameHexStr substringToIndex:configNameHexStr.length-1];
    
    
    return finalHexStr;
}


@end
