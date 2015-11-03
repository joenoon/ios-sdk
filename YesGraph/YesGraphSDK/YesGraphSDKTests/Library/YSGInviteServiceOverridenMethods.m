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
