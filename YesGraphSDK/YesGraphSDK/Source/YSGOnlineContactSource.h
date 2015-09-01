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
 *  Base source is used when online YesGraph address book entries are not available
 */
@property (nonnull, nonatomic, readonly) id<YSGContactSource> localSource;

/*!
 *  Default initializer is not available
 *
 *  @return nil
 */
- (nullable instancetype)init NS_UNAVAILABLE;

/*!
 *  Instantiate new online contact source
 *
 *  @param client      online client to connect
 *  @param localSource local backup source if cache and local source fail
 *  @param cacheSource optional source that caches online responses
 *
 *  @return instance
 */
- (nonnull instancetype)initWithClient:(nonnull YSGClient *)client localSource:(nonnull id<YSGContactSource>)localSource cacheSource:(nullable YSGCacheContactSource *)cacheSource NS_DESIGNATED_INITIALIZER;

@end
