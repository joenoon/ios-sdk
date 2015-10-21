//
//  YSGViewController.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 15/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGViewController.h"

@interface YSGViewController ()

@end

@implementation YSGViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.theme)
    {
        [self applyTheme:self.theme];
    }
    else
    {
        self.theme = [YSGTheme new];
        [self applyTheme:self.theme];
    }
}

#pragma mark - YSGStyling

- (void)applyTheme:(YSGTheme *)theme
{
    self.theme = theme;
    self.view.backgroundColor = self.theme.baseColor;
}

@end
