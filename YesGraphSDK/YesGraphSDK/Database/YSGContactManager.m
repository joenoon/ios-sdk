//
//  YSGContactManager.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 19/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Contacts;
@import AddressBook;

#import "YSGContactManager.h"

@interface YSGContactManager ()

@property (nonatomic, strong) CNContactFormatter *formatter;

@end

@implementation YSGContactManager

#pragma mark - Public Methods

+ (instancetype)shared
{
    static id shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (void)fetchContactListWithCompletion:(void (^)(NSArray<YSGContact *> *contacts, NSError *error))completion
{
    if (!completion)
    {
        return;
    }
}

#pragma mark - Private Methods

- (void)fetchLocalAddressBookWithCompletion:(void (^)(NSArray<YSGContact *> *contacts, NSError *error))completion
{
    if (!self.hasContactsPermission)
    {
        return;
    }
    
    NSArray <NSString *> *keysToFetch = @[ [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName], CNContactEmailAddressesKey, CNContactPhoneNumbersKey ];
    
    CNContactStore *store = [[CNContactStore alloc] init];
    
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    
    NSMutableArray <YSGContact *> *contacts = [NSMutableArray array];
    
    NSError *error;
    
    [store enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
    }];
    
    if (completion)
    {
        completion (contacts.copy, error);
    }
}

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
