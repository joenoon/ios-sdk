//
//  YSGLogger.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 08/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGLoggingConstants.h"

@class YSGLog;

/*!
 *  <#Description#>
 */

NS_ASSUME_NONNULL_BEGIN

@interface YSGLogger : NSObject

@property (nonatomic, assign) YSGLogLevel currentLogLevel;

@property (nonnull, nonatomic, readonly) NSArray <YSGLog *>* logs;

+ (nonnull instancetype)shared;

- (void)addLog:(nonnull YSGLog *)log;

#pragma mark - Convenience API's

+ (void)logLevel:(YSGLogLevel)level file:(const char * _Nonnull)file function:(const char  * _Nonnull )function line:(NSUInteger)line format:(nonnull NSString *)format, ...;

/*!
 *  Method should be called when error is being logged
 *
 *  @param error to be logged
 */
+ (void)logError:(nonnull NSError *)error file:(const char *_Nonnull )file function:(const char  * _Nonnull )function line:(NSUInteger)line;

@end

NS_ASSUME_NONNULL_END
