//
//  NSObject+YSGIntrospection.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 26/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

//
// Some code based on Genome by Logan Wright:
//  - https://github.com/LoganWright/Genome
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Logan Wright
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

@import ObjectiveC.runtime;

#import "NSObject+YSGIntrospection.h"
#import "YSGParsable.h"
#import "YSGValueTransformer.h"

static NSDictionary *swiftClassMapping = nil;

@implementation NSObject (YSGIntrospection)

+ (NSArray *)ysg_ignoredProperties
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
    {
        sharedInstance = @[ @"hash", @"superclass", @"description", @"debugDescription" ];
    });
    
    return sharedInstance;
}

- (NSArray *)ysg_propertyNames
{
    NSMutableArray *propertyNames = [NSMutableArray array];
    
    Class currentClass = [self class];
    
    while (currentClass != [NSObject class])
    {
        unsigned count;
        objc_property_t *properties = class_copyPropertyList(currentClass, &count);
        
        // Parse Out Properties
        for (int i = 0; i < count; i++)
        {
            objc_property_t property = properties[i];
            const char * name = property_getName(property);
            NSString * propertyName = [NSString stringWithUTF8String:name];
            
            if (![[[self class] ysg_ignoredProperties] containsObject:propertyName])
            {
                [propertyNames addObject:propertyName];
            }
            
        }
        
        free(properties);
        
        currentClass = [currentClass superclass];
    }
    
    return propertyNames;
}


- (Class)ysg_classForPropertyName:(NSString *)propertyName
{
    objc_property_t prop = class_getProperty([self class], propertyName.UTF8String);
    const char * attr = property_getAttributes(prop);
    NSString *attributes = [NSString stringWithUTF8String:attr];
    NSArray *components = [attributes componentsSeparatedByString:@"\""];
    Class propertyClass;
    
    for (NSString *component in components)
    {
        Class class = NSClassFromString(component);
        
        if (class)
        {
            propertyClass = class;
            break;
        }
        else
        {
            class = swiftClassMapping[component];
            
            if (class)
            {
                propertyClass = class;
                break;
            }
        }
    }
    
    return propertyClass;
}

- (Class)ysg_swiftClassForName:(NSString *)name
{
    return swiftClassMapping[name];
}

+ (void)load
{
    swiftClassMapping = [self ysg_swiftClassMapping];
}

+ (NSDictionary *)ysg_swiftClassMapping
{
    NSMutableDictionary *swiftClassMapping = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    Class* runtimeClasses = objc_copyClassList(&count);
    
    for (unsigned int i = 0; i < count; i++)
    {
        NSString *className = NSStringFromClass(runtimeClasses[i]);
        NSArray *comps = [className componentsSeparatedByString:@"."];

        if (comps.count == 2 && ![@[@"Foundation", @"Swift"] containsObject:comps.firstObject])
        {
            Class class = runtimeClasses[i];
            
            if ([class conformsToProtocol:@protocol(YSGParsable)] || [class isSubclassOfClass:[YSGValueTransformer class]])
            {
                NSString *demangledClassName = comps.lastObject;

                swiftClassMapping[demangledClassName] = class;
            }
        }
    }
    
    free(runtimeClasses);
    return swiftClassMapping;
}

@end
