//
//  YSGUtility.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 11/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/*!
 *  Utility methods used throughout the SDK
 */
@interface YSGUtility : NSObject

/*!
 *  Returns random User ID
 */
+ (NSString *)randomUserId;

/*!
 *  This method can be used to format the provided NSDate into an iso8061 string
 *
 *  @param: date: NSDate instance that is to be formatted into an iso8061 string 
 */

+ (NSString * _Nullable)iso8061dateStringFromDate:(NSDate *)date;

/*!
 *  This method can be used to parse an iso8061 formatted string into a NSDate instance
 *
 *  @param: formattedDateString: an iso8061 formatted string that is to be parsed
 */

+ (NSDate * _Nullable)dateFromIso8061String:(NSString *)formattedDateString;

@end

NS_ASSUME_NONNULL_END
