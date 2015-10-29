//
//  ExampleContactsOnlyTests.m
//  Example
//
//  Created by Nejc Vivod on 07/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGTestMockData.h"
#import "CommonTexts.h"

@import Social;

@interface ExampleContactsOnlyTests : XCTestCase

@property (strong, nonatomic) XCUIApplication *application;

@end

/*!
 *  For these tests to function, we must disable facebook and twitter accounts on the device / simulator.
 *  The tests will check if only 1 share button is available to the user (Contacts), if any additional
 *  accounts are enabled, the tests will fail.
 *
 *  This set of tests will run on FaceUp / Landscape orientated devices.
 */

@implementation ExampleContactsOnlyTests

- (void)setUp
{
    [super setUp];
    self.continueAfterFailure = NO;
    self.application = [[XCUIApplication alloc] init];
    self.application.launchArguments = @[ @"mocked_contacts" ];
    [self.application launch];
}

- (void)tearDown
{
    [super tearDown];
    self.application = nil;
}

- (XCUIElement *)findOneViewFromQuery:(XCUIElementQuery *)query withIdentifier:(NSString *)ident
{
    XCTAssertEqual([query matchingIdentifier:ident].count, 1, @"Identifier '%@' not found", ident);
    XCUIElement *view = [query matchingIdentifier:ident].element;
    XCTAssert([view.identifier isEqualToString:ident], @"View identifier '%@' is not equal to '%@'", view.identifier, ident);
    return view;
}


- (void)mainScreen
{
    XCTAssertEqual([[self.application otherElements] containingType:XCUIElementTypeNavigationBar identifier:navWelcomeIdent].count, 1, @"Application does not have a navigation controller with ident '%@'", navWelcomeIdent);
    
    XCUIElementQuery *imageViews = [[self.application otherElements] childrenMatchingType:XCUIElementTypeImage];
    [self findOneViewFromQuery:imageViews withIdentifier:logoIdent];
    
    XCUIElementQuery *textFields = [[self.application otherElements] childrenMatchingType:XCUIElementTypeTextField];
    XCTAssertEqual(textFields.count, 1);
    XCTAssert([textFields.element.value isEqualToString:txGrowStaticText], @"Value of the found text field '%@' is not the same as '%@'", textFields.element.value, txGrowStaticText);
    
    XCUIElementQuery *labelFields = [[self.application otherElements] childrenMatchingType:XCUIElementTypeStaticText];
    XCTAssertEqual(labelFields.count, 1);
    XCTAssert([labelFields.element.label isEqualToString:lblBoostText], @"Value of the found label '%@' is not the same as '%@'", labelFields.element.value, lblBoostText);
    
    XCUIElement * button = self.application.buttons[btnText];
    XCTAssertNotNil(button, @"Share button not found in application");
    XCTAssert([button respondsToSelector:@selector(tap)], @"Found button does not respond to the 'tap' selector!");
}

/*!
 *  This method tests the main screen (after launching) in portrtait orientation.
 *  We check if every element is accounted for, and if it has the right texts and identifiers set
 *
 */
- (void)testMainScreenFaceUp
{
    [[XCUIDevice sharedDevice] setOrientation:UIDeviceOrientationFaceUp];
    [self mainScreen];
}

/*!
 *  This method tests the main screen (after launching) in landscape orientation.
 *  We check if every element is accounted for, and if it has the right texts and identifiers set
 *
 */
- (void)testMainScreenLandscape
{
    [[XCUIDevice sharedDevice] setOrientation:UIDeviceOrientationLandscapeRight];
    [self mainScreen];
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
    NSUInteger numberOfShareLabels = 4; // share text + contacts text + URL + title
    XCTAssertEqual(self.application.otherElements.staticTexts.count, numberOfShareLabels, @"Number of labels is not %lu: %lu", numberOfShareLabels, self.application.otherElements.staticTexts.count);
    XCTAssertNotNil(self.application.otherElements.staticTexts[lbShareText], @"Label not found, expected text: '%@'", lbShareText);
    XCTAssertNotNil(self.application.otherElements.staticTexts[lbContactsText], @"Label not found, expected text: '%@'", lbContactsText);
    
    XCUIElement *contactsButton = [[[self.application.collectionViews.cells childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeImage].element;
    XCTAssert([contactsButton respondsToSelector:@selector(tap)], @"Contacts button image does not respond to tap");
    [contactsButton tap];
    
    if (self.application.alerts.count != 0)
    {
        XCUIElement *inviteAlert = self.application.alerts[alertInvite];
        // if the user hasn't confirmed it yet, the popup for allowing the contacts is shown
        XCUIElement *okButton1 = inviteAlert.buttons[@"Ok"];
        XCTAssertNotNil(okButton1, @"Missing Ok button on alert popup");
        [okButton1 tap];
        
        XCUIElement *allowAlert = self.application.alerts[@"Example"];
        XCTAssertNotNil(allowAlert, @"There should be an alert popup for don't allow / OK access to contacts");
        XCTAssertNotNil(allowAlert.buttons[@"OK"], @"Missing Ok button on alert popup");
        [allowAlert.buttons[@"OK"] tap];
    }
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

- (void)shareContacts
{
    [self.application.buttons[btnText] tap];
    [[[[self.application.collectionViews.cells childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeImage].element tap];
    
    // share sheet should open here
    XCTAssertEqual(self.application.progressIndicators.count, 0, @"There shouldn't be a progress indicator after the sheet has loaded, found: %lu", self.application.progressIndicators.count);
    XCTAssertEqual(self.application.tables.count, 1, @"There should be 1 table view with contacts, found: %lu", self.application.tables.count);
    
    XCUIElement *list = self.application.tables.element;
    XCTAssertNotNil(list, @"Table view shouldn't be nil");
    YSGContactList *mockedContacts = [YSGTestMockData mockContactList];
    [self expectationForPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ((XCUIElement *)evaluatedObject).cells.count == mockedContacts.entries.count;
    }] evaluatedWithObject:list handler:nil];
    [self waitForExpectationsWithTimeout:5 handler:nil];
    
    XCTAssertEqual(list.cells.count, mockedContacts.entries.count, @"Table view should contain %lu elements, but it has %lu", mockedContacts.entries.count, list.cells.count);
    
    for (YSGContact *c in mockedContacts.entries)
    {
        NSString *name = c.name;
        NSString *secondary = c.emails.count > 0 ? c.emails[0] : c.phones[0];
        
        NSUInteger matches = 0;
        for (NSUInteger index = 0; index < list.cells.count; ++index)
        {
            XCUIElementQuery *texts = [list.cells elementBoundByIndex:index].staticTexts;
            XCUIElementQuery *el = [texts matchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                XCUIElement *element = (XCUIElement *)evaluatedObject;
                return [element.label isEqualToString:name] || [element.label isEqualToString:secondary];
            }]];
            
            matches += el.count;
        }
        XCTAssertEqual(matches, 1, @"Expected to find 1 match in list view, but found: %lu", matches);
    }
}

/*!
 *  This method tests the contacts listview (in portrait),
 *  it check if the rendered contact cells have the
 *  same texts as the mocked contacts list.
 */
- (void)testShareContactsFaceUp
{
    [[XCUIDevice sharedDevice] setOrientation:UIDeviceOrientationFaceUp];
    [self shareContacts];
}

/*!
 *  This method tests the contacts listview (in landscape),
 *  it check if the rendered contact cells have the
 *  same texts as the mocked contacts list.
 */
- (void)testShareContactsLanscape
{
    [[XCUIDevice sharedDevice] setOrientation:UIDeviceOrientationLandscapeRight];
    [self shareContacts];
}

- (void)shareContacsSearch
{
    [self.application.buttons[btnText] tap];
    [[[[self.application.collectionViews.cells childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeImage].element tap];
    
    XCUIElement *list = self.application.tables.element;
    
    YSGContactList *mockedContacts = [YSGTestMockData mockContactList];
    XCUIElement *search = self.application.searchFields[@"Search"];
    XCTAssertNotNil(search, @"Table's search field shouldn't be nil");
    
    [search tap];
    [search typeText:@"Daniel"];
    XCTAssertEqual(list.cells.count, 1, @"There should be only 1 cell left after search, found: %lu", list.cells.count);
    [search.buttons[@"Clear text"] tap];
    XCTAssertEqual(list.cells.count, mockedContacts.entries.count, @"Table view should contain %lu elements, but it has %lu", mockedContacts.entries.count, list.cells.count);
    [self.application.buttons[@"Done"] tap];
}

/*!
 *  This method tests the search field (in portrait),
 *  it inputs the string "Daniel" (only 1 mocked
 *  contact with such a first name),
 *  and checks if only 1 cell is left in the listview
 */
- (void)testShareContactsSearchFaceUp
{
    [[XCUIDevice sharedDevice] setOrientation:UIDeviceOrientationFaceUp];
    [self shareContacsSearch];
}

/*!
 *  This method tests the search field (in landscape),
 *  it inputs the string "Daniel" (only 1 mocked
 *  contact with such a first name),
 *  and checks if only 1 cell is left in the listview
 */
- (void)testShareContactsSearchLandscape
{
    [[XCUIDevice sharedDevice] setOrientation:UIDeviceOrientationLandscapeRight];
    [self shareContacsSearch];
}

- (void)checkAlerts
{
    if (self.application.alerts.count != 0)
    {
        XCUIElement *inviteAlert = self.application.alerts[alertInvite];
        // if the user hasn't confirmed it yet, the popup for allowing the contacts is shown
        XCUIElement *okButton1 = inviteAlert.buttons[@"Ok"];
        XCTAssertNotNil(okButton1, @"Missing Ok button on alert popup");
        [okButton1 tap];
        
        XCUIElement *allowAlert = self.application.alerts[@"Example"];
        XCTAssertNotNil(allowAlert, @"There should be an alert popup for don't allow / OK access to contacts");
        XCTAssertNotNil(allowAlert.buttons[@"OK"], @"Missing Ok button on alert popup");
        [allowAlert.buttons[@"OK"] tap];
    }
}

- (void)checkAndInvite
{
    [self.application.buttons[btnText] tap];
    [[[[self.application.collectionViews.cells childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeImage].element tap];
    [self checkAlerts];
    XCUIElement *list = self.application.tables.element;
    YSGContactList *mockedContacts = [YSGTestMockData mockContactList];
    [self expectationForPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ((XCUIElement *)evaluatedObject).cells.count == mockedContacts.entries.count;
    }] evaluatedWithObject:list handler:nil];
    [self waitForExpectationsWithTimeout:5 handler:nil];
    
    // check first 2 entries and invite
    XCUIElement *cell1 = [[list cells] elementBoundByIndex:0];
    XCUIElement *cell2 = [[list cells] elementBoundByIndex:1];
    XCTAssert([cell1 respondsToSelector:@selector(tap)] && [cell2 respondsToSelector:@selector(tap)], @"Cells do not respond to 'tap'");
    [cell1 tap];
    [cell2 tap];
    
    [self.application.navigationBars[lbContactsText].buttons[btnInvite] tap];
    XCTAssert(self.application.alerts.count == 1, @"There should be an alert displayed");
    [[self.application.alerts elementBoundByIndex:0].buttons[@"Ok"] tap];
}

/*!
 *  This method selects the first two contacts from the list
 *  and initiates inviting. There should be an alert displayed,
 *  that the user should check the messaging settings. Checks done in portrait.
 *
 */
- (void)testCheckAndInviteFaceUp
{
    [[XCUIDevice sharedDevice] setOrientation:UIDeviceOrientationFaceUp];
    [self checkAndInvite];
}

/*!
 *  This method selects the first two contacts from the list
 *  and initiates inviting. There should be an alert displayed,
 *  that the user should check the messaging settings. Checks done in landscape.
 *
 */
- (void)testCheckAndInviteLandscape
{
    [[XCUIDevice sharedDevice] setOrientation:UIDeviceOrientationFaceUp];
    [self checkAndInvite];
}

@end
