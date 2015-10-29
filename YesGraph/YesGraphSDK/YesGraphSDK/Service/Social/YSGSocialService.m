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

- (BOOL)isAvailable
{
    return [SLComposeViewController isAvailableForServiceType:self.serviceType];
}

- (NSString *)serviceType
{
    return @"Unknown";
}

- (void)triggerServiceWithViewController:(nonnull YSGShareSheetController *)viewController
{
    if ([self isAvailable])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:self.serviceType];
        
        NSString *message = nil;
        
        if ([viewController.delegate respondsToSelector:@selector(shareSheetController:messageForService:userInfo:)])
        {
            NSDictionary *info = [viewController.delegate shareSheetController:viewController messageForService:self userInfo:nil];
            message = info[YSGShareSheetMessageKey];
        }
        
        if (message)
        {
            [controller setInitialText:message];
        }
        
        __weak UIViewController *weakController = controller;
        
        controller.completionHandler = ^(SLComposeViewControllerResult result)
        {
            [weakController dismissViewControllerAnimated:YES completion:nil];
        };
        
        [viewController presentViewController:controller animated:YES completion:Nil];
    }
}

@end
