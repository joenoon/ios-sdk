//
//  YesGraphSDKLocalContactSourceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Contacts;
@import XCTest;
#import "YSGLocalContactSource+ExposePrivateMethods.h"
#import "YSGLocalContactSource+OverrideContactStore.h"
#import "YSGLocalContactSource+OverrideAddressBook.h"
#import "YSGContactList.h"
#import "YSGTestMockData.h"
#import "YSGPointerPair.h"

@interface YesGraphSDKLocalContactSourceTests : XCTestCase
@property (strong, nonatomic) YSGLocalContactSource *localSource;
@end

@implementation YesGraphSDKLocalContactSourceTests

- (void)setUp
{
    [super setUp];
    [YSGLocalContactSource shouldReturnNil:YES];
    self.localSource = [YSGLocalContactSource new];
}

- (void)tearDown
{   
    [super tearDown];
    self.localSource = nil;
}

- (void)testLocalContactStoreFetchNil
{
    [self.localSource fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error)
    {
        XCTAssertNil(error, @"Error should be nil, not '%@'", error);
        XCTAssertEqual(contactList.entries.count, 0, @"There shouldn't be any entries in the contacts list");
    }];
}

- (void)testHasPermission
{
    XCTAssertTrue([YSGLocalContactSource hasPermission], @"We shouldn have contact permissions");
}

- (void)testUserDefaults
{
    XCTAssertEqual([NSUserDefaults standardUserDefaults], [YSGLocalContactSource userDefaults], @"User defaults from local source should be the same as standard user defaults");
}

- (void)testPromptTitle
{
    XCTAssert([self.localSource.contactAccessPromptTitle isEqualToString:@"Invite friends"], @"Access prompt title shouldn't be '%@'", self.localSource.contactAccessPromptTitle);
}

- (NSArray <CNLabeledValue *> *)convertToLabeledValues:(NSArray <NSString *> *)fromStrings withLabel:(NSString *)label
{
    NSMutableArray <CNLabeledValue *> *values = [NSMutableArray arrayWithCapacity:fromStrings.count];
    
    for (NSString *str in fromStrings)
    {
        [values addObject:[CNLabeledValue labeledValueWithLabel:label value:str]];
    }
    
    return values;
}

- (NSArray <CNLabeledValue *> *)convertToPhoneNumberValues:(NSArray <NSString *> *)fromStrings
{
    NSMutableArray <CNLabeledValue *> *values = [NSMutableArray arrayWithCapacity:fromStrings.count];
    
    for (NSString *str in fromStrings)
    {
        [values addObject:[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMain value:[CNPhoneNumber phoneNumberWithStringValue:str]]];
    }
    
    return values;
}

- (NSArray <YSGPointerPair *> *)generateCNContactsList
{
    NSMutableArray <YSGPointerPair *> *contacts = [NSMutableArray arrayWithCapacity:6];
    
    NSArray <NSString *> *emails = @[ @"full.name@email.com", @"fullname@email.com" ];
    NSArray <NSString *> *phones = @[ @"+1 111 111 111", @"+6 111 111 111" ];
    
    NSArray <CNLabeledValue *> *emailValues = [self convertToLabeledValues:emails withLabel:CNLabelEmailiCloud];
    NSArray <CNLabeledValue *> *phoneValues = [self convertToPhoneNumberValues:phones];
    
    CNMutableContact *fullName = [CNMutableContact new];
    fullName.namePrefix = @"Dr.";
    fullName.nameSuffix = @"phd.";
    fullName.givenName = @"Full";
    fullName.middleName = @"Entire";
    fullName.familyName = @"Name";
    fullName.nickname = @"fname";
    fullName.emailAddresses = emailValues;
    fullName.phoneNumbers = phoneValues;
    YSGContact *expectedFullName = [YSGContact new];
    expectedFullName.name = @"Dr. Full Entire Name phd.";
    expectedFullName.emails = emails.copy;
    expectedFullName.phones = phones.copy;
    [contacts addObject:[[YSGPointerPair alloc] initWith:fullName and:expectedFullName]];
    
    CNMutableContact *noMiddleName = [CNMutableContact new];
    noMiddleName.givenName = @"Full";
    noMiddleName.familyName = @"Name";
    noMiddleName.nickname = @"nomiddlename";
    noMiddleName.emailAddresses = emailValues;
    noMiddleName.phoneNumbers = phoneValues;
    YSGContact *expectednoMiddleName = [YSGContact new];
    expectednoMiddleName.name = @"Full Name";
    expectednoMiddleName.emails = emails.copy;
    expectednoMiddleName.phones = phones.copy;
    [contacts addObject:[[YSGPointerPair alloc] initWith:noMiddleName and:expectednoMiddleName]];
    
    CNMutableContact *noEmails = [CNMutableContact new];
    noEmails.givenName = @"Full";
    noEmails.familyName = @"Name";
    noEmails.nickname = @"noemails";
    noEmails.phoneNumbers = phoneValues;
    YSGContact *expectednoEmails = [YSGContact new];
    expectednoEmails.name = @"Full Name";
    expectednoEmails.phones = phones.copy;
    [contacts addObject:[[YSGPointerPair alloc] initWith:noEmails and:expectednoEmails]];
    
    CNMutableContact *justEmails = [CNMutableContact new];
    justEmails.emailAddresses = emailValues;
    YSGContact *expectedjustEmails = [YSGContact new];
    expectedjustEmails.emails = emails.copy;
    [contacts addObject:[[YSGPointerPair alloc] initWith:justEmails and:expectedjustEmails]];
    
    
    CNMutableContact *justPhones = [CNMutableContact new];
    justPhones.phoneNumbers = phoneValues;
    YSGContact *expectedjustPhones = [YSGContact new];
    expectedjustPhones.phones = phones.copy;
    [contacts addObject:[[YSGPointerPair alloc] initWith:justPhones and:expectedjustPhones]];
    
    CNContact *empty = [CNContact new];
    [contacts addObject:[[YSGPointerPair alloc] initWith:empty and:[YSGContact new]]];
    
    return contacts;
}

- (void)testYSGContactFromCNContact
{
    for (YSGPointerPair *pair in [self generateCNContactsList])
    {
        YSGContact *parsedContact = [self.localSource contactFromContact:(CNContact *)pair.item1];
        XCTAssertNotNil(parsedContact, @"Parsed contact shouldn't be nil for '%@'", pair.item1);
        YSGContact *expected = (YSGContact *)pair.item2;
        if (expected.name)
        {
            XCTAssert([parsedContact.name isEqualToString:expected.name], @"Parsed name '%@' not the same as expected '%@'", parsedContact.name, expected.name);
        }
        else
        {
            XCTAssert(!expected.name && !parsedContact.name, @"Expected a nil name, but parsed '%@'", parsedContact.name);
        }
        XCTAssertEqual(parsedContact.phones.count, expected.phones.count, @"Parsed phone list count '%lu' not the same as expected '%lu'", (unsigned long)parsedContact.phones.count, (unsigned long)expected.phones.count);
        XCTAssertEqual(parsedContact.emails.count, expected.emails.count, @"Parsed emails list count '%lu' not the same as expected '%lu'", (unsigned long)parsedContact.emails.count, (unsigned long)expected.emails.count);
    }
}

- (void)testYSGContactFromAddressBook
{
    [[self.localSource class] shouldReturnNil:NO];
    NSError *err = nil;
    NSArray <YSGContact *> *parsedContacts = [self.localSource contactListFromAddressBook:&err];
    XCTAssertNil(err, @"Error should be nil, but got '%@'", err);
    XCTAssertNotEqual(parsedContacts.count, 0, @"Parsed contacts shouldn't be empty");
}

- (void)testYSGSeperatedContactsFromYSGContact
{
    YSGContact *multiContact =  [YSGTestMockData mockContactList].entries.firstObject; // milton fuller contact
    XCTAssertEqual(multiContact.phones.count, 2, @"Test contact does not contain 2 phone numbers");
    XCTAssertEqual(multiContact.emails.count, 2, @"Test contact does not contain 2 email addresses");
    NSArray <YSGContact *> *splitContactsList = [self.localSource separatedContactsForContact:multiContact];
    XCTAssertEqual(splitContactsList.count, 2, @"Seperated contacts should always return 2 entries when count of emails and phones is larger than 0");
    YSGContact *modifiedOriginalContact = splitContactsList.firstObject;
    XCTAssert(modifiedOriginalContact == multiContact, @"First contact should be at the same address as the sent contact");
    YSGContact *copiedSeperateContact = splitContactsList.lastObject;
    XCTAssertNil(modifiedOriginalContact.emails, @"Emails in the first entry should be set to nil");
    XCTAssertNotNil(copiedSeperateContact.emails, @"Emails in the second entry shouldn't be set to nil");
    XCTAssertEqual(modifiedOriginalContact.phones.count, multiContact.phones.count, @"Phone numbers shouldn't be modified for the first contact entry");
    XCTAssert([modifiedOriginalContact.phones isEqualToArray:multiContact.phones], @"Phone numbers expected to be '%@' not '%@'", multiContact.phones, modifiedOriginalContact.phones);
    XCTAssertEqual(copiedSeperateContact.phones.count, 0, @"Phone contacts shouldn't be copied by the parsed contact");
    XCTAssert([multiContact.name isEqualToString:modifiedOriginalContact.name] && [multiContact.name isEqualToString:copiedSeperateContact.name], @"Contact names should match '%@', but got '%@' and '%@'", multiContact.name, modifiedOriginalContact.name, copiedSeperateContact.name);
    YSGContact *firstContact = [YSGTestMockData mockContactList].entries.firstObject;
    XCTAssertEqual(copiedSeperateContact.emails.count, firstContact.emails.count, @"Number of emails should be '%lu' not '%lu'", (unsigned long)firstContact.emails.count, copiedSeperateContact.emails.count);
    XCTAssert([copiedSeperateContact.emails isEqualToArray:firstContact.emails], @"Emails in the second entry should be '%@' not '%@'", firstContact.emails, copiedSeperateContact.emails);
}

@end
