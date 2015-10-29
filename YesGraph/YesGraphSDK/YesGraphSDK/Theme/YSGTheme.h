//
//  YSGTheme.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 19/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "YSGThemeConstants.h"
#import "YSGThemeConstants+AddressBook.h"

#import "YSGShareCellShapeEnum.h"
#import "YSGShareAddressBookTheme.h"
#import "YSGShareButtonFadeFactors.h"
#import "YSGStyling.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 *  Use the theme to stylize YesGraph UI
 */
@interface YSGTheme : NSObject


/*!
 *  Main color of the Share UI
 *
 *  @discussion: Default: Red color
 */
@property (nonatomic, strong) UIColor *mainColor;

/*!
 *  Official Twitter color
 */
@property (nonatomic, strong) UIColor *twitterColor;

/*!
 *  Official Facebook color
 */
@property (nonatomic, strong) UIColor *facebookColor;

/*!
 *  Main text color of the Share UI
 */
@property (nonatomic, strong) UIColor *textColor;

/*!
 *  Share sheet view background color
 *  @discussion: Default: White color
 *
 */
@property (nonatomic, strong) UIColor *baseColor;

/*!
 *  Font family of the Share UI
 *
 *  @discussion: Default: System font
 */
@property (nonatomic, copy) NSString *fontFamily;

/*!
 *  Share text font size
 * 
 *  @discussion: Default: 60 points
 */
@property (nonatomic) CGFloat shareLabelFontSize;

/*!
 *  Share text alignment
 *  @discussion: Default: Center
 *
 */
@property (nonatomic) NSTextAlignment shareLabelTextAlignment;

/*!
 *  Shape of the share button
 *  @discussion: Default: Circle shape
 *
 */
@property (nonatomic) YSGShareSheetServiceCellShape shareButtonShape;

/*!
 *  A two-component alpha factor that determines the alpha value for faded / unfaded background 
 *  color of the share button cell
 *  @discussion: Default: 0.8, 1.0
 *
 */
@property (nonatomic) YSGShareButtonFadeFactors shareButtonFadeFactors;

/*!
 *  A convinience method for setting share button fade components
 *  @param fadedAlpha   a floating point alpha value (between 0 and 1) that will be applied to the button
 *  background color when it's in a faded (triggered) state
 *
 *  @param unfadedAlpha a floating point alpha value (between 0 and 1) that will be applied to the button
 *  background color when in default state
 */
- (void)setShareButtonFadeFactorsWithFadeAlpha:(CGFloat)fadedAlpha andUnfadeAlpha:(CGFloat)unfadedAlpha;

/*!
 *  Address book theme, allows settings cell / section colors and font sizes
 *  @discussion: Default: nil (system)
 *
 */
@property (nullable, nonatomic, strong) YSGShareAddressBookTheme *shareAddressBookTheme;

@end

NS_ASSUME_NONNULL_END
