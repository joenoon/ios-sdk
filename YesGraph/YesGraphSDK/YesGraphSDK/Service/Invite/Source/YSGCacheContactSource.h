//
//  YSGCacheContactSource.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 31/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGContactSource.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 *  Cache contact source stores contact list in a local repository
 */
@interface YSGCacheContactSource : NSObject <YSGContactSource>

/*!
 *  Stores last update date
 */
@property (nonatomic, readonly) NSDate *lastUpdateDate;

/*!
 *  Location of YesGraph cache directory
 */
@property (nonatomic, copy) NSString *cacheDirectory;

/*!
 *  Updates locally stored contact list in cache
 *
 *  @param contactList to be stored
 *  @param completion  called when completed
 */
- (void)updateCacheWithContactList:(YSGContactList *)contactList completion:(nullable void (^)(NSError * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
