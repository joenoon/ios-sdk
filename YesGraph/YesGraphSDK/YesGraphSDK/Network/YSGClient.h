//
//  YSGClient.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGNetworkDefines.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 *  Provides direct API access to YesGraph API
 */
@interface YSGClient : NSObject


@property (nonatomic, copy, readonly) NSURL* baseURL;
@property (nonatomic, copy, nullable) NSString *clientKey;

- (instancetype)initWithClientKey:(NSString *)clientKey;
- (instancetype)initWithBaseURL:(NSURL *)baseURL NS_DESIGNATED_INITIALIZER;


@end

@interface YSGClient (Request)

- (nullable NSURLSessionDataTask *)GET:(NSString *)path parameters:(nullable NSDictionary *)parameters completion:(nullable YSGNetworkRequestCompletion)completion;
- (nullable NSURLSessionDataTask *)POST:(NSString *)path parameters:(nullable NSDictionary *)parameters completion:(nullable YSGNetworkRequestCompletion)completion;
- (nullable NSURLSessionDataTask *)sendRequest:(NSURLRequest *)request completion:(nullable YSGNetworkRequestCompletion)completion;

- ( NSURLRequest *)requestForMethod:(NSString *)method path:(NSString *)path parameters:(nullable NSDictionary *)parameters key:(nullable NSString *)key error:(NSError *__autoreleasing  __nullable * __nullable)error;

@end

NS_ASSUME_NONNULL_END
