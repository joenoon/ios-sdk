//
//  NSObject+YSGParsable.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 20/08/15.
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

#import "YSGParsable.h"
#import "YSGValueTransformer.h"
#import "NSObject+YSGIntrospection.h"
#import "NSArray+YSGParsable.h"

#import "NSObject+YSGParsable.h"


@interface NSDictionary (YSGParsable)

+ (NSDictionary *)ysg_mappableDictionaryForKeyPaths:(NSArray *)keyPaths;

@end

static NSString * const YSGSeparator = @"@";

@implementation NSObject (YSGParsable)

+ (nullable instancetype)ysg_objectWithDictionary:(NSDictionary *)dictionary
{
    return [self ysg_objectWithDictionary:dictionary inContext:nil error:nil];
}

+ (nullable instancetype)ysg_objectWithDictionary:(NSDictionary *)dictionary inContext:(id)context
{
    return [self ysg_objectWithDictionary:dictionary inContext:context error:nil];
}

+ (nullable instancetype)ysg_objectWithDictionary:(nonnull NSDictionary *)dictionary inContext:(nullable id)context error:(NSError *__autoreleasing  __nullable * __nullable)error
{
    id object = [[self alloc] init];
    
    if (object)
    {
        [object ysg_mapWithJsonRepresentation:dictionary inResponseContext:context];
    }
    
    return object;
}

#pragma mark - Mapping: From Json

- (void)ysg_mapWithJsonRepresentation:(NSDictionary *)jsonRepresentation inResponseContext:(id)responseContext
{
    NSDictionary *mapping = [[self class] ysg_mapping];
    NSDictionary *defaults = [[self class] ysg_defaultPropertyValues];
    
    for (NSString *propertyNameKey in mapping.allKeys)
    {
        NSString *associatedJsonKeyPath = mapping[propertyNameKey];
        
        id associatedValue = [jsonRepresentation valueForKeyPath:associatedJsonKeyPath];
        
        NSArray *components = [propertyNameKey componentsSeparatedByString:YSGSeparator];
        NSString *propertyNamePath = components.firstObject;
        
        if (!associatedValue || associatedValue == [NSNull null])
        {
            id defaultVal = defaults[propertyNamePath];
            
            if (defaultVal) {
                [self setValue:defaultVal forKeyPath:propertyNamePath];
            }
            
            continue;
        }
        
        Class mappableClass;
        Class transformerClass;
        
        // If components == 2, then the user has declared either a transformer or a mappable class in addition.
        if (components.count == 2)
        {
            NSString *classOrTransformer = components.lastObject;
            Class class = NSClassFromString(classOrTransformer);
            
            if (!class)
            {
                class = [self ysg_swiftClassForName:classOrTransformer];
            }
            
            if ([class conformsToProtocol:@protocol(YSGParsable)])
            {
                mappableClass = class;
            }
            else if ([class isSubclassOfClass:[YSGValueTransformer class]])
            {
                transformerClass = class;
            }
        }
        
        // Attempt introspection
        if (!mappableClass)
        {
            Class propertyClass = [self ysg_classForPropertyName:propertyNamePath];
            
            if ([propertyClass conformsToProtocol:@protocol(YSGParsable)])
            {
                mappableClass = propertyClass;
            }
        }
        
        // Transformer class takes precedence.
        if (transformerClass)
        {
            associatedValue = [transformerClass transformFromValue:associatedValue inContext:responseContext];
        }
        else if (mappableClass)
        {
            if ([associatedValue isKindOfClass:[NSArray class]])
            {
                associatedValue = [associatedValue ysg_arrayOfObjectsOfClass:mappableClass inContext:responseContext];
            }
            else
            {
                associatedValue = [mappableClass ysg_objectWithDictionary:associatedValue inContext:responseContext error:nil];
            }
        }
        
        [self setValue:associatedValue forKeyPath:propertyNamePath];
    }
}


#pragma mark - Mapping: To Json

- (NSDictionary *)ysg_toDictionary
{
    NSDictionary *mapping = [[self class] ysg_mapping];
    
    NSDictionary *jsonRepresentation = [[NSDictionary ysg_mappableDictionaryForKeyPaths:mapping.allValues] mutableCopy];
    
    for (NSString *propertyNameKey in mapping.allKeys)
    {
        NSArray *components = [propertyNameKey componentsSeparatedByString:YSGSeparator];
        
        Class transformerClass;
        
        if (components.count == 2)
        {
            NSString *classString = components.lastObject;
            Class possibleTransformerClass = NSClassFromString(classString);
            
            if (!possibleTransformerClass)
            {
                possibleTransformerClass = [self ysg_swiftClassForName:classString];
            }
            
            if ([possibleTransformerClass isSubclassOfClass:[YSGValueTransformer class]])
            {
                transformerClass = possibleTransformerClass;
            }
        }
        
        NSString *propertyName = components.firstObject;
        
        id val = [self valueForKeyPath:propertyName];
        
        if (val)
        {
            if (transformerClass)
            {
                val = [transformerClass transformToValue:val];
            }
            else if ([val conformsToProtocol:@protocol(YSGParsable)])
            {
                val = [val ysg_toDictionary];
            }
            else if ([val isKindOfClass:[NSArray class]])
            {
                val = [val ysg_arrayOfDictionaryObjects];
            }
            
            if (val)
            {
                NSString *jsonKeyPath = mapping[propertyNameKey];
                [jsonRepresentation setValue:val forKeyPath:jsonKeyPath];
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:jsonRepresentation];
}


#pragma mark - Mapping Overrides

+ (NSDictionary *)ysg_mapping
{
    NSArray *propertyNames = [self ysg_propertyNames];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (NSString *property in propertyNames)
    {
        dictionary[property] = property;
    }
    
    return dictionary.copy;
}

/*!
 *  Not necessary to implement this
 *
 *  @return the default properties to use when mapping the current class
 */
+ (NSMutableDictionary *)ysg_defaultPropertyValues
{
    return nil;
}

@end

#pragma mark - Dictionary

@implementation NSDictionary (YSGParsable)

+ (NSDictionary *)ysg_mappableDictionaryForKeyPaths:(NSArray *)keyPaths
{
    NSMutableDictionary *mappableDictionary = [NSMutableDictionary dictionary];
    
    for (NSString *keyPath in keyPaths)
    {
        [mappableDictionary ysg_ensureKeyPathExists:keyPath];
    }
    
    return mappableDictionary.copy;
}

- (void)ysg_ensureKeyPathExists:(NSString *)keyPath
{
    NSArray *pathComponents = [keyPath componentsSeparatedByString:@"."];
    
    if (pathComponents.count > 1)
    {
        NSUInteger lastIdx = pathComponents.count - 1;
        NSMutableString *path = [NSMutableString string];
        
        for (int i = 0; i < lastIdx; i++)
        {
            [path appendFormat:@"%@%@", i == 0 ? @"" : @".", pathComponents[i]];
            [self ysg_addDictionaryAtKeyPath:path];
        }
    }
}

- (void)ysg_addDictionaryAtKeyPath:(NSString *)keyPath
{
    if (![self valueForKeyPath:keyPath])
    {
        [self setValue:[NSMutableDictionary dictionary] forKeyPath:keyPath];
    }
}

@end


