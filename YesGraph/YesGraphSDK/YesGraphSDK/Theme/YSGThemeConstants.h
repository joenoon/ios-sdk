//
//  YSGConstants.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 28/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import UIKit;

#import "YSGShareCellShapeEnum.h"
#import "YSGShareAddressBookTheme.h"
#import "YSGShareButtonFadeFactors.h"

// Colors

NS_ASSUME_NONNULL_BEGIN

@interface YSGThemeConstants : NSObject 

/*!
 *  Default overall color of the theme  
 *  @Discussion: Default: r: 0.0, g: 0.46, b: 0.75
 *
 */
+ (UIColor *)defaultMainColor;

/*!
 *  Default color for the twitter share button
 *  @Discussion: Default: r: 0.31, g: 0.67, b: 0.95
 *
 */
+ (UIColor *)defaultTwitterColor;

/*!
 *  Default overall color of the theme  
 *  @Discussion: Default: r: 0.28, g: 0.38, b: 64
 *
 */
+ (UIColor *)defaultFacebookColor;

/*!
 *  Default background view color  
 *  @Discussion: Default: White color
 *
 */
+ (UIColor *)defaultBackgroundColor;

/*!
 *  Default text color  
 *  @Discussion: Default: r: 0.33, g: 0.33, b:0.33
 *
 */
+ (UIColor *)defaultTextColor;

/*!
 *  Default referral text color
 *  @Discussion: Default: r: 0.33, g: 0.33, b:0.33
 *
 */
+ (UIColor *)defaultReferralTextColor;

/*!
 *  Default referral button text color
 *  @Discussion: Default: r: 0.0, g: 0.46, b: 0.75
 *
 */

+ (UIColor *)defaultReferralButtonColor;

/*!
 *  Default referral banner color
 *  @Discussion: Default: white
 *
 */
+ (UIColor *)defaultReferralBannerColor;

// Font settings

/*!
 *  Default font FAMILY
 *  @Discussion: Default: System, size 12
 *
 */
+ (NSString *)defaultFontFamily;

/*!
 *  Default text button font
 *  @Discussion: Default: Bold System, size 12
 *
 */
+ (UIFont *)defaultButtonFont;

/*!
 *  Default share button cell size
 *  @Discussion: Default: 60.0f
 *
 */
+ (CGFloat)defaultShareLabelFontSize;

/*!
 *  Default text alignment
 *  @Discussion: Default: Center
 *
 */
+ (NSTextAlignment)defaultTextAlignment;

// Share button

/*!
 *  Default share button shape
 *  @Discussion: Default: Circle
 *
 */
+ (YSGShareSheetServiceCellShape)defaultShareButtonShape;

/*!
 *  Default alpha factors for the share button state animations
 *  @Discussion: Default: Unfaded state: 1.0f, Faded state: 0.8f
 *
 */
+ (YSGShareButtonFadeFactors)defaultShareButtonAlphaFactors;

@end

NS_ASSUME_NONNULL_END
