//
//  YSGPointerPair.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 06/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface YSGPointerPair : NSObject

@property (strong, nonatomic) id item1;
@property (strong, nonatomic) id item2;

- (instancetype)initWith:(id)item1 and:(id)item2;

@end

NS_ASSUME_NONNULL_END