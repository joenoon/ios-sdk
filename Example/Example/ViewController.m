//
//  ViewController.m
//  Example
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "ViewController.h"
#import "ParseBackend.h"

@import YesGraphSDK;

@interface ViewController () <YSGShareSheetDelegate>

@end

@implementation ViewController {
    YSGTheme *theme;
}

- (void)viewDidLoad
{
    theme = [YSGTheme new];
    theme.baseColor = [UIColor redColor];
    
    YesGraph *YG = [YesGraph shared];
    ParseBackend *parseBackend = [[ParseBackend alloc] init];
    
    if (YG.userId)
    {
        [parseBackend setYGclientKey:YG.userId];
    }
    
    // for parse backend example, we set a user id '1234' if there is none set in YesGraph class
    else
    {
        [parseBackend setYGclientKey:@"1234"];
    }
    
    NSLog(@"Yes Graph client key: %@", parseBackend.YGclientKey);
    
    [YG configureWithClientKey:parseBackend.YGclientKey];
    
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
    // set referralURL if you have one
    shareController.referralURL = @"hellosunschein.com/dkjh34";
    //
    
    //
    // PRESENT MODALLY
    //
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:shareController];
    
    //[self presentViewController:navController animated:YES completion:nil];
    
    //
    // PRESENT ON NAVIGATION STACK
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

@end
