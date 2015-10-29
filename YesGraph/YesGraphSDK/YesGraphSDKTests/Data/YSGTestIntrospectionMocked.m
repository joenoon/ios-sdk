//
//  YSGTestIntrospectionMocked.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 16/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGTestIntrospectionMocked.h"

@implementation TestClassForIntrospection1

- (instancetype)init
{
    if ((self = [super init]))
    {
        self.prop1 = @"Test prop1";

        uint8_t sampleBytes[4] = { 0x01, 0x02, 0x03, 0x04 };
        NSData *d1 = [NSData dataWithBytes:sampleBytes length:4];
        self.prop3 = [NSArray arrayWithObjects:d1,nil];
        
    }
    return self;
}

@end

@implementation TestClassForIntrospectionExpected1

+ (NSDictionary *)expectedIntrospectionProperties
{
    return @{ @"prop1": [NSString class], @"prop2": [NSNumber class], @"prop3": [NSArray class] };
}

@end

@implementation TestClassForIntrospection2

@end

@implementation TestCClassType

@end

@implementation TestClassForIntrospection2Expected

+ (NSDictionary *)expectedIntrospectionProperties
{
    NSDictionary *parentProps = [TestClassForIntrospectionExpected1 expectedIntrospectionProperties];
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:parentProps];
    ret[@"prop4"] = [NSData class];
    ret[@"prop5"] = [TestCClassType class];
    ret[@"prop6"] = [TestCClassType class];
    ret[@"prop7"] = [TestCClassType class];
    return ret;
}

@end