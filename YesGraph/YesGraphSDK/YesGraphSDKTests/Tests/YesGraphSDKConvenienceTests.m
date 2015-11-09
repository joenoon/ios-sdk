//
//  YesGraphSDKConvenienceTests.m
//  YesGraphSDK
//
//  Created by Gasper Rebernak on 23/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import <OCMock/OCMock.h>

#import "YesGraph+Private.h"
#import "YSGMessaging.h"
#import "YSGInviteService.h"
#import "YSGSources.h"

#import "YSGTestSettings.h"
#import "YSGTestMockData.h"

@interface YesGraphSDKConvenienceTests : XCTestCase

@property (nonatomic, strong) YesGraph* sharedGraph;

@end

@implementation YesGraphSDKConvenienceTests

- (void)setUp
{
    [super setUp];
    
    //
    // Each test is run with a seperate shared instance, not using the same one
    // so parallelization fails.
    //
    self.sharedGraph = [[YesGraph alloc] init];
    
    //
    // Create a mock for the user defaults
    //
    self.sharedGraph.userDefaults = OCMClassMock([NSUserDefaults class]);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.sharedGraph = nil;
}

- (void)testYesGraphInitialization
{
    [self.sharedGraph configureWithClientKey:YSGTestClientKey];
    
    OCMStub([self.sharedGraph.userDefaults stringForKey:@"YSGConfigurationClientKey"]).andReturn(YSGTestClientKey);
    XCTAssertFalse(self.sharedGraph.isConfigured, @"If user ID is not set isConfigured should return false");
    
    [self.sharedGraph configureWithUserId:YSGTestClientID];
    
    OCMStub([self.sharedGraph.userDefaults stringForKey:@"YSGConfigurationUserIdKey"]).andReturn(YSGTestClientID);
    
    XCTAssertTrue(self.sharedGraph.isConfigured, @"If both user ID and client key are set isConfigured should return true");
}

- (void)testYesGraphMessaging
{
    NSString *sentMessage = @"Test message";
    
    //
    // YSGMessageHandler
    //
    [self.sharedGraph setMessageHandler:^(NSString *message, NSDictionary *userInfo) {
        XCTAssert([message isEqualToString:sentMessage], @"The sent message '%@' and received message '%@' are not the same", sentMessage, message);
        XCTAssertNil(userInfo, @"User info should be nil, not '%@'", userInfo);
    }];
    
    XCTAssertNotNil(self.sharedGraph.messageHandler, @"Message handler shouldn't be nil.");
    
    [[YSGMessageCenter shared] sendMessage:sentMessage userInfo:nil];

    //
    // YSGErrorHandler
    //
    NSError *sentError = [NSError errorWithDomain:@"com.yesgraph" code:-1 userInfo:nil];

    [self.sharedGraph setErrorHandler:^(NSError *error) {
        XCTAssert([error.domain isEqualToString:sentError.domain], @"The error domain '%@' and received error domain '%@' are not the same", sentError.domain, error.domain);
        XCTAssert(error.userInfo.count == 0, @"User info should be empty, not '%@'", error.userInfo);
    }];
    
    XCTAssertNotNil(self.sharedGraph.errorHandler, @"Error handler shouldn't be nil.");
    
    [[YSGMessageCenter shared] sendError:sentError];
}

- (void)testYesGraphSettings
{
    NSInteger testNumberOfSuggestions = 10;
    NSString *testContactAccessPromptMessage = @"Test prompt";
    NSTimeInterval testContactBookTimePeriod = 1.0;
    
    [self.sharedGraph configureWithClientKey:YSGTestClientKey];
    [self.sharedGraph configureWithUserId:YSGTestClientID];
    
    [self.sharedGraph setNumberOfSuggestions:testNumberOfSuggestions];
    [self.sharedGraph setContactAccessPromptMessage:testContactAccessPromptMessage];
    [self.sharedGraph setContactBookTimePeriod:testContactBookTimePeriod];
    
    XCTAssertTrue((self.sharedGraph.contactBookTimePeriod == testContactBookTimePeriod), @"YesGraph contactBookTimePeriod \"%f\" does not match contactBookTimePeriod that was set \"%f\".", self.sharedGraph.contactBookTimePeriod, testContactBookTimePeriod);
    
    YSGShareSheetController *shareSheetController = [self.sharedGraph shareSheetControllerForInviteService];
    
    XCTAssert(shareSheetController.services.count == 1, @"YSGShareSheetController should only have 1 service when YesGrapy shareSheetControllerForInviteService is invoked, not '%lu'", (unsigned long)shareSheetController.services.count);
    
    YSGInviteService *inviteService = (YSGInviteService *)shareSheetController.services.firstObject;

    XCTAssertTrue([inviteService isKindOfClass:[YSGInviteService class]], @"Expected YSGInviteService class, not %@", [inviteService class]);
    
    XCTAssert((inviteService.numberOfSuggestions == testNumberOfSuggestions), @"Number of suggestions %lul is not the same as set %ldl", (unsigned long)inviteService.numberOfSuggestions, (long)testNumberOfSuggestions);
    
    YSGOnlineContactSource *onlineContactSource = inviteService.contactSource;
    
    YSGLocalContactSource *localContactSource = onlineContactSource.localSource;
    
    XCTAssert([localContactSource.contactAccessPromptMessage isEqualToString:testContactAccessPromptMessage], @"Invite contact permissions message \"%@\" is not the same as configured \"%@\".", localContactSource.contactAccessPromptMessage, testContactAccessPromptMessage);
}

- (void)testYesGraphContactSources
{
    XCTAssertNotNil(self.sharedGraph.localSource, @"Local source shouldn't be nil");
    XCTAssertNotNil(self.sharedGraph.cacheSource, @"Cache source shouldn't be nil");
}

- (void)testYesGraphLastFetchDate
{
    NSDate *testDate = [NSDate date];
    
    [self.sharedGraph setLastFetchDate:testDate];
    
    OCMStub([self.sharedGraph.userDefaults objectForKey:@"YSGLocalContactFetchDateKey"]).andReturn(testDate);
    
    XCTAssertEqualObjects(testDate, self.sharedGraph.lastFetchDate, @"Dates do not match!");
    
    self.sharedGraph.userDefaults = OCMClassMock([NSUserDefaults class]);
    
    [self.sharedGraph setLastFetchDate:nil];

    XCTAssertNil(self.sharedGraph.lastFetchDate, @"Date should be nil");
}

- (void)testYesGraphConfigurationFromUserDefaults
{
    OCMStub([self.sharedGraph.userDefaults objectForKey:@"YSGConfigurationClientKey"]).andReturn(YSGTestClientKey);
    OCMStub([self.sharedGraph.userDefaults objectForKey:@"YSGConfigurationUserIdKey"]).andReturn(YSGTestClientID);
    
    XCTAssertEqual(self.sharedGraph.userId, YSGTestClientID, @"UserId should still be fetched from UserDefaults");
    
    XCTAssertEqual(self.sharedGraph.clientKey, YSGTestClientKey, @"ClientKey should still be fetched from UserDefaults");
}

@end
