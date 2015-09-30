//
//  YesGraphSDKNetworkTests.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import "YSGTestSettings.h"

#import "YSGClient.h"
#import "YSGClient+Private.h"

#import "YSGStubRequestsScoped.h" // scoped OHHTTPStubs setup / teardown done via constructors / destructors

@interface YesGraphSDKNetworkTests : XCTestCase

@property (nonatomic, strong) YSGClient *client;

@end

@implementation YesGraphSDKNetworkTests

- (void)setUp
{
    [super setUp];
    self.client = [[YSGClient alloc] init];
}

- (void)tearDown
{
    [super tearDown];
    
    self.client = nil;
}

- (void)testClientKey
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Client Key Retrieved"];
    
    [self.client fetchRandomClientKeyWithSecretKey:YSGTestClientKey completion:^(NSString *clientKey, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error is: %@", error);
        }
        else
        {
            XCTAssert(clientKey.length > 0, @"Client key should be at least 1 character long");
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error)
    {
        if (error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testClientGETRequestWithoutKey
{
    // we expect to get a 401 response with
    // this body:
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Client Unauthorized Test"];
    NSString *testPath = @"https://api.yesgraph.com/v0/test"; // same URL as documentation example, but we won't set the key header

    [self.client GET:testPath parameters:nil completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
    {
        XCTAssertNotNil(response, @"Response object should not be nil");
        XCTAssertNotNil(error, @"Error object should not be nil");
        XCTAssert([response.response isKindOfClass:[NSHTTPURLResponse class]], @"Response should be of type NSHTTPURLResponse");
        XCTAssertNotNil([error.userInfo objectForKey:@"YSGErrorNetworkStatusCodeKey"], @"Error detail object does not contain the status code key");
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response.response;
        XCTAssert([resp statusCode] == 401 && [error.userInfo[@"YSGErrorNetworkStatusCodeKey"] intValue] == 401, @"HTTP status code should be Not Authorized (401)");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
    {
        if (error)
        {
            XCTFail(@"Expectation timed-out with error: %@", error);
        }
    }];
}

- (NSString *)getCombinedAuthHeader
{
    return [NSString stringWithFormat:@"Bearer %@", YSGTestClientKey];
}

- (void)testClientGETRequestHeaders
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Client Headers Test"];
    YSGStubRequestsScoped *scoped = [YSGStubRequestsScoped StubWithRequestBlock:^BOOL(NSURLRequest * _Nonnull request) {
        // check the headers for completeness
        // /test endpoint specifies the Authorization header
        NSString *authHeader = [request.allHTTPHeaderFields objectForKey:@"Authorization"];
        XCTAssertNotNil(authHeader, @"Authorization header is missing");
        XCTAssert([authHeader isEqualToString:[self getCombinedAuthHeader]], @"Authorization header is incomplete");
        NSString *clientId = [request.allHTTPHeaderFields objectForKey:@"user_id"];
        XCTAssertNotNil(clientId, @"client_id header is missing");
        XCTAssert([clientId isEqualToString:YSGTestClientID], @"client_id header value is unexpected");
        return YES;
    } andStubResponseBlock:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSData *expectedResponse = [@"{\"message\": \"You have successfully made an authorized request to the YesGraph API!\", \"meta\": { \"app_name\": \"demo\", \"docs\": \"https://www.yesgraph.com/docs/#get-test\", \"user_id\": null }  }" dataUsingEncoding:NSUTF8StringEncoding];
        return [OHHTTPStubsResponse responseWithData:expectedResponse statusCode:200 headers:nil];
    }];
    
    NSString *testPath = @"https://api.yesgraph.com/v0/test";
    
    [self.client GET:testPath parameters:@{@"user_id": YSGTestClientID} completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil");
         XCTAssertNotNil(response, @"Response shouldn't be nil");
         XCTAssertNotNil(response.responseObject, @"Response should have a parsed data object");
         XCTAssert([response.responseObject isKindOfClass:[NSDictionary class]], @"Parsed data object should be a NSDictionary");
         NSDictionary *respParsed = (NSDictionary *)response.responseObject;
         XCTAssertNotNil([respParsed objectForKey:@"message"], @"Parsed object should contains a message key");
         XCTAssertNotNil([respParsed objectForKey:@"meta"], @"Parsed object should contains a meta key");
         XCTAssert([[respParsed objectForKey:@"meta"]  isKindOfClass:[NSDictionary class]], @"Meta key should be a NSDictionary");
         NSDictionary *meta = (NSDictionary *)[respParsed objectForKey:@"meta"];
         XCTAssertNotNil([meta objectForKey:@"app_name"], @"App name should not be nil");
         XCTAssert([[meta objectForKey:@"app_name"] isEqualToString:@"demo"], @"App name should be 'demo'");
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         if (error)
         {
             XCTFail(@"Expectation timed-out with error: %@", error);
         }
     }];
    
    scoped = nil; // this isn't needed, it's used to remove compiler warnings
}


//- (void)testClientGETRequestWithNilResponse
//{
//    YSGStubRequestsScoped *scoped = [[YSGStubRequestsScoped alloc] initWithStubRequestBlock:^BOOL(NSURLRequest * _Nonnull request) {
//        return YES;
//    } andStubResponseBlock:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
//        return nil;
//    }];
//    XCTestExpectation *expectation = [self expectationWithDescription:@"Client Key Retrieved"];
//    
//    [self.client fetchRandomClientKeyWithSecretKey:YSGTestClientKey completion:^(NSString *clientKey, NSError *error)
//     {
//         XCTAssertNotNil(error, @"Error shouldn't be nil");
//         XCTAssertNil(clientKey, @"Client key should be nil");
//         
//     }];
//    
//    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error)
//     {
//         if (error)
//         {
//             XCTFail(@"Expectation Failed with error: %@", error);
//         }
//     }];
//    
//    scoped = nil;
//}

@end
