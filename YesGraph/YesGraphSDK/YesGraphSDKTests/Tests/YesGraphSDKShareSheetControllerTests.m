//
//  YesGraphSDKShareSheetControllerTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 30/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import "YSGShareSheetController+ExposedPrivateMethods.h"
#import "YSGFacebookService.h"
#import "YSGTwitterService.h"
#import "YSGShareService.h"

@interface YesGraphSDKShareSheetControllerTests : XCTestCase
@property (strong, nonatomic) YSGShareSheetController *controller;
@end

@implementation YesGraphSDKShareSheetControllerTests

- (void)setUp
{
    [super setUp];
    NSArray *services = @[ [YSGFacebookService new], [YSGTwitterService new], [YSGShareService new] ];
    self.controller = [[YSGShareSheetController alloc] initWithServices:services delegate:nil theme:nil];
}

- (void)tearDown
{
    [super tearDown];
    self.controller = nil;
}

- (void)testShareText
{
    NSString *expected = @"Share this app with friends to get our eternal gratitude";
    XCTAssertNotNil(self.controller.shareText, @"Share text should never be nil");
    XCTAssert([self.controller.shareText isEqualToString:expected], @"Share text should be '%@' but was '%@'", expected, self.controller.shareText);
    
    expected = @"Changed the text";
    self.controller.shareText = expected;
    XCTAssertNotNil(self.controller.shareText, @"Share text should never be nil");
    XCTAssert([self.controller.shareText isEqualToString:expected], @"Share text should be '%@' but was '%@'", expected, self.controller.shareText);
}

- (void)testServiceCounts
{
    XCTAssertEqual(self.controller.services.count, 3, @"Expected 3 services, got '%lu'", (unsigned long)self.controller.services.count);
    NSInteger itemsInSection = [self.controller collectionView:nil numberOfItemsInSection:0];
    XCTAssertEqual(itemsInSection, self.controller.services.count, @"Number of items in section should always be 3, not '%lu'", (unsigned long)itemsInSection);
}

- (void)testOtherInitializers
{
    YSGShareSheetController *notDefault = [YSGShareSheetController new];
    XCTAssertEqual(notDefault.services.count, 0, @"Controller initialised through other helper initialisers should contain no services");
    YSGShareSheetController *withCoder = [[YSGShareSheetController alloc] initWithCoder:[NSCoder new]];
    XCTAssertEqual(withCoder.services.count, 0, @"Controller initialised through other helper initialisers should contain no services");
    YSGShareSheetController *withNib = [[YSGShareSheetController alloc] initWithNibName:nil bundle:nil];
    XCTAssertEqual(withNib.services.count, 0, @"Controller initialised through other helper initialisers should contain no services");
    
    YSGShareSheetController *classInitialiser = [YSGShareSheetController shareSheetControllerWithServices:self.controller.services];
    XCTAssertEqual(classInitialiser.services.count, self.controller.services.count, @"Controller initalised via the class helper function with services should contain '%lu' entries not '%lu'", (unsigned long)self.controller.services.count, (unsigned long)classInitialiser.services.count);
}

@end
