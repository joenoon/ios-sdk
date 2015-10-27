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
}

@end
