//
//  NSObject+YSGJSONParsable.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 20/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

@interface NSObject (YSGJSONParsable)

- (instancetype _Nonnull)initWithDictionary:(NSDictionary * _Nonnull)dictionary;
- (instancetype _Nonnull)initWithDictionary:(NSDictionary * _Nonnull)dictionary error:(NSError ** _Nullable)error;

- (NSDictionary * _Nonnull)toDictionary;

@end
