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

- (void)testTwitterImage
{
    UIImage *twitterImage = [YSGIconDrawings twitterImage];
    CGDataProviderRef imageProvider = CGImageGetDataProvider(twitterImage.CGImage);
    NSData *data = CFBridgingRelease(CGDataProviderCopyData(imageProvider));
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *twitterImageDataPath = [bundle pathForResource:@"twitterImageData" ofType:@"bin"];
    NSData *twitterImageData = [NSData dataWithContentsOfFile:twitterImageDataPath];
    
    XCTAssert([data isEqualToData:twitterImageData], @"Generated image and image from bundled data file are not the same");
}

@end
