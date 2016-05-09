//
//  YSGContactList+Operations.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 14/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGContactList+Operations.h"

@implementation YSGContactList (Operations)

#pragma mark - Public Methods

- (NSArray<YSGContact *> *)suggestedEntriesWithNumberOfSuggestions:(NSUInteger)numberOfSuggestions
{
    //
    // Remove duplicates
    //
    NSArray <YSGContact *>* contacts = [self removeDuplicatedContacts:self.entries];
    
    //
    // Skip contacts that had already been suggested
    //
    
    NSArray <YSGContact *> *currentContacts = [contacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"wasSuggested == 0"]];
    
    //
    // If there are less currentContacts than there are number of suggestions
    //
    if (currentContacts.count < numberOfSuggestions && contacts.count > currentContacts.count)
    {
        currentContacts = [currentContacts arrayByAddingObjectsFromArray:contacts];
    }
    
    //
    // Strip array to ensure correct number of suggestions
    //
    
    if (currentContacts.count > numberOfSuggestions)
    {
        currentContacts = [currentContacts subarrayWithRange:NSMakeRange(0, numberOfSuggestions)];
    }
    
    return currentContacts;
}

- (NSDictionary <NSString *, NSArray <YSGContact *> *> *)sortedEntriesWithNumberOfSuggestions:(NSUInteger)numberOfSuggestions
{
    NSMutableDictionary <NSString *, NSMutableArray <YSGContact *> * > *contactList = [NSMutableDictionary dictionary];
    
    NSArray<YSGContact *> *entries;
    
    if (numberOfSuggestions > 0)
    {
        NSArray <YSGContact *> *suggestedEntries = [self suggestedEntriesWithNumberOfSuggestions:numberOfSuggestions];
        
        NSMutableArray <YSGContact *> *allEntries = [self.entries mutableCopy];
        
        // Remove suggestions
        [allEntries removeObjectsInArray:suggestedEntries];
        
        entries = [allEntries copy];
    }
    else
    {
        entries = self.entries;
    }
    
    for (YSGContact *contact in entries)
    {
        //
        // Check if name is empty
        //
        
        NSString *letter = [contact.name substringToIndex:1];

        if (!letter.length || ![[NSCharacterSet letterCharacterSet] characterIsMember:[letter characterAtIndex:0]])
        {
            //
            // If name is empty check if email is available
            //
            if (!letter.length && contact.email.length)
            {
                letter = [contact.email substringToIndex:1];
            }
            else
            {
                letter = @"#";
            }
        }
        
        if (letter.length && (contact.phones.count > 0 || contact.emails.count > 0))
        {
            letter = letter.uppercaseString;
            
            if (!contactList[letter])
            {
                contactList[letter] = [NSMutableArray array];
            }
            
            [contactList[letter] addObject:contact];
        }
    }
    
    NSMutableDictionary <NSString *, NSArray <YSGContact *> *> *sortedList = [NSMutableDictionary dictionary];
    
    for (NSString* letter in contactList)
    {
        NSArray *sortedContacts = contactList[letter];
        
        sortedList[letter] = [sortedContacts sortedArrayUsingFunction:contactsSort context:nil];
    }
    
    return sortedList.copy;
}


- (YSGContactList *)emailEntries
{
    YSGContactList *emailContactList = [YSGContactList new];
    emailContactList.source = self.source;
    emailContactList.useSuggestions = self.useSuggestions;
    
    NSMutableArray <YSGContact *> *emailEntries = [self.entries mutableCopy];
    NSMutableArray <YSGContact *> *emailEntriesToRemove = [NSMutableArray new];
    
    for (YSGContact* contact in self.entries)
    {
        if (contact.emails.count < 1)
        {
            [emailEntriesToRemove addObject:contact];
        }
    }
    
    [emailEntries removeObjectsInArray:emailEntriesToRemove];
    
    emailContactList.entries = emailEntries;
    
    return emailContactList;
}

- (YSGContactList *)phoneEntries
{
    YSGContactList *phoneContactList = [YSGContactList new];
    phoneContactList.source = self.source;
    phoneContactList.useSuggestions = self.useSuggestions;
    
    NSMutableArray <YSGContact *> *phoneEntries = [self.entries mutableCopy];
    NSMutableArray <YSGContact *> *phoneEntriesToRemove = [NSMutableArray new];
    
    for (YSGContact* contact in self.entries)
    {
        if (contact.phones.count < 1)
        {
            [phoneEntriesToRemove addObject:contact];
        }
    }
    
    [phoneEntries removeObjectsInArray:phoneEntriesToRemove];
    
    phoneContactList.entries = phoneEntries;
    
    return phoneContactList;
}


#pragma mark - Private Methods

- (NSArray <YSGContact *> *)removeDuplicatedContacts:(NSArray <YSGContact *> *)contacts
{
    if (!contacts.count)
    {
        return nil;
    }
    
    NSMutableDictionary *duplicatesDict = [[NSMutableDictionary alloc] init];
    NSMutableArray <YSGContact *> *filteredContacts = [NSMutableArray array];

    for (NSUInteger i = 0; i < contacts.count; i++)
    {
        if (contacts[i].name == nil || [contacts[i].name isEqual: @""]) {
            [filteredContacts addObject:contacts[i]];
        }
        else if (duplicatesDict[contacts[i].name]) {
            YSGContact *currentContact = duplicatesDict[contacts[i].name];
            // Do merging
            if (contacts[i].emails != currentContact.emails) {
                NSSet *set1 = [NSSet setWithArray:contacts[i].emails];
                NSSet *set2 = [NSSet setWithArray:currentContact.emails];
                currentContact.emails = [[set1 setByAddingObjectsFromSet:set2] allObjects];
            }
            if (contacts[i].phones != currentContact.phones) {
                NSSet *set1 = [NSSet setWithArray:contacts[i].phones];
                NSSet *set2 = [NSSet setWithArray:currentContact.phones];
                currentContact.phones = [[set1 setByAddingObjectsFromSet:set2] allObjects];
            }
        }
        else {
            [duplicatesDict setObject:contacts[i] forKey:contacts[i].name];
        }
    }

    [filteredContacts addObjectsFromArray:[duplicatesDict allValues]];
    
    return filteredContacts.copy;
}

NSInteger contactsSort(YSGContact *contact1, YSGContact *contact2, void *context)
{
    // We order contacts without name by email
    if (contact1.name.length == 0 && contact2.name.length > 0)
    {
        return [contact1.email caseInsensitiveCompare:contact2.name];
    }
    else if (contact1.name.length > 0 && contact2.name.length == 0)
    {
        return [contact1.name caseInsensitiveCompare:contact2.email];
    }
    else if (contact1.name.length == 0 && contact2.name.length == 0)
    {
        return [contact1.email caseInsensitiveCompare:contact2.email];
    }
    
    return [contact1.name caseInsensitiveCompare:contact2.name];
}

@end
