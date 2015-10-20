//
//  YSGMessageCenter.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 09/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "UIAlertController+YSGDisplay.h"

#import "YSGLogging.h"

#import "YSGMessageCenter.h"

NSString *const YSGMessageAlertButtonArrayKey = @"YSGMessageAlertButtonArrayKey";

@interface YSGMessageCenter ()

@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation YSGMessageCenter

+ (instancetype)shared
{
    static id shared = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^
    {
      shared = [[self alloc] init];
    });

    return shared;
}

#pragma mark - Public Methods

- (void)sendMessage:(NSString *)message userInfo:(NSDictionary *)userInfo
{
    YSG_LINFO(message);

    if (self.messageHandler)
    {
        self.messageHandler(message, userInfo);
    }
    else
    {
        //
        // Only one will open.
        //
        if (self.alertController)
        {
            return;
        }

        self.alertController = [UIAlertController alertControllerWithTitle:@"YesGraph" message:message preferredStyle:UIAlertControllerStyleAlert];

        //
        // Load button titles
        //

        if (userInfo[YSGMessageAlertButtonArrayKey] && [userInfo[YSGMessageAlertButtonArrayKey] isKindOfClass:[NSArray class]])
        {
            for (id object in userInfo[YSGMessageAlertButtonArrayKey])
            {
                if ([object isKindOfClass:[NSString class]])
                {
                    UIAlertAction *action = [UIAlertAction actionWithTitle:object
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *_Nonnull action) {
                                                                     self.alertController = nil;
                                                                     [self.alertController dismissViewControllerAnimated:YES completion:nil];
                                                                   }];

                    [self.alertController addAction:action];
                }
                else if ([object isKindOfClass:[UIAlertAction class]])
                {
                    [self.alertController addAction:object];
                }
            }
        }
        else
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", @"Ok")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *_Nonnull action) {
                                                             [self.alertController dismissViewControllerAnimated:YES completion:nil];
                                                             self.alertController = nil;
                                                           }];

            [self.alertController addAction:action];
        }
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.alertController ysg_show];
        });
    }
}

- (void)sendError:(NSError *)error
{
    YSG_LERROR(error);

    if (self.errorHandler)
    {
        self.errorHandler(error);
    }
}

@end
