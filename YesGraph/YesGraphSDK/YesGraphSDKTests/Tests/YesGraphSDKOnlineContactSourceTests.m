//
//  YesGraphSDKOnlineContactSourceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGMockClient.h"
#import "YSGOnlineContactSource.h"
#import "YSGCacheContactSource.h"
#import "YSGLocalContactSource+OverrideContactStore.h"
#import "YSGTestMockData.h"
#import "YSGTestSettings.h"

@interface YesGraphSDKOnlineContactSourceTests : XCTestCase
@property (strong, nonatomic) YSGLocalContactSource *localSource;
@property (strong, nonatomic) YSGCacheContactSource *cacheSource;
@end

@implementation YesGraphSDKOnlineContactSourceTests

- (void)setUp
{
    [super setUp];
    self.localSource = [YSGLocalContactSource new];
    self.cacheSource = [YSGCacheContactSource new];
    // we'll empty the existing cache so we can monitor the changes
    [self.cacheSource updateCacheWithContactList:[YSGContactList new] completion:nil];
    [YSGLocalContactSource shouldReturnNil:YES];
}

- (void)tearDown
{
    [super tearDown];
    [self.cacheSource updateCacheWithContactList:[YSGContactList new] completion:nil];
}

- (void)testFetchContactListFailure
{
    // we don't want any network operation to succeed in this case (updateAddressBook shouldn't be called
    // when expected list has 0 entries)
    YSGMockClient *mockedClient = [YSGMockClient createMockedClient:NO];
    
    YSGOnlineContactSource *onlineSource = [[YSGOnlineContactSource alloc] initWithClient:mockedClient localSource:self.localSource cacheSource:self.cacheSource];
    __weak YSGOnlineContactSource *preventRetainCycleInstance = onlineSource;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Failure Fetch Online Contact List"];

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

- (void)testFetchConctactListSuccess
{
    YSGMockClient *mockedClient = [YSGMockClient createMockedClient:NO];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Fetch Online Contact List"];
    __weak YSGContactList *expectedContactsList = [YSGTestMockData mockContactList];
    [self.cacheSource updateCacheWithContactList:expectedContactsList completion:^(NSError * _Nullable err)
    {
        XCTAssertNil(err, @"Error encountered while updating local cache: '%@'", err);
        YSGOnlineContactSource *onlineSource = [[YSGOnlineContactSource alloc] initWithClient:mockedClient localSource:self.localSource cacheSource:self.cacheSource];
        __weak YSGOnlineContactSource *preventRetainCycleInstance = onlineSource;
        
        [preventRetainCycleInstance fetchContactListWithCompletion:^(YSGContactList *returnedContacts, NSError *error)
         {
             XCTAssertNil(error, @"Error is supposed to be nil, not '%@'", error);
             XCTAssertEqual(returnedContacts.entries.count, expectedContactsList.entries.count, @"Returned contacts should contain '%lu' entries, not '%lu'", (unsigned long)expectedContactsList.entries.count, (unsigned long)returnedContacts.entries.count);
             [expectation fulfill];
         }];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil not '%@', otherwise the message handler was never invoked", error);
     }];
}

- (void)testUpdateShownSuggestions
{
    __weak YSGContactList *mockedList = [YSGTestMockData mockContactList];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Update Online Contact List"];
    YSGMockClient *mockedClient = [YSGMockClient createMockedClient:YES];
    mockedClient.completionHandler = ^(NSArray <YSGContact *> *contactList, NSString *userId, ErrorCompletion completion)
     {
         XCTAssertEqual(mockedList.entries.count, contactList.count, @"The received entries list '%@' is not the same length as '%@'", contactList, mockedList.entries);
         XCTAssertNotNil(completion, @"Completion handler block shouldn't be nil");
         completion(nil);
         
         [self.cacheSource fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error)
         {
             XCTAssertEqual(contactList.entries.count, mockedList.entries.count, @"All the contacts should have the property 'wasSuggested' set to YES, result was '%lu' out of '%lu'", (unsigned long)contactList.entries.count, (unsigned long)mockedList.entries.count);
             [expectation fulfill];
         }];
     };
    YSGOnlineContactSource *onlineSource = [[YSGOnlineContactSource alloc] initWithClient:mockedClient localSource:self.localSource cacheSource:self.cacheSource];

    __weak YSGOnlineContactSource *preventRetainCycleInstance = onlineSource;

    [preventRetainCycleInstance updateShownSuggestions:mockedList.entries contactList:mockedList];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil not '%@', otherwise the message handler was never invoked", error);
     }];
}


@end
