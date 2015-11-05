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

+ (void)setCanSendText:(BOOL)canSend
{
    _canSend = canSend;
}

+ (BOOL)canSendText
{
    return _canSend;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if (self.triggeredOnDismissed)
    {
        self.triggeredOnDismissed(completion != nil);
    }
    if (completion)
    {
        completion();
    }
}

@end
