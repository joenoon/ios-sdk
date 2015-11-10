//
//  YSGLocalContactSource+OverrideAddressBook.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 06/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import AddressBook;
#import "YSGLocalContactSource+OverrideAddressBook.h"

@implementation YSGLocalContactSource (OverrideAddressBook)

- (NSArray *)copyArrayOfAllPeopleFor:(ABAddressBookRef)addressBook
{
    NSMutableArray *contacts = [NSMutableArray new];
    
    ABMultiValueRef phoneValues = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(phoneValues, @"+1 111 111 111", kABPersonPhoneMainLabel, nil);
    ABMultiValueAddValueAndLabel(phoneValues, @"+6 111 111 111", kABPersonPhoneMainLabel, nil);
    
    ABMultiValueRef emailValues = ABMultiValueCreateMutable(kABPersonEmailProperty);
    ABMultiValueAddValueAndLabel(emailValues, @"full.name@email.com", CFSTR("email"), nil);
    ABMultiValueAddValueAndLabel(emailValues, @"fullname@email.com", CFSTR("email"), nil);
    
    ABRecordRef fullName = ABPersonCreate();
    ABRecordSetValue(fullName, kABPersonPrefixProperty, @"Dr", nil);
    ABRecordSetValue(fullName, kABPersonSuffixProperty, @"phd.", nil);
    ABRecordSetValue(fullName, kABPersonFirstNameProperty, @"Full", nil);
    ABRecordSetValue(fullName, kABPersonLastNameProperty, @"Name", nil);
    ABRecordSetValue(fullName, kABPersonMiddleNameProperty, @"Entire", nil);
    ABRecordSetValue(fullName, kABPersonNicknameProperty, @"fullName", nil);
    ABRecordSetValue(fullName, kABPersonPhoneProperty, phoneValues, nil);
    ABRecordSetValue(fullName, kABPersonEmailProperty, emailValues, nil);
    [contacts addObject:(__bridge id _Nonnull)(fullName)];
    
    ABRecordRef noMiddleName = ABPersonCreate();
    ABRecordSetValue(noMiddleName, kABPersonFirstNameProperty, @"Full", nil);
    ABRecordSetValue(noMiddleName, kABPersonLastNameProperty, @"Name", nil);
    ABRecordSetValue(noMiddleName, kABPersonNicknameProperty, @"noMiddleName", nil);
    ABRecordSetValue(noMiddleName, kABPersonPhoneProperty, phoneValues, nil);
    ABRecordSetValue(noMiddleName, kABPersonEmailProperty, emailValues, nil);
    [contacts addObject:(__bridge id _Nonnull)(noMiddleName)];
    
    ABRecordRef noEmails = ABPersonCreate();
    ABRecordSetValue(noEmails, kABPersonFirstNameProperty, @"Full", nil);
    ABRecordSetValue(noEmails, kABPersonLastNameProperty, @"Name", nil);
    ABRecordSetValue(noEmails, kABPersonNicknameProperty, @"noEmails", nil);
    ABRecordSetValue(noEmails, kABPersonPhoneProperty, phoneValues, nil);
    [contacts addObject:(__bridge id _Nonnull)(noEmails)];

    ABRecordRef justEmails = ABPersonCreate();
    ABRecordSetValue(justEmails, kABPersonNicknameProperty, @"justEmails", nil);
    ABRecordSetValue(justEmails, kABPersonEmailProperty, emailValues, nil);
    [contacts addObject:(__bridge id _Nonnull)(justEmails)];
    
    ABRecordRef justPhones = ABPersonCreate();
    ABRecordSetValue(justPhones, kABPersonNicknameProperty, @"justPhones", nil);
    ABRecordSetValue(justPhones, kABPersonPhoneProperty, phoneValues, nil);
    [contacts addObject:(__bridge id _Nonnull)(justPhones)];
    
    ABRecordRef empty = ABPersonCreate();
    [contacts addObject:(__bridge id _Nonnull)(empty)];
    
    return contacts;
}

@end
