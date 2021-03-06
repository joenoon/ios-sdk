//
//  YesGraphSDKParsableTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 16/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGObjectParsableMocked.h"
#import "YSGTestMockData.h"
#import "NSArray+YSGParsing.h"

@interface YesGraphSDKParsableTests : XCTestCase

@end

@implementation YesGraphSDKParsableTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)checkIfValidParsed:(YSGObjectParsableMocked *)parsed isEqualTo:(YSGObjectParsableMocked *)expected
{
    XCTAssert([expected.prop1 isEqualToString:parsed.prop1], @"Parsed string '%@' not the same as '%@'", parsed.prop1, expected.prop1);
    XCTAssert([expected.prop2 isEqualToArray:parsed.prop2], @"Parsed array '%@' not the same as '%@'", parsed.prop2, expected.prop2);
    XCTAssert([expected.prop3 isEqualToData:parsed.prop3], @"Parsed data '%@' not the same as '%@'", parsed.prop3, expected.prop3);
    if (expected.prop4)
    {
        XCTAssertNotNil(parsed.prop4, @"YSGContact shouldn't be nil");
        XCTAssert([parsed.prop4.description isEqualToString:expected.prop4.description], @"Parsed contact '%@' not the same as expected '%@'", parsed.prop4.description, expected.prop4.description);
    }
}

- (void)testObjectParsing
{
    YSGObjectParsableMocked *expected = [YSGObjectParsableMocked new];
    expected.prop4 = [YSGTestMockData mockContactList].entries.firstObject;
    NSDictionary *dataFromExpected = [expected ysg_toDictionary];
    {
        YSGObjectParsableMocked *parsed = [YSGObjectParsableMocked ysg_objectWithDictionary:dataFromExpected];
        [self checkIfValidParsed:parsed isEqualTo:expected];
    }
    {
        YSGObjectParsableMocked *parsed = [YSGObjectParsableMocked ysg_objectWithDictionary:dataFromExpected inContext:nil];
        [self checkIfValidParsed:parsed isEqualTo:expected];
    }
    {
        NSError *err = nil;
        YSGObjectParsableMocked *parsed = [YSGObjectParsableMocked ysg_objectWithDictionary:dataFromExpected inContext:nil error:&err];
        XCTAssertNil(err, @"Error should be nil, not '%@'", err);
        [self checkIfValidParsed:parsed isEqualTo:expected];
    }
}

- (void)testNSArrayParsing
{
    NSInteger index = 5;
    NSMutableArray <YSGObjectParsableMocked *> *expectedValues = [NSMutableArray arrayWithCapacity:index];
    NSMutableArray <NSDictionary *> *parsableValues = [NSMutableArray arrayWithCapacity:index];
    while (index-- > 0)
    {
        YSGObjectParsableMocked *expected = [YSGObjectParsableMocked new];
        expected.prop1 = [NSString stringWithFormat:@"Prop %ld", (long)index];
        expected.prop2 = @[ expected.prop1.copy, expected.prop1.copy ];
        expected.prop3 = [expected.prop1 dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *parsable = @
        {
            @"prop1" : expected.prop1,
            @"prop2" : expected.prop2,
            @"prop3" : expected.prop3
        };
        
        [expectedValues addObject:expected];
        [parsableValues addObject:parsable];
    }
    
    NSArray <YSGObjectParsableMocked *> *parsed = [parsableValues ysg_arrayOfObjectsOfClass:[YSGObjectParsableMocked class]];
    XCTAssertNotEqual(parsed.count, 0, @"There should be '%ld' parsed values", (long)expectedValues.count);
    for (index = 0; index < expectedValues.count; ++index)
    {
        [self checkIfValidParsed:parsed[index] isEqualTo:expectedValues[index]];
    }
}

@end
