//
//  YesGraphSDKValueTransformerTests.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 10/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import <OCMock/OCMock.h>

#import "YSGValueTransformer.h"

@implementation YSGValueTransformer (Override)

+ (id)transformFromValue:(id)fromValue
{
    return fromValue;
}

@end

@interface YesGraphSDKValueTransformerTests : XCTestCase

@end

@implementation YesGraphSDKValueTransformerTests

- (void)testGenericValueTransformer
{
    id object = [NSObject new];
    XCTAssertEqualObjects([YSGValueTransformer transformToValue:object], object, @"Transformed objects should be equal");
    XCTAssertEqualObjects([YSGValueTransformer transformFromValue:object], object, @"Transformed objects should be equal");
}

@end
