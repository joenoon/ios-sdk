//
//  ViewController.h
//  Example
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import UIKit;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *introTextField;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIView *additionalNotesView;
@property (weak, nonatomic) IBOutlet UILabel *additionalInfoLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
