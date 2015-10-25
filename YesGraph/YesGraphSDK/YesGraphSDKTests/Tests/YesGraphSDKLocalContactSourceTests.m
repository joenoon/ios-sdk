//
//  YesGraphSDKLocalContactSourceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGLocalContactSource.h"
#import "YSGContactList.h"
#import "YSGTestMockData.h"

@interface YesGraphSDKLocalContactSourceTests : XCTestCase
@end

@implementation YesGraphSDKLocalContactSourceTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{   
    [super tearDown];
}

- (void)testLocalContactStoreFetchNil
{
    YSGLocalContactSource *localSource = [YSGLocalContactSource new];
    [localSource fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error)
    {
        XCTAssertNil(error, @"Error should be nil, not '%@'", error);
        XCTAssertEqual(contactList.entries.count, 0, @"There shouldn't be any entries in the contacts list");
    }];
}

- (void)testHasPermission
{
    XCTAssertTrue([YSGLocalContactSource hasPermission], @"We shouldn have contact permissions");
}

@end
