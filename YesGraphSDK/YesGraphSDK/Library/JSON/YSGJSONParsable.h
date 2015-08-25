//
//  YSGJSONParsable.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 20/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

@protocol YSGJSONParsable <NSObject>

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary error:(NSError *__autoreleasing  __nullable * __nullable)error;

@end
