//
//  YSGMockedInviteService.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 02/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGMockedInviteService.h"
#import "YSGMockedOnlineContactSource.h"

@implementation YSGMockedInviteService

- (instancetype)initWithContactSource:(id<YSGContactSource>)contactSource;
{
    self = [super initWithContactSource:contactSource userId:nil];
    self.numberOfSuggestions = 1;
    return self;
}

@end
