//
//  YesGraphSDKShareSheetControllerTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 30/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "YSGShareSheetController+ExposedPrivateMethods.h"
#import "YSGFacebookService.h"
#import "YSGTwitterService.h"
#import "YSGShareService.h"
#import "YSGShareSheetServiceCell.h"
#import "YSGMockedPasteboard.h"

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

- (void)testModal
{
    XCTAssertTrue(self.controller.isModal, @"Controller should be modal");
}

- (void)headerChecksForNil
{
    XCTAssertNil(self.controller.header, @"Header should be nil at this point");
    XCTAssertNil(self.controller.logoView, @"Logo view should be nil at this point");
    XCTAssertNil(self.controller.shareLabel, @"Share label should be nil at this point");
}

- (void)headerChecksForCompleteness
{
    XCTAssertNotNil(self.controller.header, @"Header shouldn't be nil at this point");
    XCTAssertNotNil(self.controller.logoView, @"Logo view shouldn't be nil at this point");
    XCTAssertNotNil(self.controller.shareLabel, @"Share label shouldn't be nil at this point");
    
    XCTAssert([self.controller.shareLabel.text isEqualToString:self.controller.shareText], @"Share text '%@' expected to be '%@'", self.controller.shareLabel.text, self.controller.shareText);
    XCTAssert(self.controller.shareLabel.textAlignment == self.controller.theme.shareLabelTextAlignment, @"Share label text alignment is incorrect");
    XCTAssertEqual(self.controller.header.subviews.count, 2, @"Header view should contain 2 subviews, not '%lu'", (unsigned long)self.controller.header.subviews.count);
    XCTAssertTrue([self.controller.header.subviews containsObject:self.controller.shareLabel], @"Header view should hold shareLabel in its subview collection");
    XCTAssertTrue([self.controller.header.subviews containsObject:self.controller.logoView], @"Header view should hold logoView in its subview collection");
}

- (void)testSetupHeader
{
    [self headerChecksForNil];
    [self.controller setupHeader];
    [self headerChecksForCompleteness];
}

- (void)footerChecksForNil
{
    XCTAssertNil(self.controller.footer, @"Footer should be nil at this point");
    XCTAssertNil(self.controller.referralLabel, @"Referral label should be nil at this point");
    XCTAssertNil(self.controller.cpyButton, @"Copy button should be nil at this point");
}

- (void)footerChecksForCompletenessWithExpectedUrl:(NSString *)expectedUrl
{
    XCTAssertNotNil(self.controller.footer, @"Footer shouldn't be nil at this point");
    XCTAssertNotNil(self.controller.referralLabel, @"Referral label shouldn't be nil at this point");
    XCTAssertNotNil(self.controller.cpyButton, @"Copy button shouldn't be nil at this point");
    XCTAssert([self.controller.referralLabel.text isEqualToString:expectedUrl], @"Referral URL '%@' in label not the same as '%@'", self.controller.referralLabel.text, expectedUrl);
    XCTAssert(self.controller.referralLabel.textAlignment == NSTextAlignmentCenter, @"Referral label text alignment is not center");
    XCTAssert([self.controller.referralLabel.textColor isEqual:[UIColor blackColor]], @"Referral label text color is not black");
    XCTAssert([self.controller.cpyButton.titleLabel.text isEqualToString:@"copy"], @"Copy button title should be copy");
}

- (void)testSetupFooter
{
    [self footerChecksForNil];
    NSString *expectedUrl = @"http://www.test.url.com/ref?q=%20space";
    self.controller.referralURL = expectedUrl;
    [self.controller setupFooter];
    [self footerChecksForCompletenessWithExpectedUrl:expectedUrl];
}

- (void)shareServicesViewChecksForNil
{
    XCTAssertNil(self.controller.collectionView, @"Collection view should be nil at this point");
}

- (void)shareServicesViewChecksForCompleteness
{
    Class expected = [UICollectionView class];
    Class actual = [self.controller.collectionView class];
    XCTAssert(actual == expected, @"Collection view should be of type '%@' not '%@'", expected, actual);
    Class layoutExpected = [UICollectionViewFlowLayout class];
    Class layoutActual = [self.controller.collectionView.collectionViewLayout class];
    XCTAssert(layoutActual == layoutExpected, @"Collection view layout should be of type '%@' not '%@'", layoutActual, layoutExpected);
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.controller.collectionView.collectionViewLayout;
    XCTAssert(flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal, @"Scroll direction of the collection view should be horizontal");
    UIColor *actualColor = self.controller.collectionView.backgroundColor;
    UIColor *expectedColor = [UIColor clearColor];
    XCTAssert([actualColor isEqual:expectedColor], @"Background color of the collection view should be '%@' not '%@'", expectedColor, actualColor);
    XCTAssertFalse(self.controller.collectionView.translatesAutoresizingMaskIntoConstraints, @"Translates autoresizing mask into contraint property should be set to NO");
    NSString *YSGShareSheetCellIdentifier = @"YSGShareSheetCellIdentifier";
    UICollectionViewCell *dequeuedCell = [self.controller.collectionView dequeueReusableCellWithReuseIdentifier:YSGShareSheetCellIdentifier forIndexPath:[NSIndexPath indexPathWithIndex:1]];
    XCTAssertNotNil(dequeuedCell, @"Dequeued cell with identiifer '%@' shouldn't be nil", YSGShareSheetCellIdentifier);
    XCTAssert([dequeuedCell class] == [YSGShareSheetServiceCell class], @"Dequeued cell should be of type '%@' not '%@'", [YSGShareSheetServiceCell class], [dequeuedCell class]);
    XCTAssertNotNil(self.controller.collectionView.delegate, @"Delegate of the collection view shouldn't be nil");
    XCTAssertNotNil(self.controller.collectionView.dataSource, @"Data source of the collection view shouldn't be nil");
}

- (void)testSetupShareServicesView
{
    [self shareServicesViewChecksForNil];
    [self.controller setupShareServicesView];
    [self shareServicesViewChecksForCompleteness];
}

- (void)testCopy
{
    YSGMockedPasteboard *mockedPasteboard = [YSGMockedPasteboard new]; // this class will replace the UIPasteboard methods with mocked ones on init
    NSString *expectedUrl = @"http://www.test.url.com/ref?q=%20space";
    self.controller.referralURL = expectedUrl;
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    XCTAssertNil(pasteBoard.string, @"String should be nil before copy is invoked");
    [self.controller copy:nil];
    XCTAssertNotNil(pasteBoard.string, @"String shouldn't be nil after copy is invoked");
    XCTAssert([pasteBoard.string isEqualToString:expectedUrl], @"Pasteboard's string should be '%@' not '%@'", pasteBoard.string, expectedUrl);
    mockedPasteboard = nil; // cleanup, so UIPasteboard methods are switched back to the originals
}

- (void)runCollectionSelectionTestForService:(YSGShareService *)service andIndexPath:(NSIndexPath *)path
{
    id mocked = [OCMockObject partialMockForObject:self.controller];
    id mockedService = [OCMockObject partialMockForObject:service];
    
    __block BOOL fadeInvoked = NO;
    __block BOOL didTriggerService = NO;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting Fade Unfade And Trigger Invokes"];
    OCMStub([mocked fadeCell:[OCMArg any] forService:service]).andDo(^(NSInvocation *invocation)
    {
        fadeInvoked = YES;
    });
    OCMStub([mocked unfadeCell:[OCMArg any] forService:service]).andDo(^(NSInvocation *invocation)
    {
        if (fadeInvoked && didTriggerService)
        {
            [expectation fulfill];
        }
    });
    OCMStub([mockedService triggerServiceWithViewController:[OCMArg any]]).andDo(^(NSInvocation *invocation)
    {
        didTriggerService = YES;
    });
    [self.controller collectionView:self.controller.collectionView didSelectItemAtIndexPath:path];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Expectation timed-out with error '%@'", error);
     }];
    [mocked stopMocking];
    [mockedService stopMocking];
}

- (void)testCollectionViewSelection
{
    [self.controller setupShareServicesView];
    for (NSUInteger index = 0; index < self.controller.services.count; ++index)
    {
        [self runCollectionSelectionTestForService:self.controller.services[index] andIndexPath:[NSIndexPath indexPathForRow:index inSection:1]];
    }
}

- (void)testFadeCell
{
    
    YSGShareSheetServiceCell *cell = [YSGShareSheetServiceCell new];
    id uiview = OCMClassMock([UIView class]);
    XCTestExpectation *expecation = [self expectationWithDescription:@"Expect Animation With Duration 0.2 Called"];
    OCMStub(ClassMethod([uiview animateWithDuration:0.2 animations:[OCMArg any]])).andDo(^(NSInvocation *invocation)
    {
        [expecation fulfill];
    });
    [self.controller fadeCell:cell forService:nil];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error)
    {
        XCTAssertNil(error, @"Error should be nil, not '%@'", error);
    }];
}

- (void)testUnfadeCell
{
    
    YSGShareSheetServiceCell *cell = [YSGShareSheetServiceCell new];
    id uiview = OCMClassMock([UIView class]);
    XCTestExpectation *expecation = [self expectationWithDescription:@"Expect Animation With Duration 0.4 Called"];
    OCMStub(ClassMethod([uiview animateWithDuration:0.4 animations:[OCMArg any]])).andDo(^(NSInvocation *invocation)
    {
        [expecation fulfill];
    });
    [self.controller unfadeCell:cell forService:nil];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil, not '%@'", error);
     }];
}

@end
