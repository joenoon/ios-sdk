//
//  YSGMockedMessageComposeViewController.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 03/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import MessageUI;

typedef void (^TriggerOnDismissWithCompletion)(BOOL hasCompletion);

@interface YSGMockedMessageComposeViewController : MFMessageComposeViewController

@property (strong, nonatomic) TriggerOnDismissWithCompletion triggeredOnDismissed;

+ (void)setCanSendText:(BOOL)canSend;


@end
