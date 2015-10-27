//
//  YSGInviteService+OverridenMethods.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 26/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGInviteService.h"

typedef void (^TriggeredHandler)(NSArray <YSGContact *> *contacts);

@interface YSGInviteService (OverridenMethods)

@property (strong, nonatomic) TriggeredHandler triggeredForEmailContacts;
@property (strong, nonatomic) TriggeredHandler triggeredPhoneContacts;

@end
