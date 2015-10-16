//
//  YesGraphSDKYSGInviteServiceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 16/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGInviteService.h"
#import "YSGTestMockData.h"

@import ObjectiveC.runtime;

@interface YesGraphSDKYSGInviteServiceTests : XCTestCase

@end

@implementation YesGraphSDKYSGInviteServiceTests

- (void)triggerMessageWithContacts:(NSArray<YSGContact *> *)entries
{
    XCTAssertEqual(entries.count, 1, @"Entries should only contain 1 object");
    YSGContact *c = entries.firstObject;
    YSGContact *ce = [YSGTestMockData mockContactList].entries.lastObject;
    [YesGraphSDKYSGInviteServiceTests checkInterceptedMessagesForContact:c againstExpected:ce];
}

- (void)triggerEmailWithContacts:(NSArray<YSGContact *> *)entries
{
    XCTAssertEqual(entries.count, 1, @"Entries should only contain 1 object");
    YSGContact *c = entries.firstObject;
    YSGContact *ce = [YSGTestMockData mockContactList].entries.firstObject;
    [YesGraphSDKYSGInviteServiceTests checkInterceptedMessagesForContact:c againstExpected:ce];
}

+ (void)checkInterceptedMessagesForContact:(YSGContact *)intercept againstExpected:(YSGContact *)expected
{
    XCTAssert([intercept.contactString isEqualToString:expected.contactString], @"Intercepted contact '%@' should be the same as '%@'", intercept, expected);
}


- (void)setUp
{
    [super setUp];
    [self swizzleEmailMethods];
    [self swizzleMessageMethods];
}

- (void)swizzleMessageMethods
{
    Method original = class_getInstanceMethod([YSGInviteService class], @selector(triggerMessageWithContacts:));
    Method replacement = class_getInstanceMethod([self class], @selector(triggerMessageWithContacts:));
    
    IMP replacementImplementation = method_getImplementation(replacement);
    method_setImplementation(original, replacementImplementation);
}

- (void)swizzleEmailMethods
{
    Method original = class_getInstanceMethod([YSGInviteService class], @selector(triggerEmailWithContacts:));
    Method replacement = class_getInstanceMethod([self class], @selector(triggerEmailWithContacts:));
    
    IMP replacementImplementation = method_getImplementation(replacement);
    method_setImplementation(original, replacementImplementation);
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInviteWithPhoneContact
{
    NSArray *contacts = @[ [YSGTestMockData mockContactList].entries.lastObject ];
    YSGInviteService *service = [[YSGInviteService alloc] init];
    [service triggerInviteFlowWithContacts:contacts];
}

- (void)testInviteWithEmailContact
{
    NSArray *contacts = @[ [YSGTestMockData mockContactList].entries.lastObject ];
    YSGInviteService *service = [[YSGInviteService alloc] init];
    [service triggerInviteFlowWithContacts:contacts];
}

@end
