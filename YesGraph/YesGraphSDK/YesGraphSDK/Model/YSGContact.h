//
//  YSGContact.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGParsing.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 *  Represents a single Address Book contact
 */
@interface YSGContact : YSGParsableModel <YSGParsable>

@property (nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSArray<NSString *> *emails;
@property (nullable, nonatomic, copy) NSArray<NSString *> *phones;
@property (nullable, nonatomic, copy) NSDictionary *data;

- (nullable NSString *)phone;
- (nullable NSString *)email;

/*!
 *  Returns contact string based on email or phone, defaulting to phone
 *
 *  @return string with at least one contact
 */
- (nullable NSString *)contactString;

/*!
 *  Returns sanitized name of the contact for searching
 *
 *  @return name
 */
- (NSString *)sanitizedName;

/*!
 *  Returns YES, if the contact was suggested in the past
 *
 *  @return YES if contact was already suggested in the past
 */
- (BOOL)wasSuggested;

/*!
 *  Sets (marks) contact as suggested
 *
 *  @param suggested
 */
- (void)setSuggested:(BOOL)suggested;

@end

NS_ASSUME_NONNULL_END
