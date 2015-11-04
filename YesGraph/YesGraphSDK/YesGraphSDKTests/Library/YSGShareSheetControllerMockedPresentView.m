//
//  YSGShareSheetControllerMockedPresentView.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 27/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareSheetControllerMockedPresentView.h"

@implementation YSGShareSheetControllerMockedPresentView

- (instancetype)initEmpty
{
    self = [super init];
    return self;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    self.currentPresentingViewController = viewControllerToPresent;
    if (self.triggerOnPresent)
    {
        self.triggerOnPresent();
    }
}

- (void)shareSheetController:(YSGShareSheetController *)shareSheetController didShareToService:(YSGShareService *)service userInfo:(nullable NSDictionary <NSString *, id> *)userInfo error:(nullable NSError *)error
{
    if (self.triggerOnDidShare)
    {
        self.triggerOnDidShare();
    }
}

@end
