//
//  YSGFacebookService.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Social;

#import "YSGFacebookService.h"

@implementation YSGFacebookService

- (NSString *)name
{
    return @"Facebook";
    
}

- (NSString *)serviceType
{
    return SLServiceTypeFacebook;
}

@end
