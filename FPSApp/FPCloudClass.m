//
//  FSCloudClass.m
//  FuelSation
//
//  Created by Tom on 2016/7/11.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "FPCloudClass.h"
#import "CheckNetwork.h"

@implementation FPCloudClass

-(id)init
{
    self=[super init];
    
    if(self)
    {
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        ServerURL= @"http://www.brookaccessory.com";
    }
    
    return self;
}

//未模組化>>>>>

//非同步
-(void)postDataAsync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid
{
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        [self.delegate networkError];
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",ServerURL,apiName];
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"----------%lld",arc4random()%10000000000];
    
    NSURL* requestURL = [NSURL URLWithString:url];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in postDict) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDict objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [request setURL:requestURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        //test
#ifdef DEBUG
        NSString *responseData = [[NSString alloc]initWithData: data
                                                      encoding: NSUTF8StringEncoding
                                  ];
        NSLog(@"Response = %@", responseData);
        
#endif
        
        
        [self.delegate FPCloudResponseData:response Data:data Error:error  EventId:eventid];
        
    }];

}


//非同步相片
-(void)postDataAsync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid withImage:(UIImage *)image withFile:(NSString*)filePath
{
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        [self.delegate networkError];
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",ServerURL,apiName];
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"----------%lld",arc4random()%10000000000];
    
    NSURL* requestURL = [NSURL URLWithString:url];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in postDict) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDict objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //圖片
    [UIImage imageWithCGImage:[image  CGImage]
                        scale:[image scale]
                  orientation: UIImageOrientationUp];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@\"\r\n",@"123"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    //文字檔
    NSError *txtError;
    
    NSData *txtData = [NSData dataWithContentsOfFile:filePath
                                             options:NSDataReadingMappedIfSafe error:&txtError];
    if (txtData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filename\"; filename=\"%@\"\r\n",@"occcccc"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:txtData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [request setURL:requestURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        //test
#ifdef DEBUG
        NSString *responseData = [[NSString alloc]initWithData: data
                                                      encoding: NSUTF8StringEncoding
                                  ];
        NSLog(@"Response = %@", responseData);
        
#endif
        
        
        [self.delegate FPCloudResponseData:response Data:data Error:error  EventId:eventid];
        
    }];
    
}




//立即同步
-(void)postDataSync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid
{
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        [self.delegate networkError];
        
        return;
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",ServerURL,apiName];
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"----------%lld",arc4random()%10000000000];
    
    NSURL* requestURL = [NSURL URLWithString:url];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in postDict) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDict objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [request setURL:requestURL];
    
    NSError *error;
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection
                    sendSynchronousRequest: request
                    returningResponse: &response
                    error: &error
                    ];
    

    //test
#ifdef DEBUG
    NSString *responseData = [[NSString alloc]initWithData: data
                                                  encoding: NSUTF8StringEncoding
                              ];
    NSLog(@"Response = %@", responseData);
    
#endif
    
    
    [self.delegate FPCloudResponseData:response Data:data Error:error  EventId:eventid];
    
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}


//立即同步相片
-(void)postDataSync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid withImage:(UIImage *)image withFile:(NSString*)filePath
{
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        [self.delegate networkError];
        
        return;
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",ServerURL,apiName];
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"----------%lld",arc4random()%10000000000];
    
    NSURL* requestURL = [NSURL URLWithString:url];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in postDict) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDict objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    //圖片
    [UIImage imageWithCGImage:[image  CGImage]
                        scale:[image scale]
                  orientation: UIImageOrientationUp];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@\"\r\n",@"123"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
   
    //文字檔
    NSError *txtError;
    
    NSData *txtData = [NSData dataWithContentsOfFile:filePath
                                             options:NSDataReadingMappedIfSafe error:&txtError];
    if (txtData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filename\"; filename=\"%@\"\r\n",@"occcccc"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:txtData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [request setURL:requestURL];
    
    NSError *error;
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection
                    sendSynchronousRequest: request
                    returningResponse: &response
                    error: &error
                    ];
    
    
    //test
#ifdef DEBUG
    NSString *responseData = [[NSString alloc]initWithData: data
                                                  encoding: NSUTF8StringEncoding
                              ];
    NSLog(@"Response = %@", responseData);
    
#endif
    
    
    [self.delegate FPCloudResponseData:response Data:data Error:error  EventId:eventid];
    
}

//<<<<<


@end
