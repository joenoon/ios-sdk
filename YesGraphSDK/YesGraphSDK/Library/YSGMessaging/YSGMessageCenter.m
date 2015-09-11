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
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"YesGraph" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        //
        // Load button titles
        //
        
        if (userInfo[YSGMessageAlertButtonArrayKey] && [userInfo[YSGMessageAlertButtonArrayKey] isKindOfClass:[NSArray class]])
        {
            for (id object in userInfo[YSGMessageAlertButtonArrayKey])
            {
                if ([object isKindOfClass:[NSString class]])
                {
                    UIAlertAction* action = [UIAlertAction actionWithTitle:object style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [alertController addAction:action];
                }
                else if ([object isKindOfClass:[UIAlertAction class]])
                {
                    [alertController addAction:object];
                }
            }
        }
        
        [alertController ysg_show];
    }
}

- (void)sendError:(NSError *)error
{
    YSG_LERROR(error);
    
    if (self.errorHandler)
    {
        self.errorHandler (error);
    }
}

@end
