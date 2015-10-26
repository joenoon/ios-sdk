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
@property (strong, nonatomic) YSGTheme *theme;
@end

@implementation YesGraphSDKShareServiceTests

- (void)setUp
{
    [super setUp];
    self.service = [YSGShareService new];
    self.theme = [YSGTheme new];
    self.service.theme = self.theme;
}

- (void)tearDown
{
    [super tearDown];
    self.service = nil;
    self.theme = nil;
}

- (void)testTriggerWithController
{
    YSGShareSheetController *controller = [YSGShareSheetController new];
    XCTAssertThrows([self.service triggerServiceWithViewController:controller], @"Share sheet should throw an exception when directly calling triggerService");
}

- (void)testFontFamily
{
    XCTAssert([self.service.fontFamily isEqual:self.theme.fontFamily], @"Font family '%@' is not the same as theme's font family '%@'", self.service.fontFamily, self.theme.fontFamily);
    self.theme.fontFamily = @"Helvetica";
    XCTAssert([self.service.fontFamily isEqual:self.theme.fontFamily], @"Font family '%@' is not the same as theme's font family '%@'", self.service.fontFamily, self.theme.fontFamily);
}

- (void)testTextColor
{

    XCTAssert([self.service.textColor isEqual:self.theme.textColor], @"Text color '%@' is not the same as theme's text color: '%@'", self.service.textColor, self.theme.textColor);
    self.theme.textColor = [UIColor whiteColor];
    XCTAssert([self.service.textColor isEqual:self.theme.textColor], @"Text color '%@' is not the same as theme's text color: '%@'", self.service.textColor, self.theme.textColor);
}

- (void)testShape
{
    XCTAssertEqual(self.service.theme.shareButtonShape, self.theme.shareButtonShape, @"Share button shapes are not the same");
    self.theme.shareButtonShape = YSGShareSheetServiceCellShapeSquare;
    XCTAssertEqual(self.service.theme.shareButtonShape, self.theme.shareButtonShape, @"Share button shapes are not the same");
}

@end
