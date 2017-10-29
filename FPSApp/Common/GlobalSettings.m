//////////////////////////////////////////////////////////////////////////////////////
// File Name		:	SFActiveSettings.m
// Description		:	SFActiveSettings class implementation.
// Author			:	ZCO Engineering Dept.
// Copyright		:	Copyright 2011 SpiritFitness.  All rights reserved.
// Version History	:	1.0
//////////////////////////////////////////////////////////////////////////////////////

#import "GlobalSettings.h"
#import "AppDelegate.h"

@implementation GlobalSettings


static GlobalSettings *globalSettings = nil;

+ (GlobalSettings *)globalSettings
{
    @synchronized(self)
    {
        if (globalSettings == nil)
        {
            [[self alloc] init];
            
            //language default en
            globalSettings.curLanguageName=@"Base";
            
            //AppDelegate
            globalSettings.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            
            globalSettings.chanelNameArr=[NSMutableArray arrayWithObjects:@"Best for Marathon",@"A 10K Run",@"Push for 120K Biking",@"Relax",@"Hatha Yoga",@"Work Music",@"1KSkiing",@"Downhill",@"Triathlon", nil];
            
            globalSettings.activityNameArr=[NSMutableArray arrayWithObjects:@"Running",@"Running",@"Biking",@"Relax",@"Yoga",@"Office",@"Skiing",@"Skiing",@"HIIT", nil];
            
            globalSettings.chanelImageArr=[NSMutableArray arrayWithObjects:@"FP_Ch0",@"FP_Ch1",@"FP_Ch2",@"FP_Ch3",@"FP_Ch4",@"FP_Ch5",@"FP_Ch6",@"FP_Ch7",@"FP_Ch8", nil];
        }
    }
    
    return globalSettings;
}


+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (globalSettings == nil)
        {
            globalSettings = [super allocWithZone:zone];
            return globalSettings;
        }
    }
    return nil;
}


@end
