//
//  YSGUIAlertController+YSGDisplayOverride.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 27/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGUIAlertController+YSGDisplayOverride.h"

static ShowTriggered _ysgShowWasTriggered;

@implementation UIAlertController (YSGDisplayOverride)

+ (void)setYsgShowWasTriggered:(ShowTriggered)ysgShowWasTriggered
{
    _ysgShowWasTriggered = ysgShowWasTriggered;
}

/*!
 *  Overrides the main show method, so it does not display the alert controller.
 *
 *  @param animated parameter
 */
- (void)ysg_show:(BOOL)animated
{
    if (_ysgShowWasTriggered)
    {
        __weak UIAlertController *controller = self;
        _ysgShowWasTriggered(animated, controller);
    }
}

@end
