//
//  FSCloudClass.h
//  FuelSation
//
//  Created by Tom on 2016/7/11.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#define kAPIKey  @"59Df369nV9476Sad"

#define kAPI_register           @"/APi/register"
#define kAPI_login              @"/APi/login"
#define KAPI_sendPushToken      @"/APi/sendPushToken"
#define kAPI_commlogin          @"/APi/commlogin"
#define kAPI_uploaduserprofile  @"/APi/uploaduserprofile"
#define kAPI_changestatus       @"/APi/changestatus"
#define kAPI_syncconfiglist     @"/APi/syncconfiglist"
#define kAPI_syncpconfiglist    @"/APi/syncpconfiglist"
#define kAPI_forgetpwd          @"/APi/forgetpwd"
#define KAPI_chkversion         @"/APi/chkversion"
#define KAPI_chkfirmkware       @"/APi/chkfirmkware"
#define KAPI_delUserProfile     @"/APi/deluserprofile"
#define KAPI_elitegamelist      @"/APi/elitegamelist"
#define KAPI_syncelite          @"/APi/syncelite"


typedef enum
{
    CloudAPIEvent_register,             //APi/register
    CloudAPIEvent_login,                //APi/login
    CloudAPIEvent_sendPushToken,        //APi/sendPushToken
    CloudAPIEvent_commlogin,            //APi/commlogin
    CloudAPIEvent_uploaduserprofile,    //APi/uploaduserprofile
    CloudAPIEvent_changestatus,         //APi/changestatus
    CloudAPIEvent_syncconfiglist,       //APi/syncconfiglist
    CloudAPIEvent_syncpconfiglist,      //APi/syncpconfiglist
    CloudAPIEvent_forgetpwd,            //APi/forgetpwd
    CloudAPIEvent_chkversion,           //APi/chkversion
    CloudAPIEvent_chkfirmkware,         //APi/chkfirmkware
    CloudAPIEvent_delUserProfile,       //APi/delUserProfile
    CloudAPIEvent_elitegamelist,        //APi/elitegamelist
    CloudAPIEvent_syncelite             //APi/syncelite
    
}CloudAPIEventId;


@protocol FPCloudClassDelegate<NSObject>

-(void)networkError;

- (void)FPCloudResponseData:(NSURLResponse *)response Data:(NSData *)data Error:(NSError *)error EventId:(int)eventid;

@end


@interface FPCloudClass : NSObject
{
    AppDelegate *appDelegate;
    
    NSString *ServerURL;
}

@property(nonatomic,strong)id <FPCloudClassDelegate> delegate;

-(id)init;

//非同步
-(void)postDataAsync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid;

//非同步相片
-(void)postDataAsync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid withImage:(UIImage *)image withFile:(NSString*)filePath;


//立即同步
-(void)postDataSync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid;

//立即同步相片
-(void)postDataSync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid withImage:(UIImage *)image withFile:(NSString*)filePath;


@end
