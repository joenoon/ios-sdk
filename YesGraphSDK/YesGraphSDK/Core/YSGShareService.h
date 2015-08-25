//
//  YSGShareService.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
@import UIKit;

@class YSGShareService;
@class YSGShareSheetController;

/*!
 *  Message block is called every time share service needs a message
 *
 *  @param service  service instance that is asking for the message
 *  @param userInfo additional information about current message, such as sms or email incase of invite flow
 *
 *  @return string to use with share service
 */
typedef NSString * _Nonnull (^YSGShareMessageBlock)(YSGShareService* _Nonnull service, NSDictionary * _Nullable userInfo);

/*!
 *  Share service for YesGraph share sheet, abstract implementation. This class should not
 *  be initialized directly.
 */
@interface YSGShareService : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (nullable, nonatomic, assign) YSGShareMessageBlock messageBlock;

@property (nullable, nonatomic, strong) UIImage *serviceImage;

@property (nonnull, nonatomic, readonly) NSString *name;

- (void)triggerServiceWithViewController:(YSGShareSheetController *)viewController;

NS_ASSUME_NONNULL_END

@end
