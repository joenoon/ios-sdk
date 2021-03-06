//
//  YesGraphSDKModelYSGSource.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 15/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGSource.h"

@interface YesGraphSDKModelYSGSource : XCTestCase

@end

@implementation YesGraphSDKModelYSGSource

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testUserSourceParse
{
    {
        NSDictionary *sourceDictionary1 = @
         {
             @"name": @"test name",
             @"email": @"test.email@string.com",
             @"phone": @"+386 01 111 111",
             @"type": @"not ios"
         };

        YSGSource *source1 = [YSGSource ysg_objectWithDictionary:sourceDictionary1];
        XCTAssertNotNil(source1, @"Parsed source shouldn't be nil");

        NSString *name = sourceDictionary1[@"name"];
        XCTAssert([source1.name isEqualToString:name], @"Source's name '%@' isn't the same as '%@'", source1.name, name);

        NSString *email = sourceDictionary1[@"email"];
        XCTAssert([source1.email isEqualToString:email], @"Source's email '%@' isn't the same as '%@'", source1.email, email);

        NSString *phone = sourceDictionary1[@"phone"];
        XCTAssert([source1.phone isEqualToString:phone], @"Source's phone '%@' isn't the same as '%@'", source1.phone, phone);

        NSString *type = sourceDictionary1[@"type"];
        XCTAssert([source1.type isEqualToString:type], @"Source's type '%@' isn't the same as '%@'", source1.type, type);
    }
    {
        NSDictionary *sourceDictionary1 = @
         {
             @"name": @"test name",
             @"email": @"test.email@string.com",
             @"phone": @"+386 01 111 111"
         };

        YSGSource *source1 = [YSGSource ysg_objectWithDictionary:sourceDictionary1];
        XCTAssertNotNil(source1, @"Parsed source shouldn't be nil");

        NSString *name = sourceDictionary1[@"name"];
        XCTAssert([source1.name isEqualToString:name], @"Source's name '%@' isn't the same as '%@'", source1.name, name);

        NSString *email = sourceDictionary1[@"email"];
        XCTAssert([source1.email isEqualToString:email], @"Source's email '%@' isn't the same as '%@'", source1.email, email);

        NSString *phone = sourceDictionary1[@"phone"];
        XCTAssert([source1.phone isEqualToString:phone], @"Source's phone '%@' isn't the same as '%@'", source1.phone, phone);

        XCTAssert([source1.type isEqualToString:@"ios"], @"Source's type '%@' should be ios", source1.type);
    }
}

- (void)testUserSource
{
    YSGSource *source = [YSGSource new];
    XCTAssertNotNil(source, @"YSGSource shouldn't be nil");
    XCTAssert([source.type isEqualToString:@"ios"], @"The type of the generated source '%@' should be ios", source.type);
}

@end
