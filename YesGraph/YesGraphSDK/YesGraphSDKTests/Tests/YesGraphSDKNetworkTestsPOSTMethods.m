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
    [OHHTTPStubs removeAllStubs];
}

- (void)testClientPOSTRequest
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Client Post Test"];
    __block YSGStubRequestsScoped *scoped = [YSGStubRequestsScoped StubWithRequestBlock:^BOOL(NSURLRequest * _Nonnull request)
     {
        XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.yesgraph.com/v0/test"], @"Unexpected URL");
        XCTAssert([[request.HTTPMethod uppercaseString] isEqualToString:@"POST"], @"Expected a 'POST' method but got '%@'", [request.HTTPMethod uppercaseString]);
        NSString *authHeader = request.allHTTPHeaderFields[@"Authorization"];
        XCTAssertNotNil(authHeader, @"Authorization header is missing from header fields: '%@'", request.allHTTPHeaderFields);
        XCTAssert([authHeader isEqualToString:getCombinedAuthHeader()], @"Authorization header is incomplete");
        return YES;
     }
    andStubResponseBlock:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request)
     {
        NSString *payloadData = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"test_parameter\":%@}", YSGTestClientID, [NSNumber numberWithFloat:13.5f]];
        // XCTAssert([request.HTTPBody isEqualToData:[payloadData dataUsingEncoding:NSUTF8StringEncoding]]); // NOTE: tule vprasat, ce ma kdo kako idejo zakaj je httpbody enak nil, ceprav je v YSGClient requestForMethod nastavljeno vse...

        XCTAssertNotNil(request.HTTPBodyStream, @"Body stream shouldn't be nil");
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
        NSData *payloadBytes = [payloadData dataUsingEncoding:NSUTF8StringEncoding];
        XCTAssert([data isEqualToData:payloadBytes], @"Payload data doesn't match expected values");
        NSData *expectedResponse = [@"{\"message\": \"You have successfully made an authorized request to the YesGraph API!\", \"meta\": { \"app_name\": \"demo\", \"docs\": \"https://www.yesgraph.com/docs/#get-test\", \"user_id\": null }  }" dataUsingEncoding:NSUTF8StringEncoding];
        
        return [OHHTTPStubsResponse responseWithData:expectedResponse statusCode:200 headers:nil];
     }];
    
    NSString *testPath = @"https://api.yesgraph.com/v0/test";
    
    self.client.clientKey = YSGTestClientKey;
    [self.client POST:testPath parameters:@{@"user_id": YSGTestClientID, @"test_parameter": [NSNumber numberWithFloat:13.5f]} completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil");
         XCTAssertNotNil(response, @"Response shouldn't be nil");
         XCTAssertNotNil(response.responseObject, @"Response should have a parsed data object");
         XCTAssert([response.responseObject isKindOfClass:[NSDictionary class]], @"Parsed data object should be a NSDictionary");
         NSDictionary *respParsed = (NSDictionary *)response.responseObject;
         XCTAssertNotNil(respParsed[@"message"], @"Parsed object should contains a message key");
         XCTAssertNotNil(respParsed[@"meta"], @"Parsed object should contains a meta key");
         XCTAssert([respParsed[@"meta"]  isKindOfClass:[NSDictionary class]], @"Meta key should be a NSDictionary");
         NSDictionary *meta = (NSDictionary *)respParsed[@"meta"];
         XCTAssertNotNil(meta[@"app_name"], @"App name should not be nil");
         XCTAssert([meta[@"app_name"] isEqualToString:@"demo"], @"App name should be 'demo'");
         dispatch_async(dispatch_get_main_queue(), ^{
             [expectation fulfill];;
         });
     }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         if (error)
         {
             XCTFail(@"Expectation timed-out with error: %@", error);
         }
         scoped = nil; // this isn't needed, it's used to remove compiler warnings
     }];
}



@end
