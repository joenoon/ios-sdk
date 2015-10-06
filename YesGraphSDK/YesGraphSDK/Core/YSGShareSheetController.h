//
//  YSGShareSheetController.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
@import UIKit;
@import QuartzCore;

#import "YSGShareService.h"

@class YSGShareSheetController;
@class YSGTheme;

extern NSString *_Nonnull const YSGShareSheetMessageKey;

@protocol YSGShareSheetDelegate <NSObject>

@optional

/*!
 *  Called when user selected to use a specific share service
 *
 *  @param shareSheetController instance
 *  @param service              share service that will be used
 */
- (void)shareSheetController:(nonnull YSGShareSheetController *)shareSheetController didSelectService:(nonnull YSGShareService *)service;

/*!
 *  If share service does not have a message block set, the delegate is asked to provide a message.
 *  @warning: If no message is available, an exception will be raised.
 *
 *  @param shareSheetController instance
 *  @param service              service that needs message
 *  @param userInfo             additional information about the user from service
 *
 *  @return dictionary with at least "message" key, use
 */
- (nonnull NSDictionary<NSString *, id> *)shareSheetController:(nonnull YSGShareSheetController *)shareSheetController messageForService:(nonnull YSGShareService *)service userInfo:(nullable NSDictionary <NSString *, id>*)userInfo;

/*!
 *  Called when share sheet invited entries
 *
 *  @param shareSheetController instance
 *  @param service              share service that did the invite
 *  @param userInfo             userInfo that were selected (if available and no error)
 *  @param error                error during sharing
 */
- (void)shareSheetController:(nonnull YSGShareSheetController *)shareSheetController didShareToService:(YSGShareService * _Nonnull)service userInfo:(nullable NSDictionary <NSString *, id> *)userInfo error:(nullable NSError *)error;

/*!
 *  Called when user finished sharing
 *
 *  @param shareSheetController instance
 */
- (void)shareSheetControllerDidFinish:(nonnull YSGShareSheetController *)shareSheetController;

@end

/*!
 *  Main share sheet controller (entry point)
 */
@interface YSGShareSheetController : UIViewController

NS_ASSUME_NONNULL_BEGIN

/*!
 *  Referel URL that is displayed and can be copied
 *
 *  @discussion: If this is nil, no copy box is displayed.
 */
@property (nullable, nonatomic, copy) NSString *referralURL;

/*!
 *  Image that is displayed on the share sheet.
 *
 *  @discussion: If it is nil, no image view is generated
 */
@property (nullable, nonatomic, strong) UIImage *shareImage;

/*!
 *  Delegate to receive messages
 */
@property (nullable, nonatomic, weak) id<YSGShareSheetDelegate> delegate;

/*!
 *  Share services currently with share sheet controller
 */
@property (nonatomic, readonly, copy) NSArray <YSGShareService *> * services;


/*!
 *  Designated initializer
 *
 *  @param services to share with
 *  @param delegate to receive change messages
 *  @param style theme object
 *
 *  @return instance of share sheet
 */
- (instancetype)initWithServices:(nonnull NSArray<YSGShareService *> *)services delegate:(nullable id<YSGShareSheetDelegate>)delegate theme:(nullable YSGTheme *)theme NS_DESIGNATED_INITIALIZER;

NS_ASSUME_NONNULL_END

@end

#pragma mark - YSGShareSheetController Initialization

@interface YSGShareSheetController (Initialization)

NS_ASSUME_NONNULL_BEGIN

/*!
 *  Returns new instance of Share Sheet view controller
 *
 *  @param services to use in share sheet
 *
 *  @return new view controller instance to be displayed
 */
+ (instancetype)shareSheetControllerWithServices:(nonnull NSArray<YSGShareService *> *)services;

/*!
 *  Convenience initializer without theme
 *
 *  @param services to share with
 *  @param delegate to receive change messages
 *
 *  @return instance of share sheet
 */
- (instancetype)initWithServices:(NSArray<YSGShareService *> *)services delegate:(nullable id<YSGShareSheetDelegate>)delegate;

NS_ASSUME_NONNULL_END

@end
