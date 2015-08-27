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

@interface YSGOnlineContactSource : NSObject <YSGContactSource>

/*!
 *  Base source is used when online YesGraph address book entries are not available
 */
@property (nonnull, nonatomic, readonly) id<YSGContactSource> localSource;

- (nonnull instancetype)initWithClient:(nonnull YSGClient *)client localSource:(nonnull id<YSGContactSource>)localSource;

@end
