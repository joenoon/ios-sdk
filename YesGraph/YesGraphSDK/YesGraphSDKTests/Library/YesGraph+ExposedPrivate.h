//
//  YesGraph+ExposedPrivate.h
//  YesGraphSDK
//
//  Created by Gasper Rebernak on 03/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YesGraph.h"
#import "YSGLocalContactSource.h"
#import "YSGCacheContactSource.h"

@interface YesGraph (ExposedPrivate)

@property (nonatomic, readwrite, copy) NSString *userId;
@property (nonatomic, readwrite, copy) NSString *clientKey;

@property (nonatomic, copy) NSDate* lastFetchDate;

- (YSGLocalContactSource *)localSource;
- (YSGCacheContactSource *)cacheSource;

@end
