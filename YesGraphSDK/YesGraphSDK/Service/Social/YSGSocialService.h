//
//  YSGSocialService.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 26/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareService.h"

@interface YSGSocialService : YSGShareService

@property (nonatomic, readonly) BOOL isAvailable;

#pragma mark - Abstract Methods

@property (nonnull, nonatomic, readonly) NSString *serviceType;

@end
