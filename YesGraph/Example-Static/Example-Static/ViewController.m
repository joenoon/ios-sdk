//
//  ViewController.m
//  Example-Static
//
//  Created by Gasper Rebernak on 15/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "ViewController.h"
#import <YesGraphSDK/YesGraphSDK.h>
#import <objc/runtime.h>

@import Social;

@interface ViewController () <YSGShareSheetDelegate, UIWebViewDelegate>

@property (nullable, nonatomic, strong) YSGTheme *theme;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Home";
    
    self.theme = [YSGTheme new];
    
    [self setWebViewContent];
    
    self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)setWebViewContent
{
    NSString* htmlString= @"<style>a:link {color:#487EA8; text-decoration:none}\
    a:visited {color:#487EA8; text-decoration:none}\
    </style><body style=\"font-family: 'Open Sans'; font-size: 15px; margin: 0; background-color: #1F2124; text-align: left; color: #C4C6C7;\">It’s open source. <a href=\"https://github.com/YesGraph/ios-sdk\">Find it on Github here</a>. <br><br>\
    If you use CocoaPods, you can integrate with: pod 'YesGraph-iOS-SDK' Or with Carthage: github \"YesGraph/ios-sdk\" <br><br>\
    We have example applications using <a href=\"https://github.com/YesGraph/ios-sdk#example-applications\">(Parse, Swift, and Objective-C)</a> on Github.<br><br>\
    You’ll need a YesGraph account. <a href=\"https://www.yesgraph.com/\">Sign up and create an app to configure the SDK</a>.<br><br>\
    The documentation online is extensive, but if you have any trouble, email <a href=\"mailto:support@yesgraph.com\">support@yesgraph.com</a>.</body>";
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (IBAction)shareButtonTap:(UIButton *)sender
{
    if ([YesGraph shared].isConfigured)
    {
        [self presentShareSheetController];
    }
    else
    {
        [self.shareButton setTitle:@"  Configuring YesGraph...  " forState:UIControlStateNormal];
        self.shareButton.enabled = NO;
        
        [self configureYesGraphWithCompletion:^(BOOL success, NSError *error)
        {
            [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
            self.shareButton.enabled = YES;
            
            if (success)
            {
                [self presentShareSheetController];
            }
            else
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"YesGraphSDK must be configured before presenting ShareSheet" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

- (void)presentShareSheetController
{
    [YesGraph shared].theme = self.theme;
    [YesGraph shared].numberOfSuggestions = 5;
    [YesGraph shared].contactAccessPromptMessage = @"Share contacts with Example to invite friends?";
    
    YSGShareSheetController *shareController  = [[YesGraph shared] shareSheetControllerForAllServicesWithDelegate:self];
    
    // OPTIONAL
    
    // set referralURL if you have one
    shareController.referralURL = @"your-site.com/referral";
    
    //
    // PRESENT MODALLY - un/comment next 2 lines
    //
    //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:shareController];
    //[self presentViewController:navController animated:YES completion:nil];
    
    //
    // PRESENT ON NAVIGATION STACK - un/comment next 1 line
    //
    [self.navigationController pushViewController:shareController animated:YES];
}

- (void)configureYesGraphWithCompletion:(void (^)(BOOL success, NSError *error))completion
{
    if (![YesGraph shared].userId.length)
    {
        [[YesGraph shared] configureWithUserId:[YSGUtility randomUserId]];
    }
    
    //
    // Client key should be retrieved from your trusted backend.
    //
    [[YesGraph shared] configureWithClientKey:@""];
    
    if (completion)
    {
        if ([YesGraph shared].isConfigured)
        {
            completion(YES, nil);
        }
        else
        {
            completion(NO, nil);
        }
    }
}

#pragma - mark YSGShareSheetControllerDelegate

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
        if ([userInfo valueForKey:YSGInviteEmailContactsKey]) {
            return @{ YSGShareSheetMessageKey : @"This message will be posted to Email." };
        }
        else {
            return @{ YSGShareSheetMessageKey : @"This message will be posted to SMS." };
        }
    }
    
    return @{ YSGShareSheetMessageKey : @"" };
}

#pragma mark - WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
