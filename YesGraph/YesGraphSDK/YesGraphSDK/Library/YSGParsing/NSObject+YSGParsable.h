//
//  NSObject+YSGParsable.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 20/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

@interface NSObject (YSGParsable)

/*!
 *  Creates new object and fills property values from dictionary using KVO
 *
 *  @param dictionary JSON data
 *
 *  @return instance of object
 */
+ (nullable instancetype)ysg_objectWithDictionary:(nonnull NSDictionary *)dictionary;

/*!
 *  Creates new object and fills property values from dictionary using KVO
 *
 *  @param dictionary JSON data
 *  @param context    JSON payload
 *  @param error      pointer
 *
 *  @return instance of object
 */
+ (nullable instancetype)ysg_objectWithDictionary:(nonnull NSDictionary *)dictionary inContext:(nullable id)context;

/*!
 *  Creates new object and fills property values from dictionary using KVO
 *
 *  @param dictionary JSON data
 *  @param context    JSON payload
 *  @param error      pointer
 *
 *  @return instance of object
 */
+ (nullable instancetype)ysg_objectWithDictionary:(nonnull NSDictionary *)dictionary inContext:(nullable id)context error:(NSError *__autoreleasing  __nullable * __nullable)error;

/*!
 *  Returns dictionary of object properties and values
 *
 *  @return dictionary
 */
- (nullable NSDictionary *)ysg_toDictionary;

@end
