//
//  YSGConstants.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 21/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#pragma mark - Errors

extern NSString *const YSGErrorDomain;

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

extern NSString *const YSGErrorNetworkStatusCodeKey;

typedef void (^YSGErrorHandlerBlock)(NSError *error);