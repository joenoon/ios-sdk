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

@protocol YSGShareSheetDelegate <NSObject>

@optional

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

@end

/*!
 *  Main share sheet coontroller(entry point)
 */
@interface YSGShareSheetController : UIViewController

@property (nullable, nonatomic, weak) id<YSGShareSheetDelegate> delegate;

/*!
 *  Returns new instance of Share Sheet view controller
 *
 *  @param services to use in share sheet
 *
 *  @return new view controller instance to be displayed
 */
+ (instancetype _Nonnull)shareSheetControllerWithServices:(NSArray<YSGShareService *> * _Nonnull)services;

/*!
 *  Designated initializer
 *
 *  @param services to share with
 *  @param delegate to receive change messages
 *
 *  @return instance of share sheet
 */
- (instancetype _Nonnull)initWithServices:(NSArray<YSGShareService *> * _Nonnull)services delegate:(id<YSGShareSheetDelegate> _Nullable)delegate;

@end
