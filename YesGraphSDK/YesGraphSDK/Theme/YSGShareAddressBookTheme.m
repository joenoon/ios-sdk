//
//  YSGShareAddressBookTheme.m
//  YesGraphSDK
//
//  Created by w00tnes on 17/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareAddressBookTheme.h"

@implementation YSGShareAddressBookTheme

- (instancetype)init
{
    if ((self = [super init]))
    {
        // set default address list font sizes (compiler already initializes this to 0 in optimized builds ?)
        // NOTE: should this be done via the [UIFont prefferedFont..] ?
        self.cellFontSize = 17.f;
        self.cellDetailFontSize = 12.f;
        self.sectionFontSize = 17.f;
    }
    return self;
}

@end
