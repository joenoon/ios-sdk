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

// we have to dance around with the initializer, since [super init] will return nil if _canSend is set
// to NO...
- (instancetype)init
{
    BOOL send = _canSend;
    _canSend = YES;
    self = [super init];
    _canSend = send;
    return self;
}

+ (void)setCanSendMail:(BOOL)canSend
{
    _canSend = canSend;
}

+ (BOOL)canSendMail
{
    return _canSend;
}

@end
