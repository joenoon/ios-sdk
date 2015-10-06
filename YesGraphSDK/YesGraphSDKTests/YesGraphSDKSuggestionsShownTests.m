//
//  YesGraphSDKSuggestionsShownTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 06/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGTestSettings.h"
#import "YSGTestMockData.h"
#import "YSGClient+SuggestionsShown.h"
#import "YSGStubRequestsScoped.h"


@interface YesGraphSDKSuggestionsShownTests : XCTestCase

@property (strong, nonatomic) YSGClient *client;

@end

@implementation YesGraphSDKSuggestionsShownTests

- (void)setUp {
    [super setUp];
    self.client = [YSGClient new];
    self.client.clientKey = YSGTestClientKey;
}

- (void)tearDown {
    [super tearDown];
    self.client = nil;
}


- (void)asyncSuggestionsShownWithExpectation:(XCTestExpectation *)expectation
{
    NSArray *shownSuggestions = [[YSGTestMockData mockContactList].entries subarrayWithRange:NSMakeRange(0, 5)];
    [self.client updateSuggestionsSeen:shownSuggestions forUserId:YSGTestClientID withCompletion:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Error should be nil: %@", error);
         [expectation fulfill];
     }];
}

- (void)testSuggestionsShown
{
    XCTAssert(false, @"Test is not to be run yet, API endpoint missing!");
    XCTestExpectation *expectation = [self expectationWithDescription:@"Send Shown Suggestions to API"];

    [self asyncSuggestionsShownWithExpectation:expectation];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Expectation timed-out with error: %@", error);
     }];
}

- (void)testMockedSuggestionsShown
{
    XCTAssert(false, @"Test is not to be run yet, API endpoint missing!");
    XCTestExpectation *expectation = [self expectationWithDescription:@"Send Shown Suggestions to API Mocked Responses"];

    __block YSGStubRequestsScoped *scoped = [YSGStubRequestsScoped StubWithRequestBlock:^BOOL(NSURLRequest * _Nonnull request)
     {
         XCTAssert([[request.HTTPMethod uppercaseString] isEqualToString:@"POST"], @"Shown suggestions should be sent with the POST method");
         XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.yesgraph.com/v0/suggested-seen"], @"Suggestions not sent to the right URL");
         NSString *authHeader = [request.allHTTPHeaderFields objectForKey:@"Authorization"];
         XCTAssertNotNil(authHeader, @"Authorization header is missing");
         XCTAssert([authHeader isEqualToString:getCombinedAuthHeader()], @"Authorization header is incomplete");
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

         NSString *userId = [parsedResponse objectForKey:@"user_id"];
         XCTAssertNotNil(userId, @"Request body is missing user_id parameter");
         XCTAssert([userId isEqualToString:YSGTestClientID], @"user_id in request is unexpected: %@", userId);

         NSArray *sentSuggestions = [parsedResponse objectForKey:@"data"];
         XCTAssertNotNil(sentSuggestions, @"Request body is missing the data payload");

         NSArray *expectedSuggestions = [[YSGTestMockData mockContactList].entries subarrayWithRange:NSMakeRange(0, 5)];
         XCTAssert(expectedSuggestions.count == sentSuggestions.count, @"Arrays don't have the same number of elements");
         for (NSInteger index = 0; index < expectedSuggestions.count; ++i)
         {
             YSGContact *contact = [expectedSuggestions objectAtIndex:index];
             NSDictionary *sentContact = [sentSuggestions objectAtIndex:index];

             NSString *userId = [sentContact objectForKey:@"user_id"];
             XCTAssertNotNil(userId, @"UserId shouldn't be nil in suggestions payload");
             XCTAssert([userId isEqualToString:YSGTestClientID], @"Sent UserId in suggestions payload is not the same as mocked UserId: %@, should be %@", userId, YSGTestClientID);

             NSString *contactName = [sentContact objectForKey:@"contact_name"];
             XCTAssertNotNil(contactName, @"Contact name shouldn't be nil");
             XCTAssert([contactName isEqualToString:contact.name]);

             NSArray *contactEmails = [sentContact objectForKey:@"contact_emails"];
             XCTAssertNotNil(contactEmails, @"Contact emails shouldn't be nil (should be empty array)");
             XCTAssert(contactEmails.count == 0 ? !contact.emails : [contactEmails isEqualToArray:contact.emails], @"Unexpected emails array, got: %@, expected: %@", contactEmails, contact.emails);

             NSArray *contactPhones = [sentContact objectForKey:@"contact_phones"];
             XCTAssertNotNil(contactPhones, @"Contact phones shouldn't be nil (should be empty array)");
             XCTAssert(contactPhones.count == 0 ? !contact.phones : [contactPhones isEqualToArray:contact.emails], @"Unexpected phones array, got: %@, expected: %@", contactPhones, contact.phones);

             NSNumber *sSince1970 = [sentContact objectForKey:@"seen_at"];
             XCTAssertNotNil(sSince1970, @"seen_at shouldn't be nil, it should be a number"); // unless it's a string?!
             NSDate *seenAt = [NSDate dateWithTimeIntervalSince1970:[sSince1970 doubleValue]];
             XCTAssertNotNil(seenAt, @"Conversion from seen_at number to NSDate failed, number was: %@", sSince1970);
             XCTAssert([seenAt timeIntervalSinceNow] > (5 * 60), @"Converted date is more than 5 minutes off from now: %@", seenAt);
         }
         return YES;
     }
    andStubResponseBlock:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request)
     {
         NSData *response = [@"{\"message\":\"Shown suggestions saved.\"}" dataUsingEncoding:NSUTF8StringEncoding];
         return [OHHTTPStubsResponse responseWithData:response statusCode:200 headers:nil];
     }];

    [self asyncSuggestionsShownWithExpectation:expectation];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         scoped = nil;
         XCTAssertNil(error, @"Expectation timed-out with error: %@", error);
     }];
}


@end
