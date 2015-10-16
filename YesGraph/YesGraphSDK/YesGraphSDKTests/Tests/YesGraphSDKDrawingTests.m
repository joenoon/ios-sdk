//
//  YesGraphSDKDrawingTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 15/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGIconDrawings.h"

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
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imageDataPath = [bundle pathForResource:file ofType:@"bin"];
    NSData *imageData = [NSData dataWithContentsOfFile:imageDataPath];
    
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

@end
