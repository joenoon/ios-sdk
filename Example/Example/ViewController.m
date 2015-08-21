//
//  ViewController.m
//  Example
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "ViewController.h"

@import YesGraphSDK;

@interface ViewController () <YSGShareSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)shareButtonTap:(UIButton *)sender
{
    YSGShareSheetController *shareController = [[YSGShareSheetController alloc] initWithServices:nil delegate:self];
    
    [self presentViewController:shareController animated:YES completion:nil];
}

@end
