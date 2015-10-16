//
//  YSGParsableMocked.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 16/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGObjectParsableMocked.h"

@implementation YSGObjectParsableMocked

- (instancetype)init
{
    if ((self = [super init]))
    {
        self.prop1 = @"Property name is prop1";
        self.prop2 = @[ @"And", @"This", @"Property", @"Is", @"Prop2" ];
        uint8_t data[5] = { 'p', 'r', 'o', 'p', '3' };
        self.prop3 = [NSData dataWithBytes:data length:5];
    }
    return self;
}

- (NSDictionary *)mappedKvp
{
    
    return @{ @"prop1": self.prop1, @"prop2": self.prop2, @"prop3": self.prop3 };
}

@end
