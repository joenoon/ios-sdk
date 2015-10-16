//
//  YesGraphSDKIntrospectionTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 16/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+YSGIntrospection.h"
#import "YSGTestIntrospectionMocked.h"

@interface YesGraphSDKIntrospectionTests : XCTestCase

@end

@implementation YesGraphSDKIntrospectionTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)checkProperties:(NSArray *)properties againstExpected:(NSArray *)expectedProperties
{
    XCTAssertNotNil(properties, @"Properties from introspected objects shouldn't be nil");
    XCTAssertNotNil(expectedProperties, @"Expected properties list shouldn't be nil");
    
    for (NSString *propName in properties)
    {
        XCTAssertNotNil(propName, @"Property names can't be nil");
        XCTAssert([expectedProperties containsObject:propName], @"Expected properties list does not contain '%@'", propName);
    }
}

- (void)testClassForIntrospection
{
    TestClassForIntrospection1 *tc1 = [TestClassForIntrospection1 new];
    NSArray *properties1 = [tc1 ysg_propertyNames];
    NSArray *expectedProperties = [TestClassForIntrospectionExpected1 expectedIntrospectionProperties];
    [self checkProperties:properties1 againstExpected:expectedProperties];
    
    TestClassForIntrospection2 *tc2 = [TestClassForIntrospection2 new];
    NSArray *properties2 = [tc2 ysg_propertyNames];
    NSArray *expectedProperties2 = [TestClassForIntrospection2Expected expectedIntrospectionProperties];
    [self checkProperties:properties2 againstExpected:expectedProperties2];
}


@end
