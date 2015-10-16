//
//  YesGraphSDKModelYSGContactListTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 15/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGTestMockData.h"

@interface YesGraphSDKModelYSGContactListTests : XCTestCase

@end

@implementation YesGraphSDKModelYSGContactListTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testContactListOperationsSorted
{
    YSGContactList *mockedContacts = [YSGTestMockData mockContactList];
    NSDictionary <NSString *, NSArray <YSGContact *> *> *noSuggestions = [mockedContacts sortedEntriesWithNumberOfSuggestions:0];
    XCTAssertNotNil(noSuggestions, @"Sorted contacts shouldn't be nil");
    NSArray *expectedSections = @[ @{ @"M": @1 }, @{ @"R": @1 }, @{ @"P": @1 }, @{ @"S": @2 }, @{ @"T": @1 }, @{ @"H": @1 }, @{ @"C": @1 } ];
    XCTAssertEqual(noSuggestions.allKeys.count, expectedSections.count, @"There should be '%lu' groups in contacts, but found '%lu'", expectedSections.count, noSuggestions.allKeys.count);
    for (NSUInteger index = 0; index < expectedSections.count; ++index)
    {
        NSDictionary *expectation = expectedSections[index];
        NSString *key = expectation.allKeys.firstObject;
        NSArray *contacts = [noSuggestions objectForKey:key];
        XCTAssertNotNil(contacts, @"Contacts shouldn't be nil for key '%@'", key);
        NSNumber *val = [expectation objectForKey:key];
        XCTAssertEqual(contacts.count, [val integerValue], @"Number of contacts in section '%@' should be '%@', but it was '%lu'", key, val, contacts.count);
    }
}

- (void)testContactListOperationsSuggestions
{
    YSGContactList *mockedContacts = [YSGTestMockData mockContactList];
    mockedContacts.useSuggestions = YES;
    NSUInteger suggestionCount = 2;
    NSArray <YSGContact *> *suggestions = [mockedContacts suggestedEntriesWithNumberOfSuggestions:suggestionCount];
    XCTAssertEqual(suggestions.count, suggestionCount, @"The number of returned suggestions '%lu' is not '%lu'", suggestions.count, suggestionCount);
    for (NSUInteger index = 0; index < suggestionCount; ++index)
    {
        XCTAssert([suggestions[index].contactString isEqualToString:mockedContacts.entries[index].contactString], @"Contact string '%@' at index %lu is not the same as '%@'", suggestions[index].contactString, index, mockedContacts.entries[index].contactString);
    }
}

@end
