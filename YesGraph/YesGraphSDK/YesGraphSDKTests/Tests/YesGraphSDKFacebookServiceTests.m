//
//  YesGraphSDKFacebookServiceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 25/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGFacebookService.h"
#import "YSGTestImageData.h"
@import Social;

@interface YesGraphSDKFacebookServiceTests : XCTestCase
@property (strong, nonatomic) YSGFacebookService *service;
@end

@implementation YesGraphSDKFacebookServiceTests

- (void)setUp
{
    [super setUp];
    self.service = [YSGFacebookService new];
}

- (void)tearDown
{
    [super tearDown];
    self.service = nil;
}

- (void)testServiceName
{
    XCTAssert([self.service.name isEqualToString:@"Facebook"], @"Service name '%@' not expected", self.service.name);
}

- (void)testServiceType
{
    XCTAssert([self.service.serviceType isEqualToString:SLServiceTypeFacebook], @"Service type '%@' not expected", self.service.serviceType);
}

- (void)testServiceTheme
{
    XCTAssertNil(self.service.backgroundColor, @"Background color should be nil");
    YSGTheme *expected = [YSGTheme new];
    self.service.theme = expected;
    XCTAssert([self.service.backgroundColor isEqual:expected.facebookColor], @"Service background color does not match theme's facebook color");
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

- (void)testServiceImage
{
    UIImage *facebookImage = self.service.serviceImage;
    [self runTestForImage:facebookImage andFile:@"facebookImageData"];
}

@end
