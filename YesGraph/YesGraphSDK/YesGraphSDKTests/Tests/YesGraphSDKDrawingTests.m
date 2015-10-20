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
    XCTAssertNotNil(imageData, @"Image data file not found for path %@", file);
    XCTAssertEqual(data.length, imageData.length, @"Length of the pixel byte arrays are not the same");
    XCTAssert([data isEqualToData:imageData], @"Generated image and image from bundled data file are not the same");
}

- (NSString *)fileForScale:(NSString *)baseName
{
    return [NSString stringWithFormat:@"%@_%.2f", baseName, [UIScreen mainScreen].scale];
}

- (void)testPhoneImage
{
    UIImage *phoneImage = [YSGIconDrawings phoneImage];
    [self runTestForImage:phoneImage andFile:[self fileForScale:@"phoneImageData"]];
}

- (void)testFacebookImage
{
    UIImage *facebookImage = [YSGIconDrawings facebookImage];
    [self runTestForImage:facebookImage andFile:[self fileForScale:@"facebookImageData"]];
}

- (void)testTwitterImage
{
    UIImage *twitterImage = [YSGIconDrawings twitterImage];
    [self runTestForImage:twitterImage andFile:[self fileForScale:@"twitterImageData"]];
}

@end
