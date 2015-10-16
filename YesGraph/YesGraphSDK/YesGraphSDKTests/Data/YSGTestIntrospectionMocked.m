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

+ (NSArray *)expectedIntrospectionProperties
{
    return @[ @"prop1", @"prop2", @"prop3" ];
}

@end

@implementation TestClassForIntrospection2

@end

@implementation TestClassForIntrospection2Expected

+ (NSArray *)expectedIntrospectionProperties
{
    NSArray *parentProps = [TestClassForIntrospectionExpected1 expectedIntrospectionProperties];
    NSMutableArray *ret = [NSMutableArray arrayWithArray:parentProps];
    [ret addObject:@"prop4"];
    [ret addObject:@"prop5"];
    return ret;
}

@end