//
//  YSGStubRequestsScoped.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 01/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGStubRequestsScoped.h"

@implementation YSGStubRequestsScoped

+ (instancetype _Nullable)StubWithRequestBlock:(BOOL(^ _Nullable)(NSURLRequest * _Nonnull request))reqBlock andStubResponseBlock:(OHHTTPStubsResponse *_Nonnull(^ _Nullable)(NSURLRequest *_Nonnull request))respBlock
{
    return [[YSGStubRequestsScoped alloc] initWithStubRequestBlock:reqBlock andStubResponseBlock:respBlock];
}


- (instancetype _Nullable)initWithStubRequestBlock:(BOOL(^ _Nullable)(NSURLRequest * _Nonnull request))reqBlock andStubResponseBlock:(OHHTTPStubsResponse *_Nonnull(^ _Nullable)(NSURLRequest *_Nonnull request))respBlock
{
    if (self = [super init])
    {
        [OHHTTPStubs stubRequestsPassingTest:reqBlock withStubResponse:respBlock];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"Removing stubs");
    [OHHTTPStubs removeAllStubs];
}

@end
