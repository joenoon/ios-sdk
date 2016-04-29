//
//  YSGTestMockData.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGTestMockData.h"

@implementation YSGTestMockData

+ (YSGContactList *)mockContactList
{
    YSGContactList *contactList = [[YSGContactList alloc] init];
    NSDictionary *sourceDictionary1 = @
    {
        @"name": @"test name",
        @"email": @"test.email@string.com",
        @"phone": @"+386 01 111 111",
        @"type": @"not ios"
    };

    contactList.source = [YSGSource ysg_objectWithDictionary:sourceDictionary1];
    YSGContact *c1 = [YSGContact ysg_objectWithDictionary:@{ @"name": @"Daniel Higgins Jr.", @"emails:" : @[ @"d-higgins@mac.com"] }];
    YSGContact *c2 = [YSGContact ysg_objectWithDictionary:@{ @"name": @"Anna Haro", @"emails:" : @[ @"anna-haro@mac.com"] }];
    YSGContact *c3 = [YSGContact ysg_objectWithDictionary:@{ @"name": @"Hank M. Zakroff", @"emails:" : @[ @"hank-zakroff@mac.com"] }];
    YSGContact *c4 = [YSGContact ysg_objectWithDictionary:@{ @"name": @"Kate Bell", @"emails:" : @[ @"kate-bell@mac.com"] }];
    YSGContact *c5 = [YSGContact ysg_objectWithDictionary:@{ @"name": @"John Appleseed", @"emails:" : @[ @"John-Appleseed@mac.com"] }];
    YSGContact *c6 = [YSGContact ysg_objectWithDictionary:@{ @"name": @"David Taylor", @"phones:" : @[ @"555-610-6679"] }];
    
    contactList.entries = @[ c1, c2, c3, c4, c5, c6 ];
    
    return contactList;
}

@end
