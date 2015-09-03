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

YSG_EXTERN NSString *const YSGErrorDomain;

typedef NS_ENUM(NSInteger, YSGErrorCode)
{
    /*!
     *  Error code for any error that is not expected
     */
    YSGErrorCodeUnknown = 0,
    
    /*!
     *  Error code for network being offline
     */
    YSGErrorCodeNetwork,
    
    /*!
     *  Error code for server issues
     */
    YSGErrorCodeServer,
    
    /*!
     *  Error code for parsing data
     */
    YSGErrorCodeParse,
    
};

YSG_EXTERN NSString *const YSGErrorNetworkStatusCodeKey;

typedef void (^YSGErrorHandlerBlock)(NSError *error);

#pragma mark - Network

YSG_EXTERN NSString *const YSGClientAPIURL;

#pragma mark - Default Values

YSG_EXTERN NSUInteger const YSGDefaultInviteNumberOfSuggestions;
YSG_EXTERN NSString *const YSGDefaultContactAccessPromptMessage;
