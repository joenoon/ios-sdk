//
//  ExampleContactsOnlyTests.swift
//  Example-Swift
//
//  Created by Nejc Vivod on 11/10/15.
//  Copyright © 2015 Dal Rupnik. All rights reserved.
//

import XCTest

class ExampleContactsOnlyTests: XCTestCase {
    var application : XCUIApplication?
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        self.application = XCUIApplication()
        self.application!.launchArguments.append("mocked_contacts");
        self.application!.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        self.application = nil
    }
    
    func findOneViewFromQuery(query: XCUIElementQuery, identifier: String) -> XCUIElement {
        XCTAssertEqual(query.matchingIdentifier(identifier).count, 1)
        let ret = query.matchingIdentifier(identifier).element
        return ret
    }
    
    func mainScreen() {
        
        let imageViews = self.application!.images
        findOneViewFromQuery(imageViews, identifier: logoIdent)
        
        let textFields = self.application!.textFields
        XCTAssertEqual(textFields.count, 1)
        XCTAssert(textFields.element.value!.isEqualToString(txGrowStaticText), "Value of the found text field \(textFields.element.value) is not the same as \(txGrowStaticText)")
        
        let labelFields = self.application!.otherElements.childrenMatchingType(XCUIElementType.StaticText)
        XCTAssertEqual(labelFields.count, 1)
        XCTAssert(labelFields.element.label == lblBoostText, "Value of the found label \(labelFields.element.label) is not the same as \(lblBoostText)")
        
        let button = self.application!.buttons[btnText]
        XCTAssertNotNil(button)
        XCTAssert(button.respondsToSelector(#selector(XCUIElement.tap)), "Found button does not respond to the 'tap' selector")
    }
    
    /*!
    *  This method tests the main screen (after launching) in portrtait orientation.
    *  We check if every element is accounted for, and if it has the right texts and identifiers set
    *
    */
    func testMainScreenFaceUp() {
        XCUIDevice.sharedDevice().orientation = UIDeviceOrientation.FaceUp
        mainScreen()
    }
    
    /*!
    *  This method tests the main screen (after launching) in landscape orientation.
    *  We check if every element is accounted for, and if it has the right texts and identifiers set
    *
    */
    func testMainScreenLandscape() {
        XCUIDevice.sharedDevice().orientation = UIDeviceOrientation.LandscapeRight
        mainScreen()
    }
    
    func shareScreen() {
        self.application!.buttons[btnText].tap()
        XCTAssert(self.application!.otherElements.containingType(XCUIElementType.NavigationBar, identifier: navShareIdent).count == 1, "Application does not have a navigation controller with ident \(navShareIdent)")
        XCTAssert(self.application!.buttons.count == 3, "Share sheet should only contain 3 buttons, not \(self.application!.buttons.count)")
        XCTAssertNotNil(self.application!.buttons[btnWelcome], "Welcome button is missing")
        XCTAssertNotNil(self.application!.buttons[btnBack], "Back button is missing")
        XCTAssertNotNil(self.application!.buttons[btnCopy], "Copy button is missing")
        
        self.application!.buttons[btnCopy].tap()
        XCTAssert(self.application!.buttons[btnCopied].label == btnCopied, "Copy button did not change text after tap")
        
        let numberOfShareLabels: UInt = UInt(4)
        XCTAssert(self.application!.otherElements.staticTexts.count == numberOfShareLabels, "Number of labels is not \(numberOfShareLabels): \(self.application!.otherElements.staticTexts.count)")
        XCTAssertNotNil(self.application!.otherElements.staticTexts[lbShareText], "Label not found, expected text: \(lbShareText)")
        XCTAssertNotNil(self.application!.otherElements.staticTexts[lbContactsText], "Label not found, expected text: \(lbContactsText)")
        
        let contactsButton = self.application!.collectionViews.cells.childrenMatchingType(XCUIElementType.Other).elementBoundByIndex(1).childrenMatchingType(XCUIElementType.Image).element
        XCTAssert(contactsButton.respondsToSelector(Selector("tap")), "Contacts button image does not respond to tap")
        contactsButton.tap()
        
        if self.application!.alerts.count != 0 {
            let inviteAlert = self.application!.alerts[alertInvite]
            let okButton = inviteAlert.buttons["Ok"]
            XCTAssertNotNil(okButton, "Missing Ok button on alert popup")
            okButton.tap()
            
            let allowAlert = self.application!.alerts["Example-Swift"]
            XCTAssertNotNil(allowAlert, "There should be an alert popup for don't allow / OK access to contacts")
            XCTAssertNotNil(allowAlert.buttons["OK"], "Missing Ok button on alert popup")
            allowAlert.buttons["OK"].tap()
        }
    }
    
    /*!
    *  This method tests the sharing screen in portrait mode, after the user taps the "SHARE NOW"
    *  button. We check if the right number of share buttons are present.
    */
    func testShareScreenFaceUp() {
        XCUIDevice.sharedDevice().orientation = UIDeviceOrientation.FaceUp
        shareScreen()
    }
    
    /*!
    *  This method tests the sharing screen in landscape mode, after the user taps the "SHARE NOW"
    *  button. We check if the right number of share buttons are present.
    */
    func testShareScreenLandscape() {
        XCUIDevice.sharedDevice().orientation = UIDeviceOrientation.LandscapeRight
        shareScreen()
    }
    
    func shareContacts() {
        self.application!.buttons[btnText].tap()
        self.application!.collectionViews.cells.childrenMatchingType(XCUIElementType.Other).elementBoundByIndex(1).childrenMatchingType(XCUIElementType.Image).element.tap()
        
        XCTAssertEqual(self.application!.progressIndicators.count, 0)
        XCTAssertEqual(self.application!.tables.count, 1)
        
        let list = self.application!.tables.element
        XCTAssertNotNil(list, "Table view shouldn't be nil")
        let mockedContacts = YSGTestMockData.mockContactList
        let isSame = NSPredicate { (val : AnyObject, _: [String : AnyObject]?) -> Bool in
            return (val as! XCUIElement).cells.count == UInt(mockedContacts.count)
        }
        expectationForPredicate(isSame, evaluatedWithObject: list, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssert(list.cells.count == UInt(mockedContacts.count), "Table view should contain \(mockedContacts.count), but it has \(list.cells.count)")
        
        for c in mockedContacts {
            let name = c.name
            let secondary = c.emails != nil ? c.emails!.first : c.phones!.first
            var matches = UInt(0)
            for index: UInt in 0..<list.cells.count {
                let texts = list.cells.elementBoundByIndex(index).staticTexts
                let el = texts.matchingPredicate(NSPredicate(block: { (eval : AnyObject, _ : [String : AnyObject]?) -> Bool in
                    return eval.label == name || eval.label == secondary
                }))
                matches += el.count
            }
            XCTAssert(matches != 0, "Expected to find at least 1 match for every cell in list view, but found \(matches)")
        }
    }
    
    /*!
    *  This method tests the contacts listview (in portrait),
    *  it check if the rendered contact cells have the
    *  same texts as the mocked contacts list.
    */
    func testShareContactsFaceUp() {
        XCUIDevice.sharedDevice().orientation = UIDeviceOrientation.FaceUp
        shareContacts()
    }
    
    /*!
    *  This method tests the contacts listview (in landscape),
    *  it check if the rendered contact cells have the
    *  same texts as the mocked contacts list.
    */
    func testShareContactsLandscape() {
        XCUIDevice.sharedDevice().orientation = UIDeviceOrientation.LandscapeRight
        shareContacts()
    }
    
    func shareContactsSearch() {
        self.application!.buttons[btnText].tap()
        self.application!.collectionViews.cells.childrenMatchingType(XCUIElementType.Other).elementBoundByIndex(1).childrenMatchingType(XCUIElementType.Image).element.tap()
        let list = self.application!.tables.element
        let mockedContacts = YSGTestMockData.mockContactList
        let search = self.application!.searchFields["Search"]
        search.tap()
        search.typeText("Daniel")
        XCTAssert(list.cells.count == UInt(1), "There should be only 1 cell left after search, found: \(list.cells.count)")
        search.buttons["Clear text"].tap()
        XCTAssert(list.cells.count == UInt(mockedContacts.count), "Table view should contain \(mockedContacts.count) elements, but it has \(list.cells.count)")
        self.application!.buttons["Done"].tap()
    }
    
    
    /*!
    *  This method tests the search field (in portrait),
    *  it inputs the string "Daniel" (only 1 mocked
    *  contact with such a first name),
    *  and checks if only 1 cell is left in the listview
    */
    func testShareContactsSearchFaceUp() {
        XCUIDevice.sharedDevice().orientation = UIDeviceOrientation.FaceUp
        shareContactsSearch()
    }
    
    /*!
    *  This method tests the search field (in landscape),
    *  it inputs the string "Daniel" (only 1 mocked
    *  contact with such a first name),
    *  and checks if only 1 cell is left in the listview
    */
    func testShareContactsSearchLandscape() {
        XCUIDevice.sharedDevice().orientation = UIDeviceOrientation.LandscapeRight
        shareContactsSearch()
    }
    
    func checkAndInvite() {
        self.application!.buttons[btnText].tap()
        self.application!.collectionViews.cells.childrenMatchingType(XCUIElementType.Other).elementBoundByIndex(1).childrenMatchingType(XCUIElementType.Image).element.tap()
        let list = self.application!.tables.element
        let mockedContacts = YSGTestMockData.mockContactList
        let isSame = NSPredicate { (val : AnyObject, _: [String : AnyObject]?) -> Bool in
            return (val as! XCUIElement).cells.count == UInt(mockedContacts.count)
        }
        expectationForPredicate(isSame, evaluatedWithObject: list, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        
        let cell1 = list.cells.elementBoundByIndex(0)
        let cell2 = list.cells.elementBoundByIndex(1)
        XCTAssert(cell1.respondsToSelector(Selector("tap")) && cell2.respondsToSelector(Selector("tap")), "Cells do not respond to 'tap'")
        
        cell1.tap()
        cell2.tap()
        
        self.application!.navigationBars[lbContactsText].buttons[btnInvite].tap()
        XCTAssert(self.application!.alerts.count == 1, "There should be an alert displayed")
        self.application!.alerts.elementBoundByIndex(0).buttons["Ok"].tap()
    }
    
    /*!
    *  This method selects the first two contacts from the list
    *  and initiates inviting. There should be an alert displayed,
    *  that the user should check the messaging settings. Checks done in portrait.
    *
    */
    func testCheckAndInviteFaceUp() {
        XCUIDevice.sharedDevice().orientation = UIDeviceOrientation.FaceUp
        checkAndInvite()
    }
    
    /*!
    *  This method selects the first two contacts from the list
    *  and initiates inviting. There should be an alert displayed,
    *  that the user should check the messaging settings. Checks done in landscape.
    *
    */
    func testCheckAndInviteLandscape() {
        XCUIDevice.sharedDevice().orientation = UIDeviceOrientation.LandscapeRight
        checkAndInvite()
    }
}
