//
//  YesGraphSDKNetworkTests.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import "YSGTestSettings.h"

#import "YSGClient.h"
#import "YSGClient+Private.h"

@interface YesGraphSDKNetworkTests : XCTestCase

@property (nonatomic, strong) YSGClient *client;

@end

@implementation YesGraphSDKNetworkTests

- (void)setUp
{
    [super setUp];
    
    self.client = [[YSGClient alloc] init];
}

- (void)tearDown
{
    [super tearDown];
    
    self.client = nil;
}

- (void)testClientKey
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Client Key Retrieved"];
    
    [self.client fetchRandomClientKeyWithSecretKey:YSGTestClientKey completion:^(NSString *clientKey, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error is: %@", error);
        }
        else
        {
            XCTAssert(clientKey.length > 0, @"Client key should be at least 1 character long");
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error)
    {
        if (error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

@end
