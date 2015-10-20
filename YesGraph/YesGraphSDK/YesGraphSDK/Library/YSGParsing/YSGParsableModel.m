//
//  YSGParsableModel.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 01/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "NSObject+YSGParsable.h"
#import "NSObject+YSGIntrospection.h"

#import "YSGParsableModel.h"

@implementation YSGParsableModel

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray<NSString *> *propertes = self.ysg_propertyNames;
    
    for (NSString *property in propertes)
    {
        id value = [self valueForKey:property];
        
        [aCoder encodeObject:value forKey:property];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    
    if (self)
    {
        NSArray<NSString *> *properties = self.ysg_propertyNames;
        
        for (NSString *property in properties)
        {
            id value = [aDecoder decodeObjectForKey:property];
            
            Class class = [self ysg_classForPropertyName:property];
            
            if ([class conformsToProtocol:@protocol(YSGParsable)] && value)
            {
                id objectValue = [class ysg_objectWithDictionary:value];
                
                [self setValue:objectValue forKey:property];
            }
            else if (value)
            {
                [self setValue:value forKey:property];
            }
        }
    }
    
    return self;
}


@end
