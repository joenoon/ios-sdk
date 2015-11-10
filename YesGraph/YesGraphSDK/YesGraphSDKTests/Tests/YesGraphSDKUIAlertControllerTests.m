//
//  YesGraphSDKUIAlertControllerTests.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 10/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import <OCMock/OCMock.h>

#import "YSGUIAlertController+YSGDisplayOverride.h"
#import "UIAlertController+YSGDisplay.h"

#pragma mark - Private category to expose alert window property

@interface UIAlertController (Private)

@property (nonatomic, strong) UIWindow *ysg_alertWindow;

- (void)ysg_createWindow;

@end

#pragma mark - Tests

@interface YesGraphSDKUIAlertControllerTests : XCTestCase

@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation YesGraphSDKUIAlertControllerTests

- (void)setUp
{
    [super setUp];
    
    self.alertController = [UIAlertController alertControllerWithTitle:@"YesGraph" message:@"Test Message" preferredStyle:UIAlertControllerStyleAlert];
}

- (void)tearDown
{
    [super tearDown];
    
    self.alertController = nil;
}


- (void)testShow
{
    id windowMock = OCMClassMock([UIWindow class]);
    
    id viewControllerMock = OCMClassMock([UIViewController class]);
    
    OCMStub([windowMock rootViewController]).andReturn(viewControllerMock);

    self.alertController.ysg_alertWindow = windowMock;
    
    [self.alertController ysg_show:YES completion:nil];
    
    OCMVerify([viewControllerMock presentViewController:[OCMArg isKindOfClass:[UIViewController class]] animated:YES completion:[OCMArg isNil]]);
}

- (void)testCreateWindow
{
    [self.alertController ysg_createWindow];
    
    XCTAssertNotNil(self.alertController.ysg_alertWindow, @"Alert window should be automatically generated");
    XCTAssertNotNil(self.alertController.ysg_alertWindow.rootViewController, @"Alert window should be automatically generated");
}

- (void)testCreateViewController
{
    id windowMock = OCMClassMock([UIWindow class]);
    
    self.alertController.ysg_alertWindow = windowMock;
    [self.alertController ysg_createWindow];
    
    OCMVerify([windowMock setRootViewController:[OCMArg isNotNil]]);
}

- (void)testAlertWindow
{
    id windowMock = OCMClassMock([UIWindow class]);
    self.alertController.ysg_alertWindow = windowMock;
    
    XCTAssertEqualObjects(self.alertController.ysg_alertWindow, windowMock, @"Alert window objects should be equal");
}

@end
