//
//  YesGraph+Private.h
//  YesGraphSDK
//
//  Created by Gasper Rebernak on 03/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YesGraph.h"
#import "YSGLocalContactSource.h"
#import "YSGCacheContactSource.h"

@interface YesGraph (Private)

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *clientKey;

@property (nonatomic, strong) YSGLocalContactSource *localSource;
@property (nonatomic, strong) YSGCacheContactSource *cacheSource;

@property (nonatomic, copy) NSDate* lastFetchDate;

@end
