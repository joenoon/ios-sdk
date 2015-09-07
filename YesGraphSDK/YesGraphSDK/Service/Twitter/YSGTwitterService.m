//
//  YSGTwitterService.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Social;

#import "YSGTwitterService.h"

@implementation YSGTwitterService

- (NSString *)name
{
    return @"Twitter";
}

- (NSString *)callToAction
{
    return @"Tweet";
}

- (UIColor *)color {
    
    return [UIColor colorWithRed:0.31 green:0.67 blue:0.95 alpha:1];
}

- (NSString *)serviceType
{
    return SLServiceTypeTwitter;
}

@end
