//
//  YSGAddressBookMockController.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 03/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGAddressBookMockController.h"

@implementation YSGAddressBookMockController

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

@end
