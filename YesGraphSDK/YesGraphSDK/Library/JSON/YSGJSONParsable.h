//
//  YSGJSONParsable.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 20/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

@protocol YSGJSONParsable <NSObject>

- (instancetype _Nonnull)initWithDictionary:(NSDictionary * _Nonnull) error:(NSError ** _Nullable)error;

@end
