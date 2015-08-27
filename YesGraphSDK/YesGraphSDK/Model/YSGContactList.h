//
//  YSGContactList.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 26/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGContact.h"
#import "YSGSource.h"
#import "YSGParsing.h"

/*!
 *  Wraps contact list for storage and serialization
 */
@interface YSGContactList : NSObject <YSGParsable>

@property (nonatomic, assign) BOOL useSuggestions;

@property (nonnull, nonatomic, copy) NSArray <YSGContact *> *entries;

@property (nullable, nonatomic, strong) NSString *userId;
@property (nullable, nonatomic, strong) YSGSource *source;

@end
