//
//  YSGContact.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGJSONParsable.h"

/*!
 *  Represents a single Address Book contact
 */
@interface YSGContact : NSObject <YSGJSONParsable>

@property (nonnull, nonatomic, copy) NSString *name;
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

@end
