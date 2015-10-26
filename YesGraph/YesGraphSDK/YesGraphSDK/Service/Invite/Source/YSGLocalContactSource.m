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
#import "YSGContactList.h"
#import "YSGLocalContactSource.h"

static NSString *const YSGLocalContactSourcePermissionKey = @"YSGLocalContactSourcePermissionKey";

@interface YSGLocalContactSource ()

@property (nonatomic, strong) CNContactFormatter *formatter;

@end

@implementation YSGLocalContactSource

#pragma mark - Getters and Setters

+ (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

- (CNContactStore *)contactStore
{
    return [CNContactStore new];
}

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
        
        NSString *longMessage = [NSLocalizedString(@"Share entries with ", "") stringByAppendingString:[appName stringByAppendingString:NSLocalizedString(@" app to find friends to invite?", @"")]];
        NSString *shortMessage = NSLocalizedString(@"Share entries to find friends to invite?", @"");
        
        return (appName.length) ? longMessage : shortMessage;
    }
    
    return _contactAccessPromptMessage;
}

+ (BOOL)didAskForPermission
{
    return [self.userDefaults boolForKey:YSGLocalContactSourcePermissionKey];
}

+ (void)setDidAskForPermission:(BOOL)didAskForPermission
{
    [self.userDefaults setBool:didAskForPermission forKey:YSGLocalContactSourcePermissionKey];
    [self.userDefaults synchronize];
}

+ (BOOL)hasPermission
{
    if ([self useContactsFramework])
    {
        return [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized;
    }
    else
    {
        return ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized;
    }
}

+ (BOOL)useContactsFramework
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

- (void)fetchContactListWithCompletion:(void (^)(YSGContactList *contactList, NSError *))completion
{
    NSError* error;
    
    NSArray<YSGContact *> *entries = nil;
    
    if ([self class].useContactsFramework)
    {
        entries = [self contactListFromContacts:&error];
    }
    else
    {
        entries = [self contactListFromAddressBook:&error];
    }
    
    if (completion)
    {
        YSGContactList *contactList = [[YSGContactList alloc] init];
        contactList.entries = entries;
        contactList.source = [YSGSource userSource];
        
        completion (contactList, error);
    }
}



#pragma mark - Permissions

- (void)requestContactPermission:(void (^)(BOOL granted, NSError *error))completion
{
    //
    // If we already have permission, we do not request it again and just return
    //
    
    if ([self class].hasPermission)
    {
        if (completion)
        {
            completion([self class].hasPermission, nil);
        }
        
        return;
    }
    
    //
    // First ask user with a specific popup
    //
    
    if (![self class].didAskForPermission)
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:self.contactAccessPromptTitle message:self.contactAccessPromptMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dontAllowAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Don't allow", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {
            
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            //
            // Remember the decision
            //
            
            [self class].didAskForPermission = YES;
            
            [self requestContactPermission:completion];
        }];
        
        [controller addAction:dontAllowAction];
        [controller addAction:okAction];
        
        [controller ysg_show];
    }
    else
    {
        if ([self class].useContactsFramework)
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
    CNContactStore *store = [self contactStore];
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
    
    CNContactStore *store = [self contactStore];
    
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    
    NSMutableArray <YSGContact *> *entries = [NSMutableArray array];
    
    [store enumerateContactsWithFetchRequest:fetchRequest error:error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop)
    {
        YSGContact *userContact = [self contactFromContact:contact];
        
        [entries addObjectsFromArray:[self separatedContactsForContact:userContact]];
    }];
    
    return entries.copy;
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

        NSMutableArray <YSGContact *> *entries = [NSMutableArray array];
        
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
            
            [entries addObjectsFromArray:[self separatedContactsForContact:contact]];
        }
        
        CFRelease(addressBook);
        
        return entries.copy;
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

#pragma mark - Private Methods

- (NSArray<YSGContact *> *)separatedContactsForContact:(YSGContact *)contact
{
    if (contact.phones.count == 0 || contact.emails.count == 0)
    {
        return @[ contact ];
    }
    
    YSGContact *separatedContact = [[YSGContact alloc] init];
    separatedContact.name = contact.name;
    separatedContact.emails = contact.emails;
    
    contact.emails = nil;
    
    return @[ contact, separatedContact ];
}

@end
