//
//  YesGraphSDKInviteTest.m
//  YesGraphSDK
//
//  Created by w00tnes on 23/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGTestSettings.h"
#import "YSGTestMockData.h"
#import "YSGClient+Invite.h"
#import "YSGUtility.h"

@interface YesGraphSDKInviteTest : XCTestCase

@property (strong, nonatomic) YSGClient *client;

@end

@implementation YesGraphSDKInviteTest
- (void)setUp
{
    [super setUp];
    self.client = [YSGClient new];
    self.client.clientKey = YSGTestClientKey;
}


- (void)testUpdateInviteSent
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Invites Sent To Selected Contacts"];
    NSArray<YSGContact *> *invitees = [YSGTestMockData mockContactList].entries;

    [self.client updateInvitesSent:invitees forUsedId:YSGTestClientID withCompletion:^(NSError *_Nullable error)
    {
        if (error)
        {
            XCTFail(@"Expectation failed with error: %@", error);
        }
        else
        {
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *_Nullable error)
    {
        if (error)
        {
            XCTFail(@"Expectation timed-out with error: %@", error);
        }
    }];
}

- (void)testUpdateInvitesAccepted
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Invites Accepted By User"];
    NSArray<YSGContact *> *invites = [YSGTestMockData mockContactList].entries;
    NSString *randomUID = [YSGUtility randomUserId];

    [self.client updateInvitesAccepted:invites forNewUserId:randomUID withCompletion:^(NSError *_Nullable error)
    {
        if (error)
        {
            XCTFail(@"Expectation failed with error: %@", error);
        }
        else
        {
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *_Nullable error)
    {
        if (error)
        {
            XCTFail(@"Expectation timed-out with error: %@", error);
        }
    }];
}

- (void)tearDown
{
    [super tearDown];
    self.client = nil;
}

@end
