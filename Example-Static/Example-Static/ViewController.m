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

@property (nullable, nonatomic, strong) YSGTheme *theme;

@end

@implementation ViewController {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.theme = [YSGTheme new];
    self.theme.baseColor = [UIColor redColor];
}

- (IBAction)shareButtonTap:(UIButton *)sender
{
    if ([YesGraph shared].isConfigured) {
        [self presentYSGShareSheetController];
    }
    else
    {
        [self.shareButton setTitle:@"  Configuring YesGraph...  " forState:UIControlStateNormal];
        self.shareButton.enabled = NO;
        
        [self configureYesGraphWithCompletion:^(BOOL success, NSError *error) {
            [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
            self.shareButton.enabled = YES;
            if (success)
            {
                [self presentYSGShareSheetController];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"YesGraphSDK must be configured before presenting ShareSheet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            
        }];
    }
}

- (void)presentYSGShareSheetController
{
    
    [YesGraph shared].theme = self.theme;
    [YesGraph shared].numberOfSuggestions = 5;
    [YesGraph shared].contactAccessPromptMessage = @"Share contacts with Example to invite friends?";
    
    YSGShareSheetController *shareController  = [[YesGraph shared] shareSheetControllerForAllServicesWithDelegate:self];
    
    // OPTIONAL
    
    //
    // set referralURL if you have one
    shareController.referralURL = @"";
    
    
    //
    // PRESENT MODALLY
    //
    
    //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:shareController];
    //[self presentViewController:navController animated:YES completion:nil];
    
    //
    // PRESENT ON NAVIGATION STACK
    //
    
    [self.navigationController pushViewController:shareController animated:YES];
}

- (void)configureYesGraphWithCompletion:(void (^)(BOOL success, NSError *error))completion
{
    if (![YesGraph shared].userId.length) {
        [[YesGraph shared] configureWithUserId:[YSGUtility randomUserId]];
    }
    //TODO: backend call example
    
    if (completion) {
        completion(NO, nil);
    }
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
