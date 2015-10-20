//
//  YSGLog.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 08/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGParsing.h"
#import "YSGLoggingConstants.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 *  An object represents a single logged line
 */
@interface YSGLog : YSGParsableModel <YSGParsable>

@property (nonatomic, assign) YSGLogLevel level;
@property (nonatomic, copy) NSString *file;
@property (nonatomic, copy) NSString *function;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSDictionary *userInfo;

@property (nonatomic, assign) NSUInteger line;

- (void)print;

@end

NS_ASSUME_NONNULL_END