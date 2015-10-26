//
//  YesGraphSDKConvenienceTests.m
//  YesGraphSDK
//
//  Created by Gasper Rebernak on 23/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YesGraph.h"
#import "YSGMessaging.h"
#import "YSGInviteService.h"
#import "YSGSources.h"

#import "YSGTestSettings.h"
#import "YSGTestMockData.h"

@interface YesGraphSDKConvenienceTests : XCTestCase

@end

@implementation YesGraphSDKConvenienceTests

- (void)setUp
{
    [super setUp];
    
    [[YesGraph shared] configureWithClientKey:YSGTestClientKey];
    [[YesGraph shared] configureWithUserId:YSGTestClientID];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [[YesGraph shared] configureWithUserId:@""];
    [[YesGraph shared] configureWithClientKey:@""];
}

- (void)testYesGraphInitialization
{
    [[YesGraph shared] configureWithUserId:@""];
    [[YesGraph shared] configureWithClientKey:@""];
    
    [[YesGraph shared] configureWithClientKey:YSGTestClientKey];
    
    XCTAssertFalse([YesGraph shared].isConfigured, @"If user ID is not set isConfigured should return false");
    
    [[YesGraph shared] configureWithUserId:YSGTestClientID];
    
    XCTAssertTrue([YesGraph shared].isConfigured, @"If both user ID and client key are set isConfigured should return true");
}

- (void)testYesGraphMessaging
{
    NSString *sentMessage = @"Test message";
    
    //
    // YSGMessageHandler
    //
    [[YesGraph shared] setMessageHandler:^(NSString *message, NSDictionary *userInfo) {
        XCTAssert([message isEqualToString:sentMessage], @"The sent message '%@' and received message '%@' are not the same", sentMessage, message);
        XCTAssertNil(userInfo, @"User info should be nil, not '%@'", userInfo);
    }];
    
    XCTAssertNotNil([YesGraph shared].messageHandler, @"Message handler shouldn't be nil.");
    
    [[YSGMessageCenter shared] sendMessage:sentMessage userInfo:nil];

    //
    // YSGErrorHandler
    //
    NSError *sentError = [NSError errorWithDomain:@"com.yesgraph" code:-1 userInfo:nil];

    [[YesGraph shared] setErrorHandler:^(NSError *error) {
        XCTAssert([error.domain isEqualToString:sentError.domain], @"The error domain '%@' and received error domain '%@' are not the same", sentError.domain, error.domain);
        XCTAssert(error.userInfo.count == 0, @"User info should be empty, not '%@'", error.userInfo);
    }];
    
    XCTAssertNotNil([YesGraph shared].errorHandler, @"Error handler shouldn't be nil.");
    
    [[YSGMessageCenter shared] sendError:sentError];
}

- (void)testYesGraphSettings
{
    NSInteger testNumberOfSuggestions = 10;
    NSString *testContactAccessPromptMessage = @"Test prompt";
    NSTimeInterval testContactBookTimePeriod = 1.0;
    
    [[YesGraph shared] setNumberOfSuggestions:testNumberOfSuggestions];
    [[YesGraph shared] setContactAccessPromptMessage:testContactAccessPromptMessage];
    [[YesGraph shared] setContactBookTimePeriod:testContactBookTimePeriod];
    
    XCTAssertTrue(([YesGraph shared].contactBookTimePeriod == testContactBookTimePeriod), @"YesGraph contactBookTimePeriod \"%f\" does not match contactBookTimePeriod that was set \"%f\".", [YesGraph shared].contactBookTimePeriod, testContactBookTimePeriod);
    
    YSGShareSheetController *shareSheetController = [[YesGraph shared] shareSheetControllerForInviteService];
    
    XCTAssert(shareSheetController.services.count == 1, @"YSGShareSheetController should only have 1 service when YesGrapy shareSheetControllerForInviteService is invoked, not '%lu'", (unsigned long)shareSheetController.services.count);
    
    YSGInviteService *inviteService = (YSGInviteService*)shareSheetController.services.firstObject;

    XCTAssertTrue([inviteService isKindOfClass:[YSGInviteService class]], @"Expected YSGInviteService class, not %@", [inviteService class]);
    
    XCTAssert((inviteService.numberOfSuggestions == testNumberOfSuggestions), @"Number of suggestions %lul is not the same as set %ldl", (unsigned long)inviteService.numberOfSuggestions, (long)testNumberOfSuggestions);
    
    YSGOnlineContactSource *onlineContactSource = inviteService.contactSource;
    
    YSGLocalContactSource *localContactSource = onlineContactSource.localSource;
    
    XCTAssert([localContactSource.contactAccessPromptMessage isEqualToString:testContactAccessPromptMessage], @"Invite contact permissions message \"%@\" is not the same as configured \"%@\".", localContactSource.contactAccessPromptMessage, testContactAccessPromptMessage);
}

@end
