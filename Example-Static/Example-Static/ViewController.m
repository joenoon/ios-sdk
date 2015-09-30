//
//  ViewController.m
//  Example-Static
//
//  Created by Gasper Rebernak on 15/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "ViewController.h"
#import "YesGraphSDK/YesGraphSDK.h"

@interface ViewController () <YSGShareSheetDelegate>

@end

@implementation ViewController {
    YSGTheme *theme;
}

- (void)viewDidLoad
{
    theme = [YSGTheme new];
    theme.baseColor = [UIColor redColor];

    [self styleView];
    
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
    shareController.baseColor = theme.baseColor;
    
    // OPTIONAL
    
    //
    // set referralURL if you have one, leave blank if you don't
    shareController.referralURL = @"hellosunschein.com/dkjh34";
    //
    
    //
    // PRESENT MODALLY - un/comment next 2 lines
    //
    
    //  [self presentViewController:shareController animated:YES completion:nil];
    
    //
    // PRESENT ON NAVIGATION STACK - un/comment next 1 line
    //
    
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

- (void) styleView {
    
    self.additionalInfoLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
    self.introTextField.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18];
    self.shareButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
    
    self.shareButton.layer.cornerRadius = self.shareButton.frame.size.height/10;
}

@end
