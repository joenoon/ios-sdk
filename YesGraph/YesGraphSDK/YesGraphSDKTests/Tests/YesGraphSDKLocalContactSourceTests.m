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
#import "objc/runtime.h"

@interface YesGraphSDKLocalContactSourceTests : XCTestCase
@end

@implementation YesGraphSDKLocalContactSourceTests

- (void)setUp
{
    [super setUp];
    [self swizzleTheMethods];
}

- (void)tearDown
{   
    [super tearDown];
}

- (NSArray <YSGContact *> *)mockedContactListFromContacts:(NSError **)error
{
    error = nil;
    return [YSGTestMockData mockContactList].entries;
}

- (void)swizzleTheMethods
{
    {
        // we know the selector is in fact in the class, it's just not visible outside of the compilation unit
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        Method original = class_getInstanceMethod([YSGLocalContactSource class], @selector(contactListFromContacts:));
        #pragma clang diagnostic pop
        Method replacement = class_getInstanceMethod([self class], @selector(mockedContactListFromContacts:));
        method_exchangeImplementations(original, replacement);
    }
}

- (void)testFetchFonctactListWithCompletion
{
    YSGLocalContactSource *localSource = [YSGLocalContactSource new];
    __weak YSGContactList *mockedList = [YSGTestMockData mockContactList];
    __weak YSGLocalContactSource *preventRetainCycleInstance = localSource;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Fetch Contact List"];
    
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
