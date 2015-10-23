//
//  YSGLocalContactSource.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 25/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGContactSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSGLocalContactSource : NSObject <YSGContactSource>

#pragma mark - Contact Access Prompt

@property (nullable, nonatomic, copy) NSString *contactAccessPromptTitle;
/*!
 *  This message is displayed to the user before entries permissions is requested. If user agrees with the message,
 *  the user is asked for permission to Address Book.
 */
@property (nullable, nonatomic, copy) NSString *contactAccessPromptMessage;

/*!
 *  Returns YES if local contact source has permission to address book
 *
 *  @return YES if user has given permission to address book
 */
+ (BOOL)hasPermission;

@end

NS_ASSUME_NONNULL_END
