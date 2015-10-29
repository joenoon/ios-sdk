//
//  YSGMessageCenter+RemoveAlertController.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 27/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGMessageCenter+RemoveAlertController.h"

@implementation YSGMessageCenter (RemoveAlertController)

@dynamic alertController;

- (void)removeAlertController
{
    self.alertController = nil;
}

@end
