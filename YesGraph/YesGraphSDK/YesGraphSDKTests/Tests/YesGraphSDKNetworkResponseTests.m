//
//  YesGraphSDKNetworkResponseTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 23/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGNetworkResponse+ParsingMock.h"
#import "YSGTestMockData.h"

@import Contacts;

@interface YesGraphSDKNetworkResponseTests : XCTestCase

@end

@implementation YesGraphSDKNetworkResponseTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testNetworkResponseInit
{
    XCTAssertThrows([[YSGNetworkResponse alloc] init], @"The constructor should throw an exception");
}

- (void)testResponseObjectSerialization
{
    YSGNetworkResponse *response = [[YSGNetworkResponse alloc] initWithDataTask:nil response:nil data:nil error:nil];
    YSGContact *contact = [YSGTestMockData mockContactList].entries.firstObject;
    [response setResponseObject:[contact ysg_toDictionary]];
    
    YSGContact *parsedContact = [response responseObjectSerializedToClass:[YSGContact class]];
    XCTAssertNotNil(parsedContact, @"Parsed contact shouldn't be nil");
    XCTAssert([parsedContact.contactString isEqualToString:contact.contactString], @"Parsed contact string '%@' is not the same as '%@'", parsedContact.contactString, contact.contactString);
    
    YSGContact *invalidParse = [response responseObjectSerializedToClass:[CNContact class]];
    XCTAssertNil(invalidParse, @"Parsed CNContact should be nil, got: '%@'", invalidParse);
}

@end
