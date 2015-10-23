//
//  YesGraphSDKCacheContactSourceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGCacheContactSource.h"
#import "YSGCacheContactSource+MockedFilePath.h"
#import "YSGTestMockData.h"

@interface YesGraphSDKCacheContactSourceTests : XCTestCase
@property (strong, nonatomic) YSGCacheContactSource *cacheSource;
@end

@implementation YesGraphSDKCacheContactSourceTests

- (void)setUp
{
    [super setUp];
    self.cacheSource = [YSGCacheContactSource new];
    self.cacheSource.filePath = @"TestCache.plist";
    [self cleanUpFile];
}

- (void)cleanUpFile
{
    NSString *filePath = self.cacheSource.filePath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSError *err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&err];
        XCTAssertNil(err, @"There was an error cleaning up existing cache file ('%@'): '%@'", filePath, err);
    }
}

- (void)tearDown
{
    [super tearDown];
    self.cacheSource.filePath = nil;
    self.cacheSource = nil;
}

- (void)addContactsToCache
{
    __weak YesGraphSDKCacheContactSourceTests *preventRetainCycle = self;
    [preventRetainCycle.cacheSource updateCacheWithContactList:[YSGTestMockData mockContactList] completion:^(NSError * _Nullable error)
    {
        XCTAssertNil(error, @"Error should be nil, not '%@'", error);
    }];
}

- (void)checkFetchCachedListAgainst:(YSGContactList *)list
{
    __weak YesGraphSDKCacheContactSourceTests *preventRetainCycle = self;
    [preventRetainCycle.cacheSource fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error)
     {
         if (list)
         {
             XCTAssertNil(error, @"Error should be nil, not '%@'", error);
             XCTAssertNotNil(contactList, @"Contact list shouldn't be nil, expected: '%@'", list);
             XCTAssertEqual(contactList.entries.count, list.entries.count, @"Count of fetched list '%lu' isn't the same as expected '%lu'", contactList.entries.count, list.entries.count);
             for (NSUInteger index = 0; index < list.entries.count; ++index)
             {
                 NSString *gotString = contactList.entries[index].contactString;
                 NSString *expectedString = list.entries[index].contactString;
                 XCTAssert([gotString isEqualToString:expectedString], @"Expected contact string '%@' but got '%@'", expectedString, gotString);
             }
         }
         else
         {
             XCTAssertNil(contactList, @"Expected a nil contact list, but fetched: '%@'", contactList);
             XCTAssertNotNil(error, @"Error shouldn't be nil");
         }
         [preventRetainCycle addContactsToCache];
     }];
}

- (void)testCacheSource
{
    [self checkFetchCachedListAgainst:nil];
    [self addContactsToCache];
    [self checkFetchCachedListAgainst:[YSGTestMockData mockContactList]];
}

- (void)testCacheSourceWithoutCompletion
{
    [self cleanUpFile];
    [self.cacheSource fetchContactListWithCompletion:nil];
}

@end
