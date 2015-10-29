//
//  YesGraphSDKSuggestionsShownTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 06/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGTestSettings.h"
#import "YSGTestMockData.h"
#import "YSGClient+SuggestionsShown.h"
#import "YSGStubRequestsScoped.h"
#import "YSGUtility.h"

@interface YesGraphSDKSuggestionsShownTests : XCTestCase

@property (strong, nonatomic) YSGClient *client;

@end

@implementation YesGraphSDKSuggestionsShownTests

- (void)setUp
{
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

- (void)testMockedSuggestionsShown
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Send Shown Suggestions to API Mocked Responses"];

    __block YSGStubRequestsScoped *scoped = [YSGStubRequestsScoped StubWithRequestBlock:^BOOL(NSURLRequest * _Nonnull request)
     {
         XCTAssert([[request.HTTPMethod uppercaseString] isEqualToString:@"POST"], @"Shown suggestions should be sent with the POST method");
         XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.yesgraph.com/v0/suggested-seen"], @"Suggestions not sent to the right URL");
         NSString *authHeader = request.allHTTPHeaderFields[@"Authorization"];
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

         NSArray *sentSuggestions = parsedResponse[@"entries"];
         XCTAssertNotNil(sentSuggestions, @"Request body is missing entries");

         NSArray *expectedSuggestions = [[YSGTestMockData mockContactList].entries subarrayWithRange:NSMakeRange(0, 5)];
         XCTAssert(expectedSuggestions.count == sentSuggestions.count, @"Arrays don't have the same number of elements");
         for (NSInteger index = 0; index < expectedSuggestions.count; ++index)
         {
             YSGContact *contact = expectedSuggestions[index];
             NSDictionary *sentContact = sentSuggestions[index];

             NSString *userId = sentContact[@"user_id"];
             XCTAssertNotNil(userId, @"UserId shouldn't be nil in suggestions payload");
             XCTAssert([userId isEqualToString:YSGTestClientID], @"Sent UserId in suggestions payload is not the same as mocked UserId: %@, should be %@", userId, YSGTestClientID);

             NSString *contactName = sentContact[@"name"];
             XCTAssertNotNil(contactName, @"Contact name shouldn't be nil");
             XCTAssert([contactName isEqualToString:contact.name]);

             NSArray *contactEmails = sentContact[@"emails"];
             XCTAssertNotNil(contactEmails, @"Contact emails shouldn't be nil (should be empty array)");
             XCTAssert(contactEmails.count == 0 ? !contact.emails || contact.emails.count == 0 : [contactEmails isEqualToArray:contact.emails], @"Unexpected emails array, got: %@, expected: %@", contactEmails, contact.emails);

             NSArray *contactPhones = sentContact[@"phones"];
             XCTAssertNotNil(contactPhones, @"Contact phones shouldn't be nil (should be empty array)");
             XCTAssert(contactPhones.count == 0 ? !contact.phones || contact.phones.count == 0 : [contactPhones isEqualToArray:contact.phones], @"Unexpected phones array, got: %@, expected: %@", contactPhones, contact.phones);

             NSString *seenAtString = sentContact[@"seen_at"];
             XCTAssertNotNil(seenAtString, @"seen_at shouldn't be nil, it should be an ISO8601 date string");
             NSDate *parsedSeenAt = [YSGUtility dateFromIso8601String:seenAtString];
             XCTAssertNotNil(parsedSeenAt, @"seen_at string is not in an ISO8601 format: %@", seenAtString);
             NSString *current = [YSGUtility iso8601dateStringFromDate:[NSDate date]];
             NSDate *currentDate = [YSGUtility dateFromIso8601String:current];
             double diff = [currentDate timeIntervalSinceDate:parsedSeenAt];
             XCTAssert((diff) <= (5 * 60), @"Parsed date is more than 5 minutes off: %f for %@", diff, seenAtString);
         }
         return YES;
     }
    andStubResponseBlock:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request)
     {
         NSString *responseString = @"{\"message\": \"Suggested and Seen contacts added.\",\"meta\": {\"docs\": \"https://www.yesgraph.com/docs/reference#post-suggested-seen\",\"help\": \"Please contact support@yesgraph.com for any issues.\",\"time\": 0.009863853454589844}}";
         NSData *response = [responseString dataUsingEncoding:NSUTF8StringEncoding];
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
