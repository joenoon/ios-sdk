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

@property (nonatomic, assign) BOOL didAskForPermission;
@property (nonatomic, assign) BOOL hasContactsPermission;

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

- (void)fetchContactListWithCompletion:(void (^)(NSArray<YSGContact *> *, NSError *))completion
{
    //
    // TODO: Handle contacts permission
    //
    
    if (!self.hasContactsPermission)
    {
    }
    
    NSError* error;
    
    NSArray<YSGContact *> *contacts = [self contactListFromContacts:&error];
    
    //
    // On iOS 8 attempt to grab contacts from Address Book
    //
    if (contacts == nil && !error)
    {
        contacts = [self contactListFromAddressBook:&error];
    }
    
    if (completion)
    {
        completion (contacts, error);
    }
}

- (void)requestContactPermission:(void (^)(BOOL granted, NSError *error))completion
{
    
}

#pragma mark - Private Methods

#pragma mark - Contacts Framework

- (void)requestContactsPermissionWithCompletion:(void (^)(BOOL granted, NSError *error))completion
{
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error)
    {
        if (completion)
        {
            completion(granted, error);
        }
    }];
}

- (NSArray <YSGContact *> *)contactListFromContacts:(NSError **)error
{
    //
    // Protect against crash on iOS 8, where there is no contacts framework present
    //
    
    if (!NSClassFromString(@"CNContact"))
    {
        return nil;
    }
    
    NSArray <NSString *> *keysToFetch = @[ [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName], CNContactEmailAddressesKey, CNContactPhoneNumbersKey ];
    
    CNContactStore *store = [[CNContactStore alloc] init];
    
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    
    NSMutableArray <YSGContact *> *contacts = [NSMutableArray array];
    
    [store enumerateContactsWithFetchRequest:fetchRequest error:error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop)
    {
        [contacts addObject:[self contactFromContact:contact]];
    }];
    
    return contacts.copy;
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

#pragma mark - Address Book Framework

- (void)requestAddressBookPermissionWithCompletion:(void (^)(BOOL granted, NSError *error))completion
{
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef err)
    {
        NSError *error = (__bridge NSError *)err;
        
        if (completion)
        {
            completion(granted, error);
        }
    });
}

- (NSArray <YSGContact *> *)contactListFromAddressBook:(NSError **)error
{
    CFErrorRef err = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);
    
    if (addressBook != nil)
    {
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);

        NSMutableArray <YSGContact *> *contacts = [NSMutableArray array];
        
        for (NSUInteger i = 0; i < [allContacts count]; i++)
        {
            YSGContact *contact = [[YSGContact alloc] init];
            
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            contact.name = fullName;
            
            ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            ABMultiValueRef phones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            
            contact.emails = [self recordArrayFromValueRef:emails];
            contact.phones = [self recordArrayFromValueRef:phones];
            
            [contacts addObject:contact];
        }
        
        CFRelease(addressBook);
        
        return contacts.copy;
    }
    
    NSError *addressBookError = (__bridge NSError *)err;
    
    if (error)
    {
        *error = addressBookError;
    }
    
    return nil;
}

- (NSArray <NSString *> *)recordArrayFromValueRef:(ABMultiValueRef)valueRef
{
    NSMutableArray <NSString *> *values = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < ABMultiValueGetCount(valueRef); i++)
    {
        NSString *value = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(valueRef, i);
        
        [values addObject:value];
    }
    
    return values.copy;
}

@end
