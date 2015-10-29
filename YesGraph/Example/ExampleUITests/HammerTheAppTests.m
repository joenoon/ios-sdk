//
//  HammerTheAppTests.m
//  Example
//
//  Created by Nejc Vivod on 14/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "CommonTexts.h"

@interface HammerTheAppTests : XCTestCase
@property (strong, nonatomic) XCUIApplication *application;
@end

@implementation HammerTheAppTests

- (void)setUp
{
    [super setUp];
    self.continueAfterFailure = NO;
    self.application = [XCUIApplication new];
    [self.application launch];
}

- (void)tearDown
{
    [super tearDown];
    self.application = nil;
}


- (void)testShareScreen
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
    
    NSUInteger numberOfShareLabels = 6; // share text + contacts text + URL + title + twitter + facebook
    XCTAssertEqual(self.application.otherElements.staticTexts.count, numberOfShareLabels, @"Number of labels is not %lu: %lu", numberOfShareLabels, self.application.otherElements.staticTexts.count);
    XCTAssertNotNil(self.application.otherElements.staticTexts[lbShareText], @"Label not found, expected text: '%@'", lbShareText);
    XCTAssertNotNil(self.application.otherElements.staticTexts[lbContactsText], @"Label not found, expected text: '%@'", lbContactsText);
    {
        XCUIElement *facebookButton = [[[self.application.collectionViews.cells childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeImage].element;
        XCTAssert([facebookButton respondsToSelector:@selector(tap)], @"Twitter image does not respond to tap");
        [facebookButton tap];
        
        XCUIElement *facebookTitleBar = [self.application.staticTexts elementMatchingType:XCUIElementTypeStaticText identifier:@"Facebook"];
        
        [self expectationForPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return facebookTitleBar.exists;
        }] evaluatedWithObject:facebookTitleBar handler:nil];
        [self waitForExpectationsWithTimeout:5 handler:nil];
        
        XCTAssert(facebookTitleBar != nil && facebookTitleBar.exists, @"Facebook popup not shown?");
        
        XCUIElement *cancelButton = self.application.buttons[@"Cancel"];
        XCTAssertNotNil(cancelButton, @"Cancel button is missing, did the popup open?");
        [cancelButton tap];
        
    }
    {
        XCUIElement *twitterButton = [[[self.application.collectionViews.cells childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:3] childrenMatchingType:XCUIElementTypeImage].element;
        XCTAssert([twitterButton respondsToSelector:@selector(tap)], @"Twitter image does not respond to tap");
        [twitterButton tap];
        
        XCUIElement *twitterTitleBar = [self.application.staticTexts elementMatchingType:XCUIElementTypeStaticText identifier:@"Twitter"];
        
        [self expectationForPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return twitterTitleBar.exists;
        }] evaluatedWithObject:twitterTitleBar handler:nil];
        [self waitForExpectationsWithTimeout:5 handler:nil];
        
        XCTAssert(twitterTitleBar != nil && twitterTitleBar.exists, @"Twitter popup not shown?");
        
        XCUIElement *cancelButton = self.application.buttons[@"Cancel"];
        XCTAssertNotNil(cancelButton, @"Cancel button is missing, did the popup open?");
        [cancelButton tap];
    }
    {
        XCUIElement *contactsButton = [[[self.application.collectionViews.cells childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:5] childrenMatchingType:XCUIElementTypeImage].element;
        XCTAssert([contactsButton respondsToSelector:@selector(tap)], @"Contacts button image does not respond to tap");
        [contactsButton tap];
        XCUIElement *list = self.application.tables.element;
        XCTAssertNotNil(list, @"Table view shouldn't be nil");
        [self expectationForPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return ((XCUIElement *)evaluatedObject).cells.count != 0;
        }] evaluatedWithObject:list handler:nil];
        [self waitForExpectationsWithTimeout:5 handler:nil];
        
        XCUIElement *search = self.application.searchFields[@"Search"];
        [search tap];
        [search typeText:@"Daniel"];
        [[[list cells] elementBoundByIndex:0] tap];
        [search.buttons[@"Clear text"] tap];
        [[[list cells] elementBoundByIndex:1] tap];
        [[[list cells] elementBoundByIndex:(list.cells.count - 1)] tap];
        [self.application.buttons[@"Done"] tap];
        [[[list cells] elementBoundByIndex:(list.cells.count - 2)] tap];
        [self.application.navigationBars[lbContactsText].buttons[btnInvite] tap];
        [[self.application.alerts elementBoundByIndex:0].buttons[@"Ok"] tap];
    }
}





@end
