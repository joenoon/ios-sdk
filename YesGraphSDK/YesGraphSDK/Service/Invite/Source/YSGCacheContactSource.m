//
//  YSGCacheContactSource.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 31/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGConstants.h"
#import "YSGCacheContactSource.h"
#import "YSGContactList.h"

@interface YSGCacheContactSource ()

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation YSGCacheContactSource

#pragma mark - Getters and Setters

- (NSFileManager *)fileManager
{
    if (!_fileManager)
    {
        _fileManager = [NSFileManager defaultManager];
    }
    
    return _fileManager;
}

- (NSDate *)lastUpdateDate
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self filePath] error:nil];
    
    return attributes[NSFileModificationDate];
}

- (NSString *)cacheDirectory
{
    if (!_cacheDirectory)
    {
        NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        _cacheDirectory = cachePaths.firstObject;
    }
    
    return _cacheDirectory;
}

#pragma mark - Public Methods

- (void)updateCacheWithContactList:(YSGContactList *)contactList completion:(void (^)(NSError * _Nullable))completion
{
    NSString* path = [self filePath];
    
    NSString* directory = [path stringByDeletingLastPathComponent];
    
    BOOL isDirectory;
    
    if (![self.fileManager fileExistsAtPath:directory isDirectory:&isDirectory])
    {
        [self.fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    BOOL archive = [NSKeyedArchiver archiveRootObject:contactList toFile:path];
    
    if (archive && completion)
    {
        completion (nil);
    }
    else if (completion)
    {
        completion(YSGErrorWithErrorCode(YSGErrorCodeCacheWriteFailure));
    }
}

- (void)fetchContactListWithCompletion:(void (^)(YSGContactList *, NSError *))completion
{
    if (!completion)
    {
        return;
    }
    
    YSGContactList *contactList = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
    contactList.useSuggestions = NO;
    
    if (contactList)
    {
        completion(contactList, nil);
    }
    else
    {
        completion(nil, YSGErrorWithErrorCode(YSGErrorCodeCacheReadFailure));
    }
}

#pragma mark - Private Methods

- (NSString *)filePath
{
    return [NSString stringWithFormat:@"%@/%@", self.cacheDirectory, @"com.yesgraph.contact/ContactListCache.plist"];
}

@end
