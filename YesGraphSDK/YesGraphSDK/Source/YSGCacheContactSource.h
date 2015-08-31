//
//  YSGCacheContactSource.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 31/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGContactSource.h"

/*!
 *  Cache contact source
 */
@interface YSGCacheContactSource : NSObject <YSGContactSource>

- (void)updateCacheWithContactList:(nonnull YSGContactList *)contactList completion:(nullable void (^)(NSError * _Nullable))completion;

@end
