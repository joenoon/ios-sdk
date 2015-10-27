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
#import "YSGLocalContactSource+OverrideContactStore.h"
#import "YSGTestMockData.h"
#import "YSGTestSettings.h"
#import "objc/runtime.h"

@interface YesGraphSDKOnlineContactSourceTests : XCTestCase
@property (strong, nonatomic) YSGLocalContactSource *localSource;
@end

@implementation YesGraphSDKOnlineContactSourceTests

- (void)setUp
{
    [super setUp];
    self.localSource = [YSGLocalContactSource new];
    [YSGLocalContactSource shouldReturnNil:YES];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testFetchContactListSuccess
{
    YSGMockClient *mockedClient = [YSGMockClient createMockedClient:YES];
    YSGOnlineContactSource *onlineSource = [[YSGOnlineContactSource alloc] initWithClient:mockedClient localSource:self.localSource cacheSource:nil];

    __weak YSGContactList *mockedList = [YSGTestMockData mockContactList];
    __weak YSGOnlineContactSource *preventRetainCycleInstance = onlineSource;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Fetch Online Contact List"];

    [preventRetainCycleInstance fetchContactListWithCompletion:^(YSGContactList *returnedContacts, NSError *error)
     {
         XCTAssertNil(error, @"Error is supposed to be nil, not '%@'", error);
         XCTAssertNotNil(returnedContacts, @"Returned contacts shouldn't be nil");
         XCTAssertEqual(returnedContacts.entries.count, mockedList.entries.count, @"Number of returned contacts '%lu' not the same as '%lu'", (unsigned long)returnedContacts.entries.count, (unsigned long)mockedList.entries.count);
         // can't directly compare with isEqualToArray
         for (NSUInteger index = 0; index < returnedContacts.entries.count; ++index)
         {
             XCTAssert([mockedList.entries[index].contactString isEqualToString:returnedContacts.entries[index].contactString], @"Contact string '%@' in returned array is not the same as '%@' at index '%lu'", returnedContacts.entries[index].contactString, mockedList.entries[index].contactString, (unsigned long)index);
         }
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil not '%@', otherwise the message handler was never invoked", error);
     }];
}

- (void)testFetchContactListFailure
{
    YSGMockClient *mockedClient = [YSGMockClient createMockedClient:NO];
    YSGOnlineContactSource *onlineSource = [[YSGOnlineContactSource alloc] initWithClient:mockedClient localSource:self.localSource cacheSource:nil];

    __weak YSGOnlineContactSource *preventRetainCycleInstance = onlineSource;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Fetch Failure Online Contact List"];

    [preventRetainCycleInstance fetchContactListWithCompletion:^(YSGContactList *returnedContacts, NSError *error)
     {
         XCTAssertNil(error, @"Error is supposed to be nil, not '%@'", error);
         XCTAssertEqual(returnedContacts.entries.count, 0, @"Returned contacts should be empty");
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil not '%@', otherwise the message handler was never invoked", error);
     }];
}

- (void)testSendShownSuggestions
{
    __weak YSGContactList *mockedList = [YSGTestMockData mockContactList];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Update Online Contact List"];
    
    YSGMockClient *mockedClient = [YSGMockClient createMockedClient:YES];
    mockedClient.completionHandler = ^(NSArray <YSGContact *> *contactList, NSString *userId, ErrorCompletion completion)
     {
         XCTAssertEqual(mockedList.entries.count, contactList.count, @"The received entries list '%@' is not the same length as '%@'", contactList, mockedList.entries);
         XCTAssertNotNil(completion, @"Completion handler block shouldn't be nil");
         completion(nil);
         [expectation fulfill];
     };
    YSGOnlineContactSource *onlineSource = [[YSGOnlineContactSource alloc] initWithClient:mockedClient localSource:self.localSource cacheSource:nil];

    __weak YSGOnlineContactSource *preventRetainCycleInstance = onlineSource;

    [preventRetainCycleInstance sendShownSuggestions:mockedList.entries];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil not '%@', otherwise the message handler was never invoked", error);
     }];
}

@end
