//
//  YesGraphSDKInviteTest.m
//  YesGraphSDK
//
//  Created by w00tnes on 23/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSGTestSettings.h"
#import "YSGTestMockData.h"
#import "YSGClient+Invite.h"
#import "YSGUtility.h"
#import "YSGStubRequestsScoped.h"

@interface YesGraphSDKInviteTest : XCTestCase

@property (strong, nonatomic) YSGClient *client;

@end

@implementation YesGraphSDKInviteTest

- (void)setUp
{
    [super setUp];
    self.client = [YSGClient new];
    self.client.clientKey = YSGTestClientKey;
}


- (void)asyncUpdateInviteSentWithExpecation:(XCTestExpectation *)expectation
{
    NSArray<YSGContact *> *invitees = [YSGTestMockData mockContactList].entries;

    [self.client updateInvitesSent:invitees forUserId:YSGTestClientID withCompletion:^(NSError *_Nullable error)
    {
        if (error)
        {
            XCTFail(@"Expectation failed with error: %@", error);
        }
        else
        {
            [expectation fulfill];
        }
    }];
}

- (void)testUpdateInviteSent
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Invites Sent To Selected Contacts"];

    [self asyncUpdateInviteSentWithExpecation:expectation];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *_Nullable error)
    {
        XCTAssertNil(error, @"Expectation timed-out with error: %@", error);
    }];
}

- (void)testMockedUpdateInviteSent
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Mocked Invites Sent To Selected Contacts"];

    __block YSGStubRequestsScoped *scoped = [YSGStubRequestsScoped StubWithRequestBlock:^BOOL(NSURLRequest * _Nonnull request)
     {
         XCTAssert([[request.HTTPMethod uppercaseString] isEqualToString:@"POST"], @"Invites should be sent with the POST method");
         XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.yesgraph.com/v0/invite-sent"], @"Invite not being sent to the right URL");
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

         NSString *email = [parsedResponse objectForKey:@"email"];
         NSString *phone = [parsedResponse objectForKey:@"phone"];

         XCTAssertFalse(!email && !phone, @"Request can't be missing both the email and phone, at least one must be non-nil. Email: %@, Phone: %@", email, phone);         
         return YES;
     }
    andStubResponseBlock:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request)
     {
         NSData *response = [@"{\"message\":\"Invite sent added.\"}" dataUsingEncoding:NSUTF8StringEncoding];
         return [OHHTTPStubsResponse responseWithData:response statusCode:200 headers:nil];
     }];

    [self asyncUpdateInviteSentWithExpecation:expectation];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error)
     {
         scoped = nil;
         XCTAssertNil(error, @"Expectation timed-out with error: %@", error);
     }];
}

- (void)tearDown
{
    [super tearDown];
    self.client = nil;
}

@end
