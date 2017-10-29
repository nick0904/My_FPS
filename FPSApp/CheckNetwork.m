//
//  CheckNetwork.m
//  IOTCamViewer
//
//  Created by tutk on 6/5/12.
//  Copyright (c) 2012 TUTK. All rights reserved.
//

#import "CheckNetwork.h"
#import "Reachability.h"

@implementation CheckNetwork

+(BOOL)pingServer
{
    NSURL *url = [NSURL URLWithString:@"http://push.iotcplatform.com"];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response error:NULL];
    return (response != nil);
}

+(BOOL)isExistenceNetwork
{
	BOOL isExistenceNetwork = FALSE;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    if (r == nil) {
        return FALSE;
    }
    
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork=FALSE;
            break;
        case ReachableViaWWAN:
			isExistenceNetwork=TRUE;
            break;
        case ReachableViaWiFi:{
//  此段程式碼為用 VSaaS API的 get token 來驗證網路狀態
            /*
            NSURLResponse* urlResponse;
            NSError* error;
            NSString *urlStr = [NSString stringWithFormat:@"%@/token-auth",BASEURL];
            NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
            [urlRequest setHTTPMethod:@"POST"];
            NSData* data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
 
 
//            NSURLResponse* urlResponse;
//            NSError* error;
//            NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3];
//            NSData* data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
            
            NSLog(@"test internet result %@",data);
            if (data) {
                isExistenceNetwork=TRUE;
            }else isExistenceNetwork=FALSE;
			*/
            
            isExistenceNetwork=TRUE;
            
            break;
             }
    }
    
	return isExistenceNetwork;
}
@end