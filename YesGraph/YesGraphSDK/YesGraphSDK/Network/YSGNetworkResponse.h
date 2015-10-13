//
//  YSGNetworkResponse.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/*!
 *  Network response wrapper, similar to AFNetworking
 */
@interface YSGNetworkResponse : NSObject

/*!
 *  Data task that triggered response
 */
@property (nullable, nonatomic, readonly) NSURLSessionDataTask *dataTask;

/*!
 *  URL Response received from the server
 */
@property (nullable, nonatomic, readonly) NSURLResponse *response;

/*!
 *  Error from backend or from parsing
 */
@property (nullable, nonatomic, readonly) NSError *error;

/*!
 *  Parsed object from JSON, if available
 */
@property (nullable, nonatomic, readonly) id responseObject;

/*!
 *  Initializes network response based on received data and session task.
 *
 *  @discussion Designated Initializer
 *
 *  @param dataTask network task
 *  @param data     received data
 *
 *  @return instance of network response
 */
- (instancetype)initWithDataTask:(nullable NSURLSessionDataTask *)dataTask response:(nullable NSURLResponse *)response data:(nullable NSData *)data error:(nullable NSError *)error NS_DESIGNATED_INITIALIZER;

/*!
 *  Attempts to create a parsable object
 *
 *  @param class that conforms to YSGParsable protocol
 *
 *  @return instance of class if successful
 */
- (nullable id)responseObjectSerializedToClass:(Class)class;

@end

NS_ASSUME_NONNULL_END
