//
//  ViewController.m
//  Example
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "ViewController.h"
#import "objc/runtime.h"

@import YesGraphSDK;
@import Social;

@interface ViewController () <YSGShareSheetDelegate>

@property (nullable, nonatomic, strong) YSGTheme *theme;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Welcome";
    
    self.theme = [YSGTheme new];
    
    [self styleView];
    
    [self nastyHacksForUITests];
}

- (BOOL)isAvailableTwit:(NSString *)empty
{
    return [empty isEqualToString:SLServiceTypeTwitter];
}

- (BOOL)isAvailableBoth:(NSString *)empty
{
    return YES;
}

- (BOOL)isAvailableNone:(NSString *)empty
{
    return NO;
}

- (void)setString:(NSString *)str
{
    NSLog(@"Set string called with %@ from %s", str, __FILE__);
}

- (void)nastyHacksForUITests
{
    NSArray *cmdArgs = [NSProcessInfo processInfo].arguments;
    for (NSUInteger index = 1; index < cmdArgs.count; ++index)
    {
        SEL originalSel = nil, swizSel = nil;
        Class replClass;
        Method original = nil, swiz = nil;
        
        if([cmdArgs[index] isEqualToString:@"mocked_pasteboard"] == YES)
        {
            originalSel = @selector(setString:);
            swizSel = @selector(setString:);
            replClass = [[UIPasteboard generalPasteboard] class];
            original = class_getInstanceMethod(replClass, originalSel);
            swiz = class_getInstanceMethod([self class], swizSel);
        }
        else if ([cmdArgs[index] isEqualToString:@"mocked_twitter"]  == YES || [cmdArgs[index] isEqualToString:@"mocked_both"]  == YES || [cmdArgs[index] isEqualToString:@"mocked_contacts"] == YES)
        {
            replClass = [SLComposeViewController class];
            originalSel = @selector(isAvailableForServiceType:);
            swizSel = ([cmdArgs[index] isEqualToString:@"mocked_twitter"]  == YES ?
                       @selector(isAvailableTwit:) :
                       ([cmdArgs[index] isEqualToString:@"mocked_contacts"]) ?
                       @selector(isAvailableNone:) :
                       @selector(isAvailableBoth:));
            original = class_getClassMethod(replClass, originalSel);
            swiz = class_getInstanceMethod([self class], swizSel);
        }
        assert(originalSel && swizSel && original && swiz);
        
        IMP swizImp = method_getImplementation(swiz);
        method_setImplementation(original, swizImp);
    }
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"YesGraphSDK must be configured before presenting ShareSheet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
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
    [[YesGraph shared] configureWithClientKey:@"live-WzEsMCwibGVhIl0.CQCE_g.DMOwr3YUg2zwiuPMJnInVa1D3ZI"];
    
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

- (void)styleView
{
    self.additionalInfoLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
    self.introTextField.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
    self.shareButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
    
    self.shareButton.layer.cornerRadius = self.shareButton.frame.size.height/10;
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
        return @{ YSGShareSheetMessageKey : @"This message will be posted to SMS." };
        //return @"This message will be posted to Email.";
    }
    
    return @{ YSGShareSheetMessageKey : @"" };
}

@end
