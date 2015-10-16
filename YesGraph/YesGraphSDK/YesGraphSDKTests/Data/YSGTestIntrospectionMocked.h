//
//  YSGTestIntrospectionMocked.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 16/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
#import "NSObject+YSGIntrospection.h"

/*!
 *  First set of classes with expected properties
 *  this is to be used for introspection tests
 */
@interface TestClassForIntrospection1 : NSObject
{
    NSString *notAprop1;
    NSArray <NSString *> *notAprop2;
}

@property (strong, nonatomic) NSString *prop1;
@property (readonly, nonatomic) NSNumber *prop2;
@property (copy, nonatomic) NSArray <NSData *> *prop3;

@end

@interface TestClassForIntrospectionExpected1 : NSObject

+ (NSArray *)expectedIntrospectionProperties;

@end



/*!
 *  Second set of classes with expected properties
 *  this is to be used for introspection tests
 */

typedef struct
{
    uint8_t sprop1;
    size_t sprop2;
    char *sprop3;
    struct TestStructForIntrospecation2 *nextNode, *prevNode;
} TestStructForIntrospecation2;

@interface TestClassForIntrospection2 : TestClassForIntrospection1
{
    NSString *stillNotAprop;
}

@property (weak, nonatomic) NSData *prop4;
@property (atomic) TestStructForIntrospecation2 prop5;

@end

@interface TestClassForIntrospection2Expected : NSObject

+ (NSArray *)expectedIntrospectionProperties;

@end