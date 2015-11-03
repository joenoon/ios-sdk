//
//  YSGMockedMailComposeViewController.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 04/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGMockedMailComposeViewController.h"

static BOOL _canSend = NO;

@implementation YSGMockedMailComposeViewController

+ (void)setCanSendMail:(BOOL)canSend
{
    _canSend = canSend;
}

+ (BOOL)canSendMail
{
    return _canSend;
}

@end
