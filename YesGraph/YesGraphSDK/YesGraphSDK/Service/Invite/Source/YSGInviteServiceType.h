//
//  YSGInviteServiceType.h
//  YesGraphSDK
//
//  Created by Lea Marolt on 12/14/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#pragma once

typedef NS_ENUM(NSInteger, YSGInviteServiceType)
{
    /*!
     *  Display both phone & email contacts together
     */
    YSGInviteServiceTypeBoth,
    
    /*!
     *  Display only phone contacts
     */
    YSGInviteServiceTypeBothSeparate,

    /*!
     *  Display only phone contacts
     */
    YSGInviteServiceTypePhone,

    /*!
     *  Display only email ontacts
     */
    YSGInviteServiceTypeEmail
};

