//
//  YesGraphSDKNetworkClientTests.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 12/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import "YSGClient.h"
#import "YSGTestSettings.h"

@interface YesGraphSDKNetworkClientTests : XCTestCase

@property (nonatomic, strong) YSGClient *client;

@end

@implementation YesGraphSDKNetworkClientTests

- (void)setUp
{
    [super setUp];
    
    self.client = [[YSGClient alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.client = nil;
}

- (void)testInitialization
{
    self.client = [[YSGClient alloc] initWithClientKey:YSGTestClientKey];
    
    XCTAssertEqualObjects(self.client.clientKey, YSGTestClientKey, @"Client keys should be equal");
}

- (void)testParameterError
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Network GET call"];
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Network POST call"];
    
    [self.client GET:@"test" parameters:@{ @"test" : [UIView new] } completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
    {
        XCTAssertNotNil(error, @"This call should fail, due to unsupported parameters");
        
        [expectation fulfill];
    }];
    
    [self.client POST:@"test" parameters:@{ @"test" : [UIView new] } completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
    {
         XCTAssertNotNil(error, @"This call should fail, due to unsupported parameters");
         
         [expectation1 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
