//
//  YSGFacebookService.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Social;

#import "YSGFacebookService.h"
#import "YSGIconDrawings.h"

@implementation YSGFacebookService

- (NSString *)name
{
    return @"Facebook";
}

- (UIColor *)backgroundColor
{
    return self.theme.facebookColor;
}

- (NSString *)serviceType
{
    return SLServiceTypeFacebook;
}

- (UIImage *)serviceImage
{
    return [YSGIconDrawings facebookImage];
}

@end
