//
//  WelcomeViewController.h
//  Example
//
//  Created by Miran Lesjak on 27/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *sectionOneHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionOneAdditionalInfoLabel;

@property (weak, nonatomic) IBOutlet UIButton *sectionOneTryButton;

@property (weak, nonatomic) IBOutlet UIWebView *sectionFourWebView;


@end
