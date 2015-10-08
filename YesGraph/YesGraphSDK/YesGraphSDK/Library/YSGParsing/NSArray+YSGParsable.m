//
//  NSArray+YSGParsable.m
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

#import "NSArray+YSGParsable.h"
#import "NSObject+YSGParsable.h"
#import "YSGParsable.h"

@implementation NSArray (YSGParsable)

- (NSArray *)ysg_arrayOfObjectsOfClass:(Class)classForMap
{
    return [self ysg_arrayOfObjectsOfClass:classForMap inContext:nil];
}

- (NSArray *)ysg_arrayOfObjectsOfClass:(Class)classForMap inContext:(id)context
{
    NSMutableArray *mapped = [NSMutableArray array];
    
    for (NSDictionary *rawObject in self)
    {
        id mappedObject = [classForMap ysg_objectWithDictionary:rawObject inContext:context];
        [mapped addObject:mappedObject];
    }
    
    return [NSArray arrayWithArray:mapped];
}

- (NSArray *)ysg_arrayOfDictionaryObjects
{
    NSMutableArray *jsonArray = [NSMutableArray array];
    
    for (id object in self)
    {
        if ([object conformsToProtocol:@protocol(YSGParsable)])
        {
            [jsonArray addObject:[object ysg_toDictionary]];
        }
        else
        {
            [jsonArray addObject:object];
        }
    }
    
    return [NSArray arrayWithArray:jsonArray];
}

@end
