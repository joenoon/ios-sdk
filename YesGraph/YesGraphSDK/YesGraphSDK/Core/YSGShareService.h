//
//  YSGShareService.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "YSGTheme.h"

@class YSGShareService;
@class YSGShareSheetController;

NS_ASSUME_NONNULL_BEGIN

@protocol YSGShareServiceDelegate <NSObject>

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
- (nonnull NSDictionary<NSString *, id> *)shareService:(YSGShareService *)shareService messageWithUserInfo:(nullable NSDictionary <NSString *, id>*)userInfo;

/*!
 *  Called when share sheet invited entries
 *
 *  @param shareSheetController instance
 *  @param service              share service that did the invite
 *  @param userInfo             userInfo that were selected (if available and no error)
 *  @param error                error during sharing
 */
- (void)shareService:(YSGShareService *)shareService didShareWithUserInfo:(nullable NSDictionary <NSString *, id> *)userInfo error:(nullable NSError *)error;

@end

/*!
 *  Share data block is called every time share service needs data
 *
 *  @param service  service instance that is asking for the message
 *  @param userInfo additional information about current message, such as sms or email incase of invite flow
 *
 *  @return string to use with share service
 */
typedef NSDictionary * _Nonnull (^YSGShareDataBlock)(YSGShareService* _Nonnull service, NSDictionary * _Nullable userInfo);

/*!
 *  Share service for YesGraph share sheet, abstract implementation. This class should not
 *  be initialized directly.
 */
@interface YSGShareService : NSObject

@property (nullable, nonatomic, assign) YSGShareDataBlock shareDataBlock;

@property (nullable, nonatomic, strong) UIImage *serviceImage;

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) UIColor *backgroundColor;

@property (nonatomic, readonly) UIColor *textColor;

@property (nonatomic, readonly) NSString *fontFamily;

@property (nonatomic) YSGShareSheetServiceCellShape shape;

@property (nonatomic, strong) YSGTheme *theme;

@property (nullable, nonatomic, weak) id<YSGShareServiceDelegate> delegate;

- (void)triggerServiceWithViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END