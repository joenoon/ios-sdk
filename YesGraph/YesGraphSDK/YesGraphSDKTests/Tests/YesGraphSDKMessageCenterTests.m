//
//  YesGraphSDKMessageCenterTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 20/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGMessageCenter.h"

@interface YesGraphSDKMessageCenterTests : XCTestCase
@property (strong, nonatomic) YSGMessageCenter *center; 
@end

@implementation YesGraphSDKMessageCenterTests

- (void)setUp
{
    [super setUp];
    self.center = [YSGMessageCenter shared];
}

- (void)tearDown
{
    [super tearDown];
    self.center = nil;
}

- (void)testSendMessageWithHandlerBlock
{
    NSString *sentMessage = @"Test message";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Message Handler To Be Invoked"];

    __weak YSGMessageCenter *preventRetainCycleInstance = self.center;
    preventRetainCycleInstance.messageHandler = ^(NSString *message, NSDictionary * _Nullable userInfo)
     {
         // XCTAssert([message isEqualToString:sentMessage], @"The sent message '%@' and received message '%@' are not the same", sentMessage, message);
         XCTAssertNil(userInfo, @"User info should be nil, not '%@'", userInfo);
         [expectation fulfill];
     };

    [self.center sendMessage:sentMessage userInfo:nil];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil not '%@', otherwise the message handler was never invoked", error);
     }];
}

- (void)testSingleton
{
    YSGMessageCenter *instance = [YSGMessageCenter shared];
    // this will compare pointer addresses, we could cast both of them to (size_t) for clarity
    XCTAssertEqual(instance, self.center, @"The object pointer should be the same since only 1 instance of YSGMessageCenter can be initialized");
}


@end
