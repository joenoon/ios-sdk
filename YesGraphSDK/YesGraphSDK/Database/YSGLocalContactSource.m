//
//  YSGLocalContactSource.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 25/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Contacts;
@import AddressBook;

#import "YSGContact.h"
#import "YSGLocalContactSource.h"

@interface YSGLocalContactSource ()

@property (nonatomic, strong) CNContactFormatter *formatter;

@property (nonatomic, readonly) BOOL didAskForPermission;
@property (nonatomic, readonly) BOOL hasContactsPermission;

@end

@implementation YSGLocalContactSource

#pragma mark - Getters and Setters

- (CNContactFormatter *)formatter
{
    if (!_formatter)
    {
        _formatter = [[CNContactFormatter alloc] init];
    }
    
    return _formatter;
}

#pragma mark - YSGContactSource

- (void)fetchLocalAddressBookWithCompletion:(void (^)(NSArray<YSGContact *> *contacts, NSError *error))completion
{
    if (!self.hasContactsPermission)
    {
        //return;
    }
    
    NSArray <NSString *> *keysToFetch = @[ [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName], CNContactEmailAddressesKey, CNContactPhoneNumbersKey ];
    
    CNContactStore *store = [[CNContactStore alloc] init];
    
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    
    NSMutableArray <YSGContact *> *contacts = [NSMutableArray array];
    
    NSError *error;
    
    [store enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop)
    {
        [contacts addObject:[self contactFromContact:contact]];
    }];
    
    if (completion)
    {
        completion (contacts.copy, error);
    }
}

#pragma mark - Private Methods

- (YSGContact *)contactFromContact:(CNContact *)contact
{
    YSGContact *graphContact = [[YSGContact alloc] init];
    
    graphContact.name = [self.formatter stringFromContact:contact];
    
    NSMutableArray <NSString *> * emails = [NSMutableArray array];
    
    for (CNLabeledValue *value in contact.emailAddresses)
    {
        [emails addObject:value.value];
    }
    
    graphContact.emails = emails.copy;
    
    NSMutableArray <NSString *> * phones = [NSMutableArray array];
    
    for (CNLabeledValue *value in contact.phoneNumbers)
    {
        CNPhoneNumber *phoneNumber = value.value;
        
        [phones addObject:phoneNumber.stringValue];
    }
    
    graphContact.phones = phones.copy;
    
    return graphContact;
}


@end
