//
//  YSGLoggingMacros.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 08/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#pragma mark - Logging Macros

#define YSG_LEVEL_LOG(level, fmt, ...) [YSGLogger logLevel:level file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ format:(fmt), ##__VA_ARGS__]

//
// Use the macros below to correctly log messages, they are sent to YSGLogger, where they are logged and retained,
// until they are handled by the server.
//

#define YSG_LERROR(error) [YSGLogger logError:error file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__]

#define YSG_LTRACE(fmt, ...) YSG_LEVEL_LOG(YSGLogLevelTrace, fmt, ##__VA_ARGS__)
#define YSG_LDEBUG(fmt, ...) YSG_LEVEL_LOG(YSGLogLevelDebug, fmt, ##__VA_ARGS__)
#define YSG_LINFO(fmt, ...) YSG_LEVEL_LOG(YSGLogLevelInfo, fmt, ##__VA_ARGS__)
#define YSG_LWARN(fmt, ...) YSG_LEVEL_LOG(YSGLogLevelWarning, fmt, ##__VA_ARGS__)
#define YSG_LERR(fmt, ...) YSG_LEVEL_LOG(YSGLogLevelError, fmt, ##__VA_ARGS__)