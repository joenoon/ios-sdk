//
//  YesGraphSDKDrawableViewTests.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 10/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import <OCMock/OCMock.h>

#import "YSGDrawing.h"

@interface YesGraphSDKDrawableViewTests : XCTestCase

@end

@implementation YesGraphSDKDrawableViewTests

- (void)testDrawingBlock {
    XCTestExpectation* expectation = [self expectationWithDescription:@"Drawing block called"];
    
    YSGDrawableView* view = [[YSGDrawableView alloc] init];
    
    CGRect testRect = CGRectMake(20.0, 25.0, 30.0, 35.0);
    
    view.drawingBlock = ^(CGRect rect, NSDictionary *parameters)
    {
        XCTAssertTrue(rect.origin.x == testRect.origin.x, @"Rect origin X should be the same");
        XCTAssertTrue(rect.origin.y == testRect.origin.y, @"Rect origin Y should be the same");
        XCTAssertTrue(rect.size.width == testRect.size.width, @"Rect size width should be the same");
        XCTAssertTrue(rect.size.height == testRect.size.height, @"Rect size height should be the same");
        XCTAssertNil(parameters, @"Parameters dictionary should be nil");
        
        [expectation fulfill];
    };
    
    [view drawRect:testRect];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
