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

@end

@interface YesGraphSDKValueTransformerTests : XCTestCase

@end

@implementation YesGraphSDKValueTransformerTests

- (void)testGenericValueTransformer
{
    id object = [NSObject new];
    XCTAssertEqualObjects([YSGValueTransformer transformToValue:object], object, @"Transformed objects should be equal");
    XCTAssertThrows([YSGValueTransformer transformFromValue:object inContext:nil], @"The transformation should throw an exception");
}

@end
