//
//  LEDate.m
//  Pods
//
//  Created by emerson larry on 2016/12/22.
//
//

#import "LEDate.h"

@implementation NSDateFormatter (LEExtension)
+(id)leDateFormatter{
    return [[self alloc] init];
}
+(id)leDateFormatterWithFormat:(NSString *)dateFormat{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}
+(id)leDefaultDateFormatter{
    return [self leDateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}
@end
@implementation NSDate (LEExtension) 
-(NSString *)leDateDescriptionInDetail{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSInteger timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval < 60) {
        return @"1分钟内";
    } else if (timeInterval < 3600) {//1小时内
        return [NSString stringWithFormat:@"%d分钟前", (int)timeInterval / 60];
    } else if (timeInterval < 3600*24) {//24小时内
        return [NSString stringWithFormat:@"%d小时前", (int)timeInterval / 3600];
    } else if (timeInterval < 3600*24*2) {
        return @"昨天";
    } else if (timeInterval < 3600*24*3) {
        return @"2天前";
    } else if (timeInterval < 3600*24*4) {
        return @"3天前";
    } else if (timeInterval < 3600*24*5) {
        return @"4天前";
    } else if (timeInterval < 3600*24*6) {
        return @"5天前";
    } else if (timeInterval < 3600*24*7) {
        return @"6天前";
    } else if (timeInterval < 3600*24*15) {
        return @"1周前";
    } else if (timeInterval < 3600*24*16) {
        return @"2周前";
    } else if (timeInterval < 3600*24*31) {
        return @"半月前";
    }else{
        NSDateComponents *components1 = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:self];
        NSDateComponents *components2 = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:[NSDate date]];
        int monthCount=(int)((components2.year-components1.year-1)*12+(12-components1.month)+components2.month);
        if(monthCount/12>0){
            return [NSString stringWithFormat:@"%d年前",monthCount/12];
        }else {
            return [NSString stringWithFormat:@"%d月前",monthCount];
        }
    }
}
-(NSString *)leDateDescription{
    NSDateFormatter *dateFormatter = [NSDateFormatter leDateFormatterWithFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:self];
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];
    if ([theDay isEqualToString:currentDay]) {
        [dateFormatter setDateFormat:@"HH:mm"];
    }else if([self leIsThisYear]){
        [dateFormatter setDateFormat:@"MM-dd"];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [dateFormatter stringFromDate:self];
}
+(NSDate *) leDaysFromNow: (NSInteger) days{
    return [[NSDate date] leAddingDays:days];
}
+(NSDate *) leDaysBeforeNow: (NSInteger) days{
    return [[NSDate date] leSubtractingDays:days];
}
+(NSDate *) leTomorrow{
    return [NSDate leDaysFromNow:1];
}
+(NSDate *) leYesterday{
    return [NSDate leDaysBeforeNow:1];
}
+(NSDate *) leHoursFromNow: (NSInteger) dHours{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] +LE_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+(NSDate *) leHoursBeforeNow: (NSInteger) dHours{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] -LE_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+(NSDate *) leMinutesFromNow: (NSInteger) dMinutes{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] +LE_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+(NSDate *) leMinutesBeforeNow: (NSInteger) dMinutes{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] -LE_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
-(BOOL) leIsEqualIgnoringTime: (NSDate *) aDate{
    NSDateComponents *components1 = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}
-(BOOL) leIsToday{
    return [self leIsEqualIgnoringTime:[NSDate date]];
}
-(BOOL) leIsTomorrow{
    return [self leIsEqualIgnoringTime:[NSDate leTomorrow]];
}
-(BOOL) leIsYesterday{
    return [self leIsEqualIgnoringTime:[NSDate leYesterday]];
}
-(BOOL) leIsSameWeek: (NSDate *) aDate{
    NSDateComponents *components1 = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:aDate];
    if (components1.weekOfMonth != components2.weekOfMonth) return NO;
    return (abs((int)[self timeIntervalSinceDate:aDate]) < LE_WEEK);
}
-(BOOL) leIsThisWeek{
    return [self leIsSameWeek:[NSDate date]];
}
-(BOOL) leIsNextWeek{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] +LE_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self leIsSameWeek:newDate];
}
-(BOOL) leIsLastWeek{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] -LE_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self leIsSameWeek:newDate];
}
-(BOOL) leIsSameMonth: (NSDate *) aDate{
    NSDateComponents *components1 = [ LE_CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [ LE_CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}
-(BOOL) leIsThisMonth{
    return [self leIsSameMonth:[NSDate date]];
}
-(BOOL) leIsSameYear: (NSDate *) aDate{
    NSDateComponents *components1 = [ LE_CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [ LE_CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}
-(BOOL) leIsThisYear{
    return [self leIsSameYear:[NSDate date]];
}
-(BOOL) leIsNextYear{
    NSDateComponents *components1 = [ LE_CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [ LE_CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year +1));
}
-(BOOL) leIsLastYear{
    NSDateComponents *components1 = [ LE_CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [ LE_CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year -1));
}
-(BOOL) leIsEarlierThan: (NSDate *) aDate{
    return ([self compare:aDate] == NSOrderedAscending);
}
-(BOOL) leIsLaterThan: (NSDate *) aDate{
    return ([self compare:aDate] == NSOrderedDescending);
}
-(BOOL) leIsInTheFuture{
    return ([self leIsLaterThan:[NSDate date]]);
}
-(BOOL) leIsInThePast{
    return ([self leIsEarlierThan:[NSDate date]]);
}
-(BOOL) leIsTypicallyWeekend{
    NSDateComponents *components = [ LE_CURRENT_CALENDAR components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}
-(BOOL) leIsTypicallyWorkday{
    return ![self leIsTypicallyWeekend];
}
-(NSDate *) leAddingDays: (NSInteger) dDays{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] +LE_DAY * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
-(NSDate *) leSubtractingDays: (NSInteger) dDays{
    return [self leAddingDays: (dDays * -1)];
}
-(NSDate *) leAddingHours: (NSInteger) dHours{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] +LE_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
-(NSDate *) leSubtractingHours: (NSInteger) dHours{
    return [self leAddingHours: (dHours * -1)];
}
-(NSDate *) leAddingMinutes: (NSInteger) dMinutes{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] +LE_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
-(NSDate *) leSubtractingMinutes: (NSInteger) dMinutes{
    return [self leAddingMinutes: (dMinutes * -1)];
}
-(NSDate *) leStartOfDay{
    NSDateComponents *components = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [ LE_CURRENT_CALENDAR dateFromComponents:components];
}
-(NSInteger) leMinutesAfterDate: (NSDate *) aDate{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / LE_MINUTE);
}
-(NSInteger) leMinutesBeforeDate: (NSDate *) aDate{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / LE_MINUTE);
}
-(NSInteger) leHoursAfterDate: (NSDate *) aDate{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / LE_HOUR);
}
-(NSInteger) leHoursBeforeDate: (NSDate *) aDate{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / LE_HOUR);
}
-(NSInteger) leDaysAfterDate: (NSDate *) aDate{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / LE_DAY);
}
-(NSInteger) leDaysBeforeDate: (NSDate *) aDate{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / LE_DAY);
}
-(NSInteger)leDistanceInDaysToDate:(NSDate *)anotherDate{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}
-(NSInteger) leNearestHour{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] +LE_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [ LE_CURRENT_CALENDAR components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
} 
-(NSInteger) leHour{
    NSDateComponents *components = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:self];
    return components.hour;
}
-(NSInteger) leMinute{
    NSDateComponents *components = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:self];
    return components.minute;
}
-(NSInteger) leSeconds{
    NSDateComponents *components = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:self];
    return components.second;
}
-(NSInteger) leDay{
    NSDateComponents *components = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:self];
    return components.day;
}
-(NSInteger) leMonth{
    NSDateComponents *components = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:self];
    return components.month;
}
-(NSInteger) leWeek{
    NSDateComponents *components = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:self];
    return components.weekOfMonth;
}
-(NSInteger) leWeekday{
    NSDateComponents *components = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:self];
    return components.weekday;
}
-(NSInteger) leYear{
    NSDateComponents *components = [ LE_CURRENT_CALENDAR components: LE_DATE_COMPONENTS fromDate:self];
    return components.year;
}
@end
