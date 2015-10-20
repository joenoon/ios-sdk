//
//  HammerTheAppTests.swift
//  Example-Swift
//
//  Created by Nejc Vivod on 15/10/15.
//  Copyright © 2015 Dal Rupnik. All rights reserved.
//

import XCTest

class HammerTheAppTests: XCTestCase {
    var application : XCUIApplication?
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        self.application = XCUIApplication()
        self.application!.launchArguments.append("mocked_both");
        self.application!.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        self.application = nil
    }
    
    func testShareScreen() {
        self.application!.buttons[btnText].tap()
        XCTAssertEqual(self.application!.otherElements.containingType(XCUIElementType.NavigationBar, identifier: navShareIdent).count, 1);
        XCTAssertEqual(self.application!.buttons.count, 3);
        XCTAssertNotNil(self.application!.buttons[btnWelcome], "Welcome button is missing");
        XCTAssertNotNil(self.application!.buttons[btnBack], "Back button is missing");
        XCTAssertNotNil(self.application!.buttons[btnCopy], "Copy button is missing");
    
        var copyButton = self.application!.buttons[btnCopy];
        copyButton.tap();
        copyButton = self.application!.buttons[btnCopied]; // re-find the button since the ID has changed
    
        XCTAssert(copyButton.label == btnCopied, "Copy button did not change text after tap");
    
        let numberOfShareLabels: UInt = 6; // share text + contacts text + URL + title + twitter + facebook
        XCTAssertEqual(self.application!.otherElements.staticTexts.count, numberOfShareLabels);
        XCTAssertNotNil(self.application!.otherElements.staticTexts[lbShareText], "Label not found, expected text: '\(lbShareText)'");
        XCTAssertNotNil(self.application!.otherElements.staticTexts[lbContactsText], "Label not found, expected text: '\(lbContactsText)'");
    
    
        let facebookButton = self.application!.collectionViews.cells.childrenMatchingType(XCUIElementType.Other).elementBoundByIndex(1).childrenMatchingType(XCUIElementType.Image).element;
        XCTAssert(facebookButton.respondsToSelector(Selector("tap")), "Twitter image does not respond to tap");
        facebookButton.tap();
        
        let facebookTitleBar = self.application!.staticTexts.elementMatchingType(XCUIElementType.StaticText, identifier: "Facebook");
        
        expectationForPredicate(NSPredicate(block: { (eval: AnyObject, _: [String : AnyObject]?) -> Bool in
            return facebookTitleBar.exists
        }), evaluatedWithObject: facebookTitleBar, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        
        XCTAssert(facebookTitleBar.exists, "Facebook popup not shown?")
        
        let cancelButton = self.application!.buttons["Cancel"];
        XCTAssertNotNil(cancelButton, "Cancel button is missing, did the popup open?");
        cancelButton.tap();
    
    
        let twitterButton = self.application!.collectionViews.cells.childrenMatchingType(XCUIElementType.Other).elementBoundByIndex(3).childrenMatchingType(XCUIElementType.Image).element;
        XCTAssert(twitterButton.respondsToSelector(Selector("tap")), "Twitter image does not respond to tap");
        twitterButton.tap();
    
        let twitterTitleBar = self.application!.staticTexts.elementMatchingType(XCUIElementType.StaticText, identifier: "Twitter")
        expectationForPredicate(NSPredicate(block: { (eval: AnyObject, _: [String : AnyObject]?) -> Bool in
            return twitterTitleBar.exists
        }), evaluatedWithObject: twitterTitleBar, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssert(twitterTitleBar.exists, "Twitter popup not shown?")
        
        let cancelButton2 = self.application!.buttons["Cancel"];
        XCTAssertNotNil(cancelButton2, "Cancel button is missing, did the popup open?");
        cancelButton2.tap();
        
        let contactsButton = self.application!.collectionViews.cells.childrenMatchingType(XCUIElementType.Other).elementBoundByIndex(5).childrenMatchingType(XCUIElementType.Image).element;
        XCTAssert(contactsButton.respondsToSelector(Selector("tap")), "Contacts button image does not respond to tap");
        contactsButton.tap();
        
        let list = self.application!.tables.element;
        XCTAssertNotNil(list, "Table view shouldn't be nil");
        let notZero = NSPredicate { (val : AnyObject, _: [String : AnyObject]?) -> Bool in
            return (val as! XCUIElement).cells.count != 0
        }
        expectationForPredicate(notZero, evaluatedWithObject: list, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
    
        let search = self.application!.searchFields["Search"];
        search.tap();
        search.typeText("Daniel");
        list.cells.elementBoundByIndex(0).tap();
        search.buttons["Clear text"].tap();
        list.cells.elementBoundByIndex(1).tap();
        list.cells.elementBoundByIndex(list.cells.count - 1).tap();
        self.application!.buttons["Done"].tap();
        list.cells.elementBoundByIndex(list.cells.count - 2).tap();
        self.application!.navigationBars[lbContactsText].buttons[btnInvite].tap();
        self.application!.alerts.elementBoundByIndex(0).buttons["Ok"].tap();
    }
}
