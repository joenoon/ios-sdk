//
//  YSGCacheContactSource+MockedFilePath.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 23/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGCacheContactSource+MockedFilePath.h"

static NSString *mockedFilePath = nil;

@implementation YSGCacheContactSource (MockedFilePath)

- (NSString *)filePath
{
    return [NSString stringWithFormat:@"%@/%@", self.cacheDirectory, mockedFilePath];
}

- (void)setFilePath:(NSString *)filePath
{
    mockedFilePath = filePath;
}

@end
