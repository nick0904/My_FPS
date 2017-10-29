//////////////////////////////////////////////////////////////////////////////////////
// File Name		:	SFCommonCalendar.h
// Description		:	SFCommonCalendar class declaration.
// Author			:	ZCO Engineering Dept.
// Copyright		:	Copyright 2011 SpiritFitness.  All rights reserved.
// Version History	:	1.0
//////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface SFCommonCalendar : NSObject
{
   
}
+ (void)parseDateStringAsNumberFormat:(NSString*)dateString month:(NSString**)month day:(NSString**)day year:(NSString**)year;
+ (void)setSelectedCalendar:(int)value;
+ (int)getSelectedCalendar;
+ (void)setDay:(int)value;
+ (int)getDay;
+ (void)setWeek:(int)value;
+ (int)getWeek;
+ (void)setMonth:(int)value;
+ (int)getMonth;
+ (void)setYear:(int)value;
+ (int)getYear;
+ (void)setDayNumber:(int)value;
+ (int)getDayNumber;
+ (NSString *)dayFromDate:(NSDate *)date;
+ (NSDate *) createNSDateFrom:(NSInteger) day fromMonth:(NSInteger)month fromYear:(NSInteger)year;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringWithDayFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;

+ (NSString *)DateToStringByFormate:(NSDate *)date formate:(NSString*)formate;

+ (NSString *)dateToTime:(NSDate *)date;


+ (NSDate *)getDayStartForDate:(NSDate *)aDate;
+ (NSDate *)getDayEndForDate:(NSDate *)aDate;
+ (NSDate *)getWeekStartForDate:(NSDate *)aDate;
+ (NSDate *)getWeekEndForDate:(NSDate *)aDate;
+ (NSDate *)getMonthStartForDate:(NSDate *)aDate;
+ (NSDate *)getMonthEndForDate:(NSDate *)aDate;
+ (NSDate *)getYearStartForDate:(NSDate *)aDate;
+ (NSDate *)getYearEndForDate:(NSDate *)aDate;

+ (NSInteger)findFirstDayOfMonth:(NSInteger)month year:(NSInteger)year;
+ (NSUInteger)findMonthDaysCount:(NSInteger)month year:(NSInteger)year;

@end
