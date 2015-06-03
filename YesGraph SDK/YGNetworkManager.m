//
//  YGNetworkManager.m
//  YesGraph SDK
//
//  Created by Contractor Erik on 6/3/15.
//  Copyright (c) 2015 YesGraph. All rights reserved.
//

#import "YGNetworkManager.h"

@implementation YGNetworkManager

+ (instancetype)sharedInstance {
    static dispatch_once_t dispatch_token;
    static YGNetworkManager *manager = nil;
    
    dispatch_once(&dispatch_token, ^{
        manager = [[YGNetworkManager alloc] init];
    });
    return manager;
}




@end
