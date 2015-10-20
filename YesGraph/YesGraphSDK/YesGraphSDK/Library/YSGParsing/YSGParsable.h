//
//  YSGParsable.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 26/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

@protocol YSGParsable <NSSecureCoding, NSObject>

@optional

+ (NSDictionary *)ysg_mapping;
+ (NSDictionary *)ysg_defaultPropertyValues;

@end
