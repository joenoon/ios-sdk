//
//  YSGShareSheetControllerMockedPresentView.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 27/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <YesGraphSDK/YesGraphSDK.h>

typedef void (^TriggerOnPresentCallback)(void);

@interface YSGShareSheetControllerMockedPresentView : YSGShareSheetController

@property (strong, nonatomic) UIViewController * currentPresentingViewController;
@property (strong, nonatomic) TriggerOnPresentCallback triggerOnPresent;

- (instancetype)initEmpty;

@end
