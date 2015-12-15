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

NS_ASSUME_NONNULL_BEGIN

/*!
 *  Wraps contact list for storage and serialization
 */
@interface YSGContactList : YSGParsableModel <YSGParsable>

@property (nonatomic, assign) BOOL useSuggestions;

@property (nonatomic, copy) NSArray <YSGContact *> *entries;

@property (nullable, nonatomic, strong) YSGSource *source;

- (YSGContactList *)emailEntries;
- (YSGContactList *)phoneEntries;

@end

NS_ASSUME_NONNULL_END
