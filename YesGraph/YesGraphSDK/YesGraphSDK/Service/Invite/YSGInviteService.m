//
//  YSGInviteService.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import MessageUI;

#import "YSGConstants.h"
#import "YSGInviteService.h"
#import "YSGShareSheetController.h"
#import "YSGAddressBookViewController.h"
#import "YSGContactSource.h"
#import "YSGContact.h"
#import "YSGLocalContactSource.h"
#import "YSGCacheContactSource.h"
#import "YSGOnlineContactSource.h"
#import "YSGClient+Invite.h"
#import "YSGIconDrawings.h"
#import "UIAlertController+YSGDisplay.h"
#import "YSGTheme.h"
#import "YSGMessaging.h"


NSString *_Nonnull const YSGInvitePhoneContactsKey = @"YSGInvitePhoneContactsKey";
NSString *_Nonnull const YSGInviteEmailContactsKey = @"YSGInviteEmailContactsKey";
NSString *_Nonnull const YSGInviteEmailIsHTMLKey = @"YSGInviteEmailIsHTMLKey";

@interface YSGInviteService () <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong, readwrite) id<YSGContactSource> contactSource;
@property (nonatomic, strong, readwrite) NSString *userId;

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UINavigationController *addressBookNavigationController;

/*!
 *  This property stores email entries, if both should be handled
 */
@property (nonatomic, copy) NSArray <YSGContact *> *emailContacts;
@property (nonatomic, copy) NSArray <YSGContact *> *phoneContacts;

@end

@implementation YSGInviteService

- (NSString *)name
{
    if ([super name])
    {
        return [super name];
    }
    else
    {
        return @"Contacts";
    }
}

- (UIColor *)backgroundColor
{
    if ([super backgroundColor])
    {
        return [super backgroundColor];
    }
    else
    {
        return self.theme.mainColor;
    }
}

- (UIImage *)serviceImage
{
    if ([super serviceImage])
    {
        return [super serviceImage];
    }
    else
    {
        return [YSGIconDrawings phoneImage];
    }
}

- (MFMessageComposeViewController *)messageComposeViewController
{
    return [MFMessageComposeViewController new];
}

- (BOOL)canSendText
{
    return [MFMessageComposeViewController canSendText];
}

- (BOOL)canSendMail
{
    return [MFMailComposeViewController canSendMail];
}

- (MFMailComposeViewController *)mailComposeViewController
{
    return [MFMailComposeViewController new];
}

- (instancetype)init
{
    YSGOnlineContactSource *source = [[YSGOnlineContactSource alloc] initWithClient:[[YSGClient alloc] init] localSource:[YSGLocalContactSource new] cacheSource:[YSGCacheContactSource new]];
    return [self initWithContactSource:source userId:nil];
}

- (instancetype)initWithContactSource:(id<YSGContactSource>)contactSource userId:(nullable NSString *)userId
{
    self = [super init];
    
    if (self)
    {
        self.contactSource = contactSource;
        
        self.allowSearch = YES;
        
        self.nativeMessageSheet = YES;
        self.nativeEmailSheet = YES;
        
        self.inviteServiceType = YSGInviteServiceTypeBoth;
        
        self.userId = userId;
    }
    
    return self;
}

- (void)triggerServiceWithViewController:(UIViewController *)viewController
{
    [self.contactSource requestContactPermission:^(BOOL granted, NSError *error)
    {
        if (granted)
        {
            [self openInviteControllerWithController:viewController];
        }
        else if (error)
        {
            [[YSGMessageCenter shared] sendMessage: NSLocalizedString(@"Check contacts permissions in settings.", @"Check contacts permissions in settings.") userInfo:@{ YSGMessageAlertButtonArrayKey : @[ NSLocalizedString(@"Ok", @"Ok") ] }];
        }
    }];
}

- (void)openInviteControllerWithController:(nonnull UIViewController *)viewController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        YSGAddressBookViewController *addressBookViewController = [[YSGAddressBookViewController alloc] init];
    
        addressBookViewController.service = self;
        addressBookViewController.theme = self.theme;
    
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addressBookViewController];
        
        self.viewController = viewController;
        self.addressBookNavigationController = navigationController;
        
        if (self.viewController.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular
            && self.viewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular)
        {
            navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        }
        
        [viewController presentViewController:navigationController animated:YES completion:nil];
        
    });
}

- (void)triggerInviteFlowWithContacts:(NSArray<YSGContact *> *)entries
{
    //
    // Separate email and phone entries
    //
    
    self.emailContacts = nil;
    self.phoneContacts = nil;
    
    NSMutableArray <YSGContact *>* phoneContacts = [NSMutableArray array];
    NSMutableArray <YSGContact *>* emailContacts = [NSMutableArray array];
    
    for (YSGContact *contact in entries)
    {
        if (contact.emails.count)
        {
            [emailContacts addObject:contact];
        }
        else if (contact.phones.count)
        {
            [phoneContacts addObject:contact];
        }
    }
    
    self.emailContacts = emailContacts.copy;
    self.phoneContacts = phoneContacts.copy;

    if (emailContacts.count)
    {
        [self triggerEmailWithContacts:emailContacts.copy];
    }
    else if (phoneContacts.count)
    {
        [self triggerMessageWithContacts:phoneContacts.copy];
    }
}

- (void)triggerMessageWithContacts:(NSArray<YSGContact *> *)entries
{
    //
    // Call the endpoint and update invites
    //
    
    if ([self.contactSource isKindOfClass:[YSGOnlineContactSource class]])
    {
        YSGOnlineContactSource* contactSource = (YSGOnlineContactSource *)self.contactSource;
        
        [contactSource.client updateInvitesSent:entries forUserId:self.userId completion:nil];
    }
        
    //
    // Check for native message sheet
    //
    
    NSError* error;
    
    if (![self canSendText])
    {
        error = YSGErrorWithErrorCode(YSGErrorCodeInviteMessageUnavailable);
        
        [[YSGMessageCenter shared] sendError:error];
        [[YSGMessageCenter shared] sendMessage:NSLocalizedString(@"Unable to send a message. Can you check your message settings?", @"Unable to send a message. Can you check your message settings?") userInfo:nil];
    }

    if (!self.nativeMessageSheet || ![self canSendText])
    {
        if ([self.delegate respondsToSelector:@selector(shareService:didShareWithUserInfo:error:)])
        {
            [self.delegate shareService:self didShareWithUserInfo:@{ YSGInvitePhoneContactsKey : entries } error:error];
        }
        
        return;
    }
    
    MFMessageComposeViewController *messageController = self.messageComposeViewController;
    messageController.messageComposeDelegate = self;
    
    //
    // Set message
    //
    
    NSMutableArray<NSString *> * recipients = [NSMutableArray array];
    
    for (YSGContact *contact in entries)
    {
        [recipients addObject:contact.phone];
    }
    
    NSDictionary *data = [self shareDataForUserInfo:@{ YSGInvitePhoneContactsKey : entries }];
    
    messageController.subject = data[YSGShareSheetSubjectKey];
    messageController.body = data[YSGShareSheetMessageKey];
    messageController.recipients = recipients.copy;
    
    [self.addressBookNavigationController presentViewController:messageController animated:YES completion:nil];
}

- (void)triggerEmailWithContacts:(NSArray<YSGContact *> *)entries
{
    //
    // Check for native message sheet
    //
    
    NSError* error;
    
    if (![self canSendMail])
    {
        error = YSGErrorWithErrorCode(YSGErrorCodeInviteMailUnavailable);
        
        [[YSGMessageCenter shared] sendError:error];
        [[YSGMessageCenter shared] sendMessage:NSLocalizedString(@"Unable to send email. Can you check your email settings?", @"Unable to send email. Can you check your email settings?") userInfo:nil];
    }
    
    if (!self.nativeEmailSheet || ![self canSendMail])
    {
        if ([self.delegate respondsToSelector:@selector(shareService:didShareWithUserInfo:error:)])
        {
            [self.delegate shareService:self didShareWithUserInfo:@{ YSGInvitePhoneContactsKey : entries } error:error];
        }
        
        return;
    }
    
    MFMailComposeViewController *messageController = self.mailComposeViewController;
    
    messageController.mailComposeDelegate = self;
    
    NSMutableArray<NSString *>* recipients = [NSMutableArray array];
    
    for (YSGContact *contact in entries)
    {
        [recipients addObject:contact.email];
    }
    
    NSDictionary *data = [self shareDataForUserInfo:@{ YSGInviteEmailContactsKey : entries }];
    
    if (data[YSGShareSheetSubjectKey])
    {
        [messageController setSubject:data[YSGShareSheetSubjectKey]];
    }
    
    [messageController setMessageBody:data[YSGShareSheetMessageKey] isHTML:[data[YSGInviteEmailIsHTMLKey] boolValue]];
    [messageController setToRecipients:recipients];
    
    [self.addressBookNavigationController presentViewController:messageController animated:YES completion:nil];
}

- (NSDictionary *)shareDataForUserInfo:(NSDictionary *)userInfo
{
    NSDictionary *data = nil;
    
    if (self.shareDataBlock)
    {
        data = self.shareDataBlock(self, userInfo);
    }
    else if ([self.delegate respondsToSelector:@selector(shareService:messageWithUserInfo:)])
    {
        data = [self.delegate shareService:self messageWithUserInfo:userInfo];
    }

    return data;
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSError* error;
    
    if (result == MessageComposeResultFailed)
    {
        error = YSGErrorWithErrorCode(YSGErrorCodeInviteMessageFailed);
        
        [[YSGMessageCenter shared] sendError:error];
        [[YSGMessageCenter shared] sendMessage:NSLocalizedString(@"Something went wrong. Please try again.", @"Something went wrong. Please try again.") userInfo:nil];
    }
    
    if ([self.delegate respondsToSelector:@selector(shareService:didShareWithUserInfo:error:)])
    {
        [self.delegate shareService:self didShareWithUserInfo:@{ YSGInvitePhoneContactsKey : self.phoneContacts } error:error];
    }

    if (result != MessageComposeResultSent)
    {
        [controller dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    [controller dismissViewControllerAnimated:NO completion:^
    {
        if (self.emailContacts.count)
        {
            [self triggerEmailWithContacts:self.emailContacts];
        }
        else
        {
            [[YSGMessageCenter shared] sendMessage:NSLocalizedString(@"Selected contacts were successfully invited.", @"Successful invitation") userInfo:nil];
            
            [self.addressBookNavigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSError *ysgError;
    
    if (result == MFMailComposeResultFailed || error)
    {
        ysgError = YSGErrorWithErrorCodeWithError(YSGErrorCodeInviteMailFailed, error);
        
        [[YSGMessageCenter shared] sendError:ysgError];
        [[YSGMessageCenter shared] sendMessage:NSLocalizedString(@"Something went wrong. Please try again.", @"Something went wrong. Please try again.") userInfo:nil];
    }

    if ([self.delegate respondsToSelector:@selector(shareService:didShareWithUserInfo:error:)])
    {
        [self.delegate shareService:self didShareWithUserInfo:@{ YSGInviteEmailContactsKey : self.emailContacts } error:ysgError];
    }
    
    if (result != MFMailComposeResultSaved && result != MFMailComposeResultSent)
    {
        [controller dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }

    //
    // Dismiss the mail composer and entire invite screen flow
    //
    [controller dismissViewControllerAnimated:NO completion:^
    {
        if (self.phoneContacts.count)
        {
            [self triggerMessageWithContacts:self.phoneContacts];
        }
        else
        {
            [[YSGMessageCenter shared] sendMessage:NSLocalizedString(@"Selected contacts were successfully invited.", @"Successful invitation") userInfo:nil];
            
            [self.addressBookNavigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - Contact Details

- (NSString *)contactDetailStringForContact:(YSGContact *)contact
{
    NSString* contactDetail = nil;
    
    //
    // If we have a phone list, we try to use the phone
    //
    if (self.inviteServiceType == YSGInviteServiceTypePhone)
    {
        contactDetail = contact.phone;
    }
    
    if (!contactDetail)
    {
        contactDetail = contact.contactString;
    }
    
    return contactDetail;
}

#pragma mark - Private Methods

@end
