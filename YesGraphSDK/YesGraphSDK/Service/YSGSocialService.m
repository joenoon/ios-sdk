//
//  YSGSocialService.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 26/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Social;

#import "YSGShareSheetController.h"

#import "YSGSocialService.h"

@implementation YSGSocialService

- (NSString *)serviceType
{
    return @"Unknown";
}

- (void)triggerServiceWithViewController:(nonnull YSGShareSheetController *)viewController
{
    if ([SLComposeViewController isAvailableForServiceType:self.serviceType])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:self.serviceType];
        
        [controller setInitialText:@"First post from my YesGraph SDK"];
        
        __weak UIViewController *weakController = controller;
        
        controller.completionHandler = ^(SLComposeViewControllerResult result)
        {
            [weakController dismissViewControllerAnimated:YES completion:nil];
        };
        
        [viewController presentViewController:controller animated:YES completion:Nil];
    }
}

@end
