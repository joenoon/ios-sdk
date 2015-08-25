//
//  YSGInviteService.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareService.h"
#import "YSGContactSource.h"

extern NSString *_Nonnull const YSGInviteContactsKey;

/*!
 *  Invite service prepared to send email and sms contacts
 */
@interface YSGInviteService : YSGShareService

/*!
 *  Contact source that invite service uses for contacts
 */
@property (nonnull, nonatomic, strong, readonly) id<YSGContactSource> contactSource;

/*!
 *  This message is displayed to the user before contacts permissions is requested. If user agrees with the message,
 *  the user is asked for permission to Address Book.
 */
@property (nonnull, nonatomic, copy) NSString *requestContactPermissionMessage;

#pragma mark - Invite configuration

/*!
 *  If phone number contacts should be displayed.
 *
 *  @discussion: Default value: YES
 */
@property (nonatomic, assign) BOOL usePhone;

/*!
 *  If email contacts should be displayed.
 *
 *  @discussion: Default value: YES
 */
@property (nonatomic, assign) BOOL useEmail;

/*!
 *  If invite service should support multiple selection of user contacts.
 *
 *  @discussion: Default value: YES
 */
@property (nonatomic, assign) BOOL multipleSelection;

/*!
 *  If native message screen should be used - displays the iOS modal message send screen.
 *
 *  @discussion: Default value: YES
 */
@property (nonatomic, assign) BOOL nativeMessageSheet;

/*!
 *  If native email screen should be used - displays the iOS modal email send screen.
 *
 *  @discussion: Default value: YES
 */
@property (nonatomic, assign) BOOL nativeEmailSheet;

/*!
 *  Number of suggestions displayed above contacts. Use 0 to disable suggestions.
 *
 *  @discussion: Default value is: 5
 */
@property (nonatomic, assign) NSUInteger numberOfSuggestions;

/*!
 *  Whether invite selection will display a search bar on top
 *
 *  @discussion: Default value is: YES
 */
@property (nonatomic, assign) BOOL allowSearch;

#pragma mark - Initialization

/*!
 *  Initialize with contact manager
 *
 *  @param contactManager manager to work with contacts
 *
 *  @return instance of invite service
 */
- (instancetype _Nonnull)initWithContactSource:(nonnull id<YSGContactSource>)contactSource NS_DESIGNATED_INITIALIZER;

#pragma mark - Triggers

- (void)triggerInviteFlowWithContacts:(nonnull NSArray <YSGContact *> *)contacts;

@end
