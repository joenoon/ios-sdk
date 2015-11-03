//
//  YSGMockedUISearchController.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 03/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGMockedUISearchController.h"

@implementation YSGMockedUISearchBar

@end

@implementation YSGMockedUISearchController

@synthesize searchBar;

- (instancetype)initWithSearch:(NSString *)mockedSearch
{
    if ((self = [super init]))
    {
        self.searchBar = [YSGMockedUISearchBar new];
        self.searchBar.text = mockedSearch;
    }
    return self;
}

@end
