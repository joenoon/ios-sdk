//
//  YSGViewController.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 15/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import UIKit;

#import "YSGStyling.h"
#import "YSGTheme.h"

/*!
 *  Base view controller for YesGraph UI, implements some basic styling code.
 */
@interface YSGViewController : UIViewController <YSGStyling>

@property (nullable, nonatomic, strong) YSGTheme *theme;

@end
