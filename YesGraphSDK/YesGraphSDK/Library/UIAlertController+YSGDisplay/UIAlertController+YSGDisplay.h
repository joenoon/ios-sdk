//
//  UIAlertController+YSGDisplay.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 25/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import UIKit;

/*!
 *  These utility methods are used to present alert controller anywhere in the app, similar to UIAlertView.
 */
@interface UIAlertController (YSGDisplay)

- (void)ysg_show;
- (void)ysg_show:(BOOL)animated;

@end
