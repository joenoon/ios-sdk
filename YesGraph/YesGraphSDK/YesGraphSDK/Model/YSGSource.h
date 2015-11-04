//
//  YSGSource.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGParsing.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 *  Represents a contact source
 */
@interface YSGSource : YSGParsableModel <YSGParsable>

@property (nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *phone;

// Do not modify
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END