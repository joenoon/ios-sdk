//
//  YSGAddressBookMockController.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 03/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import UIKit;

typedef void (^TriggerOnPresentCallback)(void);

@interface YSGAddressBookMockController : UINavigationController

@property (strong, nonatomic) UIViewController * currentPresentingViewController;
@property (strong, nonatomic) TriggerOnPresentCallback triggerOnPresent;

- (instancetype)initEmpty;

@end
