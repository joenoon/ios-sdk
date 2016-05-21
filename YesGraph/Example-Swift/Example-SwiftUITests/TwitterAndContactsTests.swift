//
//  TwitterAndContactsTests.swift
//  Example-Swift
//
//  Created by Nejc Vivod on 12/10/15.
//  Copyright © 2015 Dal Rupnik. All rights reserved.
//

import XCTest

class TwitterAndContactsTests: XCTestCase {
    var application : XCUIApplication?
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        self.application = XCUIApplication()
        self.application!.launchArguments.append("mocked_twitter");
        self.application!.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        self.application = nil
    }

    
    func shareScreen() {
        self.application!.buttons[btnText].tap()
        XCTAssertEqual(self.application!.navigationBars.element.identifier, navShareIdent, "Application does not have a navigation controller with ident \(navShareIdent)")

        //XCTAssert(self.application!.otherElements.containingType(XCUIElementType.NavigationBar, identifier: navShareIdent).count == 1, "Application does not have a navigation controller with ident \(navShareIdent)")
        XCTAssert(self.application!.buttons.count == 3, "Share sheet should only contain 3 buttons, not \(self.application!.buttons.count)")
        XCTAssertNotNil(self.application!.buttons[btnWelcome], "Welcome button is missing")
        XCTAssertNotNil(self.application!.buttons[btnBack], "Back button is missing")
        XCTAssertNotNil(self.application!.buttons[btnCopy], "Copy button is missing")
        
        self.application!.buttons[btnCopy].tap()
        XCTAssert(self.application!.buttons[btnCopied].label == btnCopied, "Copy button did not change text after tap")
        
        let numberOfShareLabels: UInt = UInt(6)
        XCTAssert(self.application!.otherElements.staticTexts.count == numberOfShareLabels, "Number of labels is not \(numberOfShareLabels): \(self.application!.otherElements.staticTexts.count)")
        XCTAssertNotNil(self.application!.otherElements.staticTexts[lbShareText], "Label not found, expected text: \(lbShareText)")
        XCTAssertNotNil(self.application!.otherElements.staticTexts[lbContactsText], "Label not found, expected text: \(lbContactsText)")
        
        let twitterButton = self.application!.collectionViews.cells.childrenMatchingType(XCUIElementType.Other).elementBoundByIndex(1)
        XCTAssert(twitterButton.respondsToSelector(#selector(XCUIElement.tap)), "Twitter button image does not respond to tap")
        twitterButton.tap()
        
        let twitterTitleBar = self.application!.staticTexts.elementMatchingType(XCUIElementType.StaticText, identifier: "Twitter")
        
        expectationForPredicate(NSPredicate(block: { (eval: AnyObject, _: [String : AnyObject]?) -> Bool in
            return twitterTitleBar.exists
        }), evaluatedWithObject: twitterTitleBar, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssert(twitterTitleBar.exists, "Twitter popup not shown?")
        
        let postButton = self.application!.buttons["Post"]
        XCTAssertNotNil(postButton, "Post button is missing, did the popup open?")
        postButton.tap()
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
}

