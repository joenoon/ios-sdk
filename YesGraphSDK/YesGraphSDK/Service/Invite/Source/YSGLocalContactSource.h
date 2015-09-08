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
@property (nullable, nonatomic, copy) NSString *contactAccessPromptMessage;

@property (nonatomic, readonly) BOOL hasPermission;

/*!
 *  This holds last date that contacts were fetched. This can be used to test whether to upload them again.
 */
@property (nullable, nonatomic, readonly) NSDate* lastContactFetchDate;

@end

NS_ASSUME_NONNULL_END
