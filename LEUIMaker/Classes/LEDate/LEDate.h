//
//  LEDate.h
//  Pods
//
//  Created by emerson larry on 2016/12/22.
//
//

#import <Foundation/Foundation.h> 
#define LE_MINUTE	60
#define LE_HOUR		3600
#define LE_DAY		86400
#define LE_WEEK		604800
#define LE_YEAR		31556926
#define  LE_DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
#define  LE_CURRENT_CALENDAR [NSCalendar currentCalendar]
@interface NSDateFormatter (LEExtension)
+(id)leDateFormatter;
+(id)leDateFormatterWithFormat:(NSString *)dateFormat;
+(id)leDefaultDateFormatter;
@end

@interface NSDate (LEExtension)
-(NSString *)leDateDescriptionInDetail;
-(NSString *)leDateDescription;
+(NSDate *) leDaysFromNow: (NSInteger) days;
+(NSDate *) leDaysBeforeNow: (NSInteger) days;
+(NSDate *) leTomorrow;
+(NSDate *) leYesterday;
+(NSDate *) leHoursFromNow: (NSInteger) dHours;
+(NSDate *) leHoursBeforeNow: (NSInteger) dHours;
+(NSDate *) leMinutesFromNow: (NSInteger) dMinutes;
+(NSDate *) leMinutesBeforeNow: (NSInteger) dMinutes;
-(BOOL) leIsEqualIgnoringTime: (NSDate *) aDate;
-(BOOL) leIsToday;
-(BOOL) leIsTomorrow;
-(BOOL) leIsYesterday;
-(BOOL) leIsSameWeek: (NSDate *) aDate;
-(BOOL) leIsThisWeek;
-(BOOL) leIsNextWeek;
-(BOOL) leIsLastWeek;
-(BOOL) leIsSameMonth: (NSDate *) aDate;
-(BOOL) leIsThisMonth;
-(BOOL) leIsSameYear: (NSDate *) aDate;
-(BOOL) leIsThisYear;
-(BOOL) leIsNextYear;
-(BOOL) leIsLastYear;
-(BOOL) leIsEarlierThan: (NSDate *) aDate;
-(BOOL) leIsLaterThan: (NSDate *) aDate;
-(BOOL) leIsInTheFuture;
-(BOOL) leIsInThePast;
-(BOOL) leIsTypicallyWeekend;
-(BOOL) leIsTypicallyWorkday;
-(NSDate *) leAddingDays: (NSInteger) dDays;
-(NSDate *) leSubtractingDays: (NSInteger) dDays;
-(NSDate *) leAddingHours: (NSInteger) dHours;
-(NSDate *) leSubtractingHours: (NSInteger) dHours;
-(NSDate *) leAddingMinutes: (NSInteger) dMinutes;
-(NSDate *) leSubtractingMinutes: (NSInteger) dMinutes;
-(NSDate *) leStartOfDay;
-(NSInteger) leMinutesAfterDate: (NSDate *) aDate;
-(NSInteger) leMinutesBeforeDate: (NSDate *) aDate;
-(NSInteger) leHoursAfterDate: (NSDate *) aDate;
-(NSInteger) leHoursBeforeDate: (NSDate *) aDate;
-(NSInteger) leDaysAfterDate: (NSDate *) aDate;
-(NSInteger) leDaysBeforeDate: (NSDate *) aDate;
-(NSInteger)leDistanceInDaysToDate:(NSDate *)anotherDate;
-(NSInteger) leNearestHour;
-(NSInteger) leHour;
-(NSInteger) leMinute;
-(NSInteger) leSeconds;
-(NSInteger) leDay;
-(NSInteger) leMonth;
-(NSInteger) leWeek;
-(NSInteger) leWeekday;
-(NSInteger) leYear;
@end

