//
//  YesGraphSDKModelYSGContactListTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 15/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGContactList+ExposedPrivate.h"
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
    NSArray *expectedSections = @[ @{ @"#": @9 }, @{ @"M": @2 }, @{ @"R": @1 }, @{ @"P": @1 }, @{ @"S": @3 }, @{ @"T": @1 }, @{ @"H": @1 }, @{ @"C": @3 } ];
    XCTAssertEqual(noSuggestions.allKeys.count, expectedSections.count, @"There should be '%lu' groups in contacts, but found '%lu'", (unsigned long)expectedSections.count, (unsigned long)noSuggestions.allKeys.count);
    for (NSUInteger index = 0; index < expectedSections.count; ++index)
    {
        NSDictionary *expectation = expectedSections[index];
        NSString *key = expectation.allKeys.firstObject;
        NSArray *contacts = noSuggestions[key];
        XCTAssertNotNil(contacts, @"Contacts shouldn't be nil for key '%@'", key);
        NSNumber *val = expectation[key];
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

- (void)checkNumberOfSuggestionsReturnedFor:(NSUInteger)expected
{
    YSGContactList *mockedContacts = [YSGTestMockData mockContactList];
    mockedContacts.useSuggestions = YES;
    NSArray <YSGContact *> *suggestions = [mockedContacts suggestedEntriesWithNumberOfSuggestions:expected];
    XCTAssertEqual(suggestions.count, expected, @"The number of returned suggestions '%lu' is not '%lu'", (unsigned long)suggestions.count, (unsigned long)expected);
}

- (void)testNumericValidityOfReturnedSuggestions
{
    for (NSUInteger expect = 0; expect <= 5; ++expect)
    {
        [self checkNumberOfSuggestionsReturnedFor:expect];
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

- (void)testContactListOperationsSortedNumberOfSuggestionsSmallerThanCount
{
    YSGContactList *mockedContacts = [YSGTestMockData mockContactList];
    mockedContacts.useSuggestions = YES;
    NSUInteger suggestionCount = 1;
    NSDictionary <NSString *, NSNumber *> *expectedEntryCounts = @
    {
        @"M": @1,
        @"R": @1,
        @"P": @1,
        @"S": @3,
        @"T": @1,
        @"C": @3,
        @"H": @1,
        @"#": @9
    };
    NSUInteger expectedCount = expectedEntryCounts.count;
    
    XCTAssertNoThrow([mockedContacts sortedEntriesWithNumberOfSuggestions:suggestionCount], @"Exception was thrown while sorting contact list.");
    
    NSDictionary <NSString *, NSArray <YSGContact *> *> *sortedEntries = [mockedContacts sortedEntriesWithNumberOfSuggestions:suggestionCount];
    XCTAssertEqual(sortedEntries.count, expectedCount, @"The number of returned entries '%lu' is not '%lu'", (unsigned long)sortedEntries.count, (unsigned long)expectedCount);
    for (NSString *key in expectedEntryCounts.allKeys)
    {
        NSNumber *expected = expectedEntryCounts[key];
        XCTAssertEqual(expected.integerValue, sortedEntries[key].count, @"Expected '%@' entries for key '%@', got '%lu'", expected, key, (unsigned long)sortedEntries[key].count);
    }
}

- (void)testContactListRemoveDuplicate
{
    YSGContactList *list = [YSGContactList new];
    NSUInteger numberOfSuggestions = 1;
    XCTAssertNil([list removeDuplicatedContactsFromSuggestions:nil numberOfSuggestions:numberOfSuggestions], @"Remove duplicate should return nil when the contacts list is empty");
    
    list.entries = [YSGTestMockData mockContactList].entries;
    NSArray *trimmedList = [list removeDuplicatedContactsFromSuggestions:list.entries numberOfSuggestions:numberOfSuggestions];
    XCTAssertNotNil(trimmedList, @"Trimmed suggestions list shouldn't be nil");
    XCTAssertEqual(trimmedList.count, numberOfSuggestions, @"The trimmed list should contain only '%lu' contacts, not '%lu'", (unsigned long)numberOfSuggestions, (unsigned long)trimmedList.count);
}

- (void)testContactListOperationsSuggestionsZero
{
    YSGContactList *mockedContacts = [YSGTestMockData mockContactList];
    mockedContacts.useSuggestions = YES;
    NSUInteger suggestionCount = 0;
    
    NSArray <YSGContact *> *sortedEntries = [mockedContacts suggestedEntriesWithNumberOfSuggestions:suggestionCount];
    XCTAssertEqual(sortedEntries.count, 0, @"There shouldn't be any suggestions when the count is set to 0");
}

@end
