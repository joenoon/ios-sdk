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
    return @"Tweet";
}

- (UIColor *)backgroundColor
{
    return self.theme.twitterColor;
}

- (NSString *)serviceType
{
    return SLServiceTypeTwitter;
}

- (UIImage *)serviceImage
{
    return [YSGIconDrawings twitterImage];
}

@end
