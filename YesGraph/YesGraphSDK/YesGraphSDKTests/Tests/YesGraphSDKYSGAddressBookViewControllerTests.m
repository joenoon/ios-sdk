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
#import "YSGMockedInviteService.h"
#import "YSGMockedOnlineContactSource.h"
#import "YSGAddressBookCell.h"

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
    
    if (sorted.count)
    {
        NSArray <NSString *> *sortedSections = [sorted.allKeys sortedArrayUsingFunction:contactLettersSort context:nil];
        XCTAssert([sortedSections isEqualToArray:self.controller.letters], @"Sections '%@' not the same as '%@'", self.controller.letters, sortedSections);
        unsigned long tableViewSections = self.controller.tableView.numberOfSections;
        if (contactsList.useSuggestions)
        {
            // remove 1 section from the count if suggestions are to be shown (first section is reserved for suggestions)
            --tableViewSections;
        }
        XCTAssertEqual(tableViewSections, sortedSections.count, @"Number of sections in table view '%lu' not the same as '%lu'", tableViewSections, (unsigned long)sortedSections.count);
        for (NSUInteger index = 0; index < sortedSections.count; ++index)
        {
            NSString *key = sortedSections[index];
            unsigned long numberOfEntries = [self.controller.tableView numberOfRowsInSection:contactsList.useSuggestions ? index + 1 : index]; // if we're showing suggestions, we have to offest the tableview index by 1 (first one reserved for suggestions)
            unsigned long expectedEntries = sorted[key].count;
            XCTAssertEqual(numberOfEntries, expectedEntries, @"Expected '%lu' number of entries in table view for section '%lu' ('%@'), not '%lu'", expectedEntries, (unsigned long)index, key, numberOfEntries);
        }
    }
}

- (void)testContactListWithoutService
{
    [self runContactListNilChecks];
    YSGContactList *mockedList = [YSGTestMockData mockContactList];
    self.controller.contactList = mockedList;
    [self runContactListAllChecksWith:mockedList];
}

- (void)testContactListWithOnlineService
{
    [self runContactListNilChecks];
    __weak YesGraphSDKYSGAddressBookViewControllerTests *preventRetainCycle = self;
    YSGMockedOnlineContactSource *mockedOnlineSource = [YSGMockedOnlineContactSource new];
    XCTestExpectation *expectation = [preventRetainCycle expectationWithDescription:@"Expected Suggestions Shown Handler Invoked"];
    mockedOnlineSource.suggestionsShown = ^(NSArray <YSGContact *> *suggestions)
    {
        XCTAssert([preventRetainCycle.controller.suggestions isEqualToArray:suggestions], @"Controller suggestions '%@' do not match sent suggestions '%@'", preventRetainCycle.controller.suggestions, suggestions);
        [expectation fulfill];
    };
    YSGMockedInviteService *mockedService = [[YSGMockedInviteService alloc] initWithContactSource:mockedOnlineSource];
    self.controller.service = mockedService;
    YSGContactList *mockedList = [YSGTestMockData mockContactList];
    mockedList.useSuggestions = YES;
    self.controller.contactList = mockedList;
    [self runContactListAllChecksWith:mockedList];
    [preventRetainCycle waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, @"Error while waiting for expectation: %@", error);
    }];
}

- (void)testContactListWithZeroAssign
{
    [self runContactListNilChecks];
    YSGContactList *mockedList = [YSGContactList new];
    self.controller.contactList = mockedList;
    [self runContactListAllChecksWith:mockedList];
}

- (void)testContactForIndexPath
{
    YSGContactList *mockedList = [YSGTestMockData mockContactList];
    self.controller.contactList = mockedList;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    NSDictionary <NSString *, NSArray <YSGContact *> *> *sorted = [mockedList sortedEntriesWithNumberOfSuggestions:self.controller.service.numberOfSuggestions];
    NSArray <NSString *> *sortedSections = [sorted.allKeys sortedArrayUsingFunction:contactLettersSort context:nil];
    NSString *key = sortedSections[indexPath.section];
    YSGContact *contact = sorted[key][indexPath.row];
    XCTAssertNotNil(contact, @"Expected contact shouldn't be nil for index path '%@'", indexPath);
    YSGContact *foundContact = [self.controller contactForIndexPath:indexPath];
    XCTAssertNotNil(foundContact, @"Found contact shouldn't be nil");
    XCTAssert([foundContact.description isEqualToString:contact.description], @"Description string '%@' does not match '%@'", foundContact.description, contact.description);
}

- (void)testSelectContacts
{
    YSGContactList *mockedList = [YSGTestMockData mockContactList];
    self.controller.contactList = mockedList;
    XCTAssertEqual(self.controller.selectedContacts.count, 0, @"Shouldn't be any selected contacts yet");
    NSIndexPath *firstRowIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.controller tableView:self.controller.tableView didSelectRowAtIndexPath:firstRowIndexPath];
    XCTAssertEqual(self.controller.selectedContacts.count, 1, @"There should be 1 contact selected");
    NSIndexPath *secondRowIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.controller tableView:self.controller.tableView didSelectRowAtIndexPath:secondRowIndexPath];
    XCTAssertEqual(self.controller.selectedContacts.count, 2, @"There should be 2 contacts selected");
    YSGContact *firstExpected = [self.controller contactForIndexPath:firstRowIndexPath];
    YSGContact *secondExpected = [self.controller contactForIndexPath:secondRowIndexPath];
    XCTAssertTrue([self.controller.selectedContacts containsObject:firstExpected], @"Selected contacts set '%@' does not contain '%@'", self.controller.selectedContacts, firstExpected);
    XCTAssertTrue([self.controller.selectedContacts containsObject:secondExpected], @"Selected contacts set '%@' does not contain '%@'", self.controller.selectedContacts, secondExpected);
    
    [self.controller tableView:self.controller.tableView didDeselectRowAtIndexPath:firstRowIndexPath];
    XCTAssertEqual(self.controller.selectedContacts.count, 1, @"There should be 1 contact selected");
    XCTAssertTrue([self.controller.selectedContacts containsObject:secondExpected], @"Selected contacts set '%@' does not contain '%@'", self.controller.selectedContacts, secondExpected);
    XCTAssertFalse([self.controller.selectedContacts containsObject:firstExpected], @"Selected contacts set '%@' should not contain '%@'", self.controller.selectedContacts, firstExpected);
}

- (void)testTableViewCell
{
    YSGContactList *mockedList = [YSGTestMockData mockContactList];
    self.controller.contactList = mockedList;
    [self.controller viewDidLoad];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    YSGContact *expected = [self.controller contactForIndexPath:indexPath];
    UITableViewCell *cell = [self.controller tableView:self.controller.tableView cellForRowAtIndexPath:indexPath];
    XCTAssertNotNil(cell, @"Retrieved cell shouldn't be nil for index path '%@'", indexPath);
    XCTAssert([cell isKindOfClass:[YSGAddressBookCell class]], @"Retrieved cell should be of class '%@' not '%@'", [YSGAddressBookCell class], [cell class]);
    YSGAddressBookCell *retrievedCell = (YSGAddressBookCell *)cell;
    XCTAssert([retrievedCell.textLabel.text isEqualToString:expected.name], @"Cell text label should be '%@' not '%@'", expected.name, retrievedCell.textLabel.text);
    XCTAssert([retrievedCell.detailTextLabel.text isEqualToString:expected.contactString], @"Detail text label should be '%@' not '%@'", expected.contactString, retrievedCell.detailTextLabel.text);
    XCTAssertFalse(retrievedCell.selected, @"Retrieved cell shouldn't be selected");
    
    [self.controller tableView:self.controller.tableView didSelectRowAtIndexPath:indexPath];
    YSGAddressBookCell *retrievedSameCell = (YSGAddressBookCell *)[self.controller tableView:self.controller.tableView cellForRowAtIndexPath:indexPath];
    XCTAssertTrue(retrievedSameCell.selected, @"Retrieved cell should be selected");
}

@end