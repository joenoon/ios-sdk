//
//  YSGMockClient.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
#import "YSGClient.h"

@class YSGContact;

@interface YSGMockClient : YSGClient

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic) BOOL shouldSucceed;

typedef void (^ErrorCompletion)(NSError * _Nullable error);
typedef void (^MockUpdateCompletionHandler)(NSArray <YSGContact *> * suggestionsShown, NSString * userId, ErrorCompletion _Nullable completion);
@property (copy, nonatomic) MockUpdateCompletionHandler _Nullable completionHandler;

+ (instancetype)createMockedClient:(BOOL)shouldSucceed;

NS_ASSUME_NONNULL_END

@end
