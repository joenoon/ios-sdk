//
//  YSGContactList.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 26/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGContactList.h"

@implementation YSGContactList

+ (NSDictionary *)ysg_mapping
{
    return @{ @"entries" : @"entries", @"source" : @"source" };
}

- (YSGContactList *)emailEntries {
    // copy with zone maybe
    YSGContactList *emailContactList = [YSGContactList new];
    emailContactList.source = self.source;
    emailContactList.useSuggestions = self.useSuggestions;
    NSMutableArray <YSGContact *> *emailEntries = [self.entries mutableCopy];
    NSMutableArray <YSGContact *> *emailEntriesToRemove = [NSMutableArray new];
    
    for (int i = 0; i < self.entries.count; i++) {
        YSGContact *contact = self.entries[i];
        if (contact.emails.count < 1) {
            [emailEntriesToRemove addObject:contact];
        }
    }
    
    [emailEntries removeObjectsInArray:emailEntriesToRemove];
    
    emailContactList.entries = emailEntries;
    
    return emailContactList;
}

- (YSGContactList *)phoneEntries {
    YSGContactList *phoneContactList = [YSGContactList new];
    phoneContactList.source = self.source;
    phoneContactList.useSuggestions = self.useSuggestions;
    NSMutableArray <YSGContact *> *phoneEntries = [self.entries mutableCopy];
    NSMutableArray <YSGContact *> *phoneEntriesToRemove = [NSMutableArray new];
    
    for (int i = 0; i < self.entries.count; i++) {
        YSGContact *contact = self.entries[i];
        if (contact.emails.count < 1) {
            [phoneEntriesToRemove addObject:contact];
        }
    }
    
    [phoneEntries removeObjectsInArray:phoneEntriesToRemove];
    
    phoneContactList.entries = phoneEntries;
    
    return phoneContactList;
}

@end
