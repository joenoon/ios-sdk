//
//  YSGOnlineContactSource.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 25/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGContactSource.h"

@interface YSGOnlineContactSource : NSObject <YSGContactSource>

/*!
 *  Base source is used when online YesGraph address book entries are not available
 */
@property (nonnull, nonatomic, readonly) id<YSGContactSource> baseSource;

- (nonnull instancetype)initWithBaseSource:(nonnull id<YSGContactSource>)baseSource;

@end
