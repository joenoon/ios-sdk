//
//  YesGraphSDKYesGraphTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 25/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YesGraph+PrivateProperties.h"
#import "YSGTestSettings.h"

@interface YesGraphSDKYesGraphTests : XCTestCase

@end

@implementation YesGraphSDKYesGraphTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testConfigureClientKey
{
    YesGraph *yesGraph = [YesGraph new];
    [yesGraph configureWithClientKey:YSGTestClientKey];
    XCTAssert([yesGraph.clientKey isEqualToString:YSGTestClientKey], @"Configure with client key failed, yesgraph client key '%@' not the same as '%@'", yesGraph.clientKey, YSGTestClientKey);
}

- (void)testConfigureWithClientID
{
    YesGraph *yesGraph = [YesGraph new];
    [yesGraph configureWithUserId:YSGTestClientID];
    XCTAssert([yesGraph.userId isEqualToString:YSGTestClientID], @"Configure with user id failed, yesgraph client id '%@' not the same as '%@'", yesGraph.userId, YSGTestClientID);
}

- (void)testConfigured
{
    YesGraph *yesGraph = [YesGraph new];
    [yesGraph configureWithClientKey:YSGTestClientKey];
    [yesGraph configureWithUserId:YSGTestClientID];
    XCTAssertTrue(yesGraph.isConfigured, @"Configuration should be true since both the key and ID were set");
}

- (void)testUnconfigured
{
    YesGraph *yesGraph = [YesGraph new];
    XCTAssertFalse(yesGraph.isConfigured, @"The SDK shouldn't be configured at this point");
    XCTAssertNil(yesGraph.userId, @"User id shouldn't be set to anything");
    XCTAssertNil(yesGraph.clientKey, @"Client key shouldn't be set to anything");
}

- (void)testContactTimePeriod
{
    YesGraph *yesGraph = [YesGraph new];
    NSTimeInterval defaultInterval = 24 * 60 * 60; // 24 hours
    XCTAssertEqual(defaultInterval, yesGraph.contactBookTimePeriod, @"Contact book time period is '%f' but '%f' was expected", yesGraph.contactBookTimePeriod, defaultInterval);
}

- (void)testThemeUnassigned
{
    YesGraph *yesGraph = [YesGraph new];
    YSGTheme *theme = [YSGTheme new];
    XCTAssertNotNil(yesGraph.theme, @"Theme shouldn't be nil, the SDK should generate a new instance on get");
    XCTAssert([yesGraph.theme.facebookColor isEqual:theme.facebookColor], @"Facebook colors do not match, the themes are not the same");
    XCTAssert([yesGraph.theme.fontFamily isEqualToString:theme.fontFamily], @"Font families do not match, the themes are not the same");
    XCTAssert([yesGraph.theme.mainColor isEqual:theme.mainColor], @"Main colors do not match, the themes are not the same");
    XCTAssertEqual(yesGraph.theme.shareButtonLabelFontSize, theme.shareButtonLabelFontSize, @"Share button label font sizes do not match, the themes are not the same");
    XCTAssertEqual(yesGraph.theme.shareLabelTextAlignment, theme.shareLabelTextAlignment, @"Share label text alignments do not match, the themes are not the same");
    XCTAssertEqual(yesGraph.theme.shareButtonShape, theme.shareButtonShape, @"Share button shapes do not match, the themes are not the same");
    XCTAssertEqual(yesGraph.theme.shareButtonLabelTextAlignment, theme.shareButtonLabelTextAlignment, @"Button text alignments do not match, the themes are not the same");
    XCTAssert([yesGraph.theme.textColor isEqual:theme.textColor], @"The text colors do not match, the themes are not the same");
    XCTAssert([yesGraph.theme.twitterColor isEqual:theme.twitterColor], @"The twitter colors do not match, the themes are not the same");
    XCTAssertEqual(yesGraph.theme.shareButtonFadeFactors.AlphaFadeFactor, theme.shareButtonFadeFactors.AlphaFadeFactor, @"Fade factors do not match, the themes are not the same");
    XCTAssertEqual(yesGraph.theme.shareButtonFadeFactors.AlphaUnfadeFactor, theme.shareButtonFadeFactors.AlphaUnfadeFactor, @"Unfade factors do not match, the themes are not the same");
    XCTAssertNil(yesGraph.theme.shareAddressBookTheme.sectionBackground, @"Section background should be nil");
    XCTAssert([yesGraph.theme.shareAddressBookTheme.viewBackground isEqual:theme.shareAddressBookTheme.viewBackground], @"Share address book view backgrounds do not match, the themes are not the same");
    XCTAssertEqual(yesGraph.theme.shareAddressBookTheme.sectionFontSize, theme.shareAddressBookTheme.sectionFontSize, @"Share address book section font sizes do not match, the themes are not the same");
}

- (void)testThemeAssignment
{
    YesGraph *yesGraph = [YesGraph new];
    YSGTheme *theme = [YSGTheme new];
    yesGraph.theme = theme;
    XCTAssert(yesGraph.theme == theme, @"The theme pointers should be the same after assignment");
}

@end
