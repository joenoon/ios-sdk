//
//  YSGNetworkResponse.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

/*!
 *  Network response wrapper, similar to AFNetworking
 */
@interface YSGNetworkResponse : NSObject

/*!
 *  Data task that triggered response
 */
@property (nullable, nonatomic, readonly) NSURLSessionDataTask *dataTask;

/*!
 *  Error from backend or from parsing
 */
@property (nullable, nonatomic, readonly) NSError *error;

/*!
 *  Parsed object from JSON, if available
 */
@property (nullable, nonatomic, readonly) id responseObject;

- (nonnull instancetype)initWithDataTask:(nullable NSURLSessionDataTask *)dataTask data:(nullable NSData *)data NS_DESIGNATED_INITIALIZER;
@end
