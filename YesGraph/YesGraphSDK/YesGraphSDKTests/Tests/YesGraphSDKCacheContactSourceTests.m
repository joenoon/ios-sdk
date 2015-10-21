//
//  YesGraphSDKCacheContactSourceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGCacheContactSource.h"
#import "YSGTestMockData.h"
#import "objc/runtime.h"

@interface YesGraphSDKCacheContactSourceTests : XCTestCase

@end

@implementation YesGraphSDKCacheContactSourceTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

+ (YSGContactList *)mockedUnarchiveWithFile:(NSString *)filePath
{
    return [YSGTestMockData mockContactList];
}

+ (YSGContactList *)mockedEmptyUnarchiveWithFile:(NSString *)filePath
{
    return nil;
}

- (void)swizzleCachedUnarchiverWithEmpty:(BOOL)shouldBeEmpty
{
    Method original = class_getClassMethod([NSKeyedUnarchiver class], @selector(unarchiveObjectWithFile:));
    Method replaced;
    if (shouldBeEmpty)
    {
        replaced = class_getClassMethod([self class], @selector(mockedEmptyUnarchiveWithFile:));
    }
    else
    {
        replaced = class_getClassMethod([self class], @selector(mockedUnarchiveWithFile:));
    }
    method_exchangeImplementations(original, replaced);
}

- (void)testFetchWithNonEmpty
{
    [self swizzleCachedUnarchiverWithEmpty:NO];
    YSGCacheContactSource *cachedSource = [YSGCacheContactSource new];
    __weak YSGCacheContactSource *preventRetainCycleInstance = cachedSource;
    __weak YSGContactList *mockedList = [YSGTestMockData mockContactList];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Fetch Cached Contact List"];
    
    [preventRetainCycleInstance fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error) {
        XCTAssertNil(error, @"Error is supposed to be nil, not '%@'", error);
        XCTAssertNotNil(contactList, @"Returned contacts shouldn't be nil");
        XCTAssertEqual(contactList.entries.count, mockedList.entries.count, @"Number of returned contacts '%lu' not the same as '%lu'", (unsigned long)contactList.entries.count, mockedList.entries.count);
        // can't directly compare with isEqualToArray
        for (NSUInteger index = 0; index < contactList.entries.count; ++index)
        {
            XCTAssert([mockedList.entries[index].contactString isEqualToString:contactList.entries[index].contactString], @"Contact string '%@' in returned array is not the same as '%@' at index '%lu'", contactList.entries[index].contactString, mockedList.entries[index].contactString, index);
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil not '%@', otherwise the message handler was never invoked", error);
     }];
}

- (void)testFetchWithEmpty
{
    [self swizzleCachedUnarchiverWithEmpty:YES];
    YSGCacheContactSource *cachedSource = [YSGCacheContactSource new];
    __weak YSGCacheContactSource *preventRetainCycleInstance = cachedSource;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expect Fetch Cached Contact List"];
    
    [preventRetainCycleInstance fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error) {
        XCTAssertNotNil(error, @"Error is supposed to be nil, not '%@'", error);
        XCTAssertNil(contactList, @"Returned contacts shouldn't be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil not '%@', otherwise the message handler was never invoked", error);
     }];
}



@end
