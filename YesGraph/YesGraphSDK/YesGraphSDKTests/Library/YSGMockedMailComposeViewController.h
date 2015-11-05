//
//  YSGMockedMailComposeViewController.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 04/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import MessageUI;

typedef void (^TriggerOnDismissWithCompletion)(BOOL hasCompletion);

@interface YSGMockedMailComposeViewController : MFMailComposeViewController

@property (strong, nonatomic) TriggerOnDismissWithCompletion triggeredOnDismissed;

- (instancetype)init;

+ (void)setCanSendMail:(BOOL)canSend;

@end
