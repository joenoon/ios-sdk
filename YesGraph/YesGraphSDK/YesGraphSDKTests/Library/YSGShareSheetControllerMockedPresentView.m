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

- (void)shareService:(YSGShareService *)shareService didShareWithUserInfo:(NSDictionary<NSString *,id> *)userInfo error:(NSError *)error
{
    if (self.triggerOnDidShare)
    {
        self.triggerOnDidShare();
    }
    if (self.triggerOnDidShareUserInfo)
    {
        self.triggerOnDidShareUserInfo(error);
    }
}

@end
