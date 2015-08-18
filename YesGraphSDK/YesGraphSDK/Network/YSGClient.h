//
//  YSGClient.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGContact.h"
#import "YSGSource.h"

/*!
 *  Provides direct API access to YesGraph API
 */
@interface YSGClient : NSObject

+ (instancetype)shared;

- (void)updateAddressBookWithContactList:(NSArray <YSGContact *> * _Nonnull )contacts withSource:(YSGSource * _Nonnull)source completion:(void (^)(NSError *error))completion;

@end
