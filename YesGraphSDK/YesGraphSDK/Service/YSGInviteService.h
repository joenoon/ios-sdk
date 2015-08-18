//
//  YSGInviteService.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareService.h"

/*!
 *  Invite service prepared to send email and sms contacts
 */
@interface YSGInviteService : YSGShareService

@property (nonatomic, assign) BOOL messageService;
@property (nonatomic, assign) BOOL emailService;

/*!
 *  Number of suggestions displayed above contacts. Use 0 to disable suggestions.
 *
 *  @discussion: Default value is: 5
 */
@property (nonatomic, assign) NSUInteger numberOfSuggestions;

@end
