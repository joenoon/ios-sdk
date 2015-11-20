//
//  YesGraphSDKCacheContactSourceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
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
    [self.cacheSource setMockedFilePath:@"TestCache.plist"];
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
             XCTAssertEqual(contactList.entries.count, list.entries.count, @"Count of fetched list '%lu' isn't the same as expected '%lu'", (unsigned long)contactList.entries.count, (unsigned long)list.entries.count);
             for (NSUInteger index = 0; index < list.entries.count; ++index)
             {
                 NSString *gotString = contactList.entries[index].contactString;
                 NSString *expectedString = list.entries[index].contactString;
                 
                 if (gotString && expectedString)
                 {
                     XCTAssert([gotString isEqualToString:expectedString], @"Expected contact string '%@' but got '%@'", expectedString, gotString);
                 }
                 
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

- (void)testCacheContactSourceFileNotExist
{
    NSString *directoryPath = [[self.cacheSource filePath] stringByDeletingLastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err = nil;
    [fileManager removeItemAtPath:directoryPath error:&err];
    XCTAssertNil(err, @"There shouldn't be any errors while removing directory at path '%@'", directoryPath);
    
    {
        BOOL isDirectory;
        BOOL exists = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
        XCTAssert(!(isDirectory || exists), @"The directory shouldn't exist at path '%@' after it's been removed", directoryPath);
    }
    [self.cacheSource updateCacheWithContactList:[YSGTestMockData mockContactList] completion:nil];
    
    {
        BOOL isDirectory;
        BOOL exists = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
        XCTAssert(isDirectory && exists, @"The directory shouldn exist at path '%@' after the cache list has been updated", directoryPath);
    }
}

@end
