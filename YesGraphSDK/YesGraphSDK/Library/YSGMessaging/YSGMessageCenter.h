//
//  YSGMessageCenter.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 09/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGConstants.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 *  Error messages and messages to be displayed are redirected to message center.
 */
@interface YSGMessageCenter : NSObject

/*!
 *  If custom error block is set, all errors are sent to it in addition of the default logging mechanism.
 */
@property (nonatomic, assign) YSGErrorHandlerBlock errorHandler;

/*!
 *  If message block is set, messages are sent to the block instead of displayed on screen.
 */
@property (nonatomic, assign) YSGMessageHandlerBlock messageHandler;

+ (instancetype)shared;

/*!
 *  Sends message to message handler block or displays default alert view.
 *
 *  @param message to be displayed
 *  @param userInfo to be sent
 */
- (void)sendMessage:(nonnull NSString *)message userInfo:(nullable NSDictionary *)userInfo;

/*!
 *  Sends error to message center and logs it.
 *
 *  @param error to be logged
 */
- (void)sendError:(nonnull NSError *)error;

@end

NS_ASSUME_NONNULL_END
