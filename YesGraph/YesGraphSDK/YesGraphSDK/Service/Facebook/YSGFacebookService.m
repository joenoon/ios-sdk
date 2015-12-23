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
    if ([super name])
    {
        return [super name];
    }
    else
    {
        return @"Facebook";
    }
}

- (UIColor *)backgroundColor
{
    if ([super backgroundColor])
    {
        return [super backgroundColor];
    }
    else
    {
        return self.theme.facebookColor;
    }
}

- (UIImage *)serviceImage
{
    if ([super serviceImage])
    {
        return [super serviceImage];
    }
    else
    {
        return [YSGIconDrawings facebookImage];
    }
}

- (NSString *)serviceType
{
    return SLServiceTypeFacebook;
}

@end
