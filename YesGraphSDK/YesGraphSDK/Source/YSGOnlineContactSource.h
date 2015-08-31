//
//  YSGOnlineContactSource.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 25/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGClient.h"
#import "YSGContactSource.h"
#import "YSGCacheContactSource.h"

@interface YSGOnlineContactSource : NSObject <YSGContactSource>

/*!
 *  Caches YesGraph response and uses cache if at the next call, server is not available.
 *
 *  @discussion Default: YES
 */
@property (nonatomic, assign) BOOL useCache;

/*!
 *  Base source is used when online YesGraph address book entries are not available
 */
@property (nonnull, nonatomic, readonly) id<YSGContactSource> localSource;

- (nonnull instancetype)initWithClient:(nonnull YSGClient *)client localSource:(nonnull id<YSGContactSource>)localSource cacheSource:(nullable YSGCacheContactSource *)cacheSource NS_DESIGNATED_INITIALIZER;

@end
