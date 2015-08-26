//
//  YesGraphSDKParseTests.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 26/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;

#import "YSGContact.h"
#import "YSGParsing.h"

@interface YesGraphSDKParseTests : XCTestCase

@end

@implementation YesGraphSDKParseTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDictionarySuccess
{
    NSDictionary *contact1 = @{ @"name" : @"Mr1. Test", @"emails" : @[ @"mr.test1@test.com", @"mr1.test@test.com" ], @"phones" : @[ @"+1 555 123 456", @"+22 25 123 456" ] };
    
    NSDictionary *contact2 = @{ @"name" : @"Mr2. Test", @"emails" : @[ @"mr.test1@test.com" ], @"phones" : @[ @"+1 555 123 456", @"+22 25 123 456" ] };
    
    NSDictionary *contact3 = @{ @"name" : @"Mr3. Test", @"phones" : @[ @"+1 555 123 456", @"+22 25 123 456" ] };
    
    NSDictionary *contact4 = @{ @"name" : @"Mr4. Test", @"emails" : @[ ], @"phones" : @[ @"+1 555 123 456", @"+22 25 123 456" ] };
    
    NSDictionary *contact5 = @{ @"name" : @"Mr5. Test", @"emails" : @[ @"mr.test1@test.com", @"mr1.test@test.com" ] };
    
    NSDictionary *contact6 = @{ @"name" : @"Mr6. Test", @"emails" : @[ @"mr.test1@test.com", @"mr1.test@test.com" ], @"phones" : @[ ] };
    
    NSDictionary *contact7 = @{ @"name" : @"Mr7. Test", @"phones" : @[ @"mr.test1@test.com" ], @"phones" : @[ @"+1 555 123 456" ] };
    
    NSDictionary *contact8 = @{ @"name" : @"Mr8. Test", @"phones" : @[ @"+1 555 123 456" ] };
    
    
    YSGContact *parsedContact1 = [YSGContact ysg_objectWithDictionary:contact1];
    YSGContact *parsedContact2 = [YSGContact ysg_objectWithDictionary:contact2];
    YSGContact *parsedContact3 = [YSGContact ysg_objectWithDictionary:contact3];
    YSGContact *parsedContact4 = [YSGContact ysg_objectWithDictionary:contact4];
    YSGContact *parsedContact5 = [YSGContact ysg_objectWithDictionary:contact5];
    YSGContact *parsedContact6 = [YSGContact ysg_objectWithDictionary:contact6];
    YSGContact *parsedContact7 = [YSGContact ysg_objectWithDictionary:contact7];
    YSGContact *parsedContact8 = [YSGContact ysg_objectWithDictionary:contact8];
    
    XCTAssert(parsedContact1 != nil);
    XCTAssert(parsedContact2 != nil);
    XCTAssert(parsedContact3 != nil);
    XCTAssert(parsedContact4 != nil);
    XCTAssert(parsedContact5 != nil);
    XCTAssert(parsedContact6 != nil);
    XCTAssert(parsedContact7 != nil);
    XCTAssert(parsedContact8 != nil);
}


- (void)testDictionaryDataTest
{
    NSDictionary *contact1 = @{ @"name" : @"Mr1. Test", @"emails" : @[ @"mr.test1@test.com", @"mr1.test@test.com" ], @"phones" : @[ @"+1 555 123 456", @"+22 25 123 456" ] };
    
    YSGContact *parsedContact1 = [YSGContact ysg_objectWithDictionary:contact1];
    
    XCTAssert([parsedContact1.name isEqualToString:@"Mr1. Test"]);
    XCTAssert(parsedContact1.emails.count == 2);
    XCTAssert(parsedContact1.phones.count == 2);
    
    XCTAssert([parsedContact1.emails.firstObject isEqualToString:@"mr.test1@test.com"]);
    XCTAssert([parsedContact1.phones.firstObject isEqualToString:@"+1 555 123 456"]);
}

@end
