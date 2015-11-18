//
//  YesGraphSDKDrawingTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 15/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import <OCMock/OCMock.h>

#import "YSGIconDrawings.h"
#import "YSGTestImageData.h"

@interface YesGraphSDKDrawingTests : XCTestCase

@end

@implementation YesGraphSDKDrawingTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)runTestForImage:(UIImage *)image andFile:(NSString *)file
{
    CGDataProviderRef imageProvider = CGImageGetDataProvider(image.CGImage);
    NSData *data = CFBridgingRelease(CGDataProviderCopyData(imageProvider));
    
    NSData *imageData = [YSGTestImageData getDataForImageFile:file];
    
    XCTAssertNotNil(imageData, @"Image data file not found for path %@", file);
    XCTAssertEqual(data.length, imageData.length, @"Length of the pixel byte arrays are not the same");
    XCTAssert([data isEqualToData:imageData], @"Generated image and image from bundled data file are not the same");
}

- (void)testPhoneImage
{
    UIImage *phoneImage = [YSGIconDrawings phoneImage];
    [self runTestForImage:phoneImage andFile:@"phoneImageData"];
}

- (void)testFacebookImage
{
    UIImage *facebookImage = [YSGIconDrawings facebookImage];
    [self runTestForImage:facebookImage andFile:@"facebookImageData"];
}

- (void)testTwitterImage
{
    UIImage *twitterImage = [YSGIconDrawings twitterImage];
    [self runTestForImage:twitterImage andFile:@"twitterImageData"];
}

- (void)testTargets
{
    id mockObject = OCMStrictClassMock([UIImageView class]);
    //OCMStub([mockObject setImage:[OCMArg isNotNil]]);
    OCMExpect([mockObject setImage:[OCMArg any]]);
    
    YSGIconDrawings* drawings = [[YSGIconDrawings alloc] init];
    drawings.phoneTargets = @[ mockObject ];
    
    OCMVerifyAll(mockObject);
    
    mockObject = OCMStrictClassMock([UIImageView class]);
    //OCMStub([mockObject setImage:[OCMArg isNotNil]]);
    OCMExpect([mockObject setImage:[OCMArg any]]);
    
    drawings.facebookTargets = @[ mockObject ];
    
    OCMVerifyAll(mockObject);
    
    mockObject = OCMStrictClassMock([UIImageView class]);
    //OCMStub([mockObject setImage:[OCMArg isNotNil]]);
    OCMExpect([mockObject setImage:[OCMArg any]]);
    
    drawings.twitterTargets = @[ mockObject ];
    
    OCMVerifyAll(mockObject);
}

@end
