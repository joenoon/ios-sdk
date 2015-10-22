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
    XCTestExpectation *expectation = [self expectationWithDescription:@"Mocked Invites Sent To Selected Contacts"];

    __block YSGStubRequestsScoped *scoped = [YSGStubRequestsScoped StubWithRequestBlock:^BOOL(NSURLRequest * _Nonnull request)
     {
         XCTAssert([[request.HTTPMethod uppercaseString] isEqualToString:@"POST"], @"Invites should be sent with the POST method");
         XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.yesgraph.com/v0/invites-sent"], @"Invite not being sent to the right URL");
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

         YSGContactList *mockedContacts = [YSGTestMockData mockContactList];
         NSArray *entries = parsedResponse[@"entries"];
         XCTAssertNotNil(entries, @"Request body is missing entries parameter");
         XCTAssert(entries.count == mockedContacts.entries.count, @"Expected the same number of entries in request body as there are in the mocked contact list, but got %lu instead of %lu", (unsigned long)(unsigned long)entries.count, (unsigned long)mockedContacts.entries.count);

         for (NSUInteger index = 0; index < entries.count; ++index)
         {
             NSDictionary *entry = entries[index];

             NSString *userId = entry[@"user_id"];
             XCTAssertNotNil(userId, @"user_id is missing for entry: %@", entry);
             XCTAssert([userId isEqualToString:YSGTestClientID], @"user_id is %@, but expected %@", userId, YSGTestClientID);

             YSGContact *contact = mockedContacts.entries[index];

             NSString *name = entry[@"invitee_name"];
             XCTAssertNotNil(name, @"invitee_name is missing for entry: %@", entry);
             XCTAssert([name isEqualToString:contact.name], @"invitee_name %@ should be %@", name, contact.name);

             NSString *sentAt = entry[@"sent_at"];
             XCTAssertNotNil(name, @"sent_at is missing for entry: %@", entry);
             NSDate *parsedSentAt = [YSGUtility dateFromIso8601String:sentAt];
             XCTAssertNotNil(parsedSentAt, @"Parsing date string '%@' failed, is the format correct?", sentAt);

             NSString *phone = entry[@"phone"];
             NSString *email = entry[@"email"];
             XCTAssert(phone || email, @"Both phone and email are missing for entry: %@", entry);
             if (phone)
             {
                 XCTAssertNotNil(contact.phone, @"Contact %@ does not have any phones, but entry %@ does", contact, entry);
                 XCTAssert([phone isEqualToString:contact.phone], @"Contact's first phone number %@ is not the same as entry's %@", contact.phone, phone);
             }
             if (email)
             {
                 XCTAssertNotNil(contact.email, @"Contact %@ does not have any emails, but entry %@ does", contact, entry);
                 XCTAssert([email isEqualToString:contact.email], @"Contact's first email %@ is not the same as entry's %@", contact.email, email);
             }
         }

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
