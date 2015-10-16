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

- (void)testClassForIntrospection
{
    TestClassForIntrospection *tc1 = [TestClassForIntrospection new];
    NSArray *properties1 = [tc1 ysg_propertyNames];
    NSArray *expectedProperties = [TestClassForIntrospectionExpected expectedIntrospectionProperties];

    for (NSString *propName in properties1)
    {
        XCTAssertNotNil(propName, @"Property names can't be nil");
        XCTAssert([expectedProperties containsObject:propName], @"Expected properties list does not contain '%@'", propName);
    }
}


@end
