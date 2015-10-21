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

@interface YesGraphSDKSwizzledMethods : XCTestCase

@property (strong, nonatomic) YSGContact *contactEmail;
@property (strong, nonatomic) YSGContact *contactPhone;

+ (instancetype)shared;

- (void)swizzleBoth;

@end

@implementation YesGraphSDKSwizzledMethods

+ (instancetype)shared
{
    static YesGraphSDKSwizzledMethods *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YesGraphSDKSwizzledMethods new];
    });
    return shared;
}

- (instancetype)init
{
    if ((self = [super init]))
    {
        [self swizzleBoth];
    }
    return self;
}

- (void)swizzleBoth
{
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

- (void)triggerMessageWithContacts:(NSArray<YSGContact *> *)entries
{
    XCTAssertEqual(entries.count, 1, @"Entries should only contain 1 object");
    YSGContact *c = entries.firstObject;
    YSGContact *expected = [YesGraphSDKSwizzledMethods shared].contactPhone;
    XCTAssert([c.contactString isEqualToString:expected.contactString], @"Intercepted contact '%@' does not match the expected contact '%@'", c, expected);
}

- (void)triggerEmailWithContacts:(NSArray<YSGContact *> *)entries
{
    XCTAssertEqual(entries.count, 1, @"Entries should only contain 1 object");
    YSGContact *c = entries.firstObject;
    YSGContact *expected = [YesGraphSDKSwizzledMethods shared].contactEmail;
    XCTAssert([c.contactString isEqualToString:expected.contactString], @"Intercepted contact '%@' does not match the expected contact '%@'", c, expected);
}

@end

@interface YesGraphSDKYSGInviteServiceTests : XCTestCase
@property (strong, nonatomic) YesGraphSDKSwizzledMethods *swizzles;
@end

@implementation YesGraphSDKYSGInviteServiceTests

- (void)setUp
{
    [super setUp];
    self.swizzles = [YesGraphSDKSwizzledMethods shared];
}

- (void)tearDown
{
    [super tearDown];
    self.swizzles = nil;
}

- (void)testInviteWithPhoneContact
{
    YSGContact *invitee = [YSGTestMockData mockContactList].entries.lastObject;
    NSArray *contacts = @[ invitee ];
    self.swizzles.contactPhone = invitee;
    YSGInviteService *service = [[YSGInviteService alloc] init];
    [service triggerInviteFlowWithContacts:contacts];
}

- (void)testInviteWithEmailContact
{
    YSGContact *invitee = [YSGTestMockData mockContactList].entries.firstObject;
    invitee.phones = nil;
    NSArray *contacts = @[ invitee ];
    self.swizzles.contactEmail = invitee;
    YSGInviteService *service = [[YSGInviteService alloc] init];
    [service triggerInviteFlowWithContacts:contacts];
}

@end
