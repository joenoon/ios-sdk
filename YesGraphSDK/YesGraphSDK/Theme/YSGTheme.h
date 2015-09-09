//
//  YSGTheme.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 19/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
@import UIKit;

/*!
 *  Use the theme to stylize YesGraph UI
 */
@interface YSGTheme : NSObject

/*!
 *  Main color of the Share UI
 *
 *  @discussion: Default: Red color
 */
@property (nonnull, nonatomic, strong) UIColor *mainColor;

/*!
 *  Official Twitter color
 */
@property (nonnull, nonatomic, strong) UIColor *twitterColor;

/*!
 *  Official Facebook color
 */
@property (nonnull, nonatomic, strong) UIColor *facebookColor;

/*!
 *  Main taxt color of the Share UI
 */
@property (nonnull, nonatomic, strong) UIColor *textColor;

/*!
 *  Font family of the Share UI
 *
 *  @discussion: Default: System font
 */
@property (nonnull, nonatomic, copy) NSString *fontFamily;

@end
