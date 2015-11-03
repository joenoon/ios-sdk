//
//  YSGInviteService+OverridenMethods.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 26/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGInviteService.h"

@import MessageUI;

NS_ASSUME_NONNULL_BEGIN

typedef void (^TriggeredHandler)(NSArray <YSGContact *> *contacts);

@interface YSGInviteServiceOverridenMethods : YSGInviteService

@property (strong, nonatomic) TriggeredHandler triggeredForEmailContacts;
@property (strong, nonatomic) TriggeredHandler triggeredPhoneContacts;
@property (nonatomic) BOOL triggerFakeImplementation;

@end

@interface YSGInviteService()

@property (strong, nonatomic) MFMessageComposeViewController *messageComposeViewController;

@property (strong, nonatomic) MFMailComposeViewController *mailComposeViewController;

@property (strong, nonatomic) UINavigationController *addressBookNavigationController;

@property (nonatomic, strong, readwrite) id<YSGContactSource> contactSource;

@property (nonatomic, weak) YSGShareSheetController *viewController;

- (void)openInviteControllerWithController:(YSGShareSheetController *)viewController;

- (void)triggerMessageWithContacts:(NSArray<YSGContact *> *)entries;

- (void)triggerEmailWithContacts:(NSArray<YSGContact *> *)entries;

@end

NS_ASSUME_NONNULL_END
