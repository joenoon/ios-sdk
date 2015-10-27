//
//  YSGContactList+ExposedPrivate.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 26/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGContactList+Operations.h"

@interface YSGContactList (ExposedPrivate)

- (NSArray <YSGContact *> *)removeDuplicatedContactsFromSuggestions:(NSArray <YSGContact *> *)contacts numberOfSuggestions:(NSUInteger)number;

@end
