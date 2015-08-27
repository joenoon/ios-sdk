//
//  YSGClient.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGNetworkDefines.h"

/*!
 *  Provides direct API access to YesGraph API
 */
@interface YSGClient : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy, readonly) NSURL* baseURL;
@property (nonatomic, copy, nullable) NSString *clientKey;

+ (instancetype)shared;

NS_ASSUME_NONNULL_END

@end

@interface YSGClient (Request)

- (nullable NSURLSessionDataTask *)GET:(nonnull NSString *)path parameters:(nullable NSDictionary *)parameters completion:(nullable YSGNetworkRequestCompletion)completion;
- (nullable NSURLSessionDataTask *)POST:(nonnull NSString *)path parameters:(nullable NSDictionary *)parameters completion:(nullable YSGNetworkRequestCompletion)completion;
- (nullable NSURLSessionDataTask *)sendRequest:(nonnull NSURLRequest *)request completion:(nullable YSGNetworkRequestCompletion)completion;

- (nonnull NSURLRequest *)requestForMethod:(nonnull NSString *)method path:(nonnull NSString *)path parameters:(nullable NSDictionary *)parameters key:(nullable NSString *)key error:(NSError *__autoreleasing  __nullable * __nullable)error;

@end