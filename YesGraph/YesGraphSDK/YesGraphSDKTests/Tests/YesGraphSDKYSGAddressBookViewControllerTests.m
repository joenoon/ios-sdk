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

- (void)testContactList
{
    XCTAssertNil(self.controller.contactList, @"Contact list should be nil at this point");
    XCTAssertEqual(self.controller.sortedContacts.count, 0, @"Sorted contacts shouldn't have any entries");
    XCTAssertEqual(self.controller.letters.count, 0, @"Letters shouldn't have any entries");
    XCTAssertEqual(self.controller.suggestions.count, 0, @"Suggestions shouldn't have any entries");
    XCTAssertNil(self.controller.service, @"Service should be nil");
    
    YSGContactList *mockedList = [YSGTestMockData mockContactList];
    self.controller.contactList = mockedList;
    
    XCTAssertEqual(self.controller.contactList.entries.count, mockedList.entries.count, @"Contact list should contain '%lu' entries, not '%lu'", (unsigned long)mockedList.entries.count, (unsigned long)self.controller.contactList.entries.count);
    XCTAssertEqual(self.controller.suggestions.count, self.controller.service.numberOfSuggestions, @"Expected '%lu' suggestions, not '%lu'", (unsigned long)self.controller.service.numberOfSuggestions, (unsigned long)self.controller.suggestions.count);
    XCTAssertNil(self.controller.searchResults, @"Search results weren't reset to nil");
    XCTAssertEqual(self.controller.selectedContacts.count, 0, @"Selected contacts weren't reset to 0");
}

@end
