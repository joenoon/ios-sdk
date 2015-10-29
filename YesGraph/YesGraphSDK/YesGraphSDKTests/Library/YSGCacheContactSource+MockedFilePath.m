//
//  YSGCacheContactSource+MockedFilePath.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 23/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGCacheContactSource+MockedFilePath.h"

@implementation YSGCacheContactSource (MockedFilePath)

@dynamic filePath;

- (void)setMockedFilePath:(NSString *)mockedFilePath
{
    self.filePath = [NSString stringWithFormat:@"%@/%@", self.cacheDirectory, mockedFilePath];
}

@end
