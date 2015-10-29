//
//  YSGMessageCenter+RemoveAlertController.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 27/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGMessageCenter.h"
#import "YSGUIAlertController+YSGDisplayOverride.h"

@interface YSGMessageCenter (RemoveAlertController)

@property (nonatomic, strong) UIAlertController *alertController;

- (void)removeAlertController;

@end
