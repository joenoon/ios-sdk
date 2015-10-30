//
//  YesGraphSDKNetworkTestsGETMethods.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 29/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import "YSGTestSettings.h"

#import "YSGTestClientWithID.h"

#import "YSGStubRequestsScoped.h" // scoped OHHTTPStubs setup / teardown done via constructors / destructors

@interface YesGraphSDKNetworkTestsGETMethods : XCTestCase

@property (nonatomic, strong) YSGTestClientWithID *client;

@end

@implementation YesGraphSDKNetworkTestsGETMethods

- (void)setUp
{
    [super setUp];

    self.client = [[YSGTestClientWithID alloc] initWithId:GENERATE_ID( )];
}

- (void)tearDown
{
    [super tearDown];

    self.client = nil;
    [OHHTTPStubs removeAllStubs];
}

- (void)testClientKey
{
    __block YSGStubRequestsScoped *scoped = [YSGStubRequestsScoped StubWithRequestBlock:^BOOL(NSURLRequest *_Nonnull request) {

      NSString *clientId = request.allHTTPHeaderFields[@"YSGClientID"];

      if ([self.client.clientID isEqualToString:clientId])
      {
          XCTAssert([[request.HTTPMethod uppercaseString] isEqualToString:@"POST"], @"Client key request should be sent with the POST method");
          XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.yesgraph.com/v0/client-key"], @"Client key request not sent to the right URL");
          NSString *authHeader = request.allHTTPHeaderFields[@"Authorization"];
          XCTAssertNotNil(authHeader, @"Authorization header is missing");
          XCTAssert([authHeader isEqualToString:getCombinedAuthHeader( )], @"Authorization header is incomplete");
          XCTAssertNotNil(request.HTTPBodyStream, @"No data can be read from the stream");

          NSInputStream *istream = request.HTTPBodyStream;
          NSMutableData *data = [NSMutableData new];
          [istream open];

          size_t sizeOfBuf = 1024;
          uint8_t *buf = malloc(sizeOfBuf);
          NSInteger len = 0;

          while ([istream hasBytesAvailable] && (len = [istream read:buf maxLength:sizeOfBuf]) > 0)
          {
              [data appendBytes:buf length:len];
          }

          free(buf);
          [istream close];

          NSError *err = nil;
          NSDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
          XCTAssertNil(err, @"Error parsing response data: %@", err);

          NSString *userId = parsedResponse[@"user_id"];
          XCTAssertNotNil(userId, @"UserId shouldn't be nil in client key payload");
      }
      return YES;
    }
        andStubResponseBlock:^OHHTTPStubsResponse *_Nonnull(NSURLRequest *_Nonnull request) {
          NSString *responseString = @"{\"client_key\": \"12345678asdfg\"}";
          NSData *response = [responseString dataUsingEncoding:NSUTF8StringEncoding];
          return [OHHTTPStubsResponse responseWithData:response statusCode:200 headers:nil];
        }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Client Key Retrieved"];

    [self.client fetchRandomClientKeyWithSecretKey:YSGTestClientKey
                                        completion:^(NSString *clientKey, NSError *error) {
                                          XCTAssertNil(error, @"Error should be nil: %@", error);
                                          XCTAssert(clientKey.length > 0, @"Client key should be at least 1 character long");
                                          [expectation fulfill];
                                        }];

    [self waitForExpectationsWithTimeout:5.0
                                 handler:^(NSError *_Nullable error) {
                                   scoped = nil;
                                   XCTAssertNil(error, @"Expectation timed-out with error: %@", error);
                                 }];
}

- (void)testClientGETRequestWithoutKey
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Client Unauthorized Test"];
    NSString *testPath = @"https://api.yesgraph.com/v0/test"; // same URL as documentation example, but we won't set the key header

    [self.client GET:testPath
          parameters:nil
          completion:^(YSGNetworkResponse *_Nullable response, NSError *_Nullable error) {
            XCTAssertNotNil(response, @"Response object should not be nil");
            XCTAssertNotNil(error, @"Error object should not be nil");
            dispatch_async(dispatch_get_main_queue( ), ^{
              [expectation fulfill];
              ;
            });
          }];

    [self waitForExpectationsWithTimeout:5.0
                                 handler:^(NSError *_Nullable error) {
                                   if (error)
                                   {
                                       XCTFail(@"Expectation timed-out with error: %@", error);
                                   }
                                 }];
}

- (void)testClientGETRequestHeaders
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Client Headers Test"];
    __block YSGStubRequestsScoped *scoped = [YSGStubRequestsScoped StubWithRequestBlock:^BOOL(NSURLRequest *_Nonnull request) {
      NSString *clientId = request.allHTTPHeaderFields[@"YSGClientID"];

      if ([self.client.clientID isEqualToString:clientId])
      {
          // check the headers for completeness
          // /test endpoint specifies the Authorization header
          XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.yesgraph.com/v0/test"], @"Unexpected URL: '%@'", request.URL.absoluteString);
          XCTAssert([[request.HTTPMethod uppercaseString] isEqualToString:@"GET"], @"Expected a 'GET' method but got '%@'", [request.HTTPMethod uppercaseString]);
          NSString *authHeader = request.allHTTPHeaderFields[@"Authorization"];
          XCTAssertNotNil(authHeader, @"Authorization header is missing");
          XCTAssert([authHeader isEqualToString:getCombinedAuthHeader( )], @"Authorization header is incomplete");
      }
      return YES;
    }
        andStubResponseBlock:^OHHTTPStubsResponse *_Nonnull(NSURLRequest *_Nonnull request) {
          NSData *expectedResponse = [@"{\"message\": \"You have successfully made an authorized request to the YesGraph API!\", \"meta\": { \"app_name\": \"demo\", \"docs\": \"https://www.yesgraph.com/docs/#get-test\", \"user_id\": null }  }" dataUsingEncoding:NSUTF8StringEncoding];
          return [OHHTTPStubsResponse responseWithData:expectedResponse statusCode:200 headers:nil];
        }];

    NSString *testPath = @"https://api.yesgraph.com/v0/test";

    YSGClient *client = [[YSGClient alloc] init];
    client.clientKey = YSGTestClientKey;

    [client GET:testPath
        parameters:nil
        completion:^(YSGNetworkResponse *_Nullable response, NSError *_Nullable error) {
          XCTAssertNil(error, @"Error should be nil");
          XCTAssertNotNil(response, @"Response shouldn't be nil");
          XCTAssertNotNil(response.responseObject, @"Response should have a parsed data object");
          XCTAssert([response.responseObject isKindOfClass:[NSDictionary class]], @"Parsed data object should be a NSDictionary");
          NSDictionary *respParsed = (NSDictionary *)response.responseObject;
          XCTAssertNotNil(respParsed[@"message"], @"Parsed object should contains a message key");
          XCTAssertNotNil(respParsed[@"meta"], @"Parsed object should contains a meta key");
          XCTAssert([respParsed[@"meta"] isKindOfClass:[NSDictionary class]], @"Meta key should be a NSDictionary");
          NSDictionary *meta = (NSDictionary *)respParsed[@"meta"];
          XCTAssertNotNil(meta[@"app_name"], @"App name should not be nil");
          XCTAssert([meta[@"app_name"] isEqualToString:@"demo"], @"App name should be 'demo'");
          dispatch_async(dispatch_get_main_queue( ), ^{
            [expectation fulfill];
            ;
          });
        }];

    [self waitForExpectationsWithTimeout:5.0
                                 handler:^(NSError *_Nullable error) {
                                   if (error)
                                   {
                                       XCTFail(@"Expectation timed-out with error: %@", error);
                                   }
                                   scoped = nil; // this isn't needed, it's used to remove compiler warnings
                                 }];
}

@end
