//
//  YSGStubRequestsScoped.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 01/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
@import OHHTTPStubs;

NS_ASSUME_NONNULL_BEGIN

#define GENERATE_STUB_ID() ([NSString stringWithFormat:@"%s_%s", __FILE__, __FUNCTION__])

@interface YSGStubRequestsScoped : NSObject

@property (strong, nonatomic) NSString * _Nullable stubID;

+ (instancetype _Nullable)StubWithID:(NSString *)stubID andRequestBlock:(BOOL(^ _Nullable)(NSURLRequest * _Nonnull request))reqBlock andStubResponseBlock:(OHHTTPStubsResponse *(^ _Nullable)(NSURLRequest * request))respBlock;

- (instancetype _Nullable)initWithStubID:(NSString *)stubID andRequestBlock:(BOOL(^ _Nullable)(NSURLRequest * _Nonnull request))reqBlock andStubResponseBlock:(OHHTTPStubsResponse *_Nonnull(^ _Nullable)(NSURLRequest *_Nonnull request))respBlock;

@end

NS_ASSUME_NONNULL_END