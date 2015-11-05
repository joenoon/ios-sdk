//
//  YSGShareSheetControllerMockedPresentView.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 27/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <YesGraphSDK/YesGraphSDK.h>

typedef void (^TriggerOnCallCallback)(void);
typedef void (^TriggeredOnCallbackWithError)(NSError *error);

@interface YSGShareSheetControllerMockedPresentView : YSGShareSheetController<YSGShareSheetDelegate, YSGShareServiceDelegate>

@property (strong, nonatomic) UIViewController * currentPresentingViewController;
@property (strong, nonatomic) TriggerOnCallCallback triggerOnPresent;
@property (strong, nonatomic) TriggerOnCallCallback triggerOnDidShare;
@property (strong, nonatomic) TriggeredOnCallbackWithError triggerOnDidShareUserInfo;

- (instancetype)initEmpty;

@end
