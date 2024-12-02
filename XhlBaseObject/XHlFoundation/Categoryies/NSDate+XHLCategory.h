//
//  NSDate+XHLCategory.h
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/8/2.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_MINUTE    60
#define D_HOUR        3600
#define D_DAY        86400
#define D_WEEK        604800
#define D_YEAR        31556926

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (XHLCategory)
// Relative dates from the current date
//根据时间戳获取时间对象
+ (NSDate *) xhl_dateWithTimeSecond:(NSInteger)timeSceond;

+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;//判断是这周
- (BOOL) isNextWeek;//判断是下周
- (BOOL) isLastWeek;//判断是上周
- (BOOL) isSameMonthAsDate: (NSDate *) aDate;//相同月
- (BOOL) isThisMonth;//这月
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
//比当前时间早
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
//比当前时间晚
- (BOOL) isLaterThanDate: (NSDate *) aDate;

// Date roles
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;

// Adjusting dates
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;

- (NSTimeInterval) daysDecimalAfterDate: (NSDate *) aDate;
- (NSTimeInterval) hoursDecimalAfterDate: (NSDate *) aDate;

#pragma mark - 常用时间格式化
//yyyy年MM月dd日 HH时mm分ss秒
- (NSString *)getChineseYMDTime;
//yyyy年MM月dd日
- (NSString *)getChineseYMD;
//yyyy年MM月
- (NSString *)getChineseYM;
//yyyy-MM-dd HH:mm:ss
- (NSString *)getDividerYMDTime;
//yyyy-MM-dd
- (NSString *)getDividerYMD;
//yyyy/MM/dd HH:mm:ss
- (NSString *)getDashYMDTime;
//yyyy/MM/dd
- (NSString *)getashYMD;

//获取几天前或者后的时间 前使用-号如7天前 -7  7天后: 4
- (NSDate *)getNDay:(NSInteger)n;

+ (long)timeSecondsSince1970;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;
@property (readonly) NSInteger quarter;//季度

/**
 获得时间差离现在时间的显示,如几分钟前,几小时前,几天前,数据格式化为-
 */
- (NSString *)xhl_getDividerTimeInterval;
/**
 获得时间差离现在时间的显示,如几分钟前,几小时前,几天前,数据格式化为年月日
 */
- (NSString *)xhl_getChineserTimeInterval;
@end

NS_ASSUME_NONNULL_END
