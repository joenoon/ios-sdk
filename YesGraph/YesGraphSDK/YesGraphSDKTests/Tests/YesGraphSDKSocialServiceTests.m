//
//  YesGraphSDKSocialServiceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 26/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGSocialService.h"

@interface YesGraphSDKSocialServiceTests : XCTestCase
@property (strong, nonatomic) YSGSocialService *service;
@end

@implementation YesGraphSDKSocialServiceTests

- (void)setUp
{
    [super setUp];
    self.service = [YSGSocialService new];
}

- (void)tearDown
{
    [super tearDown];
    self.service = nil;
}

- (void)testName
{
    XCTAssertNil(self.service.name, @"Service name should be nil, not '%@'", self.service.name);
}

- (void)testServiceType
{
    XCTAssert([self.service.serviceType isEqualToString:@"Unknown"], @"The service type is expected to be Unknown, not '%@'", self.service.serviceType);}

- (void)testServiceImage
{
    XCTAssertNil(self.service.serviceImage, @"Service image should be nil");
}

@end
