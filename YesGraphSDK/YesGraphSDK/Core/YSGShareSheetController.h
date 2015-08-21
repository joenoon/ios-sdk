//
//  YSGShareSheetController.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "YSGShareService.h"

@class YSGShareSheetController;
@class YSGTheme;

@protocol YSGShareSheetDelegate <NSObject>

@optional

/*!
 *  Called when user selected to use a specific share service
 *
 *  @param shareSheetController instance
 *  @param service              share service that will be used
 */
- (void)shareSheetController:(YSGShareSheetController * _Nonnull)shareSheetController didSelectService:(YSGShareService * _Nonnull)service;

/*!
 *  If share service does not have a message block set, the delegate is asked to provide a message.
 *  @warning: If no message is available, an exception will be raised.
 *
 *  @param shareSheetController instance
 *  @param service              service that needs message
 *  @param userInfo             additional information about the user from service
 *
 *  @return message to use
 */
- (NSString * _Nonnull)shareSheetController:(YSGShareSheetController * _Nonnull)shareSheetController messageForService:(YSGShareService * _Nonnull)service userInfo:(NSDictionary * _Nullable)userInfo;

/*!
 *  Called when share sheet invited contacts
 *
 *  @param shareSheetController instance
 *  @param service              share service that did the invite
 *  @param userInfo             userInfo that were selected (if available and no error)
 *  @param error                error during sharing
 */
- (void)shareSheetController:(YSGShareSheetController * _Nonnull)shareSheetController didShareToService:(YSGShareService * _Nonnull)service userInfo:(NSDictionary * _Nullable)userInfo error:(NSError * _Nullable)error;

/*!
 *  Called when user finished sharing
 *
 *  @param shareSheetController instance
 */
- (void)shareSheetControllerDidFinish:(YSGShareSheetController * _Nonnull)shareSheetController;

@end

/*!
 *  Main share sheet controller (entry point)
 */
@interface YSGShareSheetController : UIViewController

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

@end

#pragma mark - YSGShareSheetController Initialization

@interface YSGShareSheetController (Initialization)

/*!
 *  Returns new instance of Share Sheet view controller
 *
 *  @param services to use in share sheet
 *
 *  @return new view controller instance to be displayed
 */
+ (instancetype _Nonnull)shareSheetControllerWithServices:(NSArray<YSGShareService *> * _Nonnull)services;

/*!
 *  Convenience initializer without theme
 *
 *  @param services to share with
 *  @param delegate to receive change messages
 *
 *  @return instance of share sheet
 */
- (instancetype _Nonnull)initWithServices:(NSArray<YSGShareService *> * _Nonnull)services delegate:(id<YSGShareSheetDelegate> _Nullable)delegate;

/*!
 *  Designated initializer
 *
 *  @param services to share with
 *  @param delegate to receive change messages
 *  @param style theme object
 *
 *  @return instance of share sheet
 */
- (instancetype _Nonnull)initWithServices:(NSArray<YSGShareService *> * _Nonnull)services delegate:(id<YSGShareSheetDelegate> _Nullable)delegate theme:(YSGTheme * _Nullable)theme;

@end
