//
//  YSGLoggingConstants.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 08/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGLoggingConstants.h"

NS_ASSUME_NONNULL_BEGIN

NSString* YSGLogLevelString (YSGLogLevel level)
{
    switch (level)
    {
        case YSGLogLevelError:
            return @"Error";
        case YSGLogLevelWarning:
            return @"Warning";
        case YSGLogLevelInfo:
            return @"Info";
        case YSGLogLevelDebug:
            return @"Debug";
        case YSGLogLevelTrace:
            return @"Trace";
        default:
            return @"None";
    }
}

NS_ASSUME_NONNULL_END