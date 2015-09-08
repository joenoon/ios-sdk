//
//  YSGLoggingConstants.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 08/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YSGLogLevel)
{
    YSGLogLevelNone = 0,
    YSGLogLevelError = 1,
    YSGLogLevelWarning = 2,
    YSGLogLevelInfo = 3,
    YSGLogLevelDebug = 4,
    YSGLogLevelTrace = 5
};

NSString* YSGLogLevelString (YSGLogLevel level);

NS_ASSUME_NONNULL_END
