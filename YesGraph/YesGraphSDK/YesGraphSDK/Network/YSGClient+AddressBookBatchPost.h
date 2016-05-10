//
//  YSGClient+BatchPost.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 11/01/16.
//  Copyright © 2016 YesGraph. All rights reserved.
//

@import Foundation;
#import "YSGClient.h"
#import "YSGClient+Private.h"
#import "YSGContactList.h"

static const NSUInteger YSGBatchCount = 500;

NS_ASSUME_NONNULL_BEGIN

@interface YSGClient (BatchPost)

- (void)updateAddressBookWithContactList:(YSGContactList *)contactList forUserId:(NSString *)userId completionWaitForFinish:(BOOL)waitForFinish completion:(nullable YSGNetworkFetchCompletion)completion;

@end

NS_ASSUME_NONNULL_END