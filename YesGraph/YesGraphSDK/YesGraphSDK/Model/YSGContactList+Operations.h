//
//  YSGContactList+Operations.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 14/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGContactList.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSGContactList (Operations)

- (NSArray<YSGContact *> *)suggestedEntriesWithNumberOfSuggestions:(NSUInteger)numberOfSuggestions;
- (NSDictionary <NSString *, NSArray <YSGContact *> *> *)sortedEntriesWithNumberOfSuggestions:(NSUInteger)numberOfSuggestions;

- (NSArray <YSGContact *> *)removeDuplicatedContacts:(NSArray <YSGContact *> *)contacts;

@end

NS_ASSUME_NONNULL_END