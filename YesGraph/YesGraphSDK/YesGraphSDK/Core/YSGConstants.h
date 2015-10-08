//
//  YSGConstants.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 21/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGMacros.h"

#pragma mark - Errors

NS_ASSUME_NONNULL_BEGIN

YSG_EXTERN NSString *const YSGErrorDomain;

typedef NS_ENUM(NSInteger, YSGErrorCode)
{
    /*!
     *  Error code for any error that is not expected.
     */
    YSGErrorCodeUnknown = 0,
    
    /*!
     *  Error code for network being offline.
     */
    YSGErrorCodeNetwork,
    
    /*!
     *  Error code for server issues.
     */
    YSGErrorCodeServer,
    
    /*!
     *  Error code for parsing data.
     */
    YSGErrorCodeParse,
    
    /*!
     *  Error code when device is not capable of sending a message.
     */
    YSGErrorCodeInviteMessageUnavailable,
    
    /*!
     *  Error code when device is not capable of sending an email.
     *
     *  @discussion This happens if there are no email accounts set up on the device.
     */
    YSGErrorCodeInviteMailUnavailable,
    
    /*!
     *  Error code when device failed to send a message.
     */
    YSGErrorCodeInviteMessageFailed,
    
    /*!
     *  Error code when device failed to send an email.
     */
    YSGErrorCodeInviteMailFailed,
    
    /*!
     *  Error code when cache fails to read from file system
     */
    YSGErrorCodeCacheReadFailure,
    
    /*!
     *  Error code when cache fails to write file to system
     */
    YSGErrorCodeCacheWriteFailure
};

YSG_EXTERN NSString *const YSGErrorNetworkStatusCodeKey;

typedef void (^YSGErrorHandlerBlock)(NSError *error);
typedef void (^YSGMessageHandlerBlock)(NSString *message, NSDictionary * _Nullable userInfo);

YSG_EXTERN NSError* YSGErrorWithErrorCode (YSGErrorCode errorCode);
YSG_EXTERN NSError* YSGErrorWithErrorCodeWithError (YSGErrorCode errorCode, NSError *underlyingError);
YSG_EXTERN NSString* YSGLocalizedErrorDescriptionForErrorCode (YSGErrorCode errorCode);

#pragma mark - Network

YSG_EXTERN NSString *const YSGClientAPIURL;

#pragma mark - Default Values

YSG_EXTERN NSUInteger const YSGDefaultInviteNumberOfSuggestions;
//YSG_EXTERN NSString *const YSGDefaultContactAccessPromptMessage;
YSG_EXTERN NSTimeInterval const YSGDefaultContactBookTimePeriod;

NS_ASSUME_NONNULL_END
