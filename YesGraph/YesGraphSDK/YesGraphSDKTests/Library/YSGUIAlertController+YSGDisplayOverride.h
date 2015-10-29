//
//  YSGUIAlertController+YSGDisplayOverride.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 27/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "UIAlertController+YSGDisplay.h"

typedef void (^ShowTriggered)(BOOL withAnimationArgument, UIAlertController *controller);

@interface UIAlertController (YSGDisplayOverride)

+ (void)setYsgShowWasTriggered:(ShowTriggered)ysgShowWasTriggered;

@end
