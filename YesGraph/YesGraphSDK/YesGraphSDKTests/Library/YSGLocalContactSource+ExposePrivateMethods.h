//
//  YSGLocalContactSource+ExposePrivateMethods.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 26/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGLocalContactSource.h"
#import "YSGContact.h"
@import Contacts;

@interface YSGLocalContactSource (ExposePrivateMethods)

+ (NSUserDefaults *)userDefaults;

@end

@interface YSGLocalContactSource ()

- (YSGContact *)contactFromContact:(CNContact *)contact;

- (NSArray <YSGContact *> *)contactListFromAddressBook:(NSError **)error;

- (NSArray<YSGContact *> *)separatedContactsForContact:(YSGContact *)contact;

@end
