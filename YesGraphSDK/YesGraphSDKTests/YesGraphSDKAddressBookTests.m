//
//  YesGraphSDKAddressBookTests.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import "YSGTestSettings.h"
#import "YSGTestMockData.h"

#import "YSGClient+AddressBook.h"

@interface YesGraphSDKAddressBookTests : XCTestCase

@property (nonatomic, strong) YSGClient *client;

@end

@implementation YesGraphSDKAddressBookTests

- (void)setUp
{
    [super setUp];
    
    self.client = [[YSGClient alloc] init];
}

- (void)tearDown
{
    [super tearDown];
    
    self.client = nil;
}

- (void)testFetchAddressBook
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Address Book Fetched"];
    
    self.client.clientKey = YSGTestClientKey;
    
    [self.client fetchAddressBookForUserId:YSGTestClientID completion:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        XCTAssert([responseObject isKindOfClass:[YSGContactList class]]);
        
        YSGContactList* contactList = (YSGContactList *)responseObject;
        
        XCTAssert(contactList.entries.count > 0);
        
        XCTAssert([contactList.entries.firstObject isKindOfClass:[YSGContact class]]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error)
    {
        if (error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testUpdateAddressBook
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Address Book Fetched"];
    
    self.client.clientKey = YSGTestClientKey;
        
    [self.client updateAddressBookWithContactList:[YSGTestMockData mockContactList] completion:^(id _Nullable responseObject, NSError * _Nullable error)
    {
        XCTAssert(responseObject != nil);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error)
    {
        if (error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

@end
