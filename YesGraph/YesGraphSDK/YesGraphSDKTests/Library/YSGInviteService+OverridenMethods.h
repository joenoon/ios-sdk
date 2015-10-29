//
//  YSGInviteService+OverridenMethods.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 26/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGInviteService.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^TriggeredHandler)(NSArray <YSGContact *> *contacts);

@interface YSGInviteService (OverridenMethods)

@property (strong, nonatomic) TriggeredHandler triggeredForEmailContacts;
@property (strong, nonatomic) TriggeredHandler triggeredPhoneContacts;

@end

@interface YSGInviteService()

- (void)openInviteControllerWithController:(YSGShareSheetController *)viewController;

@end

NS_ASSUME_NONNULL_END
