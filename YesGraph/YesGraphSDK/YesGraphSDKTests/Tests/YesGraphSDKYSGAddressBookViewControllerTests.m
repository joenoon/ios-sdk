//
//  YesGraphSDKYSGAddressBookViewControllerTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 02/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import "YSGAddressBookViewController+ExposedPrivate.h"
#import "YSGTestMockData.h"

@interface YesGraphSDKYSGAddressBookViewControllerTests : XCTestCase

@property (strong, nonatomic) YSGAddressBookViewController *controller;

@end

@implementation YesGraphSDKYSGAddressBookViewControllerTests

- (void)setUp
{
    [super setUp];
    self.controller = [YSGAddressBookViewController new];
}

- (void)tearDown
{
    [super tearDown];
    self.controller = nil;
}

- (void)testStyling
{
    XCTAssertNil(self.controller.theme, @"Theme should be nil");
    YSGTheme *newTheme = [YSGTheme new];
    newTheme.shareAddressBookTheme = [YSGShareAddressBookTheme new];
    newTheme.shareAddressBookTheme.viewBackground = [UIColor redColor];
    [self.controller applyTheme:newTheme];
    XCTAssertNotNil(self.controller.theme, @"Theme shouldn't be nil after applyTheme is called");
    XCTAssert([self.controller.view.tintColor isEqual:newTheme.mainColor], @"Address book view's tint color should be '%@' but it was '%@'", newTheme.mainColor, self.controller.view.tintColor);
    XCTAssert([self.controller.view.backgroundColor isEqual:newTheme.shareAddressBookTheme.viewBackground], @"Address book view's background color should be '%@' but it was '%@'", newTheme.shareAddressBookTheme.viewBackground, self.controller.view.backgroundColor);
    if (self.controller.navigationController)
    {
        XCTAssert([self.controller.navigationController.navigationBar.tintColor isEqual:newTheme.mainColor], @"Navigation bar's tint color should be '%@' but it was '%@'", newTheme.mainColor, self.controller.navigationController.navigationBar.tintColor);
    }
    XCTAssert([self.controller.tableView.backgroundColor isEqual:newTheme.shareAddressBookTheme.viewBackground], @"Table view's tint color should be '%@' but it was '%@'", newTheme.shareAddressBookTheme.viewBackground, self.controller.tableView.backgroundColor);
}

- (void)runContactListNilChecks
{
    XCTAssertNil(self.controller.contactList, @"Contact list should be nil at this point");
    XCTAssertEqual(self.controller.sortedContacts.count, 0, @"Sorted contacts shouldn't have any entries");
    XCTAssertEqual(self.controller.letters.count, 0, @"Letters shouldn't have any entries");
    XCTAssertEqual(self.controller.suggestions.count, 0, @"Suggestions shouldn't have any entries");
    XCTAssertNil(self.controller.service, @"Service should be nil");
}

- (void)runContactListAllChecksWith:(YSGContactList *)contactsList
{
    XCTAssertEqual(self.controller.contactList.entries.count, contactsList.entries.count, @"Contact list should contain '%lu' entries, not '%lu'", (unsigned long)contactsList.entries.count, (unsigned long)self.controller.contactList.entries.count);
    XCTAssertEqual(self.controller.suggestions.count, self.controller.service.numberOfSuggestions, @"Expected '%lu' suggestions, not '%lu'", (unsigned long)self.controller.service.numberOfSuggestions, (unsigned long)self.controller.suggestions.count);
    XCTAssertNil(self.controller.searchResults, @"Search results weren't reset to nil");
    XCTAssertEqual(self.controller.selectedContacts.count, 0, @"Selected contacts weren't reset to 0");
    
    NSDictionary <NSString *, NSArray <YSGContact *> *> *sorted = [contactsList sortedEntriesWithNumberOfSuggestions:self.controller.service.numberOfSuggestions];
    XCTAssertEqual(self.controller.letters.count, sorted.allKeys.count, @"Number of sorted entry sections '%lu' not the same as '%lu'", (unsigned long)self.controller.letters.count, (unsigned long)sorted.allKeys.count);
    
    NSArray <NSString *> *sortedSections = [sorted.allKeys sortedArrayUsingFunction:contactLettersSort context:nil];
    XCTAssert([sortedSections isEqualToArray:self.controller.letters], @"Sections '%@' not the same as '%@'", self.controller.letters, sortedSections);
    XCTAssertEqual(self.controller.tableView.numberOfSections, sortedSections.count, @"Number of sections in table view '%lu' not the same as '%lu'", (unsigned long)self.controller.tableView.numberOfSections, (unsigned long)sortedSections.count);
    for (NSUInteger index = 0; index < sortedSections.count; ++index)
    {
        NSString *key = sortedSections[index];
        unsigned long numberOfEntries = [self.controller.tableView numberOfRowsInSection:index];
        unsigned long expectedEntries = sorted[key].count;
        XCTAssertEqual(numberOfEntries, expectedEntries, @"Expected '%lu' number of entries in table view for section '%lu' ('%@'), not '%lu'", expectedEntries, (unsigned long)index, key, numberOfEntries);
    }
}

- (void)testContactList
{
    [self runContactListNilChecks];
    YSGContactList *mockedList = [YSGTestMockData mockContactList];
    self.controller.contactList = mockedList;
    [self runContactListAllChecksWith:mockedList];
}
@end