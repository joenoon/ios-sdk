//
//  YesGraphSDKIntrospectionTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 16/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
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

- (void)checkProperties:(NSArray *)properties againstExpected:(NSDictionary *)expectedProperties
{
    XCTAssertNotNil(properties, @"Properties from introspected objects shouldn't be nil");
    XCTAssertNotNil(expectedProperties, @"Expected properties list shouldn't be nil");
    
    for (NSString *propName in properties)
    {
        XCTAssertNotNil(propName, @"Property names can't be nil");
        XCTAssertNotNil(expectedProperties[propName], @"Property '%@' not found in expected properties '%@'", propName, expectedProperties);
    }
}

- (void)testClassForIntrospection
{
    TestClassForIntrospection1 *tc1 = [TestClassForIntrospection1 new];
    NSArray *properties1 = [tc1 ysg_propertyNames];
    NSDictionary *expectedProperties = [TestClassForIntrospectionExpected1 expectedIntrospectionProperties];
    [self checkProperties:properties1 againstExpected:expectedProperties];
    
    TestClassForIntrospection2 *tc2 = [TestClassForIntrospection2 new];
    NSArray *properties2 = [tc2 ysg_propertyNames];
    NSDictionary *expectedProperties2 = [TestClassForIntrospection2Expected expectedIntrospectionProperties];
    [self checkProperties:properties2 againstExpected:expectedProperties2];
}

- (void)checkPropertyTypesFor:(NSArray *)properties againstExpected:(NSDictionary *)expectedProperties withClass:(Class)type
{
    XCTAssertNotNil(properties, @"Properties from introspected objects shouldn't be nil");
    XCTAssertNotNil(expectedProperties, @"Expected properties list shouldn't be nil");
    
    for (NSString *propName in properties)
    {
        Class propType = [type ysg_classForPropertyName:propName];
        Class expectedType = expectedProperties[propName];
        if (propType == nil)
        {
            XCTAssert(expectedType == [TestCClassType class], @"Expected a '%@' when property type is nil, but got: '%@'", [TestCClassType class], propType);
        }
        else
        {
            XCTAssert(expectedType == propType, @"The types are not the same, property is of tyoe '%@' but '%@' was expected", propType, expectedType);
        }
    }
}

- (void)testClassForIntrospectionWithPropertyTypes
{
    TestClassForIntrospection1 *tc1 = [TestClassForIntrospection1 new];
    NSArray *properties1 = [tc1 ysg_propertyNames];
    NSDictionary *expectedProperties1 = [TestClassForIntrospectionExpected1 expectedIntrospectionProperties];
    [self checkPropertyTypesFor:properties1 againstExpected:expectedProperties1 withClass:[tc1 class]];
    
    TestClassForIntrospection2 *tc2 = [TestClassForIntrospection2 new];
    NSArray *properties2 = [tc2 ysg_propertyNames];
    NSDictionary *expectedProperties2 = [TestClassForIntrospection2Expected expectedIntrospectionProperties];
    [self checkPropertyTypesFor:properties2 againstExpected:expectedProperties2 withClass:[tc2 class]];
}

@end
