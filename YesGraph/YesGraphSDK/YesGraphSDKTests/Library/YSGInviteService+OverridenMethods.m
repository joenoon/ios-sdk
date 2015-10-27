//
//  YSGInviteService+OverridenMethods.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 26/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGInviteService+OverridenMethods.h"

static TriggeredHandler _triggeredForEmailContacts;
static TriggeredHandler _triggeredForPhoneContacts;

@implementation YSGInviteService (OverridenMethods)

- (TriggeredHandler)triggeredForEmailContacts
{
    return _triggeredForEmailContacts;
}

- (TriggeredHandler)triggeredPhoneContacts
{
    return _triggeredForPhoneContacts;
}

- (void)setTriggeredPhoneContacts:(TriggeredHandler)triggeredPhoneContacts
{
    _triggeredForPhoneContacts = triggeredPhoneContacts;
}

- (void)setTriggeredForEmailContacts:(TriggeredHandler)triggeredForEmailContacts
{
    _triggeredForEmailContacts = triggeredForEmailContacts;
}

- (void)triggerEmailWithContacts:(NSArray <YSGContact *> *)entries
{
    if (self.triggeredForEmailContacts)
    {
        self.triggeredForEmailContacts(entries);
    }
}

- (void)triggerMessageWithContacts:(NSArray <YSGContact *> *)entries
{
    if (self.triggeredPhoneContacts)
    {
        self.triggeredPhoneContacts(entries);
    }
}

@end
