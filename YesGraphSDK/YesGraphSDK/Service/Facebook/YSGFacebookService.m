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

- (NSString *)callToAction
{
    return @"Share";
}

- (UIColor *)color
{
    return [UIColor colorWithRed:0.28 green:0.38 blue:0.64 alpha:1];
}

- (NSString *)serviceType
{
    return SLServiceTypeFacebook;
}

@end
