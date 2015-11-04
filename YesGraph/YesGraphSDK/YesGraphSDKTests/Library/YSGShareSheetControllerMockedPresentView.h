//
//  YSGShareSheetControllerMockedPresentView.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 27/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <YesGraphSDK/YesGraphSDK.h>

typedef void (^TriggerOnCallCallback)(void);

@interface YSGShareSheetControllerMockedPresentView : YSGShareSheetController<YSGShareSheetDelegate, YSGShareServiceDelegate>

@property (strong, nonatomic) UIViewController * currentPresentingViewController;
@property (strong, nonatomic) TriggerOnCallCallback triggerOnPresent;
@property (strong, nonatomic) TriggerOnCallCallback triggerOnDidShare;

- (instancetype)initEmpty;

@end
