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

@implementation ViewController {
    YSGTheme *theme;
}

- (void)viewDidLoad
{
    theme = [YSGTheme new];
    
    // Welcome screen
    [self.introTextField setTextColor:theme.textColor];
    [self.introTextField setFont:[UIFont fontWithName:theme.fontFamily size:self.introTextField.font.pointSize]];
    [self.additionalNotesTextView setTextColor:theme.textColor];
    [self.additionalNotesTextView setFont:[UIFont fontWithName:theme.fontFamily size:self.additionalNotesTextView.font.pointSize]];
    
    [super viewDidLoad];
}

- (IBAction)shareButtonTap:(UIButton *)sender
{
    YSGLocalContactSource *localSource = [YSGLocalContactSource new];
    localSource.contactAccessPromptMessage = @"Share contacts with Example to invite friends?";
    
    YSGOnlineContactSource *onlineSource = [[YSGOnlineContactSource alloc] initWithClient:[[YSGClient alloc] init] localSource:localSource cacheSource:[YSGCacheContactSource new]];
    
    YSGInviteService *inviteService = [[YSGInviteService alloc] initWithContactSource:onlineSource userId:@"1234"];
    inviteService.numberOfSuggestions = 3;
    inviteService.theme = theme;
    
    YSGFacebookService *facebookService = [YSGFacebookService new];
    facebookService.theme = theme;
    
    YSGTwitterService *twitterService = [YSGTwitterService new];
    twitterService.theme = theme;
    
    YSGShareSheetController *shareController = [[YSGShareSheetController alloc] initWithServices:@[ facebookService, twitterService, inviteService ] delegate:self];
    
    [self.navigationController pushViewController:shareController animated:YES];
}

- (nonnull NSDictionary *)shareSheetController:(nonnull YSGShareSheetController *)shareSheetController messageForService:(nonnull YSGShareService *)service userInfo:(nullable NSDictionary *)userInfo
{
    if ([service isKindOfClass:[YSGFacebookService class]])
    {
        //
        // Facebook actually ignores this message, even in the popup.
        //
        
        return @{ YSGShareSheetMessageKey : @"This message will be posted to Facebook." };
    }
    else if ([service isKindOfClass:[YSGTwitterService class]])
    {
        return @{ YSGShareSheetMessageKey : @"This message will be posted to Twitter." };
    }
    else if ([service isKindOfClass:[YSGInviteService class]])
    {
        return @{ YSGShareSheetMessageKey : @"This message will be posted to SMS." };
        //return @"This message will be posted to Email.";
    }
    
    return @{ YSGShareSheetMessageKey : @"" };
}

@end
