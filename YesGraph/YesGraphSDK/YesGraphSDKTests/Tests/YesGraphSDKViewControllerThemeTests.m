//
//  YesGraphSDKViewControllerThemeTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 20/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGViewController.h"
#import "YSGTheme.h"

@interface YesGraphSDKViewControllerThemeTests : XCTestCase
@property (strong, nonatomic) YSGTheme *baseTheme;
@property (strong, nonatomic) YSGTheme *changedTheme;
@end

@implementation YesGraphSDKViewControllerThemeTests

- (void)setUp
{
    [super setUp];
    self.baseTheme = [YSGTheme new];
    self.changedTheme = [YSGTheme new];
    self.changedTheme.baseColor = [UIColor redColor];
}

- (void)tearDown
{
    [super tearDown];
    self.baseTheme = nil;
    self.changedTheme = nil;
}

- (void)testViewControllerStylingProtocol
{
    YSGViewController *controller = [YSGViewController new];
    controller.theme = self.baseTheme;
    XCTAssert([controller respondsToSelector:@selector(applyTheme:)], @"The controller does not respond to selector, is the protocol YSGStyling not implemented?");
    XCTAssert([controller.theme.baseColor isEqual:self.baseTheme.baseColor], @"The color set in viewcontroller does not match the base color, property assignment did not succeed");
    XCTAssert([controller.view.backgroundColor isEqual:self.baseTheme.baseColor], @"The color of the view in viewcontroller does not match the base color");
    [controller applyTheme:self.changedTheme];
    XCTAssert([controller.theme.baseColor isEqual:self.changedTheme.baseColor], @"The color set in viewcontroller does not match the changed color, assignment via protocol YSGStyling did not succeed");
    XCTAssert([controller.view.backgroundColor isEqual:self.changedTheme.baseColor], @"The color of the view in viewcontroller does not match the base color");
}

@end
