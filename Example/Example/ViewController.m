//
//  ViewController.m
//  Example
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

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
    theme.shareAddressBookTheme.sectionBackground = [[UIColor redColor] colorWithAlphaComponent:0.38f];
    
    if ([YesGraph shared].userId)
    {
        [self setYSGclientKey:[YesGraph shared].userId];
    }
    
    // for parse backend example, we set a user id '1234' if there is none set in YesGraph class
    else
    {
        [self setYSGclientKey:@"1234"];
    }
    
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
    // PRESENT MODALLY - un/comment next 3 lines
    //
    
       [self presentViewController:shareController animated:YES completion:nil];
    
    //
    // PRESENT ON NAVIGATION STACK - un/comment next 1 line
    //
    
     //  [self.navigationController pushViewController:shareController animated:YES];
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

- (void)setYSGclientKey:(NSString *)userId
{
    [PFCloud callFunctionInBackground:@"YGgetClientKey"
                       withParameters:[[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", nil]
                                block:^(NSString *response, NSError *error) {
                                    if (!error)
                                    {
                                        NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
                                        
                                        NSError *jsonSerializationError;
                                        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers)error:&jsonSerializationError];
                                        if (jsonSerializationError)
                                        {
                                            NSLog(@"Json serizalization error: %@", jsonSerializationError.description);
                                        }
                                        
                                        NSString *YSGclientKey = [jsonObject objectForKey:@"client_key"];
                                        if (YSGclientKey)
                                        {
                                            NSLog(@"Yes Graph client key: %@", YSGclientKey);
                                            [[YesGraph shared] configureWithClientKey:YSGclientKey];
                                        }
                                    }
                                    else
                                    {
                                        NSLog(@"Error:%@", error.description);
                                    }
                                }];
}

@end
