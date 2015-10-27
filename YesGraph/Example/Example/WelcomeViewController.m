//
//  WelcomeViewController.m
//  Example
//
//  Created by Miran Lesjak on 27/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self styleView];
    [self insertContent];
}

- (void)styleView
{
    self.sectionOneHeaderLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:24];
    self.sectionOneAdditionalInfoLabel.font = [UIFont fontWithName:@"OpenSans" size:18];
    self.sectionOneTryButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
}

- (void)insertContent
{
    NSString* htmlString= @"It’s open source. [Find it on Github here.](https://github.com/YesGraph/ios-sdk)\
                            If you use CocoaPods, you can integrate with: pod 'YesGraph-iOS-SDK' Or with Carthage: github \"YesGraph/ios-sdk\"\
                            We have example applications using (Parse, Swift, and Objective-C](https://github.com/YesGraph/ios-sdk#example-applications) on Github. You’ll need a YesGraph account. [Sign up and create an app to configure the SDK.](https://www.yesgraph.com/) The documentation online is extensive, but if you have any trouble, email [support@yesgraph.com](mailto:support@yesgraph.com).";
    [self.sectionFourWebView loadHTMLString:htmlString baseURL:nil];
}

@end
