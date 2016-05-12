//
//  YesGraphSDKConvenienceTests.m
//  YesGraphSDK
//
//  Created by Gasper Rebernak on 23/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
@import Social;

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

- (void)testDefaults
{
    XCTAssertNotNil(self.sharedGraph.userDefaults, @"User Defaults should not be nil");
    self.sharedGraph.userDefaults = nil;
    XCTAssertNotNil(self.sharedGraph.userDefaults, @"User Defaults should not be nil");
}

- (void)testYesGraphMessaging
{
    NSString *sentMessage = @"Test message";
    
    //
    // YSGMessageHandler
    //
    
    __weak YesGraph *weakSelf = self.sharedGraph;

    [weakSelf setMessageHandler:^(NSString *message, NSDictionary *userInfo) {
        XCTAssert([message isEqualToString:sentMessage], @"The sent message '%@' and received message '%@' are not the same", sentMessage, message);
        XCTAssertNil(userInfo, @"User info should be nil, not '%@'", userInfo);
    }];
    
    XCTAssertNotNil(self.sharedGraph.messageHandler, @"Message handler shouldn't be nil.");
    
    [[YSGMessageCenter shared] sendMessage:sentMessage userInfo:nil];

    //
    // YSGErrorHandler
    //
    NSError *sentError = [NSError errorWithDomain:@"com.yesgraph" code:-1 userInfo:nil];

    [weakSelf setErrorHandler:^(NSError *error) {
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

- (void)testYesGraphShareSheetInitialization
{
    YSGShareSheetController* controller = [self.sharedGraph shareSheetControllerForAllServices];
    
    XCTAssertNil(controller, @"Missing client key, share sheet controller should be nil");
    
    self.sharedGraph.clientKey = YSGTestClientKey;
    
    controller = [self.sharedGraph shareSheetControllerForAllServicesWithDelegate:nil];
    
    XCTAssertNil(controller, @"Missing user ID, share sheet controller should be nil");
    
    self.sharedGraph.userId = YSGTestClientID;
    
    controller = [self.sharedGraph shareSheetControllerForInviteServiceWithDelegate:nil];
    
    XCTAssertNotNil(controller, @"Controller should be created.");
    
    //
    // Mock availability method on social service, to ensure
    //
    
    id mockComposeViewController = OCMClassMock([SLComposeViewController class]);
    
    OCMStub([mockComposeViewController isAvailableForServiceType:[OCMArg any]]).andReturn(YES);
    
    controller = [self.sharedGraph shareSheetControllerForAllServices];
    
    XCTAssertNotNil(controller, @"Controller should be created for all services.");
}

- (void)testYesGraphContactSources
{
    XCTAssertNotNil(self.sharedGraph.localSource, @"Local source shouldn't be nil");
    XCTAssertNotNil(self.sharedGraph.cacheSource, @"Cache source shouldn't be nil");
}

- (void)testYesGraphContactOwnerMetadata
{
    self.sharedGraph.contactOwnerMetadata = [[YSGSource alloc] init];
    self.sharedGraph.contactOwnerMetadata.name = @"MyTestName";
    
    XCTAssert([self.sharedGraph.contactOwnerMetadata.name isEqualToString:@"MyTestName"], @"Contact owner metadata should match");
    
    self.sharedGraph.contactOwnerMetadata = nil;
    
    XCTAssertNil(self.sharedGraph.contactOwnerMetadata, @"Contact owner metadata should be nil");
}

- (void)testYesGraphApplicationNotification
{
    [self.sharedGraph configureWithUserId:@"TEST_USER_ID"];
    [self.sharedGraph configureWithClientKey:@"TEST_CLIENT_KEY"];

    // Checking if checks are correct
    self.sharedGraph.lastFetchDate = [NSDate date];
    
    [self.sharedGraph applicationNotification:nil];
    
    NSDate *distantPast = [NSDate distantPast];
    [self.sharedGraph setLastFetchDate:distantPast];
    
    OCMStub([self.sharedGraph.userDefaults objectForKey:@"YSGLocalContactFetchDateKey"]).andReturn(distantPast);
    
    id classMock = OCMClassMock([self.sharedGraph.localSource class]);
    OCMStub([classMock hasPermission]).andReturn(NO);
    
    //
    // Check if permission check is correct
    //
    [self.sharedGraph applicationNotification:nil];
    
    OCMStub([classMock hasPermission]).andReturn(YES);
    
    id mockLocalSource = OCMPartialMock(self.sharedGraph.localSource);
    OCMStub([mockLocalSource fetchContactListWithCompletion:nil]);

    self.sharedGraph.localSource = mockLocalSource;
    
    id sharedMock = OCMPartialMock(self.sharedGraph);
    OCMStub([sharedMock fetchContactListWithCompletion:nil]);

    [self.sharedGraph applicationNotification:nil];
    
    XCTAssertTrue([sharedMock isConfigured]);
        
    OCMVerify([mockLocalSource fetchContactListWithCompletion:[OCMArg isNotNil]]);
}

- (void)testYesGraphUpdateContactList
{
    //XCTestExpectation *expectation = [self expectationWithDescription:@"Expect completion block to be provided and called."];
    
    XCTAssertNil(self.sharedGraph.lastFetchDate, @"Last fetch date must be nil before calling update.");
    
    id mockedClient = OCMStrictClassMock([YSGClient class]);
    
    OCMStub([mockedClient setClientKey:[OCMArg any]]);
    
    id mockedGraph = OCMPartialMock(self.sharedGraph);
    OCMStub([mockedGraph lastFetchDate]).andReturn([NSDate date]);

    OCMStub([mockedGraph fetchContactListWithCompletion:[OCMArg any]]).andDo(^(NSInvocation *invocation)
    {
        void (^completion)(id, NSError *) = nil;
        [invocation getArgument:&completion atIndex:5];

        // Run the completion it should invoke setLastFetchDate
        completion(nil, nil);

        // Check if last fetch date returns a value

        XCTAssertNotNil(self.sharedGraph.lastFetchDate);
    });

    self.sharedGraph.client = mockedClient;

    OCMVerifyAll(mockedGraph);
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
