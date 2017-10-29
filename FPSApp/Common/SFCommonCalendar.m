//////////////////////////////////////////////////////////////////////////////////////
// File Name		:	SFCommonCalendar.m
// Description		:	SFCommonCalendar class implementation.
// Author			:	ZCO Engineering Dept.
// Copyright		:	Copyright 2011 SpiritFitness.  All rights reserved.
// Version History	:	1.0
//////////////////////////////////////////////////////////////////////////////////////

#import "SFCommonCalendar.h"

static SFCommonCalendar *sharedInstance = nil;

static int selectedCalendar;
static int year;
static int month;
static int week;
static int day;
static int dayNumber;

@implementation SFCommonCalendar

+ (SFCommonCalendar*)sharedInstance
{
    if(nil == sharedInstance)
    {
        sharedInstance = [[SFCommonCalendar alloc] init];
    }
    return sharedInstance;
}

+ (void)parseDateStringAsNumberFormat:(NSString*)dateString month:(NSString**)month day:(NSString**)day year:(NSString**)year
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
	NSDate *dateObj = [dateFormatter dateFromString:dateString];

	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dateObj];
	*year           = [NSString stringWithFormat:@"%d", [dateComponents year]];
	*month          = [NSString stringWithFormat:@"%d", [dateComponents month]];
 	*day            = [NSString stringWithFormat:@"%d", [dateComponents day]];
}

+ (void)setSelectedCalendar:(int)value
{
    selectedCalendar=value;
}

+ (int)getSelectedCalendar
{
    return selectedCalendar;
}

+ (void)setDay:(int)value
{
    day=value;
}

+ (int)getDay
{
    return day;
}

+ (void)setWeek:(int)value
{
    week=value;
}

+ (int)getWeek
{
    return week;
}

+ (void)setMonth:(int)value
{
    month=value;
}

+ (int)getMonth
{
    return month;
}

+ (void)setYear:(int)value
{
    year=value;
}

+ (int)getYear
{
    return year;
}

+ (void)setDayNumber:(int)value
{
    dayNumber=value;
}

+ (int)getDayNumber
{
    return dayNumber;
}

+ (NSDate *) createNSDateFrom:(NSInteger) day fromMonth:(NSInteger)month fromYear:(NSInteger)year
{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    NSDate *thisDate = [gregorian dateFromComponents:components];


    return thisDate;
}

+ (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    formatter.dateFormat        = @"MM/dd/yyyy";
    NSDate *date                = [formatter dateFromString:string];

    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    formatter.dateFormat        = @"MM/dd/yyyy";
    NSString *string            = [formatter stringFromDate:date];

    return string;
}

+ (NSString *)DateToStringByFormate:(NSDate *)date formate:(NSString*)formate
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    formatter.dateFormat        = formate;
    NSString *string            = [formatter stringFromDate:date];
    
    return string;
}

+ (NSString *)stringWithDayFromDate:(NSDate *)date
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    formatter.dateFormat        = @"EEE MM/dd/yyyy";
    NSString *string            = [formatter stringFromDate:date];

    return string;
}

+ (NSString *)dateToTime:(NSDate *)date
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    formatter.dateFormat        = @"hh:mm";
    NSString *string            = [formatter stringFromDate:date];

    return string;
}

+ (NSString *)dayFromDate:(NSDate *)date
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    formatter.dateFormat        = @"dd";
    NSString *string            = [formatter stringFromDate:date];

    return string;
}



+ (NSDate *)getDayStartForDate:(NSDate *)aDate
{
    NSCalendar *gregorian               = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents    = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit fromDate:aDate];
    dateComponents.hour     = 0;
    dateComponents.minute   = 0;
    dateComponents.second   = 0;
    aDate                               = [gregorian dateFromComponents:dateComponents];

    return aDate;
}

+ (NSDate *)getDayEndForDate:(NSDate *)aDate
{
    NSCalendar *gregorian               = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents    = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit fromDate:aDate];
    dateComponents.hour     = 23;
    dateComponents.minute   = 59;
    dateComponents.second   = 59;
    aDate                               = [gregorian dateFromComponents:dateComponents];

    return aDate;
}

+ (NSDate *)getWeekStartForDate:(NSDate *)aDate
{
    aDate = [SFCommonCalendar getDayStartForDate:aDate];
    NSCalendar *gregorian               = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger   weekDay                 = 1;
    NSInteger   weekOfMonth             = 1;
    NSDateComponents *dateComponents    = [gregorian components:NSWeekOfMonthCalendarUnit| NSWeekdayCalendarUnit fromDate:aDate];
    weekDay                             = dateComponents.weekday;
    weekOfMonth                         = dateComponents.weekOfMonth;
    
    if (weekOfMonth == 1)
    {
        aDate   = [self getMonthStartForDate:aDate];
    }
    else
    {
        dateComponents                      = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit fromDate:aDate];
        dateComponents.day                  = dateComponents.day - (weekDay - 1);
        aDate                               = [gregorian dateFromComponents:dateComponents];
    }

    return aDate;
}

+ (NSDate *)getWeekEndForDate:(NSDate *)aDate
{
    aDate = [SFCommonCalendar getDayStartForDate:aDate];
    NSCalendar *gregorian               = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger   weekDay                 = 1;
    NSInteger   weekOfMonth             = 1;
    NSDateComponents *dateComponents    = [gregorian components:NSWeekOfMonthCalendarUnit| NSWeekdayCalendarUnit fromDate:aDate];
    weekDay                             = dateComponents.weekday;
    weekOfMonth                         = dateComponents.weekOfMonth;
    NSRange range                       = [gregorian rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:aDate];
    
    if (weekOfMonth == range.length)
    {
        aDate   = [self getMonthEndForDate:aDate];
    }
    else
    {
        dateComponents                      = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit fromDate:aDate];
        dateComponents.day                  = dateComponents.day + (7 - weekDay);
        aDate                               = [gregorian dateFromComponents:dateComponents];
    }

    return aDate;
}


+ (NSDate *)getMonthStartForDate:(NSDate *)aDate
{
    NSCalendar *gregorian               = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents    = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit fromDate:aDate];
    dateComponents.day  = 1;
    aDate               = [gregorian dateFromComponents:dateComponents];

    return aDate;
}

+ (NSDate *)getMonthEndForDate:(NSDate *)aDate
{
    NSCalendar *gregorian               = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents    = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit fromDate:aDate];
    NSRange range       = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:aDate];
    dateComponents.day  = range.length;
    aDate               = [gregorian dateFromComponents:dateComponents];

    return aDate;
}

+ (NSDate *)getYearStartForDate:(NSDate *)aDate
{
    NSCalendar *gregorian               = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents    = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit fromDate:aDate];
    dateComponents.month    = 1;
    dateComponents.day      = 1;
    aDate                   = [gregorian dateFromComponents:dateComponents];

    return aDate;
}

+ (NSDate *)getYearEndForDate:(NSDate *)aDate
{
    NSCalendar *gregorian               = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents    = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit fromDate:aDate];
    dateComponents.month    = 12;
    dateComponents.day      = 31;
    aDate                   = [gregorian dateFromComponents:dateComponents];

    return aDate;
}


+ (NSInteger)findFirstDayOfMonth:(NSInteger)month year:(NSInteger)year
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    NSString *stringDate = [NSString stringWithFormat:@"%d-%d-1",year, month];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *tmpdate = [inputFormatter dateFromString:stringDate];
    [inputFormatter setDateFormat:@"e"];
    NSString *returnString = [inputFormatter stringFromDate:tmpdate];
    
    return [returnString intValue] - 1;// Make 0 based
}

+ (NSUInteger)findMonthDaysCount:(NSInteger)month year:(NSInteger)year
{
    NSDateFormatter *dassinputFormatter = [[NSDateFormatter alloc] init];
    NSString *stringDate    = [NSString stringWithFormat:@"%d-%d-1",(int)year, (int)month];
    [dassinputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *aday            = [dassinputFormatter dateFromString:stringDate];
    NSCalendar *calendar    = [NSCalendar currentCalendar];
    NSRange days            = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:aday];
    
    return days.length;
}

@end
