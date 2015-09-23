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

@interface YesGraphSDKInviteTest : XCTestCase

@property(strong, nonatomic) YSGClient *client;

@end

@implementation YesGraphSDKInviteTest

- (void)setUp
{
    [super setUp];
    self.client = [YSGClient new];
    self.client.clientKey = YSGTestClientKey;
}

- (void)testInviteSent
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Invites Sent To Selected Contacts"];
    YSGContactList *listOfContacts = [YSGTestMockData mockContactList];

    [self.client updateInviteSentToContacts:listOfContacts.entries
                                  forUserId:YSGTestClientID
                             withCompletion:^(NSError *_Nullable error)
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
    [self waitForExpectationsWithTimeout:5.0
                                 handler:^(NSError *error)
    {
        if (error)
        {
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)tearDown
{
    [super tearDown];
    self.client = nil;
}

@end
