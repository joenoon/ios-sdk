//
//  YSGInviteService+OverridenMethods.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 26/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGInviteServiceOverridenMethods.h"
#import "YSGLocalContactSource.h"

@implementation YSGInviteServiceOverridenMethods

- (instancetype)init
{
    if ((self = [super init]))
    {
        self.triggerFakeImplementation = YES;
        self.contactSource = [YSGLocalContactSource new]; // so we won't send invites to the API
    }
    return self;
}

- (void)triggerEmailWithContacts:(NSArray <YSGContact *> *)entries
{
    if (!self.triggerFakeImplementation)
    {
        [super triggerEmailWithContacts:entries];
    }
    else if (self.triggeredForEmailContacts)
    {
        self.triggeredForEmailContacts(entries);
    }
}

- (void)triggerMessageWithContacts:(NSArray <YSGContact *> *)entries
{
    if (!self.triggerFakeImplementation)
    {
        [super triggerMessageWithContacts:entries];
    }
    else if (self.triggeredPhoneContacts)
    {
        self.triggeredPhoneContacts(entries);
    }
}

@end

static MFMailComposeViewController *_mailComposeViewController = nil;
static MFMessageComposeViewController *_messageComposeViewController = nil;

@implementation YSGInviteService (MockMessagingControllers)

- (void)setMailComposeViewController:(MFMailComposeViewController *)mailComposeViewController
{
    _mailComposeViewController = mailComposeViewController;
}

- (MFMailComposeViewController *)mailComposeViewController
{
    if (_mailComposeViewController)
    {
        return _mailComposeViewController;
    }
    return [MFMailComposeViewController new];
}

- (void)setMessageComposeViewController:(MFMessageComposeViewController *)messageComposeViewController
{
    _messageComposeViewController = messageComposeViewController;
}

- (MFMessageComposeViewController *)messageComposeViewController
{
    if (_messageComposeViewController)
    {
        return _messageComposeViewController;
    }
    return [MFMessageComposeViewController new];
}

- (BOOL)canSendText
{
    if (_messageComposeViewController)
    {
        return [[_messageComposeViewController class] canSendText];
    }
    return [MFMessageComposeViewController canSendText];
}

- (BOOL)canSendMail
{
    if (_mailComposeViewController)
    {
        return [[_mailComposeViewController class] canSendMail];
    }
    return [MFMailComposeViewController canSendMail];
}

@end