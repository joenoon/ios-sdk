//
//  YSGSource.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGSource.h"

@implementation YSGSource

+ (nonnull instancetype)userSource
{
    YSGSource *source = [[self alloc] init];
    
    source.type = @"ios";
    
    return source;
}

@end
