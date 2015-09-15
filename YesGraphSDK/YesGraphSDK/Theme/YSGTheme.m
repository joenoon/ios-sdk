//
//  YSGTheme.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 19/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGTheme.h"

@implementation YSGTheme

- (instancetype)init
{
    if ((self = [super init]))
    {
        // setup default color values
        self.mainColor = [UIColor colorWithRed:0.9 green:0.11 blue:0.17 alpha:1];
        self.twitterColor = [UIColor colorWithRed:0.31 green:0.67 blue:0.95 alpha:1];
        self.facebookColor = [UIColor colorWithRed:0.28 green:0.38 blue:0.64 alpha:1];
        self.textColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1];
        self.shareViewBackgroundColor = [UIColor whiteColor];
        self.fontFamily = @"Helvetica";
    }
    return self;
}

@end
