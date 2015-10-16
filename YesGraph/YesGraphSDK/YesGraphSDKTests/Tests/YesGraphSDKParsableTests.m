//
//  YesGraphSDKParsableTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 16/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGObjectParsableMocked.h"

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
    XCTAssertNotNil(parsed, @"Parsed object shouldn't be nil for dictionary: '%@'", expected.mappedKvp);
    XCTAssert([expected.prop1 isEqualToString:parsed.prop1], @"Parsed string '%@' not the same as '%@'", parsed.prop1, expected.prop1);
    XCTAssert([expected.prop2 isEqualToArray:parsed.prop2], @"Parsed array '%@' not the same as '%@'", parsed.prop2, expected.prop2);
    XCTAssert([expected.prop3 isEqualToData:parsed.prop3], @"Parsed data '%@' not the same as '%@'", parsed.prop3, expected.prop3);
}

- (void)testObjectParsing
{
    YSGObjectParsableMocked *expected = [YSGObjectParsableMocked new];
    NSDictionary *dataFromExpected = expected.mappedKvp;
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

@end
