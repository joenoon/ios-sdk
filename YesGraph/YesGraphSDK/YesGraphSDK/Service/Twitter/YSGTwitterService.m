//
//  YSGTwitterService.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Social;

#import "YSGTwitterService.h"
#import "YSGIconDrawings.h"

@implementation YSGTwitterService

- (NSString *)name
{
    if ([super name])
    {
        return [super name];
    }
    else
    {
        return @"Twitter";
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
        return self.theme.twitterColor;
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
        return [YSGIconDrawings twitterImage];
    }
}

- (NSString *)serviceType
{
    return SLServiceTypeTwitter;
}

@end
