//
//  YesGraph.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGConstants.h"
#import "YSGLoggingConstants.h"
#import "YSGShareSheetController.h"
#import "YSGTheme.h"
#import "YSGSource.h"
#import "YSGContactList.h"

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/*!
 *  This class is the main entry point into YesGraph SDK and acts as the main customization point and exposes custom
 *  properties that can be used to read state of YesGraph SDK.
 */
@interface YesGraph : NSObject

/*!
 *  YES if SDK is ready to be triggered.
 */
@property (nonatomic, readonly) BOOL isConfigured;

/*!
 *  User ID used with YesGraph SDK
 */
@property (nullable, nonatomic, readonly, copy) NSString *userId;

/*!
 *  Client Key used with YesGraph SDK
 */
@property (nullable, nonatomic, readonly, copy) NSString *clientKey;

/*!
 *  To achieve better suggestion rankings, set the contact owner metadata (name, email, phone)
 */
@property (nullable, nonatomic, strong) YSGSource *contactOwnerMetadata;

/*!
 *  Shared instance to YesGraph
 *
 *  @return instance of YesGraph SDK
 */
+ (instancetype)shared;

@end

@interface YesGraph (Initialization)

/*!
 *  Configure YesGraph SDK with a client key that you receive from your trusted backend
 *  using YesGraph Secret Key. The client key is persisted in the SDK until configure
 *  method is called again.
 *
 *  @note: https://docs.yesgraph.com/v0/docs/connecting-apps
 *
 *  @param key client string that is received from YesGraph backend on your trusted backend.
 */
- (void)configureWithClientKey:(NSString *)clientKey;

/*!
 *  Configure YesGraph SDK with an user ID that will be used to fetch address book.
 *  User ID is persisted until next time this method is called.
 *
 *  @param userId to be used with YesGraph API.
 */
- (void)configureWithUserId:(NSString *)userId;

@end

@interface YesGraph (Share)

/*!
 *  Factory method for share sheet view controller. Delegate should be set manually. All available
 *  sharing services are added to the share sheet.
 *
 *  @return instance of share sheet controller
 */
- (nullable YSGShareSheetController *)shareSheetControllerForAllServices;

/*!
 *  Factory method for share sheet view controller with delegate. All available
 *  sharing services are added to the share sheet.
 *
 *  @param delegate for share sheet controller that conforms to YSGShareSheetDelegate.
 *
 *  @return instance of share sheet controller
 */
- (nullable YSGShareSheetController *)shareSheetControllerForAllServicesWithDelegate:(nullable id<YSGShareSheetDelegate>)delegate;

/*!
 *  Factory method for share sheet view controller that includes only the YesGraph invite service.
 *
 *  @return instance of share sheet controller
 */
- (nullable YSGShareSheetController *)shareSheetControllerForInviteService;

/*!
 *  Factory method for share sheet view controller that includes only the YesGraph invite service.
 *
 *  @param delegate for share sheet controller that conforms to YSGShareSheetDelegate.
 *
 *  @return instance of share sheet controller
 */
- (nullable YSGShareSheetController *)shareSheetControllerForInviteServiceWithDelegate:(nullable id<YSGShareSheetDelegate>)delegate;

@end


@interface YesGraph (Fetch)

/*!
 *  This retrieves the contact list from the app cache if it exists, otherwise it retrieves it from the phone. Then it uploads
 * to YesGraph and runs the completion on the results.
 */
- (void)fetchContactListWithCompletion:(void (^)(YSGContactList *, NSError *))completion;

@end


@interface YesGraph (Customization)

@property (nullable, nonatomic, strong) YSGTheme *theme;

@end

/*!
 *  Messaging blocks
 */
@interface YesGraph (Messaging)

/*!
 *  If this block is set, it will receive errors from SDK in the handler.
 */
@property (nullable, nonatomic, assign) YSGErrorHandlerBlock errorHandler;

/*!
 *  If this block is set messages emitted by
 */
@property (nullable, nonatomic, assign) YSGMessageHandlerBlock messageHandler;

@end

@interface YesGraph (Settings)

/*!
 *  Number of suggestions displayed when inviting address book users
 */
@property (nonatomic, assign) NSUInteger numberOfSuggestions;

/*!
 *  Before address book permission is requested, this message displays
 */
@property (nullable, nonatomic, copy) NSString *contactAccessPromptMessage;

/*!
 *  This text is displayed on the share sheet
 */
@property (nullable, nonatomic, copy) NSString *shareSheetText;

/*!
 *  Every time that application is activated, it is checked when was the last time that
 *  address book was uploaded to YesGraph API. If this time had passed, address book will be uploaded again
 *  automatically in the background.
 *
 *  @discussion: Default: 24 hours
 */
@property (nonatomic, assign) NSTimeInterval contactBookTimePeriod;

@end

@interface YesGraph (Logging)

/*!
 *  Current log level
 */
@property (nonatomic, assign) YSGLogLevel logLevel;

@end

NS_ASSUME_NONNULL_END