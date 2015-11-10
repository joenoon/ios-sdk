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
    
    @try
    {
        [YSGValueTransformer transformFromValue:object inContext:nil];
        XCTAssertTrue(false, @"The call above must throw an exception");
    }
    @catch (NSException *exception)
    {
        XCTAssertTrue(true, @"The call above must throw an exception");
    }
}

@end
