//
//  YSGUtility.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 11/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGUtility.h"

static NSString * const dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss";
static NSString * const dateLocale = @"en_US_POSIX";

@implementation YSGUtility

+ (NSString *)randomUserId
{
    double random = (double)arc4random() / UINT32_MAX;
    
    NSUInteger randomNumber = random * (9999999 - 1000000) + 1000000;
    
    NSString *randomString = [NSString stringWithFormat:@"%lu_%lu", (unsigned long)[NSDate date].timeIntervalSince1970, (unsigned long)randomNumber];
    
    return [NSString stringWithFormat:@"anon_%@", [[randomString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]];
}

+ (NSString *)iso8601dateStringFromDate:(NSDate *)date
{
    NSDateFormatter *isoFormat = [NSDateFormatter new];   
    NSLocale *posixLocale = [NSLocale localeWithLocaleIdentifier:dateLocale];
    isoFormat.locale = posixLocale;
    isoFormat.dateFormat = dateFormat;
    isoFormat.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    return [isoFormat stringFromDate:date];
}


+ (NSDate *)dateFromIso8601String:(NSString *)formattedDateString
{
    NSDateFormatter *isoFormat = [NSDateFormatter new];
    NSLocale *posixLocale = [NSLocale localeWithLocaleIdentifier:dateLocale];
    isoFormat.locale = posixLocale;
    isoFormat.dateFormat = dateFormat;
    isoFormat.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    return [isoFormat dateFromString:formattedDateString];
}


@end
