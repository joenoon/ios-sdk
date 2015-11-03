//
//  YSGMockedMailComposeViewController.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 04/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import MessageUI;

@interface YSGMockedMailComposeViewController : MFMailComposeViewController

+ (void)setCanSendMail:(BOOL)canSend;

+ (BOOL)canSendMail;

@end
