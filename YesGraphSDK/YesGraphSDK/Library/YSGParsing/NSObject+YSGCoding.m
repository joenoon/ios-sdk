//
//  NSObject+YSGCoding.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 31/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGParsable.h"
#import "NSObject+YSGParsable.h"
#import "NSObject+YSGCoding.h"
#import "NSObject+YSGIntrospection.h"

@implementation NSObject (YSGCoding)

+ (BOOL)supportsSecureCoding
{
    if ([self conformsToProtocol:@protocol(YSGParsable)])
    {
        return YES;
    }
    
    return NO;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if (![self conformsToProtocol:@protocol(YSGParsable)])
    {
        return;
    }
    
    NSDictionary *object = [self ysg_toDictionary];
    
    for (id property in object)
    {
        if ([object[property] isKindOfClass:[NSNumber class]])
        {
            [aCoder encodeObject:object[property] forKey:property];
        }
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (![self conformsToProtocol:@protocol(YSGParsable)])
    {
        return nil;
    }
    
    self = [self init];
    
    if (self)
    {
        NSArray<NSString *> *properties = self.ysg_propertyNames;
        
        for (NSString *property in properties)
        {
            [self setValue:[aDecoder decodeObjectForKey:property] forKey:property];
        }
    }
    
    return self;
}

@end
