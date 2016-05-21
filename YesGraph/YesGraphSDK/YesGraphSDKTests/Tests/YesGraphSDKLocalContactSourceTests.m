//
//  YesGraphSDKLocalContactSourceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Contacts;
@import XCTest;
@import OCMock;
#import "YSGLocalContactSource+ExposePrivateMethods.h"
#import "YSGLocalContactSource+OverrideContactStore.h"
#import "YSGLocalContactSource+OverrideAddressBook.h"
#import "YSGUIAlertController+YSGDisplayOverride.h"
#import "YSGContactList.h"
#import "YSGTestMockData.h"

@interface YesGraphSDKLocalContactSourceTests : XCTestCase
@property (strong, nonatomic) YSGLocalContactSource *localSource;
@property (strong, nonatomic) NSMutableArray <YSGContact *> *expectedContactsSequence;
@property (strong, nonatomic) NSArray <NSString *> *mockedEmailAddressSequences;
@property (strong, nonatomic) NSArray <NSString *> *mockedPhoneNumberSequences;
@end

@implementation YesGraphSDKLocalContactSourceTests

- (void)setUp
{
    [super setUp];
    [YSGLocalContactSource shouldReturnNil:YES];
    self.localSource = [YSGLocalContactSource new];
    self.expectedContactsSequence = [NSMutableArray new];
    self.mockedEmailAddressSequences = @[ @"full.name@email.com", @"fullname@email.com" ];
    self.mockedPhoneNumberSequences = @[ @"+1 111 111 111", @"+6 111 111 111" ];
    
    YSGContact *expectedFullName = [YSGContact new];
    expectedFullName.name = @"Full Entire Name";
    expectedFullName.emails = self.mockedEmailAddressSequences.copy;
    expectedFullName.phones = self.mockedPhoneNumberSequences.copy;
    [self.expectedContactsSequence addObject:expectedFullName];
    
    YSGContact *expectednoMiddleName = [YSGContact new];
    expectednoMiddleName.name = @"Full Name";
    expectednoMiddleName.emails = self.mockedEmailAddressSequences.copy;
    expectednoMiddleName.phones = self.mockedPhoneNumberSequences.copy;
    [self.expectedContactsSequence addObject:expectednoMiddleName];
    
    YSGContact *expectednoEmails = [YSGContact new];
    expectednoEmails.name = @"Full Name";
    expectednoEmails.phones = self.mockedPhoneNumberSequences.copy;
    [self.expectedContactsSequence addObject:expectednoEmails];
    
    YSGContact *expectedjustEmails = [YSGContact new];
    expectedjustEmails.emails = self.mockedEmailAddressSequences.copy;
    [self.expectedContactsSequence addObject:expectedjustEmails];
    
    YSGContact *expectedjustPhones = [YSGContact new];
    expectedjustPhones.phones = self.mockedPhoneNumberSequences.copy;
    [self.expectedContactsSequence addObject:expectedjustPhones];
    
    [self.expectedContactsSequence addObject:[YSGContact new]];
}

- (void)tearDown
{   
    [super tearDown];
    self.localSource = nil;
    [UIAlertController setYsgShowWasTriggered:nil];
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

- (NSArray <CNContact *> *)generateCNContactsList
{
    NSMutableArray <CNContact *> *contacts = [NSMutableArray arrayWithCapacity:6];

    NSArray <CNLabeledValue *> *emailValues = [self convertToLabeledValues:self.mockedEmailAddressSequences withLabel:CNLabelEmailiCloud];
    NSArray <CNLabeledValue *> *phoneValues = [self convertToPhoneNumberValues:self.mockedPhoneNumberSequences];
    
    CNMutableContact *fullName = [CNMutableContact new];
    fullName.givenName = @"Full";
    fullName.middleName = @"Entire";
    fullName.familyName = @"Name";
    fullName.nickname = @"fname";
    fullName.emailAddresses = emailValues;
    fullName.phoneNumbers = phoneValues;
    [contacts addObject:fullName];
    
    CNMutableContact *noMiddleName = [CNMutableContact new];
    noMiddleName.givenName = @"Full";
    noMiddleName.familyName = @"Name";
    noMiddleName.nickname = @"nomiddlename";
    noMiddleName.emailAddresses = emailValues;
    noMiddleName.phoneNumbers = phoneValues;
    [contacts addObject:noMiddleName];
    
    CNMutableContact *noEmails = [CNMutableContact new];
    noEmails.givenName = @"Full";
    noEmails.familyName = @"Name";
    noEmails.nickname = @"noemails";
    noEmails.phoneNumbers = phoneValues;
    [contacts addObject:noEmails];
    
    CNMutableContact *justEmails = [CNMutableContact new];
    justEmails.emailAddresses = emailValues;
    [contacts addObject:justEmails];
    
    CNMutableContact *justPhones = [CNMutableContact new];
    justPhones.phoneNumbers = phoneValues;
    [contacts addObject:justPhones];
    
    CNContact *empty = [CNContact new];
    [contacts addObject:empty];
    
    return contacts;
}

- (void)compareYsgContact:(YSGContact *)expected with:(YSGContact *)compared
{
    XCTAssertNotNil(compared, @"Parsed contact shouldn't be nil'");
    if (expected.name)
    {
        XCTAssert([compared.name isEqualToString:expected.name], @"Parsed name '%@' not the same as expected '%@'", compared.name, expected.name);
    }
    else
    {
        XCTAssert(!expected.name && !compared.name, @"Expected a nil name, but parsed '%@'", compared.name);
    }
    XCTAssertEqual(compared.phones.count, expected.phones.count, @"Parsed phone list count '%lu' not the same as expected '%lu'", (unsigned long)compared.phones.count, (unsigned long)expected.phones.count);
    XCTAssertEqual(compared.emails.count, expected.emails.count, @"Parsed emails list count '%lu' not the same as expected '%lu'", (unsigned long)compared.emails.count, (unsigned long)expected.emails.count);
    if (expected.phones.count != 0)
    {
        XCTAssert([compared.phones isEqualToArray:expected.phones], @"Phone number list expected to be '%@' not '%@'", expected.phones, compared.phones);
    }
    if (expected.emails.count != 0)
    {
        XCTAssert([compared.emails isEqualToArray:expected.emails], @"Email address list expected to be '%@' not '%@'", expected.emails, compared.emails);
    }
}

- (void)testYSGContactFromCNContact
{
    NSArray <CNContact *> *generatedContactsList = [self generateCNContactsList];
    XCTAssertEqual(generatedContactsList.count, self.expectedContactsSequence.count, @"Generated contacts list is not the same size as the expected contacts list");
    
    for (NSUInteger index = 0; index < generatedContactsList.count; ++index)
    {
        YSGContact *parsedContact = [self.localSource contactFromContact:generatedContactsList[index]];
        [self compareYsgContact:self.expectedContactsSequence[index] with:parsedContact];
    }
}

- (void)testYSGContactFromAddressBook
{
    [[self.localSource class] shouldReturnNil:NO];
    NSMutableArray <YSGContact *> *seperatedContacts = [NSMutableArray new];
    // we have to 'prep' the expected array since the contactListFromAddressBook does this as well and we'll have 8
    // entries instead of 6
    for (YSGContact *actualContact in self.expectedContactsSequence)
    {
        [seperatedContacts addObjectsFromArray:[self.localSource separatedContactsForContact:actualContact]];
    }
    NSError *err = nil;
    NSArray <YSGContact *> *parsedContacts = [self.localSource contactListFromAddressBook:&err];
    XCTAssertNil(err, @"Error should be nil, but got '%@'", err);
    XCTAssertEqual(parsedContacts.count, seperatedContacts.count, @"Expected '%lu' contacts from address book, not '%lu'", (unsigned long)seperatedContacts.count, (unsigned long)parsedContacts.count);
    for (NSUInteger index = 0; index < seperatedContacts.count; ++index)
    {
        [self compareYsgContact:seperatedContacts[index] with:parsedContacts[index]];
    }
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
    XCTAssertEqual(copiedSeperateContact.emails.count, firstContact.emails.count, @"Number of emails should be '%lu' not '%lu'", (unsigned long)firstContact.emails.count, (unsigned long)copiedSeperateContact.emails.count);
    XCTAssert([copiedSeperateContact.emails isEqualToArray:firstContact.emails], @"Emails in the second entry should be '%@' not '%@'", firstContact.emails, copiedSeperateContact.emails);
}

- (void)testPermissionsDidNotAskGrantedFalse
{
    id mock = [OCMockObject partialMockForObject:self.localSource];
    OCMStub([mock hasPermission]).andReturn(NO);
    OCMStub([mock didAskForPermission]).andReturn(NO);
    OCMStub([mock contactAccessPromptTitle]).andReturn(@"Mocked Title");
    OCMStub([mock contactAccessPromptMessage]).andReturn(@"Mocked message");
    //OCMStub([mock setDidAskForPermission:YES]);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expected UIAlertController To Show"];
    
    [UIAlertController setYsgShowWasTriggered:^(BOOL withAnimationArgument, UIAlertController *controller)
    {
        XCTAssertNotNil(controller, @"Displayed controller shouldn't be nil");
        XCTAssertEqual(controller.actions.count, 2, @"There should be 2 actions associated with alert controller");
        NSString *expectedDontAllow = @"Don't allow";
        NSString *expectedOk = @"Ok";
        XCTAssert([controller.actions.firstObject.title isEqualToString:expectedDontAllow], @"First controller action should have the title '%@', but title was '%@'", expectedDontAllow, controller.actions.firstObject.title);
        XCTAssert([controller.actions.lastObject.title isEqualToString:expectedOk], @"Second controller action should have the title '%@', but title was '%@'", expectedOk, controller.actions.lastObject.title);
        XCTAssert([controller.title isEqualToString:[self.localSource contactAccessPromptTitle]], @"Controller's title should be '%@', but was '%@'", [self.localSource contactAccessPromptTitle], controller.title);
        [expectation fulfill];
        
        // Following code from http://stackoverflow.com/questions/36926827/how-can-you-test-the-contents-of-a-uialertaction-handler-with-ocmock
        //Get the "Don't Allow" button
        UIAlertAction *action = controller.actions[0];
        
        //Cast the pointer of the handle block into a form that we can execute
        void (^someBlock)(id obj) = [action valueForKey:@"handler"];
        
        //Execute the code of the join button
        someBlock(action);
    }];
    
    [self.localSource requestContactPermission:^(BOOL granted, NSError * _Nullable error)
    {
        XCTAssertFalse(granted);
        XCTAssertNil(error);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, @"Expectation timed-out with error '%@'", error);
    }];
}


- (void)testPermissionsDidNotAskGrantedTrue
{
    id mock = [OCMockObject partialMockForObject:self.localSource];
    OCMStub([mock hasPermission]).andReturn(NO);
    OCMStub([mock didAskForPermission]).andReturn(NO);
    OCMStub([mock contactAccessPromptTitle]).andReturn(@"Mocked Title");
    OCMStub([mock contactAccessPromptMessage]).andReturn(@"Mocked message");
    //OCMStub([mock setDidAskForPermission:YES]);
    
    [UIAlertController setYsgShowWasTriggered:^(BOOL withAnimationArgument, UIAlertController *controller)
     {
         XCTAssertNotNil(controller, @"Displayed controller shouldn't be nil");
         XCTAssertEqual(controller.actions.count, 2, @"There should be 2 actions associated with alert controller");
         NSString *expectedDontAllow = @"Don't allow";
         NSString *expectedOk = @"Ok";
         XCTAssert([controller.actions.firstObject.title isEqualToString:expectedDontAllow], @"First controller action should have the title '%@', but title was '%@'", expectedDontAllow, controller.actions.firstObject.title);
         XCTAssert([controller.actions.lastObject.title isEqualToString:expectedOk], @"Second controller action should have the title '%@', but title was '%@'", expectedOk, controller.actions.lastObject.title);
         XCTAssert([controller.title isEqualToString:[self.localSource contactAccessPromptTitle]], @"Controller's title should be '%@', but was '%@'", [self.localSource contactAccessPromptTitle], controller.title);

     }];
    
    [self.localSource requestContactPermission:^(BOOL granted, NSError * _Nullable error)
     {
         XCTAssertTrue(granted);
         XCTAssertNil(error);
     }];
}


- (void)testPermissionsDidAskContactStore
{
    id mock = [OCMockObject partialMockForObject:self.localSource];
    OCMStub([mock hasPermission]).andReturn(NO);
    OCMStub([mock didAskForPermission]).andReturn(YES);
    [self.localSource requestContactPermission:^(BOOL granted, NSError * _Nullable error)
     {
         XCTAssertTrue(granted);
         XCTAssertNil(error);
     }];
}

- (void)testPermissionsDidAskAddressBook
{
    id mock = [OCMockObject partialMockForObject:self.localSource];
    OCMStub([mock hasPermission]).andReturn(NO);
    OCMStub([mock didAskForPermission]).andReturn(YES);
    OCMStub([mock useContactsFramework]).andReturn(NO);
    
    [self.localSource requestContactPermission:^(BOOL granted, NSError * _Nullable error)
     {
         XCTAssertFalse(granted);
         XCTAssertNil(error);
     }];
}


- (void)testContactAccessPromptMessageLong
{
    id mock = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
    NSString *mockedBundleDisplayName = @"MockedBundleDisplayName";
    OCMStub([mock objectForInfoDictionaryKey:@"CFBundleDisplayName"]).andReturn(mockedBundleDisplayName);
    NSString *mockedBundleName = @"MockedBundle";
    OCMStub([mock objectForInfoDictionaryKey:@"CFBundleName"]).andReturn(mockedBundleName);
    NSString *expected = [NSString stringWithFormat:@"Share entries with %@ app to find friends to invite?", mockedBundleName];
    XCTAssert([self.localSource.contactAccessPromptMessage isEqualToString:expected], @"Expected prompt message to be '%@', but got '%@'", expected, self.localSource.contactAccessPromptMessage);
}

- (void)testContactAccessPromptMessageShort
{
    id mock = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
    OCMStub([mock objectForInfoDictionaryKey:@"CFBundleDisplayName"]).andReturn(@"");
    OCMStub([mock objectForInfoDictionaryKey:@"CFBundleName"]).andReturn(@"");
    NSString *expected = @"Share entries to find friends to invite?";
    XCTAssert([self.localSource.contactAccessPromptMessage isEqualToString:expected], @"Expected prompt message to be '%@', but got '%@'", expected, self.localSource.contactAccessPromptMessage);
}

- (void)testSetDidAskForPermission
{
    [[self.localSource class] setDidAskForPermission:NO];
    XCTAssertFalse([[self.localSource class] didAskForPermission], @"Did as for permission should be set to NO");
    [[self.localSource class] setDidAskForPermission:YES];
    XCTAssertTrue([[self.localSource class] didAskForPermission], @"Did as for permission should be set to YES");
}

@end
