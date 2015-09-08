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

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/*!
 *  This class is the main entry point into YesGraph SDK and acts as the main customization point and exposes custom 
 *  properties that can be used to read state of YesGraph SDK.
 */
@interface YesGraph : NSObject

/*!
 *  User ID used with YesGraph SDK
 */
@property (nullable, nonatomic, readonly, copy) NSString *userId;

/*!
 *  Shared instance to YesGraph
 *
 *  @return instance of YesGraph SDK
 */
+ (instancetype)shared;

@end

@interface YesGraph (Initialization)

/*!
 *  Configure YesGraph SDK with a client key that you receive from your trusted backend using YesGraph Secret Key.
 *  @note: https://docs.yesgraph.com/v0/docs/connecting-apps
 *
 *  @param key client string that is received from YesGraph backend on your trusted backend.
 */
- (void)configureWithClientKey:(NSString *)clientKey;

/*!
 *  Configure YesGraph SDK with an user ID that will be used to save address book
 *
 *  @param userId to be used with API calls
 */
- (void)configureWithUserId:(NSString *)userId;

@end

@interface YesGraph (Share)

/*!
 *  Factory method for share sheet view controller without delegate. Delegate can still be set manually.
 *
 *  @return instance of share sheet controller
 */
- (YSGShareSheetController *)defaultShareSheetController;

/*!
 *  Factory method for share sheet view controller with delegate
 *
 *  @param delegate for share sheet controller that conforms to YSGShareSheetDelegate.
 *
 *  @return instance of share sheet controller
 */
- (YSGShareSheetController *)defaultShareSheetControllerWithDelegate:(nullable id<YSGShareSheetDelegate>)delegate;

@end

@interface YesGraph (Customization)

@property (nullable, nonatomic, strong) YSGTheme *theme;

@end

/*!
 *  Error handling methods
 */
@interface YesGraph (ErrorHandling)

@property (nullable, nonatomic, strong) YSGErrorHandlerBlock errorHandler;

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
