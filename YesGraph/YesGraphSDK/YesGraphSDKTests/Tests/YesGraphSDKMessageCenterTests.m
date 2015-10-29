//
//  YesGraphSDKMessageCenterTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 20/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGMessageCenter+RemoveAlertController.h"

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
    self.center.errorHandler = nil;
    self.center.messageHandler = nil;
    [self.center removeAlertController];
    self.center = nil;
    [UIAlertController setYsgShowWasTriggered:nil];
}

- (void)testSendMessageWithHandlerBlock
{
    NSString *sentMessage = @"Test message";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Message Handler To Be Invoked"];

    __weak YSGMessageCenter *preventRetainCycleInstance = self.center;
    preventRetainCycleInstance.messageHandler = ^(NSString *message, NSDictionary * _Nullable userInfo)
     {
         XCTAssert([message isEqualToString:sentMessage], @"The sent message '%@' and received message '%@' are not the same", sentMessage, message);
         XCTAssertNil(userInfo, @"User info should be nil, not '%@'", userInfo);
         [expectation fulfill];
     };

    [self.center sendMessage:sentMessage userInfo:nil];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil not '%@', otherwise the message handler was never invoked", error);
     }];
}

- (void)testSendErrorWithHandlerBlock
{
    NSError *sentError = [NSError errorWithDomain:@"YesGraphSDKDomain" code:22 userInfo:nil];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Error Handler To Be Invoked"];

    __weak YSGMessageCenter *preventRetainCycleInstance = self.center;
    preventRetainCycleInstance.errorHandler = ^(NSError *error)
     {
         XCTAssertNotNil(error, @"Sent error shouldn't be nil");
         XCTAssert([sentError.domain isEqualToString:error.domain], @"Error domain '%@' is not the same as sent domain '%@'", error.domain, sentError.domain);
         XCTAssertEqual(sentError.code, error.code, @"Error code '%ld' is not the same as sent code '%lu'", (long)error.code,  (long)sentError.code);
         XCTAssert([sentError.userInfo isEqualToDictionary:error.userInfo], @"User info '%@' is not the same as sent '%@'", error.userInfo, sentError.userInfo);
         [expectation fulfill];
     };

    [self.center sendError:sentError];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil not '%@', otherwise the error handler was never invoked", error);
     }];
}

- (void)testSingleton
{
    YSGMessageCenter *instance = [YSGMessageCenter shared];
    // this will compare pointer addresses, we could cast both of them to (size_t) for clarity
    XCTAssertEqual(instance, self.center, @"The object pointer should be the same since only 1 instance of YSGMessageCenter can be initialized");
}

- (void)testSendMessageWithoutHandlerBlock
{
    NSString *sentMessage = @"Test message";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Overridden ysg_show To Be Called"];
    __block BOOL wasTriggered = NO;
    [UIAlertController setYsgShowWasTriggered:^(BOOL withAnimationArgument, UIAlertController *controller)
    {
        wasTriggered = YES;
        XCTAssertNotNil(controller, @"Invoked controller shouldn't be nil");
        XCTAssertTrue(withAnimationArgument, @"The UIAlertController should be shown with an animation");
        [expectation fulfill];
    }];
    [self.center sendMessage:sentMessage userInfo:nil];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil not '%@', otherwise the overridden method 'ysg_show' was never invoked", error);
         XCTAssertTrue(wasTriggered, @"UIAlertController was never triggered");
         [UIAlertController setYsgShowWasTriggered:nil];
     }];
}

- (void)testSendMessageWithoutHandlerWithUserInfo
{
    NSString *sentMessage = @"Test message";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Overridden ysg_show To Be Called With Custom User Info"];
    __block BOOL wasTriggered = NO;
    NSDictionary *userInfo = @
    {
        YSGMessageAlertButtonArrayKey: @[ @"Custom Alert Button 1", @"Custom Alert Button 2" ]
    };
    [UIAlertController setYsgShowWasTriggered:^(BOOL withAnimationArgument, UIAlertController *controller)
     {
         wasTriggered = YES;
         XCTAssertNotNil(controller, @"Invoked controller shouldn't be nil");
         NSUInteger expectedCount = ((NSArray *)userInfo[YSGMessageAlertButtonArrayKey]).count;
         NSUInteger actionsCount = controller.actions.count;
         XCTAssertEqual(actionsCount, expectedCount, @"Controller should contain '%lu' actions, but found '%lu'", (unsigned long)expectedCount, (unsigned long)actionsCount);
         XCTAssertTrue(withAnimationArgument, @"The UIAlertController should be shown with an animation");
         [expectation fulfill];
     }];
    [self.center sendMessage:sentMessage userInfo:userInfo];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil not '%@', otherwise the message handler was never invoked", error);
         XCTAssertTrue(wasTriggered, @"UIAlertController was never triggered");
     }];
}


@end
