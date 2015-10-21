//
//  YesGraphSDKOnlineContactSourceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGMockClient.h"
#import "YSGOnlineContactSource.h"
#import "YSGCacheContactSource.h"
#import "YSGLocalContactSource.h"
#import "YSGTestMockData.h"

@interface YesGraphSDKOnlineContactSourceTests : XCTestCase
@property (strong, nonatomic) YSGMockClient *mockedClientGenerator;
@end

@implementation YesGraphSDKOnlineContactSourceTests

- (void)setUp
{
    [super setUp];
    self.mockedClientGenerator = [YSGMockClient new];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testFetchContactListSuccess
{
    YSGClient *mockedClient = [self.mockedClientGenerator createMockedClient:YES];
    YSGLocalContactSource *localSource = [YSGLocalContactSource new];
    YSGCacheContactSource *cacheSource = [YSGCacheContactSource new];
    YSGOnlineContactSource *onlineSource = [[YSGOnlineContactSource alloc] initWithClient:mockedClient localSource:localSource cacheSource:cacheSource];

    __weak YSGContactList *mockedList = [YSGTestMockData mockContactList];
    __weak YSGOnlineContactSource *preventRetainCycleInstance = onlineSource;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Fetch Online Contact List"];

    [preventRetainCycleInstance fetchContactListWithCompletion:^(YSGContactList *returnedContacts, NSError *error)
     {
         XCTAssertNil(error, @"Error is supposed to be nil, not '%@'", error);
         XCTAssertNotNil(returnedContacts, @"Returned contacts shouldn't be nil");
         XCTAssertEqual(returnedContacts.entries.count, mockedList.entries.count, @"Number of returned contacts '%lu' not the same as '%lu'", (unsigned long)returnedContacts.entries.count, mockedList.entries.count);
         // can't directly compare with isEqualToArray
         for (NSUInteger index = 0; index < returnedContacts.entries.count; ++index)
         {
             XCTAssert([mockedList.entries[index].contactString isEqualToString:returnedContacts.entries[index].contactString], @"Contact string '%@' in returned array is not the same as '%@' at index '%lu'", returnedContacts.entries[index].contactString, mockedList.entries[index].contactString, index);
         }
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil not '%@', otherwise the message handler was never invoked", error);
     }];
}

@end
