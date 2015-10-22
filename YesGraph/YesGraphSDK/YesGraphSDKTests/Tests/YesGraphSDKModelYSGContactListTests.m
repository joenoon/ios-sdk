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
    NSArray *expectedSections = @[ @{ @"#": @9 }, @{ @"M": @2 }, @{ @"R": @1 }, @{ @"P": @1 }, @{ @"S": @2 }, @{ @"T": @1 }, @{ @"H": @1 }, @{ @"C": @3 } ];
    XCTAssertEqual(noSuggestions.allKeys.count, expectedSections.count, @"There should be '%lu' groups in contacts, but found '%lu'", (unsigned long)expectedSections.count, (unsigned long)noSuggestions.allKeys.count);
    for (NSUInteger index = 0; index < expectedSections.count; ++index)
    {
        NSDictionary *expectation = expectedSections[index];
        NSString *key = expectation.allKeys.firstObject;
        NSArray *contacts = [noSuggestions objectForKey:key];
        XCTAssertNotNil(contacts, @"Contacts shouldn't be nil for key '%@'", key);
        NSNumber *val = [expectation objectForKey:key];
        XCTAssertEqual(contacts.count, [val integerValue], @"Number of contacts in section '%@' should be '%@', but it was '%lu'", key, val, (unsigned long)contacts.count);
    }
}

- (void)testContactListOperationsSuggestions
{
    YSGContactList *mockedContacts = [YSGTestMockData mockContactList];
    mockedContacts.useSuggestions = YES;
    NSUInteger suggestionCount = 2;
    NSArray <YSGContact *> *suggestions = [mockedContacts suggestedEntriesWithNumberOfSuggestions:suggestionCount];
    XCTAssertEqual(suggestions.count, suggestionCount, @"The number of returned suggestions '%lu' is not '%lu'", (unsigned long)suggestions.count, (unsigned long)suggestionCount);
    for (NSUInteger index = 0; index < suggestionCount; ++index)
    {
        XCTAssert([suggestions[index].contactString isEqualToString:mockedContacts.entries[index].contactString], @"Contact string '%@' at index %lu is not the same as '%@'", suggestions[index].contactString, (unsigned long)index, mockedContacts.entries[index].contactString);
    }
}

- (void)testContactListOperationsSortedNumberOfSuggestionsBiggerThanEntriesCount
{
    YSGContactList *mockedContacts = [YSGTestMockData mockContactList];
    mockedContacts.useSuggestions = YES;
    NSUInteger suggestionCount = mockedContacts.entries.count + 1;
    
    XCTAssertNoThrow([mockedContacts sortedEntriesWithNumberOfSuggestions:suggestionCount], @"Exception was thrown while sorting contact list.");
    
    NSDictionary <NSString *, NSArray <YSGContact *> *> *sortedEntries = [mockedContacts sortedEntriesWithNumberOfSuggestions:suggestionCount];
    XCTAssertEqual(sortedEntries.count, 0, @"The number of returned entries '%lu' is not '%d'", (unsigned long)sortedEntries.count, 0);
}

@end
