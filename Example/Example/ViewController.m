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
    YSGLocalContactSource *localSource = [YSGLocalContactSource new];
    localSource.contactAccessPromptMessage = @"Share contacts with Example to invite friends?";
    
    YSGInviteService *service = [[YSGInviteService alloc] initWithContactSource:localSource];
    service.numberOfSuggestions = 3;
    
    YSGShareSheetController *shareController = [[YSGShareSheetController alloc] initWithServices:@[ service ] delegate:self];
    
    [self.navigationController pushViewController:shareController animated:YES];
}

@end
