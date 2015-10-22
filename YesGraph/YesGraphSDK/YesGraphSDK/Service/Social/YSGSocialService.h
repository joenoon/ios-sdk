//
//  YSGSocialService.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 26/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareService.h"
#import "YSGTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSGSocialService : YSGShareService

@property (nonatomic, readonly) BOOL isAvailable;

#pragma mark - Abstract Methods

@property (nonatomic, readonly) NSString *serviceType;

@end

NS_ASSUME_NONNULL_END