//
//  YSGStubRequestsScoped.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 01/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGStubRequestsScoped.h"

@implementation YSGStubRequestsScoped

+ (instancetype _Nullable)StubWithID:(NSString *)stubID andRequestBlock:(BOOL(^ _Nullable)(NSURLRequest * _Nonnull request))reqBlock andStubResponseBlock:(OHHTTPStubsResponse *(^ _Nullable)(NSURLRequest * request))respBlock
{
    return [[YSGStubRequestsScoped alloc] initWithStubID:stubID andRequestBlock:reqBlock andStubResponseBlock:respBlock];
}


- (instancetype _Nullable)initWithStubID:(NSString *)stubID andRequestBlock:(BOOL(^ _Nullable)(NSURLRequest * _Nonnull request))reqBlock andStubResponseBlock:(OHHTTPStubsResponse *_Nonnull(^ _Nullable)(NSURLRequest *_Nonnull request))respBlock
{
    if (self = [super init])
    {
        self.stubID = stubID;
        [OHHTTPStubs stubRequestsPassingTest:reqBlock withStubResponse:respBlock];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"Removing stubs");
    [OHHTTPStubs removeAllStubs];
    self.stubID = nil;
}

@end
