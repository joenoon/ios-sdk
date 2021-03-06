//
//  YSGConstants.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 21/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGConstants.h"

NSString *const YSGErrorDomain                          = @"YSGErrorDomain";
NSString *const YSGErrorNetworkStatusCodeKey            = @"YSGErrorNetworkStatusCodeKey";

NSUInteger const YSGDefaultInviteNumberOfSuggestions           = 5;

NSString *const YSGClientAPIURL                         = @"https://api.yesgraph.com/v0/";

static NSString *YSGDefaultContactAccessPromptMessage    = nil;

NSTimeInterval const YSGDefaultContactBookTimePeriod    = (60.0 * 60.0) * 24.0; // 60 seconds in 60 minutes * 24 hours


#pragma mark - Global Error Functions

NSError* YSGErrorWithErrorCode (YSGErrorCode errorCode)
{
    return [NSError errorWithDomain:YSGErrorDomain code:errorCode userInfo:@{ NSLocalizedDescriptionKey : YSGLocalizedErrorDescriptionForErrorCode(errorCode) }];
}

NSError* YSGErrorWithErrorCodeWithError (YSGErrorCode errorCode, NSError *error)
{
    return [NSError errorWithDomain:YSGErrorDomain code:errorCode userInfo:@{ NSLocalizedDescriptionKey : YSGLocalizedErrorDescriptionForErrorCode(errorCode), NSUnderlyingErrorKey : error }];
}

NSString* YSGLocalizedErrorDescriptionForErrorCode (YSGErrorCode errorCode)
{
    switch (errorCode)
    {
        case YSGErrorCodeInviteMessageUnavailable:
            return NSLocalizedString(@"Native Message Composer is unable to send text messages.", @"");
        case YSGErrorCodeInviteMailUnavailable:
            return NSLocalizedString(@"Native Mail Composer is unable to send text messages.", @"");
        default:
            return NSLocalizedString(@"Unknown error", @"");
    }
}