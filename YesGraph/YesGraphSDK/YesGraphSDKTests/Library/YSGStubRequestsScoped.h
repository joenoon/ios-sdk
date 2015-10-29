//
//  YSGStubRequestsScoped.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 01/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
@import OHHTTPStubs;

@interface YSGStubRequestsScoped : NSObject

+ (instancetype _Nullable)StubWithRequestBlock:(BOOL(^ _Nullable)(NSURLRequest * _Nonnull request))reqBlock andStubResponseBlock:(OHHTTPStubsResponse *_Nonnull(^ _Nullable)(NSURLRequest *_Nonnull request))respBlock;

- (instancetype _Nullable)initWithStubRequestBlock:(BOOL(^ _Nullable)(NSURLRequest * _Nonnull request))reqBlock andStubResponseBlock:(OHHTTPStubsResponse *_Nonnull(^ _Nullable)(NSURLRequest *_Nonnull request))respBlock;

@end
