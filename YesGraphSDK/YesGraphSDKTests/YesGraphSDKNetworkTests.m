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

- (void)testClientGETRequestWithoutKey
{
    // we expect to get a 401 response with
    // this body:
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Client Unauthorized Test"];
    NSString *testPath = @"https://api.yesgraph.com/v0/test"; // same URL as documentation example, but we won't set the key header

    [self.client GET:testPath parameters:nil completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
    {
        XCTAssertNotNil(response, @"Response object should not be nil");
        XCTAssertNotNil(error, @"Error object should not be nil");
        XCTAssert([response.response isKindOfClass:[NSHTTPURLResponse class]], @"Response should be of type NSHTTPURLResponse");
        XCTAssertNotNil([error.userInfo objectForKey:@"YSGErrorNetworkStatusCodeKey"], @"Error detail object does not contain the status code key");
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response.response;
        XCTAssert([resp statusCode] == 401 && [error.userInfo[@"YSGErrorNetworkStatusCodeKey"] intValue] == 401, @"HTTP status code should be Not Authorized (401)");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
    {
        if (error)
        {
            XCTFail(@"Expectation timed-out with error: %@", error);
        }
    }];
}

@end
