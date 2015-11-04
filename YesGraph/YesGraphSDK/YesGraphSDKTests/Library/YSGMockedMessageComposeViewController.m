//
//  YSGMockedMessageComposeViewController.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 03/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGMockedMessageComposeViewController.h"

static BOOL _canSend = NO;

@implementation YSGMockedMessageComposeViewController

+ (void)setCanSendText:(BOOL)canSend
{
    _canSend = canSend;
}

+ (BOOL)canSendText
{
    return _canSend;
}

@end
