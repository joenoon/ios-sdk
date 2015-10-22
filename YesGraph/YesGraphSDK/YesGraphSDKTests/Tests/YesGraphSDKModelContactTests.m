//
//  YesGraphSDKModelContactTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 14/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGTestMockData.h"

@interface YesGraphSDKModelContactTests : XCTestCase

@end

@implementation YesGraphSDKModelContactTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testContactMethods
{
    YSGContactList *mockedContacts = [YSGTestMockData mockContactList];
    for (YSGContact *contact in mockedContacts.entries)
    {
        if (contact.phones.count > 0)
        {
            XCTAssert([contact.phone isEqualToString:contact.phones[0]], @"Contact's phone should be the first entry in the list");
        }
        if (contact.emails.count > 0)
        {
            XCTAssert([contact.email isEqualToString:contact.emails[0]], @"Contact's email should be the first entry in the list");
        }
        NSString *contactString = contact.email ?: contact.phone;
        XCTAssert([contact.contactString isEqualToString:contactString], @"Contact string should be either an email or a phone number if no emails are present");
        
        if (contact.name)
        {
            NSString *sanitizedNameString = [contact.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            XCTAssert([contact.sanitizedName isEqualToString:sanitizedNameString], @"Contact's sanitized name string shouldn't include any whitespaces or newlines");
        }
    }
}

- (void)compareContact:(YSGContact *)contact withDictionary:(NSDictionary *)dictionary
{
    XCTAssertNotNil(contact, @"Contact should not be nil after parsing values from: %@", dictionary);
    NSString *name = [dictionary objectForKey:@"name"];
    XCTAssert([contact.name isEqualToString:name], @"Contact name '%@' is not the same as '%@'", contact.name, name);

    id emailObject = [dictionary objectForKey:@"emails"];

    if ([emailObject isKindOfClass:[NSArray class]])
    {
        NSArray *emails = (NSArray *)emailObject;
        XCTAssertEqual(contact.emails.count, emails.count, @"Emails count '%lu' is not the same as in dictionary '%lu'", (unsigned long)contact.emails.count, (unsigned long)emails.count);
        for (NSUInteger index = 0; index < emails.count; ++index)
        {
            XCTAssert([contact.emails[index] isEqualToString:emails[index]], @"The email '%@' at index '%lu' is not the same as '%@'", contact.emails[index], (unsigned long)index, emails[index]);
        }
    }
    else if ([emailObject isKindOfClass:[NSString class]])
    {
        NSString *email = (NSString *)emailObject;
        XCTAssert([contact.emails isKindOfClass:[NSString class]], @"Parsing a wrong type should also change the type of the class");
        XCTAssert([((NSString *)contact.emails) isEqualToString:email], @"The contact should only contain 1 email '%@' that should match '%@'", contact.email, email);
    }


    id phoneObject = [dictionary objectForKey:@"phones"];

    if ([phoneObject isKindOfClass:[NSArray class]])
    {
        NSArray *phones = (NSArray *)phoneObject;
        XCTAssertEqual(contact.phones.count, phones.count, @"Phones count '%lu' is not the same as in dictionary '%lu'", (unsigned long)contact.phones.count, (unsigned long)phones.count);
        for (NSUInteger index = 0; index < phones.count; ++index)
        {
            XCTAssert([contact.phones[index] isEqualToString:phones[index]], @"The phone '%@' at index '%lu' is not the same as '%@'", contact.phones[index], (unsigned long)index, phones[index]);
        }
    }
    else if ([phoneObject isKindOfClass:[NSString class]])
    {
        NSString *phone = (NSString *)phoneObject;
        XCTAssert([contact.phones isKindOfClass:[NSString class]], @"Parsing a wrong type should also change the type of the class");
        XCTAssert([((NSString *)contact.phones) isEqualToString:phone], @"The contact should only contain 1 phone '%@' that should match '%@'", contact.phone, phone);
    }
}

- (void)testContactParsable
{
    NSDictionary *validContactValues1 = @
     {
         @"name": @"Test Name String",
         @"emails": @[ @"valid.email@string.com" ],
         @"phones": @[ @"+386 01 111 111" ],
     };
    NSDictionary *validContactValues2 = @
     {
         @"name": @"Test Name String #2",
         @"emails": @[ @"valid.email@string.com", @"valid.email2@string.com" ],
         @"phones": @[ @"+386 01 111 111", @"+386 02 222 222" ],
     };
    NSDictionary *validContactValues3 = @
     {
         @"name": @"Test Name String",
         @"emails": @"invalid.email@string.com",
         @"phones": @"+386 01 111 111"
     };
    NSDictionary *invalidContactValues1 = @
     {
         @"name": @"Test Name String"
     };
    NSDictionary *invalidContactValues3 = @
     {
         @"name": @"Test Name String",
         @"email": @"invalid.email@string.com",
         @"phone": @"+386 01 111 111"
     };

    YSGContact *validContact1 = [YSGContact ysg_objectWithDictionary:validContactValues1];
    [self compareContact:validContact1 withDictionary:validContactValues1];
    YSGContact *validContact2 = [YSGContact ysg_objectWithDictionary:validContactValues2];
    [self compareContact:validContact2 withDictionary:validContactValues2];
    YSGContact *validContact3 = [YSGContact ysg_objectWithDictionary:validContactValues3];
    [self compareContact:validContact3 withDictionary:validContactValues3];

    {
        YSGContact *invalidContact1 = [YSGContact ysg_objectWithDictionary:invalidContactValues1];
        // it should only contain the name
        XCTAssertNotNil(invalidContact1, @"The contact shouldn't be nil even though it has an invalid state");
        NSString *name = [invalidContactValues1 objectForKey:@"name"];
        XCTAssert([invalidContact1.name isEqualToString:name], @"Invalid contact's name '%@' is not the same as '%@'", invalidContact1.name, name);
        XCTAssertNil(invalidContact1.emails, @"Emails should be nil");
        XCTAssertNil(invalidContact1.phones, @"Phones should be nil");
    }

    {
        YSGContact *invalidContact3 = [YSGContact ysg_objectWithDictionary:invalidContactValues3];
        // it should only contain the name
        XCTAssertNotNil(invalidContact3, @"The contact shouldn't be nil even though it has an invalid state");
        NSString *name = [invalidContactValues3 objectForKey:@"name"];
        XCTAssert([invalidContact3.name isEqualToString:name], @"Invalid contact's name '%@' is not the same as '%@'", invalidContact3.name, name);
        XCTAssertNil(invalidContact3.emails, @"Emails should be nil");
        XCTAssertNil(invalidContact3.phones, @"Phones should be nil");
    }

}

@end
