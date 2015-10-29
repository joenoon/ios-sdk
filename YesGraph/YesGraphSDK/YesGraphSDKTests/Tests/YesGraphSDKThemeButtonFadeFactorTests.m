//
//  YesGraphSDKThemeButtonFadeFactorTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGTheme.h"

@interface YesGraphSDKThemeButtonFadeFactorTests : XCTestCase
@property (strong, nonatomic) YSGTheme *theme;
@property (nonatomic) YSGShareButtonFadeFactors fadeFactors;
@end

@implementation YesGraphSDKThemeButtonFadeFactorTests

- (void)setUp
{
    [super setUp];
    self.theme = [YSGTheme new];
    self.fadeFactors = (YSGShareButtonFadeFactors)
     {
         .AlphaFadeFactor = 0.1f,
         .AlphaUnfadeFactor = 1.0f
     };
}

- (void)tearDown
{
    [super tearDown];
    self.theme = nil;
}

- (void)compareExpected:(YSGShareButtonFadeFactors)expected withActual:(YSGShareButtonFadeFactors)actual
{
    for (NSUInteger index = 0; index < 2; ++index)
    {
        XCTAssertEqual(expected.AlphaPair[index], actual.AlphaPair[index], @"Alpha fade factor at index '%lu' was '%f' but '%f' was expected", (unsigned long)index, actual.AlphaPair[index], expected.AlphaPair[index]);
    }
}

- (void)testSetButtonFadeFactorsWithStructs
{
    XCTAssertEqual(self.fadeFactors.AlphaPair[0], self.fadeFactors.AlphaFadeFactor, @"The YSGShareButtonFadeFactors union doesn't have the right packing order, AlphaFadeFactor should be the same as AlphaPair element at index 0");
    XCTAssertEqual(self.fadeFactors.AlphaPair[1], self.fadeFactors.AlphaUnfadeFactor, @"The YSGShareButtonFadeFactors union doesn't have the right packing order, AlphaUnfadeFactor should be the same as AlphaPair element at index 1");
    [self.theme setShareButtonFadeFactors:self.fadeFactors];
    [self compareExpected:self.fadeFactors withActual:self.theme.shareButtonFadeFactors];
}

- (void)testSetButtonFadeFactorsWithHelper
{
    [self.theme setShareButtonFadeFactorsWithFadeAlpha:self.fadeFactors.AlphaPair[0] andUnfadeAlpha:self.fadeFactors.AlphaPair[1]];
    [self compareExpected:self.fadeFactors withActual:self.theme.shareButtonFadeFactors];
}

- (void)testSetButtonFadeFactorsWithClamp
{
    YSGShareButtonFadeFactors factors = (YSGShareButtonFadeFactors)
     {
         .AlphaFadeFactor = -1.1f,
         .AlphaUnfadeFactor = 10.5f
     };
    YSGShareButtonFadeFactors expectedFactors = (YSGShareButtonFadeFactors)
     {
         .AlphaFadeFactor = 0.f,
         .AlphaUnfadeFactor = 1.f
     };
    [self.self.theme setShareButtonFadeFactors:factors];
    [self compareExpected:expectedFactors withActual:self.theme.shareButtonFadeFactors];
}

@end
