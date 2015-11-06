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

@interface YSGInviteService (MockMessagingControllers)

@property (strong, nonatomic) MFMessageComposeViewController *messageComposeViewController;

@property (strong, nonatomic) MFMailComposeViewController *mailComposeViewController;

@end

@interface YSGInviteService()

@property (strong, nonatomic) UINavigationController *addressBookNavigationController;

@property (nonatomic, strong, readwrite) id<YSGContactSource> contactSource;

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, copy) NSArray <YSGContact *> *emailContacts;

@property (nonatomic, copy) NSArray <YSGContact *> *phoneContacts;

- (void)openInviteControllerWithController:(UIViewController *)viewController;

- (void)triggerMessageWithContacts:(NSArray<YSGContact *> *)entries;

- (void)triggerEmailWithContacts:(NSArray<YSGContact *> *)entries;

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
