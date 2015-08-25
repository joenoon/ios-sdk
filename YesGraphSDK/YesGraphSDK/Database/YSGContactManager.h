//
//  YSGContactManager.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 19/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGContact.h"
#import "YSGContactSource.h"

/*!
 *  Contact manager to do all work with contacts
 */
@interface YSGContactManager : NSObject <YSGContactSource>

/*!
 *  Default contact source used by contact manager
 */
@property (nonnull, nonatomic, strong) id<YSGContactSource> defaultSource;

+ (nonnull instancetype)shared;

@end
