//
//  YSGLoggingMacros.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 08/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#pragma mark - Logging Macros

#define YSG_LEVEL_LOG(level, levelString, fmt, ...) [YSGLogger logLevel:level file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ format:fmt, ##__VA_ARGS__];
#define YSG_LOG_ERROR(error) [YSGLogger logError file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__

#define YSG_LTRACE(fmt, ...) YSG_LEVEL_LOG(UALogLevelTrace, fmt, ##__VA_ARGS__)
#define YSG_LDEBUG(fmt, ...) YSG_LEVEL_LOG(UALogLevelDebug, fmt, ##__VA_ARGS__)
#define YSG_LINFO(fmt, ...) YSG_LEVEL_LOG(UALogLevelInfo, fmt, ##__VA_ARGS__)
#define YSG_LWARN(fmt, ...) YSG_LEVEL_LOG(UALogLevelWarn, fmt, ##__VA_ARGS__)
#define YSG_LERR(fmt, ...) YSG_LEVEL_LOG(UALogLevelError, fmt, ##__VA_ARGS__)