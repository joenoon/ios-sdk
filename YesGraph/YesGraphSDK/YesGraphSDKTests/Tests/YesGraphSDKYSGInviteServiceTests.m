//
//  YesGraphSDKYSGInviteServiceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 16/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGInviteService+OverridenMethods.h"
#import "YSGTestMockData.h"

@interface YesGraphSDKYSGInviteServiceTests : XCTestCase
@property (strong, nonatomic) YSGInviteService *service;
@end

@implementation YesGraphSDKYSGInviteServiceTests

- (void)setUp
{
    [super setUp];
    self.service = [YSGInviteService new];
}

- (void)tearDown
{
    [super tearDown];
    self.service = nil;
}

- (void)testInviteWithPhoneContact
{
    YSGContact *invitee = [YSGTestMockData mockContactList].entries.lastObject;
    NSArray *contacts = @[ invitee ];
    __weak YesGraphSDKYSGInviteServiceTests *preventRetainCycle = self;
    preventRetainCycle.service.triggeredForEmailContacts = ^(NSArray <YSGContact *> *entries)
    {
        XCTAssertEqual(contacts.count, entries.count, @"Received entries count '%lu' does not match the sent count '%lu'", entries.count, contacts.count);
        __weak YSGContact *firstSent = contacts[0];
        __weak YSGContact *firstRec = entries[0];
        XCTAssert([firstSent.description isEqualToString:firstRec.description], @"Description of received contact '%@' does not match the description of the sent contact '%@'", firstSent.description, firstRec.description);
    };
    [self.service triggerInviteFlowWithContacts:contacts];
}

- (void)testInviteWithEmailContact
{
    YSGContact *invitee = [YSGTestMockData mockContactList].entries.firstObject;
    invitee.phones = nil;
    NSArray *contacts = @[ invitee ];
    __weak YesGraphSDKYSGInviteServiceTests *preventRetainCycle = self;
    preventRetainCycle.service.triggeredPhoneContacts = ^(NSArray <YSGContact *> *entries)
    {
        XCTAssertEqual(contacts.count, entries.count, @"Received entries count '%lu' does not match the sent count '%lu'", entries.count, contacts.count);
        __weak YSGContact *firstSent = contacts[0];
        __weak YSGContact *firstRec = entries[0];
        XCTAssert([firstSent.description isEqualToString:firstRec.description], @"Description of received contact '%@' does not match the description of the sent contact '%@'", firstSent.description, firstRec.description);
    };
    [self.service triggerInviteFlowWithContacts:contacts];
    
}

- (void)testInviteBothKinds
{
    YSGContact *onlyEmail = [YSGTestMockData mockContactList].entries.firstObject;
    YSGContact *onlyPhone = [YSGTestMockData mockContactList].entries.lastObject;
    onlyEmail.phones = nil;
    onlyPhone.emails = nil;
    NSArray *contacts = @[ onlyEmail, onlyPhone ];
    __weak YesGraphSDKYSGInviteServiceTests *preventRetainCycle = self;
    preventRetainCycle.service.triggeredForEmailContacts = ^(NSArray <YSGContact *> *entries)
    {
        XCTAssertEqual(entries.count, 1, @"Received entries count '%lu' does not match the sent count '%lu'", entries.count, contacts.count);
        __weak YSGContact *firstSent = contacts[0];
        __weak YSGContact *firstRec = entries[0];
        XCTAssert([firstSent.description isEqualToString:firstRec.description], @"Description of received contact '%@' does not match the description of the sent contact '%@'", firstSent.description, firstRec.description);
    };
    preventRetainCycle.service.triggeredPhoneContacts = ^(NSArray <YSGContact *> *entries)
    {
        XCTAssertEqual(entries.count, 1, @"Received entries count '%lu' does not match the sent count '%lu'", entries.count, contacts.count);
        __weak YSGContact *firstSent = contacts[1];
        __weak YSGContact *firstRec = entries[0];
        XCTAssert([firstSent.description isEqualToString:firstRec.description], @"Description of received contact '%@' does not match the description of the sent contact '%@'", firstSent.description, firstRec.description);
    };
    [self.service triggerInviteFlowWithContacts:contacts];
}

@end
