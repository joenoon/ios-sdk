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
    return [[self removeDuplicatedContactsFromSuggestions:self.entries numberOfSuggestions:numberOfSuggestions] copy];
}

- (NSDictionary <NSString *, NSArray <YSGContact *> *> *)sortedEntriesWithNumberOfSuggestions:(NSUInteger)numberOfSuggestions
{
    NSMutableDictionary <NSString *, NSMutableArray <YSGContact *> * > *contactList = [NSMutableDictionary dictionary];
    
    NSArray<YSGContact *> *entries;
    
    if (numberOfSuggestions > 0)
    {
        if (numberOfSuggestions <= self.entries.count)
        {
            entries = [self.entries subarrayWithRange:NSMakeRange(numberOfSuggestions, self.entries.count - numberOfSuggestions)];
        }
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
            if (contact.email.length)
            {
                letter = [contact.email substringToIndex:1];
            }
            else
            {
                letter = @"#";
            }
        }
        
        if (letter.length)
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

#pragma mark - Private Methods

- (NSArray <YSGContact *> *)removeDuplicatedContactsFromSuggestions:(NSArray <YSGContact *> *)contacts numberOfSuggestions:(NSUInteger)number
{
    if (!contacts.count)
    {
        return nil;
    }
    
    NSMutableArray <YSGContact *> *contactsWithEmails = [NSMutableArray array];
    NSMutableArray <YSGContact *> *contactsWithPhones = [NSMutableArray array];
    
    for (NSUInteger i = 0; i< number; i++)
    {
        if (contacts.count <= i)
        {
            break;
        }
        
        if(contacts[i].emails.count > 0)
        {
            [contactsWithEmails addObject:contacts[i]];
            
            NSPredicate *sameNamePredicate = [NSPredicate predicateWithFormat:@"name = %@", contacts[i].name];
            
            NSArray <YSGContact *> *sameNamePhoneContacts = [contactsWithPhones filteredArrayUsingPredicate:sameNamePredicate];
            
            if (sameNamePhoneContacts.count)
            {
                [contactsWithPhones removeObjectsInArray:sameNamePhoneContacts];
                number ++;
            }
        }
        
        else if (contacts[i].phones.count > 0)
        {
            NSPredicate *sameNamePredicate = [NSPredicate predicateWithFormat:@"name = %@", contacts[i].name];
            
            if ([contactsWithEmails filteredArrayUsingPredicate:sameNamePredicate].count)
            {
                number++;
            }
            else
            {
                [contactsWithPhones addObject:contacts[i]];
            }
        }
    }
    
    NSMutableArray <YSGContact *> *filteredContacts = [NSMutableArray array];
    
    [filteredContacts addObjectsFromArray:contactsWithEmails];
    [filteredContacts addObjectsFromArray:contactsWithPhones];
    
    return filteredContacts.copy;
}

NSInteger contactsSort(YSGContact *contact1, YSGContact *contact2, void *context)
{
    // We force contacts without name on the bottom of the list
    if (contact1.name.length == 0)
    {
        return NSOrderedAscending;
    }
    else if (contact2.name.length == 0)
    {
        return NSOrderedDescending;
    }
    
    return [contact1.name caseInsensitiveCompare:contact1.name];
}

@end
