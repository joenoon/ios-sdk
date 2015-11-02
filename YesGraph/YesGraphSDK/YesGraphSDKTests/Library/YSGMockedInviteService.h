//
//  YSGMockedInviteService.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 02/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <YesGraphSDK/YesGraphSDK.h>

@interface YSGMockedInviteService : YSGInviteService

- (instancetype)initWithContactSource:(id<YSGContactSource>)contactSource;

@end
