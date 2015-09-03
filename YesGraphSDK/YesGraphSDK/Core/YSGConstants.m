//
//  YSGConstants.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 21/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGConstants.h"

NSString *const YSGErrorDomain = @"YSGErrorDomain";
NSString *const YSGErrorNetworkStatusCodeKey = @"YSGErrorNetworkStatusCodeKey";

NSUInteger const YSGInviteNumberOfSuggestions = 5;

NSString *const YSGClientAPIURL = @"https://api.yesgraph.com/v0/";

NSString *const YSGDefaultContactAccessPromptMessage = @"Share contacts to invite friends?";

#pragma mark - Global Error Functions

NSError* YSGErrorWithErrorCode (YSGErrorCode errorCode)
{
    return [NSError errorWithDomain:YSGErrorDomain code:errorCode userInfo:@{ NSLocalizedDescriptionKey : YSGLocalizedErrorDescriptionForErrorCode(errorCode) }];
}

NSString* YSGLocalizedErrorDescriptionForErrorCode (YSGErrorCode errorCode)
{
    switch (errorCode)
    {
        case YSGErrorCodeInviteMessageUnavailable:
            return @"Native Message Composer is unable to send text messages.";
        case YSGErrorCodeInviteMailUnavailable:
            return @"Native Mail Composer is unable to send text messages.";
        default:
            return @"Unknown error";
    }
}