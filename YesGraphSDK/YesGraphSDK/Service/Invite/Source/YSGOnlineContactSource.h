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

NS_ASSUME_NONNULL_BEGIN

@interface YSGOnlineContactSource : NSObject <YSGContactSource>

@property (nullable, nonatomic, copy) NSString *userId;

/*!
 *  Base source is used when online YesGraph address book entries are not available
 */
@property (nonatomic, readonly) id<YSGContactSource> localSource;

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
- (instancetype)initWithClient:(YSGClient *)client localSource:(id<YSGContactSource>)localSource cacheSource:(nullable YSGCacheContactSource *)cacheSource NS_DESIGNATED_INITIALIZER;
                                
@end

@class YSGContact;
                                
@interface YSGOnlineContactSource (SuggestionsSHown)

/*!
 *  Every time the suggestions list is shown, it is sent to the YesGraph API
 */
- (void)sendShownSuggestions:(NSArray <YSGContact *> *)contacts;

@end
                                
NS_ASSUME_NONNULL_END
