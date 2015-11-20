//
//  YesGraphSDKShareCellServiceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 20/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGShareSheetServiceCell+ExposedPrivate.h"

@interface YesGraphSDKShareCellServiceTests : XCTestCase

@property (strong, nonatomic) YSGShareSheetServiceCell *cell;

@end

@implementation YesGraphSDKShareCellServiceTests

- (void)setUp
{
    [super setUp];
    self.cell = [[YSGShareSheetServiceCell alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
}

- (void)tearDown
{
    [super tearDown];
    self.cell = nil;
}

- (void)runCheckForShape:(YSGShareSheetServiceCellShape)shape
{
    [self.cell setShape:shape];
    CGFloat expectedRadius = 0;
    NSString *shapeDescription = @"Rectangle";
    
    switch (shape) {
        case YSGShareSheetServiceCellShapeCircle:
            expectedRadius = self.cell.serviceLogo.frame.size.height / 2;
            shapeDescription = @"Cirlce";
            break;
        case YSGShareSheetServiceCellShapeRoundedSquare:
            expectedRadius = self.cell.serviceLogo.frame.size.height / 10;
            shapeDescription = @"Rounded square";
            break;
        default: break;
            
    }
    XCTAssertEqual(self.cell.serviceLogo.layer.cornerRadius, expectedRadius, @"Expected the layer radius to be '%f' for shape '%@', but was '%f'", expectedRadius, shapeDescription, self.cell.serviceLogo.layer.cornerRadius);
}

- (void)testSetShape
{
    XCTAssertNotNil(self.cell, @"Cell shouldn;t be nil");
    [self runCheckForShape:YSGShareSheetServiceCellShapeCircle];
    [self runCheckForShape:YSGShareSheetServiceCellShapeSquare];
    [self runCheckForShape:YSGShareSheetServiceCellShapeRoundedSquare];
}

- (void)checZerokDimensionsForCell:(YSGShareSheetServiceCell *)cell
{
    XCTAssertNotNil(cell, @"Cell shouldn't be nil when default init is called");
    XCTAssertEqual(cell.frame.size.height, 0, @"Frame should be 0 points in height, but found '%f'", cell.frame.size.height);
    XCTAssertEqual(cell.frame.size.width, 0, @"Frame should be 0 points in width, but found '%f'", cell.frame.size.width);
}

- (void)testEmptyInit
{
    YSGShareSheetServiceCell *cell = [YSGShareSheetServiceCell new];
    [self checZerokDimensionsForCell:cell];
}

@end
