//
//  YesGraphSDKShareSheetControllerTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 30/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import "YSGShareSheetController+ExposedPrivateMethods.h"
#import "YSGFacebookService.h"
#import "YSGTwitterService.h"
#import "YSGShareService.h"

@interface YesGraphSDKShareSheetControllerTests : XCTestCase
@property (strong, nonatomic) YSGShareSheetController *controller;
@end

@implementation YesGraphSDKShareSheetControllerTests

- (void)setUp
{
    [super setUp];
    NSArray *services = @[ [YSGFacebookService new], [YSGTwitterService new], [YSGShareService new] ];
    self.controller = [[YSGShareSheetController alloc] initWithServices:services delegate:nil theme:nil];
}

- (void)tearDown
{
    [super tearDown];
    self.controller = nil;
}

- (void)testShareText
{
    NSString *expected = @"Share this app with friends to get our eternal gratitude";
    XCTAssertNotNil(self.controller.shareText, @"Share text should never be nil");
    XCTAssert([self.controller.shareText isEqualToString:expected], @"Share text should be '%@' but was '%@'", expected, self.controller.shareText);
    
    expected = @"Changed the text";
    self.controller.shareText = expected;
    XCTAssertNotNil(self.controller.shareText, @"Share text should never be nil");
    XCTAssert([self.controller.shareText isEqualToString:expected], @"Share text should be '%@' but was '%@'", expected, self.controller.shareText);
}

- (void)testServiceCounts
{
    XCTAssertEqual(self.controller.services.count, 3, @"Expected 3 services, got '%lu'", (unsigned long)self.controller.services.count);
    NSInteger itemsInSection = [self.controller collectionView:nil numberOfItemsInSection:0];
    XCTAssertEqual(itemsInSection, self.controller.services.count, @"Number of items in section should always be 3, not '%lu'", (unsigned long)itemsInSection);
}

- (void)testOtherInitializers
{
    YSGShareSheetController *notDefault = [YSGShareSheetController new];
    XCTAssertEqual(notDefault.services.count, 0, @"Controller initialised through other helper initialisers should contain no services");
    YSGShareSheetController *withCoder = [[YSGShareSheetController alloc] initWithCoder:[NSCoder new]];
    XCTAssertEqual(withCoder.services.count, 0, @"Controller initialised through other helper initialisers should contain no services");
    YSGShareSheetController *withNib = [[YSGShareSheetController alloc] initWithNibName:nil bundle:nil];
    XCTAssertEqual(withNib.services.count, 0, @"Controller initialised through other helper initialisers should contain no services");
    
    YSGShareSheetController *classInitialiser = [YSGShareSheetController shareSheetControllerWithServices:self.controller.services];
    XCTAssertEqual(classInitialiser.services.count, self.controller.services.count, @"Controller initalised via the class helper function with services should contain '%lu' entries not '%lu'", (unsigned long)self.controller.services.count, (unsigned long)classInitialiser.services.count);
}

- (void)testModal
{
    XCTAssertTrue(self.controller.isModal, @"Controller should be modal");
}

- (void)testSetupHeader
{
    XCTAssertNil(self.controller.header, @"Header should be nil at this point");
    XCTAssertNil(self.controller.logoView, @"Logo view should be nil at this point");
    XCTAssertNil(self.controller.shareLabel, @"Share label should be nil at this point");
    
    [self.controller setupHeader];
    
    XCTAssertNotNil(self.controller.header, @"Header shouldn't be nil at this point");
    XCTAssertNotNil(self.controller.logoView, @"Logo view shouldn't be nil at this point");
    XCTAssertNotNil(self.controller.shareLabel, @"Share label shouldn't be nil at this point");
    
    XCTAssert([self.controller.shareLabel.text isEqualToString:self.controller.shareText], @"Share text '%@' expected to be '%@'", self.controller.shareLabel.text, self.controller.shareText);
    XCTAssert(self.controller.shareLabel.textAlignment == self.controller.theme.shareLabelTextAlignment, @"Share label text alignment is incorrect");
    XCTAssertEqual(self.controller.header.subviews.count, 2, @"Header view should contain 2 subviews, not '%lu'", (unsigned long)self.controller.header.subviews.count);
    XCTAssertTrue([self.controller.header.subviews containsObject:self.controller.shareLabel], @"Header view should hold shareLabel in its subview collection");
    XCTAssertTrue([self.controller.header.subviews containsObject:self.controller.logoView], @"Header view should hold logoView in its subview collection");
}

- (void)testSetupFooter
{
    XCTAssertNil(self.controller.footer, @"Footer should be nil at this point");
    XCTAssertNil(self.controller.referralLabel, @"Referral label should be nil at this point");
    XCTAssertNil(self.controller.cpyButton, @"Copy button should be nil at this point");
    
    self.controller.referralURL = @"http://www.test.url.com/ref?q=%20space";
    [self.controller setupFooter];
    
    XCTAssertNotNil(self.controller.footer, @"Footer shouldn't be nil at this point");
    XCTAssertNotNil(self.controller.referralLabel, @"Referral label shouldn't be nil at this point");
    XCTAssertNotNil(self.controller.cpyButton, @"Copy button shouldn't be nil at this point");
    XCTAssert([self.controller.referralLabel.text isEqualToString:self.controller.referralURL], @"Referral URL '%@' in label not the same as '%@'", self.controller.referralLabel.text, self.controller.referralURL);
    XCTAssert(self.controller.referralLabel.textAlignment == NSTextAlignmentCenter, @"Referral label text alignment is not center");
    XCTAssert([self.controller.referralLabel.textColor isEqual:[UIColor blackColor]], @"Referral label text color is not black");
    XCTAssert([self.controller.cpyButton.titleLabel.text isEqualToString:@"copy"], @"Copy button title should be copy");
}

@end
