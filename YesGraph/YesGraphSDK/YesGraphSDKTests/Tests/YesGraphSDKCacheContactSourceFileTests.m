//
//  YesGraphSDKCacheContactSourceFileTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 26/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGTestMockData.h"
#import "YSGCacheContactSource+ExposeFileProperties.h"

@interface YesGraphSDKCacheContactSourceFileTests : XCTestCase
@property (strong, nonatomic) YSGCacheContactSource *source;
@end

@implementation YesGraphSDKCacheContactSourceFileTests

- (void)setUp
{
    [super setUp];
    self.source = [YSGCacheContactSource new];
}

- (void)tearDown
{
    [super tearDown];
    self.source = nil;
}

- (void)testFilePath
{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *expectedFilePath = [NSString stringWithFormat:@"%@/%@", cachePath, @"com.yesgraph.contact/ContactListCache.plist"];
    XCTAssert([[self.source filePath] isEqualToString:expectedFilePath], @"File path '%@' is not the same as expected '%@'", [self.source filePath], expectedFilePath);
}

- (void)testLastUpdateDate
{
    YSGContactList *empty = [YSGContactList new];
    [self.source updateCacheWithContactList:empty completion:nil];
    
    NSDate *newDate = self.source.lastUpdateDate;
    [self.source updateCacheWithContactList:[YSGTestMockData mockContactList] completion:nil];
    XCTAssert(fabs([newDate timeIntervalSinceNow]) <= 5.f, @"There shouldn't be more than 5 seconds of difference between now and last modified time '%@'", newDate);
}

@end
