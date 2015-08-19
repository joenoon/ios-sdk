//
//  YSGContact.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

/*!
 *  Represents a single Address Book contact
 */
@interface YSGContact : NSObject

@property (nonnull, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSArray<NSString *> *emails;
@property (nullable, nonatomic, copy) NSArray<NSString *> *phones;
@property (nullable, nonatomic, copy) NSDictionary *data;

- (NSString *)phone;
- (NSString *)email;

/*!
 *  Returns contact string
 *
 *  @return <#return value description#>
 */
- (NSString *)contactString;

@end
