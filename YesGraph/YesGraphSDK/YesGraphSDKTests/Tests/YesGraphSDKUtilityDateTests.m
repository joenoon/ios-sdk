//
//  YesGraphSDKUtilityDateTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 13/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGUtility.h"

@interface YesGraphSDKUtilityDateTests : XCTestCase

@end

@implementation YesGraphSDKUtilityDateTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDateStringification
{
    NSCalendar *mainCalendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [NSDateComponents new];
    NSUInteger year = 2000;
    NSUInteger month = 1;
    NSUInteger day = 1;
    NSUInteger startHour = 1;
    NSUInteger minute = 0;
    NSUInteger second = 0;

    dateComponents.year = year;
    dateComponents.month = month;
    dateComponents.day = day;
    dateComponents.hour = startHour;
    dateComponents.minute = minute;
    dateComponents.second = second;

    NSDate *testDate = [mainCalendar dateFromComponents:dateComponents];
    NSUInteger hourStep = 12;
    NSUInteger totalSteps = hourStep * 2 * 90; // we wish to traverse 90 days by half-day steps

    while (totalSteps-- > 0)
    {
        NSString *parsedString = [YSGUtility iso8601dateStringFromDate:testDate];
        XCTAssertNotNil(parsedString, @"Parsed string shouldn't be nil for date %@", testDate);
        NSDate *parsedDateFromParsedString = [YSGUtility dateFromIso8601String:parsedString];
        XCTAssertNotNil(parsedDateFromParsedString, @"Parsed date from parsed string shouldn't be nil for string %@", parsedString);
        XCTAssert([testDate isEqualToDate:parsedDateFromParsedString], @"Test date '%@' is not the same as twice-converted parsed date '%@'", testDate, parsedDateFromParsedString);
        
        testDate = [testDate dateByAddingTimeInterval:(hourStep * 3600)];
    }
}
    
@end
