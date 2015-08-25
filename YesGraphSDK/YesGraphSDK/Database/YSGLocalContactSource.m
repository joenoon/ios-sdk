//
//  YSGLocalContactSource.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 25/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import UIKit;
@import Contacts;
@import AddressBook;

#import "UIAlertController+YSGDisplay.h"
#import "YSGContact.h"
#import "YSGLocalContactSource.h"

static NSString *const YSGLocalContactSourcePermissionKey = @"YSGLocalContactSourcePermissionKey";

@interface YSGLocalContactSource ()

@property (nonatomic, strong) CNContactFormatter *formatter;

@property (nonatomic, assign) BOOL didAskForPermission;
@property (nonatomic, assign) BOOL hasContactsPermission;

@end

@implementation YSGLocalContactSource

#pragma mark - Getters and Setters

- (NSString *)contactAccessPromptTitle
{
    if (!_contactAccessPromptTitle)
    {
        return @"Invite friends";
    }
    
    return _contactAccessPromptTitle;
}

- (NSString *)contactAccessPromptMessage
{
    if (!_contactAccessPromptMessage)
    {
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        
        if (appName)
        {
            appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        }
        
        return (appName.length) ? [NSString stringWithFormat:@"Share contacts with %@ app to find friends to invite?", appName] : @"Share contacts to find friends to invite?";
    }
    
    return _contactAccessPromptMessage;
}

- (BOOL)didAskForPermission
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:YSGLocalContactSourcePermissionKey];
}

- (void)setDidAskForPermission:(BOOL)didAskForPermission
{
    [[NSUserDefaults standardUserDefaults] setBool:didAskForPermission forKey:YSGLocalContactSourcePermissionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)hasPermission
{
    if ([self useContactsFramework])
    {
        return [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    }
    else
    {
        return ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized;
    }
}

- (BOOL)useContactsFramework
{
    return [[CNContactStore alloc] init] != nil;
}

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
    NSError* error;
    
    NSArray<YSGContact *> *contacts = nil;
    
    if (self.useContactsFramework)
    {
        contacts = [self contactListFromContacts:&error];
    }
    else
    {
        contacts = [self contactListFromAddressBook:&error];
    }
    
    YSGContact* contact = [[YSGContact alloc] init];
    contact.name = @"Dal Special Contact";
    contact.phones = @[];
    contact.emails = @[ @"legoless@gmail.com" ];
    
    contacts = [contacts arrayByAddingObject:contact];
    
    if (completion)
    {
        completion (contacts, error);
    }
}

#pragma mark - Permissions

- (void)requestContactPermission:(void (^)(BOOL granted, NSError *error))completion
{
    //
    // If we already have permission, we do not request it again and just return
    //
    
    if (self.hasPermission)
    {
        if (completion)
        {
            completion(self.hasPermission, nil);
        }
        
        return;
    }
    
    //
    // First ask user with a specific popup
    //
    
    if (!self.didAskForPermission)
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:self.contactAccessPromptTitle message:self.contactAccessPromptMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dontAllowAction = [UIAlertAction actionWithTitle:@"Don't allow" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {
            
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            //
            // Remember the decision
            //
            
            self.didAskForPermission = YES;
            
            [self requestContactPermission:completion];
        }];
        
        [controller addAction:dontAllowAction];
        [controller addAction:okAction];
        
        [controller ysg_show];
    }
    else
    {
        if (self.useContactsFramework)
        {
            [self requestContactsPermissionWithCompletion:completion];
        }
        else
        {
            [self requestAddressBookPermissionWithCompletion:completion];
        }
    }
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
    NSArray <NSString *> *keysToFetch = @[ [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName], CNContactEmailAddressesKey, CNContactPhoneNumbersKey ];
    
    CNContactStore *store = [[CNContactStore alloc] init];
    
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    
    NSMutableArray <YSGContact *> *contacts = [NSMutableArray array];
    
    [store enumerateContactsWithFetchRequest:fetchRequest error:error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop)
    {
        YSGContact *userContact = [self contactFromContact:contact];
        
        if (userContact.emails.count || userContact.phones.count)
        {
            [contacts addObject:userContact];
        }
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
            
            if (contact.emails.count || contact.phones.count)
            {
                [contacts addObject:contact];
            }
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
