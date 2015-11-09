//
//  YSGPointerPair.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 06/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGPointerPair.h"

@implementation YSGPointerPair

- (instancetype)initWith:(id)item1 and:(id)item2
{
    if ((self = [super init]))
    {
        self.item1 = item1;
        self.item2 = item2;
    }
    return self;
}

@end
