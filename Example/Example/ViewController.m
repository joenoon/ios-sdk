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
    
    YSGOnlineContactSource *onlineSource = [[YSGOnlineContactSource alloc] initWithClient:[YSGClient shared] localSource:localSource cacheSource:nil];
    
    YSGInviteService *inviteService = [[YSGInviteService alloc] initWithContactSource:onlineSource];
    inviteService.numberOfSuggestions = 3;
    
    YSGShareSheetController *shareController = [[YSGShareSheetController alloc] initWithServices:@[ [YSGFacebookService new], [YSGTwitterService new], inviteService ] delegate:self];
    shareController.delegate = self;
    
    [self.navigationController pushViewController:shareController animated:YES];
}

- (nonnull NSString *)shareSheetController:(nonnull YSGShareSheetController *)shareSheetController messageForService:(nonnull YSGShareService *)service userInfo:(nullable NSDictionary *)userInfo
{
    if ([service isKindOfClass:[YSGFacebookService class]])
    {
        //
        // Facebook actually ignores this message, even in the popup.
        //
        
        return @"This message will be posted to Facebook.";
    }
    else if ([service isKindOfClass:[YSGTwitterService class]])
    {
        return @"This message will be posted to Twiiter.";
    }
    else if ([service isKindOfClass:[YSGInviteService class]])
    {
        return @"";
    }
    
    return @"";
}

@end
