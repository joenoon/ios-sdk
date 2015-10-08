//
//  YSGClient+Private.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSGClient (Private)

- (void)fetchRandomClientKeyWithSecretKey:(NSString *)secretKey completion:(void (^)(NSString *clientKey, NSError *error))completion;

- (void)fetchClientKeyWithSecretKey:(NSString *)secretKey forUser:(NSString *)user completion:(void (^)(NSString *clientKey, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
