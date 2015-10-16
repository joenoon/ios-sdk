//
//  YSGTestIntrospectionMocked.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 16/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
#import "NSObject+YSGIntrospection.h"

@interface TestClassForIntrospection : NSObject
{
    NSString *notAprop1;
    NSArray <NSString *> *notAprop2;
}

@property (strong, nonatomic) NSString *prop1;
@property (readonly, nonatomic) NSNumber *prop2;
@property (copy, nonatomic) NSArray <NSData *> *prop3;

@end

@interface TestClassForIntrospectionExpected : NSObject

+ (NSArray *)expectedIntrospectionProperties;

@end

