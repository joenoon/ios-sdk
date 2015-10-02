//
//  YSGShareAddressBookTheme.m
//  YesGraphSDK
//
//  Created by w00tnes on 17/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareAddressBookTheme.h"
#import "YSGConstants+AddressBook.h"

@implementation YSGShareAddressBookTheme

- (instancetype)init
{
    if ((self = [super init]))
    {
        // set default address list font sizes (compiler already initializes this to 0 in optimized builds ?)
        // NOTE: should this be done via the [UIFont prefferedFont..] ?
        self.cellDetailFontSize = [YSGThemeConstants cellDefaultFontSize];
        self.cellFontSize = [YSGThemeConstants cellDefaultFontSize];
        self.sectionFontSize = [YSGThemeConstants cellDefaultFontSize];
        self.viewBackground = [UIColor whiteColor];
    }
    return self;
}

@end
