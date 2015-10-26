//
//  YesGraphSDKLocalContactSourceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGLocalContactSource+ExposePrivateMethods.h"
#import "YSGContactList.h"
#import "YSGTestMockData.h"

@interface YesGraphSDKLocalContactSourceTests : XCTestCase
@property (strong, nonatomic) YSGLocalContactSource *localSource;
@end

@implementation YesGraphSDKLocalContactSourceTests

- (void)setUp
{
    [super setUp];
    self.localSource = [YSGLocalContactSource new];
}

- (void)tearDown
{   
    [super tearDown];
    self.localSource = nil;
}

- (void)testLocalContactStoreFetchNil
{
    [self.localSource fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error)
    {
        XCTAssertNil(error, @"Error should be nil, not '%@'", error);
        XCTAssertEqual(contactList.entries.count, 0, @"There shouldn't be any entries in the contacts list");
    }];
}

- (void)testHasPermission
{
    XCTAssertTrue([YSGLocalContactSource hasPermission], @"We shouldn have contact permissions");
}

- (void)testUserDefaults
{
    XCTAssertEqual([NSUserDefaults standardUserDefaults], [YSGLocalContactSource userDefaults], @"User defaults from local source should be the same as standard user defaults");
}

- (void)testPromptTitle
{
    XCTAssert([self.localSource.contactAccessPromptTitle isEqualToString:@"Invite friends"], @"Access prompt title shouldn't be '%@'", self.localSource.contactAccessPromptTitle);
}

@end
