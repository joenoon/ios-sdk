//
//  YesGraphSDKSocialServiceTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 26/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGSocialService.h"
#import "YSGShareSheetControllerMockedPresentView.h"

@import Social;

@interface YSGShareSheetControllerMock : NSObject <YSGShareServiceDelegate>

@end

@implementation YSGShareSheetControllerMock

- (nullable NSDictionary<NSString *, id> *)shareService:(YSGShareService *)shareService messageWithUserInfo:(nullable NSDictionary <NSString *, id>*)userInfo
{
    return nil;
}

- (void)shareService:(YSGShareService *)shareService didShareWithUserInfo:(nullable NSDictionary <NSString *, id> *)userInfo error:(nullable NSError *)error
{
    
}

@end

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

- (void)testTriggerServiceWithViewController
{
    YSGShareSheetControllerMockedPresentView *viewController = [YSGShareSheetControllerMockedPresentView new];
    YSGShareSheetControllerMock *mockedDelegate = [YSGShareSheetControllerMock new];
    self.service.delegate = mockedDelegate;
    [self.service triggerServiceWithViewController:viewController];
    XCTAssertTrue(self.service.isAvailable, @"Should be available for '%@'", self.service.serviceType);
    XCTAssertNil(viewController.currentPresentingViewController, @"Presented view controller should be nil when social service is called directly");
}

- (void)testTriggerServiceWithViewControllerAndDelegateResponds
{
    YSGShareSheetControllerMockedPresentView *viewController = [YSGShareSheetControllerMockedPresentView new];
    YSGShareSheetControllerMock *mockedDelegate = [YSGShareSheetControllerMock new];
    self.service.delegate = mockedDelegate;
    [self.service triggerServiceWithViewController:viewController];
    XCTAssertTrue(self.service.isAvailable, @"Should be available for '%@'", self.service.serviceType);
    XCTAssertNil(viewController.currentPresentingViewController, @"Presented view controller should be nil when social service is called directly");
}

@end
