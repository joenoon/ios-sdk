//
//  NSObject+YSGCoding.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 31/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

@interface NSObject (YSGCoding)

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder;
+ (BOOL)supportsSecureCoding;

@end
