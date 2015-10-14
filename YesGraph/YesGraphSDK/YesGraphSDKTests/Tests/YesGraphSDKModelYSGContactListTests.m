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
