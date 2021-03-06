//
//  TwitterAndContacsTests.m
//  Example
//
//  Created by Nejc Vivod on 12/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "CommonTexts.h"

@interface TwitterAndContacsTests : XCTestCase

@property (strong, nonatomic) XCUIApplication *application;

@end

/*!
 *  For these tests to function, we must disable facebook and enable twitter account on the device / simulator.
 *  The tests will check if only 2 share buttons are available to the user (Contacts, Twitter), if any additional
 *  accounts are enabled, the tests will fail.
 *
 *  This set of tests will run on FaceUp / Landscape orientated devices.
 */

@implementation TwitterAndContacsTests

- (void)setUp
{
    [super setUp];
    self.continueAfterFailure = NO;
    self.application = [[XCUIApplication alloc] init];
    self.application.launchArguments = @[ @"mocked_twitter" ];
    [self.application launch];
}

- (void)tearDown
{
    [super tearDown];
    self.application = nil;
}

- (void)shareScreen
{
    [self.application.buttons[btnText] tap];
    
    XCTAssertEqual([[self.application otherElements] containingType:XCUIElementTypeNavigationBar identifier:navShareIdent].count, 1, @"Application does not have a navigation controller with ident '%@'", navShareIdent);
    
    XCTAssertEqual(self.application.buttons.count, 3, @"Share sheet should contain 3 buttons, not %lu", self.application.buttons.count);
    XCTAssertNotNil(self.application.buttons[btnWelcome], @"Welcome button is missing");
    XCTAssertNotNil(self.application.buttons[btnBack], @"Back button is missing");
    XCTAssertNotNil(self.application.buttons[btnCopy], @"Copy button is missing");
    
    XCUIElement *copyButton = self.application.buttons[btnCopy];
    [copyButton tap];
    copyButton = self.application.buttons[btnCopied]; // re-find the button since the ID has changed
    
    XCTAssert([copyButton.label isEqualToString:btnCopied], @"Copy button did not change text after tap");
    
    // Share title, share text, URL, Contacts static texts
    NSUInteger numberOfShareLabels = 5; // share text + contacts text + URL + title + twitter
    XCTAssertEqual(self.application.otherElements.staticTexts.count, numberOfShareLabels, @"Number of labels is not %lu: %lu", numberOfShareLabels, self.application.otherElements.staticTexts.count);
    XCTAssertNotNil(self.application.otherElements.staticTexts[lbShareText], @"Label not found, expected text: '%@'", lbShareText);
    XCTAssertNotNil(self.application.otherElements.staticTexts[lbContactsText], @"Label not found, expected text: '%@'", lbContactsText);
    
    XCUIElement *twitterButton = [[[self.application.collectionViews.cells childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeImage].element;
    XCTAssert([twitterButton respondsToSelector:@selector(tap)], @"Twitter image does not respond to tap");
    [twitterButton tap];
    
    XCUIElement *twitterTitleBar = [self.application.staticTexts elementMatchingType:XCUIElementTypeStaticText identifier:@"Twitter"];
    
    [self expectationForPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return twitterTitleBar.exists;
    }] evaluatedWithObject:twitterTitleBar handler:nil];
    [self waitForExpectationsWithTimeout:5 handler:nil];
    
    XCTAssert(twitterTitleBar != nil && twitterTitleBar.exists, @"Twitter popup not shown?");
    
    XCUIElement *postButton = self.application.buttons[@"Post"];
    XCTAssertNotNil(postButton, @"Post button is missing, did the popup open?");
    [postButton tap];
}

/*!
 *  This method tests the sharing screen in portrait mode, after the user taps the "SHARE NOW"
 *  button. We check if the right number of share buttons are present.
 */
- (void)testShareScreenFaceUp
{
    [[XCUIDevice sharedDevice] setOrientation:UIDeviceOrientationFaceUp];
    [self shareScreen];
}

/*!
 *  This method tests the sharing screen in landscape mode, after the user taps the "SHARE NOW"
 *  button. We check if the right number of share buttons are present.
 */
- (void)testShareScreenLandscape
{
    [[XCUIDevice sharedDevice] setOrientation:UIDeviceOrientationLandscapeRight];
    [self shareScreen];
}

@end
