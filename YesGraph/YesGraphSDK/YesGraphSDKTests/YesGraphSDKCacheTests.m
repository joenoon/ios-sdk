//
//  YesGraphSDKCacheTests.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 01/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGCacheContactSource.h"
#import "YSGTestMockData.h"

@import XCTest;

@interface YesGraphSDKCacheTests : XCTestCase

@end

@implementation YesGraphSDKCacheTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCacheTest
{
    YSGCacheContactSource *contactSource = [[YSGCacheContactSource alloc] init];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    contactSource.cacheDirectory = paths.firstObject;
    
    YSGContactList *contactList = [YSGTestMockData mockContactList];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Cache contact fetch"];
    
    [contactSource updateCacheWithContactList:contactList completion:^(NSError * _Nullable error)
    {
        [contactSource fetchContactListWithCompletion:^(YSGContactList * _Nullable fetchedContactList, NSError * _Nullable error)
        {
            XCTAssert(fetchedContactList != nil);
            XCTAssert(fetchedContactList.entries.count == contactList.entries.count);
            XCTAssert([fetchedContactList.entries.firstObject isKindOfClass:[YSGContact class]]);
            XCTAssert([contactList.entries.firstObject.name isEqualToString:fetchedContactList.entries.firstObject.name]);
            XCTAssert(contactList.useSuggestions == fetchedContactList.useSuggestions);
            
            [expectation fulfill];
        }];
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
