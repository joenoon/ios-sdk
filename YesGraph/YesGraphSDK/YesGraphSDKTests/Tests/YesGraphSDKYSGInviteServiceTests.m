//
//  YesGraphSDKYSGInviteServiceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 16/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGInviteServiceOverridenMethods.h"
#import "YSGTestMockData.h"
#import "YSGTestImageData.h"
#import "YSGShareSheetControllerMockedPresentView.h"
#import "YSGMockedMessageComposeViewController.h"
#import "YSGShareSheetControllerMockedPresentView.h"
#import "YSGAddressBookMockController.h"
#import "YSGMockedMailComposeViewController.h"

@interface YesGraphSDKYSGInviteServiceTests : XCTestCase
@property (strong, nonatomic) YSGInviteServiceOverridenMethods *service;
@property (strong, nonatomic) YSGTheme *theme;
@end

@implementation YesGraphSDKYSGInviteServiceTests

- (void)setUp
{
    [super setUp];
    self.service = [YSGInviteServiceOverridenMethods new];
    self.theme = [YSGTheme new];
    self.service.theme = self.theme;
}

- (void)tearDown
{
    [super tearDown];
    self.service = nil;
    self.theme = nil;
}

- (void)testInviteWithPhoneContact
{
    YSGContact *invitee = [YSGTestMockData mockContactList].entries.lastObject;
    NSArray *contacts = @[ invitee ];
    __weak YesGraphSDKYSGInviteServiceTests *preventRetainCycle = self;
    preventRetainCycle.service.triggeredForEmailContacts = ^(NSArray <YSGContact *> *entries)
    {
        XCTAssertEqual(contacts.count, entries.count, @"Received entries count '%lu' does not match the sent count '%lu'", (unsigned long)entries.count, (unsigned long)contacts.count);
        __weak YSGContact *firstSent = contacts[0];
        __weak YSGContact *firstRec = entries[0];
        XCTAssert([firstSent.description isEqualToString:firstRec.description], @"Description of received contact '%@' does not match the description of the sent contact '%@'", firstSent.description, firstRec.description);
    };
    [self.service triggerInviteFlowWithContacts:contacts];
}

- (void)testInviteWithEmailContact
{
    YSGContact *invitee = [YSGTestMockData mockContactList].entries.firstObject;
    invitee.phones = nil;
    NSArray *contacts = @[ invitee ];
    __weak YesGraphSDKYSGInviteServiceTests *preventRetainCycle = self;
    preventRetainCycle.service.triggeredPhoneContacts = ^(NSArray <YSGContact *> *entries)
    {
        XCTAssertEqual(contacts.count, entries.count, @"Received entries count '%lu' does not match the sent count '%lu'", (unsigned long)entries.count, (unsigned long)contacts.count);
        __weak YSGContact *firstSent = contacts[0];
        __weak YSGContact *firstRec = entries[0];
        XCTAssert([firstSent.description isEqualToString:firstRec.description], @"Description of received contact '%@' does not match the description of the sent contact '%@'", firstSent.description, firstRec.description);
    };
    [self.service triggerInviteFlowWithContacts:contacts];
    
}

- (void)testInviteBothKinds
{
    YSGContact *onlyEmail = [YSGTestMockData mockContactList].entries.firstObject;
    YSGContact *onlyPhone = [YSGTestMockData mockContactList].entries.lastObject;
    onlyEmail.phones = nil;
    onlyPhone.emails = nil;
    NSArray *contacts = @[ onlyEmail, onlyPhone ];
    __weak YesGraphSDKYSGInviteServiceTests *preventRetainCycle = self;
    preventRetainCycle.service.triggeredForEmailContacts = ^(NSArray <YSGContact *> *entries)
    {
        XCTAssertEqual(entries.count, 1, @"Received entries count '%lu' does not match the sent count '%lu'", (unsigned long)entries.count, (unsigned long)contacts.count);
        __weak YSGContact *firstSent = contacts[0];
        __weak YSGContact *firstRec = entries[0];
        XCTAssert([firstSent.description isEqualToString:firstRec.description], @"Description of received contact '%@' does not match the description of the sent contact '%@'", firstSent.description, firstRec.description);
    };
    preventRetainCycle.service.triggeredPhoneContacts = ^(NSArray <YSGContact *> *entries)
    {
        XCTAssertEqual(entries.count, 1, @"Received entries count '%lu' does not match the sent count '%lu'", (unsigned long)entries.count, (unsigned long)contacts.count);
        __weak YSGContact *firstSent = contacts[1];
        __weak YSGContact *firstRec = entries[0];
        XCTAssert([firstSent.description isEqualToString:firstRec.description], @"Description of received contact '%@' does not match the description of the sent contact '%@'", firstSent.description, firstRec.description);
    };
    [self.service triggerInviteFlowWithContacts:contacts];
}

- (void)testServiceName
{
    XCTAssert([self.service.name isEqualToString:@"Contacts"], @"The service name should be 'Contacts' not '%@'", self.service.name);
}

- (void)testServiceBackgroundColor
{
    XCTAssert([self.service.backgroundColor isEqual:self.theme.mainColor], @"Theme's main color and service background color should be the same");
}

- (void)testServiceImage
{
    NSData *imageData = [YSGTestImageData getDataForImageFile:@"phoneImageData"];
    XCTAssertNotNil(imageData, @"Image data file not found for path %@", @"phoneImageData");
    UIImage *image = self.service.serviceImage;
    CGDataProviderRef imageProvider = CGImageGetDataProvider(image.CGImage);
    NSData *data = CFBridgingRelease(CGDataProviderCopyData(imageProvider));
    XCTAssertEqual(data.length, imageData.length, @"Length of the pixel byte arrays are not the same");
    XCTAssert([data isEqualToData:imageData], @"Generated image and image from bundled data file are not the same");
}

- (void)testOpenInviteController
{
    YSGShareSheetControllerMockedPresentView *viewController = [YSGShareSheetControllerMockedPresentView new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting View Controller To Be Presented"];
    __weak YSGShareSheetControllerMockedPresentView *preventRetainCycle = viewController;
    viewController.triggerOnPresent = ^(void)
    {
        XCTAssertNotNil(preventRetainCycle.currentPresentingViewController, @"Current presenting view controller shouldn't be nil");
        XCTAssert([preventRetainCycle.currentPresentingViewController isKindOfClass:[UINavigationController class]], @"Current presenting view controller should be of type UINavigationController");
        [expectation fulfill];
    };
    [self.service openInviteControllerWithController:viewController];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
    {
        XCTAssertNil(error, @"Error encountered while waiting for expectation: '%@'", error);
    }];

}

- (void)testTriggerServiceWithViewControllerGrantedPermissions
{
    YSGShareSheetControllerMockedPresentView *mockedController = [YSGShareSheetControllerMockedPresentView new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting View Controller To Be Presented"];
    __weak YSGShareSheetControllerMockedPresentView *preventRetainCycle = mockedController;
    mockedController.triggerOnPresent = ^(void)
    {
        XCTAssertNotNil(preventRetainCycle.currentPresentingViewController, @"Current presenting view controller shouldn't be nil");
        XCTAssert([preventRetainCycle.currentPresentingViewController isKindOfClass:[UINavigationController class]], @"Current presenting view controller should be of type UINavigationController");
        [expectation fulfill];
    };
    [self.service triggerServiceWithViewController:mockedController];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error encountered while waiting for expectation: '%@'", error);
     }];
}

- (void)testTriggerMessageWithContactsCanSend
{
    YSGAddressBookMockController *mockedController = [YSGAddressBookMockController new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting View Controller To Be Presented"];
    __weak YSGAddressBookMockController *preventRetainCycle = mockedController;
    mockedController.triggerOnPresent = ^(void)
    {
        XCTAssertNotNil(preventRetainCycle.currentPresentingViewController, @"Current presenting view controller shouldn't be nil");
        XCTAssert([preventRetainCycle.currentPresentingViewController isKindOfClass:[MFMessageComposeViewController class]], @"Current presenting view controller should be of type UINavigationController");
        [expectation fulfill];
    };

    NSArray <YSGContact *> *contacts = [[YSGTestMockData mockContactList].entries subarrayWithRange:NSMakeRange(0, 3)];
    [YSGMockedMessageComposeViewController setCanSendText:YES];
    self.service.triggerFakeImplementation = NO;
    self.service.messageComposeViewController = [YSGMockedMessageComposeViewController new];
    self.service.addressBookNavigationController = mockedController;
    [self.service triggerMessageWithContacts:contacts];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error encountered while waiting for expectation: '%@'", error);
     }];
}

- (void)testTriggerMessageWithContactsCannotSend
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting View Controller To Be Presented"];
    YSGShareSheetControllerMockedPresentView *mockedViewController = [YSGShareSheetControllerMockedPresentView new];
    mockedViewController.triggerOnDidShare = ^(void)
    {
        [expectation fulfill];
    };
    YSGAddressBookMockController *mockedController = [YSGAddressBookMockController new];
    NSArray <YSGContact *> *contacts = [[YSGTestMockData mockContactList].entries subarrayWithRange:NSMakeRange(0, 3)];
    [YSGMockedMessageComposeViewController setCanSendText:NO];
    self.service.triggerFakeImplementation = NO;
    self.service.messageComposeViewController = [YSGMockedMessageComposeViewController new];
    self.service.addressBookNavigationController = mockedController;
    self.service.viewController = mockedViewController;
    self.service.delegate = mockedViewController;
    mockedViewController.delegate = mockedViewController;
    
    [self.service triggerMessageWithContacts:contacts];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error encountered while waiting for expectation: '%@'", error);
     }];
}

- (void)testTriggerEmailWithContactsCanSend
{
    YSGAddressBookMockController *mockedController = [YSGAddressBookMockController new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting View Controller To Be Presented"];
    __weak YSGAddressBookMockController *preventRetainCycle = mockedController;
    mockedController.triggerOnPresent = ^(void)
    {
        XCTAssertNotNil(preventRetainCycle.currentPresentingViewController, @"Current presenting view controller shouldn't be nil");
        XCTAssert([preventRetainCycle.currentPresentingViewController isKindOfClass:[MFMailComposeViewController class]], @"Current presenting view controller should be of type UINavigationController");
        [expectation fulfill];
    };
    
    NSUInteger capacity = 3;
    NSMutableArray <YSGContact *> *contacts = [NSMutableArray arrayWithCapacity:capacity];
    
    for (YSGContact *contact in [YSGTestMockData mockContactList].entries)
    {
        if (contact.email)
        {
            [contacts addObject:contact];
            --capacity;
            if (capacity == 0)
            {
                break;
            }
        }
    }
    [YSGMockedMailComposeViewController setCanSendMail:YES];
    self.service.mailComposeViewController = [YSGMockedMailComposeViewController new];
    self.service.triggerFakeImplementation = NO;
    self.service.addressBookNavigationController = mockedController;
    [self.service triggerEmailWithContacts:contacts];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error encountered while waiting for expectation: '%@'", error);
     }];
}

- (void)testTriggerEmailWithContactsCannotSend
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting View Controller To Be Presented"];
    YSGShareSheetControllerMockedPresentView *mockedViewController = [YSGShareSheetControllerMockedPresentView new];
    mockedViewController.triggerOnDidShare = ^(void)
    {
        [expectation fulfill];
    };
    
    NSUInteger capacity = 3;
    NSMutableArray <YSGContact *> *contacts = [NSMutableArray arrayWithCapacity:capacity];
    
    for (YSGContact *contact in [YSGTestMockData mockContactList].entries)
    {
        if (contact.email)
        {
            [contacts addObject:contact];
            --capacity;
            if (capacity == 0)
            {
                break;
            }
        }
    }
    YSGAddressBookMockController *mockedController = [YSGAddressBookMockController new];
    [YSGMockedMailComposeViewController setCanSendMail:NO];
    self.service.triggerFakeImplementation = NO;
    self.service.mailComposeViewController = [YSGMockedMailComposeViewController new];
    self.service.addressBookNavigationController = mockedController;
    self.service.viewController = mockedViewController;
    self.service.delegate = mockedViewController;
    mockedViewController.delegate = mockedViewController;
    
    [self.service triggerEmailWithContacts:contacts];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error encountered while waiting for expectation: '%@'", error);
     }];
}

- (void)testMessageDidFinishWithFailResult
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting Mail Controller To Finish Successfully"];
    YSGShareSheetControllerMockedPresentView *mockedViewController = [YSGShareSheetControllerMockedPresentView new];
    mockedViewController.triggerOnDidShareUserInfo = ^(NSError *error)
    {
        XCTAssertNotNil(error, @"Error shouldn't be nil when MessageComposeResult is set to failed");
        [expectation fulfill];
    };
    
    YSGAddressBookMockController *mockedController = [YSGAddressBookMockController new];
    self.service.triggerFakeImplementation = NO;
    self.service.addressBookNavigationController = mockedController;
    self.service.viewController = mockedViewController;
    self.service.delegate = mockedViewController;
    self.service.phoneContacts = [[YSGTestMockData mockContactList].entries subarrayWithRange:NSMakeRange(0, 3)];
    mockedViewController.delegate = mockedViewController;
    
    YSGMockedMessageComposeViewController *messageController = [YSGMockedMessageComposeViewController new];
    [self.service messageComposeViewController:messageController didFinishWithResult:MessageComposeResultFailed];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error encountered while waiting for expectation: '%@'", error);
     }];
}

- (void)testMessageDidFinishWithSentResultNoEmailContacts
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting Mail Controller To Finish Successfully"];
    YSGShareSheetControllerMockedPresentView *mockedViewController = [YSGShareSheetControllerMockedPresentView new];
    YSGAddressBookMockController *mockedController = [YSGAddressBookMockController new];
    self.service.triggerFakeImplementation = NO;
    self.service.addressBookNavigationController = mockedController;
    self.service.viewController = mockedViewController;
    self.service.delegate = mockedViewController;
    self.service.phoneContacts = [[YSGTestMockData mockContactList].entries subarrayWithRange:NSMakeRange(0, 3)];
    mockedViewController.delegate = mockedViewController;
    
    YSGMockedMessageComposeViewController *messageController = [YSGMockedMessageComposeViewController new];
    messageController.triggeredOnDismissed = ^(BOOL hasCompletion)
    {
        XCTAssertTrue(hasCompletion, @"Controller should trigger dismissal with a valid completion block");
        XCTAssertEqual(self.service.emailContacts.count, 0, @"There shouldn't be any email contacts at this point");
        [expectation fulfill];
    };
    [self.service messageComposeViewController:messageController didFinishWithResult:MessageComposeResultSent];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error encountered while waiting for expectation: '%@'", error);
     }];
}

- (void)testMessageDidFinishWithSentResultEmailContacts
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting Mail Controller To Finish Successfully"];
    YSGShareSheetControllerMockedPresentView *mockedViewController = [YSGShareSheetControllerMockedPresentView new];
    YSGAddressBookMockController *mockedController = [YSGAddressBookMockController new];
    
    __weak YSGAddressBookMockController *preventRetainCycle = mockedController;
    mockedController.triggerOnPresent = ^(void)
    {
        XCTAssertNotNil(preventRetainCycle.currentPresentingViewController, @"Current presenting view controller shouldn't be nil");
        XCTAssert([preventRetainCycle.currentPresentingViewController isKindOfClass:[MFMailComposeViewController class]], @"Current presenting view controller should be of type MFMailComposeViewController");
        [expectation fulfill];
    };
    
    [YSGMockedMailComposeViewController setCanSendMail:YES];
    self.service.mailComposeViewController = [YSGMockedMailComposeViewController new];
    self.service.triggerFakeImplementation = NO;
    self.service.addressBookNavigationController = mockedController;
    self.service.viewController = mockedViewController;
    self.service.delegate = mockedViewController;
    
    NSUInteger capacity = 3;
    NSMutableArray <YSGContact *> *contacts = [NSMutableArray arrayWithCapacity:capacity];
    
    for (YSGContact *contact in [YSGTestMockData mockContactList].entries)
    {
        if (contact.email && contact.phone)
        {
            [contacts addObject:contact];
            --capacity;
            if (capacity == 0)
            {
                break;
            }
        }
    }
    
    self.service.phoneContacts = contacts;
    self.service.emailContacts = contacts;
    mockedViewController.delegate = mockedViewController;
    
    YSGMockedMessageComposeViewController *messageController = [YSGMockedMessageComposeViewController new];
    messageController.triggeredOnDismissed = ^(BOOL hasCompletion)
    {
        XCTAssertTrue(hasCompletion, @"Controller should trigger dismissal with a valid completion block");
    };
    [self.service messageComposeViewController:messageController didFinishWithResult:MessageComposeResultSent];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error encountered while waiting for expectation: '%@'", error);
     }];
}

- (void)testMailDidFinishWithFailResult
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting Mail Controller To Finish Successfully"];
    YSGShareSheetControllerMockedPresentView *mockedViewController = [YSGShareSheetControllerMockedPresentView new];
    mockedViewController.triggerOnDidShareUserInfo = ^(NSError *error)
    {
        XCTAssertNotNil(error, @"Error shouldn't be nil when MessageComposeResult is set to failed");
        [expectation fulfill];
    };
    
    NSUInteger capacity = 3;
    NSMutableArray <YSGContact *> *contacts = [NSMutableArray arrayWithCapacity:capacity];
    
    for (YSGContact *contact in [YSGTestMockData mockContactList].entries)
    {
        if (contact.email)
        {
            [contacts addObject:contact];
            --capacity;
            if (capacity == 0)
            {
                break;
            }
        }
    }
    YSGAddressBookMockController *mockedController = [YSGAddressBookMockController new];
    self.service.triggerFakeImplementation = NO;
    self.service.addressBookNavigationController = mockedController;
    self.service.viewController = mockedViewController;
    self.service.delegate = mockedViewController;
    self.service.emailContacts = contacts;
    mockedViewController.delegate = mockedViewController;
    
    NSError *err = [NSError errorWithDomain:@"testing the failure domain" code:-2 userInfo:nil];
    YSGMockedMailComposeViewController *mailController = [YSGMockedMailComposeViewController new];
    [self.service mailComposeController:mailController didFinishWithResult:MFMailComposeResultFailed error:err];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error encountered while waiting for expectation: '%@'", error);
     }];
}


- (void)testMailDidFinishWithSentResultNoPhoneContacts
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting Mail Controller To Finish Successfully"];
    YSGShareSheetControllerMockedPresentView *mockedViewController = [YSGShareSheetControllerMockedPresentView new];
    YSGAddressBookMockController *mockedController = [YSGAddressBookMockController new];
    self.service.triggerFakeImplementation = NO;
    self.service.addressBookNavigationController = mockedController;
    self.service.viewController = mockedViewController;
    self.service.delegate = mockedViewController;
    
    NSUInteger capacity = 3;
    NSMutableArray <YSGContact *> *contacts = [NSMutableArray arrayWithCapacity:capacity];
    
    for (YSGContact *contact in [YSGTestMockData mockContactList].entries)
    {
        if (contact.email)
        {
            [contacts addObject:contact];
            --capacity;
            if (capacity == 0)
            {
                break;
            }
        }
    }
    
    self.service.emailContacts = contacts;
    mockedViewController.delegate = mockedViewController;
    
    YSGMockedMailComposeViewController *mailController = [YSGMockedMailComposeViewController new];
    mailController.triggeredOnDismissed = ^(BOOL hasCompletion)
    {
        XCTAssertTrue(hasCompletion, @"Controller should trigger dismissal with a valid completion block");
        XCTAssertEqual(self.service.phoneContacts.count, 0, @"There shouldn't be any phone contacts at this point");
        [expectation fulfill];
    };
    [self.service mailComposeController:mailController didFinishWithResult:MFMailComposeResultSent error:nil];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error encountered while waiting for expectation: '%@'", error);
     }];
}

- (void)testMailDidFinishWithSentResultEmailContacts
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting Mail Controller To Finish Successfully"];
    YSGShareSheetControllerMockedPresentView *mockedViewController = [YSGShareSheetControllerMockedPresentView new];
    YSGAddressBookMockController *mockedController = [YSGAddressBookMockController new];
    
    __weak YSGAddressBookMockController *preventRetainCycle = mockedController;
    mockedController.triggerOnPresent = ^(void)
    {
        XCTAssertNotNil(preventRetainCycle.currentPresentingViewController, @"Current presenting view controller shouldn't be nil");
        XCTAssert([preventRetainCycle.currentPresentingViewController isKindOfClass:[MFMessageComposeViewController class]], @"Current presenting view controller should be of type MFMessageComposeViewController");
        [expectation fulfill];
    };
    
    [YSGMockedMailComposeViewController setCanSendMail:YES];
    [YSGMockedMessageComposeViewController setCanSendText:YES];
    self.service.mailComposeViewController = [YSGMockedMailComposeViewController new];
    self.service.messageComposeViewController = [YSGMockedMessageComposeViewController new];
    self.service.triggerFakeImplementation = NO;
    self.service.addressBookNavigationController = mockedController;
    self.service.viewController = mockedViewController;
    self.service.delegate = mockedViewController;
    
    NSUInteger capacity = 3;
    NSMutableArray <YSGContact *> *contacts = [NSMutableArray arrayWithCapacity:capacity];
    
    for (YSGContact *contact in [YSGTestMockData mockContactList].entries)
    {
        if (contact.email && contact.phone)
        {
            [contacts addObject:contact];
            --capacity;
            if (capacity == 0)
            {
                break;
            }
        }
    }
    
    self.service.phoneContacts = contacts;
    self.service.emailContacts = contacts;
    mockedViewController.delegate = mockedViewController;
    
    YSGMockedMailComposeViewController *mailController = [YSGMockedMailComposeViewController new];
    mailController.triggeredOnDismissed = ^(BOOL hasCompletion)
    {
        XCTAssertTrue(hasCompletion, @"Controller should trigger dismissal with a valid completion block");
    };
    [self.service mailComposeController:mailController didFinishWithResult:MFMailComposeResultSent error:nil];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error encountered while waiting for expectation: '%@'", error);
     }];
}

@end
