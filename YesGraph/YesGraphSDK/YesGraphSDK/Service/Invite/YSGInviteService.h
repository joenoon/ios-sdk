//
//  YSGInviteService.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareService.h"
#import "YSGContactSource.h"
#import "YSGContact.h"
#import "YSGInviteServiceType.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString* const YSGInvitePhoneContactsKey;
extern NSString* const YSGInviteEmailContactsKey;
extern NSString* const YSGInviteEmailIsHTMLKey;

/*!
 *  Invite service prepared to send email and sms entries
 */
@interface YSGInviteService : YSGShareService

/*!
 *  Contact source that invite service uses for entries
 */
@property (nonatomic, strong, readonly) id<YSGContactSource> contactSource;

/*!
 *  User Id to invite for
 */
@property (nonatomic, readonly) NSString *userId;

#pragma mark - Invite configuration

/*!
 *  If phone number entries should be displayed.
 *
 *  @discussion: Default value: YES
 */
@property (nonatomic, assign) BOOL usePhone;

/*!
 *  If email entries should be displayed.
 *
 *  @discussion: Default value: YES
 */
@property (nonatomic, assign) BOOL useEmail;

/*!
 *  If invite service should support multiple selection of user entries.
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
 *  Number of suggestions displayed above entries. Use 0 to disable suggestions.
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

// LMS stuff

@property (nonatomic, assign) YSGInviteServiceType inviteServiceType;

#pragma mark - Initialization

/*!
 *  Initialize with contact manager
 *
 *  @param contactManager manager to work with entries
 *
 *  @return instance of invite service
 */
- (instancetype)initWithContactSource:(id<YSGContactSource>)contactSource userId:(nullable NSString *)userId NS_DESIGNATED_INITIALIZER;

#pragma mark - Triggers

- (void)triggerInviteFlowWithContacts:(NSArray <YSGContact *> *)entries;

@end

NS_ASSUME_NONNULL_END
