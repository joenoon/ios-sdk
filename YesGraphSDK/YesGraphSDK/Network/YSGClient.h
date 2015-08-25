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

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy, nullable) NSString *clientKey;

+ (instancetype)shared;

- (void)setupWithSecretKey:(NSString *)secretKey;

- (void)updateAddressBookWithContactList:(NSArray <YSGContact *> *)contacts withSource:(YSGSource *)source completion:(nullable void (^)(NSError *__nullable error))completion;

NS_ASSUME_NONNULL_END

@end
