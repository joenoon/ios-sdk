//
//  YesGraphSDKShareServiceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 25/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGShareService.h"
#import "YSGShareSheetController.h"
#import "YSGTheme.h"

@interface YesGraphSDKShareServiceTests : XCTestCase
@property (strong, nonatomic) YSGShareService *service;
@end

@implementation YesGraphSDKShareServiceTests

- (void)setUp
{
    [super setUp];
    self.service = [YSGShareService new];
}

- (void)tearDown
{
    [super tearDown];
    self.service = nil;
}

- (void)testTriggerWithController
{
    YSGShareSheetController *controller = [YSGShareSheetController new];
    XCTAssertThrows([self.service triggerServiceWithViewController:controller], @"Share sheet should throw an exception when directly calling triggerService");
}

- (void)testFontFamily
{
    YSGTheme *theme = [YSGTheme new];
    self.service.theme = theme;
    XCTAssert([self.service.fontFamily isEqual:theme.fontFamily], @"Font family '%@' is not the same as theme's font family '%@'", self.service.fontFamily, theme.fontFamily);
    theme.fontFamily = @"Helvetica";
    XCTAssert([self.service.fontFamily isEqual:theme.fontFamily], @"Font family '%@' is not the same as theme's font family '%@'", self.service.fontFamily, theme.fontFamily);
}

- (void)testTextColor
{
    YSGTheme *theme = [YSGTheme new];
    self.service.theme = theme;
    XCTAssert([self.service.textColor isEqual:theme.textColor], @"Text color '%@' is not the same as theme's text color: '%@'", self.service.textColor, theme.textColor);
    theme.textColor = [UIColor whiteColor];
    XCTAssert([self.service.textColor isEqual:theme.textColor], @"Text color '%@' is not the same as theme's text color: '%@'", self.service.textColor, theme.textColor);
}

@end
