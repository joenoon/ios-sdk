//
//  NSObject+YSGIntrospection.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 26/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

@interface NSObject (YSGIntrospection)

- (NSArray *)ysg_propertyNames;

- (Class)ysg_classForPropertyName:(NSString *)propertyName;

- (Class)ysg_swiftClassForName:(NSString *)name;

+ (NSDictionary *)ysg_swiftClassMapping;

@end
