//
//  YesGraph.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGConstants.h"
#import "YSGShareSheetController.h"
#import "YSGTheme.h"

@import Foundation;

/*!
 *  This class is the main entry point into YesGraph SDK and acts as the main customization point
 */
@interface YesGraph : NSObject

/*!
 *  User ID used with YesGraph SDK
 */
@property (nullable, nonatomic, readonly) NSString *userId;

/*!
 *  Shared instance to YesGraph
 *
 *  @return instance of YesGraph SDK
 */
+ (nonnull instancetype)shared;

@end

@interface YesGraph (Initialization)

/*!
 *  Configure YesGraph SDK with a client key that you receive from your trusted backend using YesGraph Secret Key.
 *  @note: https://docs.yesgraph.com/v0/docs/connecting-apps
 *
 *  @param key client string that is received from YesGraph backend on your trusted backend.
 */
- (void)configureWithClientKey:(nonnull NSString *)key;

/*!
 *  Configure YesGraph SDK with an user ID that will be used to save address book
 *
 *  @param userId to be used with API calls
 */
- (void)configureWithUserId:(nonnull NSString *)userId;

@end

@interface YesGraph (Share)

- (nonnull YSGShareSheetController *)defaultShareSheetControllerWithDelegate:(nullable id<YSGShareSheetDelegate>)delegate;

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
