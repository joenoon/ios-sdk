//
//  YesGraphSDKAddressBookTests.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import "YSGTestSettings.h"
#import "YSGTestMockData.h"

#import "YSGClient+AddressBook.h"

#import "YSGStubRequestsScoped.h" // scoped OHHTTPStubs setup / teardown done via constructors / destructors

@interface YesGraphSDKAddressBookTests : XCTestCase

@property (nonatomic, strong) YSGClient *client;

@end

@implementation YesGraphSDKAddressBookTests

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

- (void)asyncFetchWithExpectation:(XCTestExpectation *)expectation
{
    self.client.clientKey = YSGTestClientKey;
    
    [self.client fetchAddressBookForUserId:YSGTestClientID completion:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        XCTAssert([responseObject isKindOfClass:[YSGContactList class]]);
        YSGContactList* contactList = (YSGContactList *)responseObject;
        XCTAssert(contactList.entries.count == [YSGTestMockData mockContactList].entries.count);
        XCTAssert([contactList.entries.firstObject isKindOfClass:[YSGContact class]]);
        
        [expectation fulfill];
    }];
}

- (void)testFetchAddressBook
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Address Book Fetched"];
    [self asyncFetchWithExpectation:expectation]; 
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error)
    {
        if (error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)asyncUpdateWithExpectation:(XCTestExpectation *)expectation
{
    self.client.clientKey = YSGTestClientKey;
        
    [self.client updateAddressBookWithContactList:[YSGTestMockData mockContactList] completion:^(id _Nullable responseObject, NSError * _Nullable error)
    {
        XCTAssertNotNil(responseObject, @"Response shouldn't be nil");
        XCTAssertNil(error, @"Error should be nil");
        [expectation fulfill];
    }];
}

- (void)testUpdateAddressBook
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Address Book Fetched"];
    
    [self asyncUpdateWithExpectation:expectation];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error)
    {
        if (error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

// NOTE: duplication of code, this should be yanked out...
//       everything below this should probably be moved out of this file?
- (NSString *)getCombinedAuthHeader
{
    return [NSString stringWithFormat:@"Bearer %@", YSGTestClientKey];
}

- (NSString *)getCombinedURL:(NSString *)base
{
    return [NSString stringWithFormat:@"%@/%@", base, YSGTestClientID];
}

- (NSData *)buildMockedAddressBookJSONResponse
{
    YSGContactList *contacts = [YSGTestMockData mockContactList];
    NSMutableArray *contactsData = [[NSMutableArray alloc] initWithCapacity:contacts.entries.count];
    NSArray *empty = [NSArray new];
    for (YSGContact *c in contacts.entries)
    {
        NSDictionary *contactData = @{
            @"phones": c.phones ? c.phones : empty,
            @"emails": c.emails ? c.emails : empty,
            @"email": c.email ? c.email : [NSNull null],
            @"name": c.name ? c.name : [NSNull null],
            @"phone": c.phone ? c.phone : [NSNull null],
            @"data": c.data ? c.data : empty
        };
        [contactsData addObject:contactData];           
    }
    NSDictionary *respDic = @{
        @"meta": @"test",
        @"total_count": [NSNumber numberWithInteger:contacts.entries.count],
        @"user_id": YSGTestClientID,
        @"data": contactsData
    };
    NSError *err = nil;
    NSData *ret = [NSJSONSerialization dataWithJSONObject:respDic options:NSJSONWritingPrettyPrinted  error:&err];
    XCTAssertNil(err, @"Error converting contacts data to json: %@", err.localizedDescription);
    return ret;

}

- (void)testFetchMockedAddressBook
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Address Book Fetched Mocked Data"];    
    NSData *response = [self buildMockedAddressBookJSONResponse];
    
    __block YSGStubRequestsScoped *scoped = [YSGStubRequestsScoped StubWithRequestBlock:^BOOL(NSURLRequest * _Nonnull request)
     {
         XCTAssert([[request.HTTPMethod uppercaseString] isEqualToString:@"GET"], @"Request type for mocked data should be GET");
         XCTAssert([request.URL.absoluteString isEqualToString:[self getCombinedURL:@"https://api.yesgraph.com/v0/address-book"]], @"Unexpected URL");
         NSString *authHeader = [request.allHTTPHeaderFields objectForKey:@"Authorization"];
         XCTAssertNotNil(authHeader, @"Authorization header is missing");
         XCTAssert([authHeader isEqualToString:[self getCombinedAuthHeader]], @"Authorization header is incomplete");
         return YES;
     }
    andStubResponseBlock:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request)
     {
         NSLog(@"Response mocked");
         return [OHHTTPStubsResponse responseWithData:response statusCode:200 headers:nil];
     }];

    [self asyncFetchWithExpectation:expectation];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error)
     {
         scoped = nil;
         XCTAssertNil(error, @"Expectation failed with error: %@", error);
     }];   
}

- (void)testUpdateMockedAddressBook
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Address Book Mocked Update"];

    __block YSGStubRequestsScoped *scoped = [YSGStubRequestsScoped StubWithRequestBlock:^BOOL(NSURLRequest * _Nonnull request)
     {
         XCTAssert([[request.HTTPMethod uppercaseString] isEqualToString:@"POST"], @"Request type for mocked data should be POST");
         XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.yesgraph.com/v0/address-book"], @"Unexpected URL");
         NSString *authHeader = [request.allHTTPHeaderFields objectForKey:@"Authorization"];
         XCTAssertNotNil(authHeader, @"Authorization header is missing");
         XCTAssert([authHeader isEqualToString:[self getCombinedAuthHeader]], @"Authorization header is incomplete");
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
         NSDictionary *mockDic = [[YSGTestMockData mockContactList] ysg_toDictionary];
         XCTAssert([mockDic isEqualToDictionary:parsedResponse], @"Mocked response not the same as parsed data");
         return YES;
     }
    andStubResponseBlock:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request)
     {
         NSString *mockResponseString = @"{\"message\":\"Address book for 1234 added.\",\"batch_id\":\"e8e38d79-1d2b-466f-8aa1-02c3ca7479d5\"}";
         return [OHHTTPStubsResponse responseWithData:[mockResponseString dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 headers:nil];
     }];

    [self asyncUpdateWithExpectation:expectation];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error)
     {
         scoped = nil;
         XCTAssertNil(error, @"Expectation failed with error %@", error);
     }];
}

@end
