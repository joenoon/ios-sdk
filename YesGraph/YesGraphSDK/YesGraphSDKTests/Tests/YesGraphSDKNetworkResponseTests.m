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
#import "YSGConstants.h"

@import Contacts;

@interface YesGraphSDKNetworkResponseTests : XCTestCase

@end

@implementation YesGraphSDKNetworkResponseTests

- (void)testNetworkResponseInit
{
    XCTAssertThrows([[YSGNetworkResponse alloc] init], @"The constructor should throw an exception");
    
    NSError* error = [NSError errorWithDomain:@"com.yesgraph.sdk.tests" code:1 userInfo:nil];
    
    YSGNetworkResponse *response = [[YSGNetworkResponse alloc] initWithResponse:nil data:nil error:error];
    
    XCTAssert(response.error.code == YSGErrorCodeNetwork, @"Initializing with error should create a network error code");
    XCTAssertEqualObjects(response.error.userInfo[NSUnderlyingErrorKey], error, @"Initialized error should be placed into user dictionary");
}

- (void)testResponseObjectSerialization
{
    YSGNetworkResponse *response = [[YSGNetworkResponse alloc] initWithResponse:nil data:nil error:nil];
    YSGContact *contact = [YSGTestMockData mockContactList].entries.firstObject;
    [response setResponseObject:[contact ysg_toDictionary]];
    
    YSGContact *parsedContact = [response responseObjectSerializedToClass:[YSGContact class]];
    XCTAssertNotNil(parsedContact, @"Parsed contact shouldn't be nil");
    XCTAssert([parsedContact.contactString isEqualToString:contact.contactString], @"Parsed contact string '%@' is not the same as '%@'", parsedContact.contactString, contact.contactString);
    
    YSGContact *invalidParse = [response responseObjectSerializedToClass:[CNContact class]];
    XCTAssertNil(invalidParse, @"Parsed CNContact should be nil, got: '%@'", invalidParse);
    
    //
    // Invalid JSON response
    //
    response = [[YSGNetworkResponse alloc] initWithResponse:nil data:[@"{FailJSON}" dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    
    XCTAssert(response.error.code == YSGErrorCodeParse, @"Network response should display parse error code");
}

@end
