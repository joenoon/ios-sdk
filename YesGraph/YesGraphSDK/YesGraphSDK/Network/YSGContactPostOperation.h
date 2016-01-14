//
//  YSGContactPostOperation.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 12/01/16.
//  Copyright © 2016 YesGraph. All rights reserved.
//

@import Foundation;
#import "YSGClient+AddressBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSGContactPostOperation : NSOperation

@property (strong, nonatomic) id responseObject;
@property (strong, nonatomic) NSError *responseError;

- (instancetype)initWithClient:(YSGClient *)client contactsList:(YSGContactList *)partialList andUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END