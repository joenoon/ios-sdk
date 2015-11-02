//
//  YesGraphSDKYSGAddressBookViewControllerTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 02/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import "YSGAddressBookViewController+ExposedPrivate.h"

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

@end
