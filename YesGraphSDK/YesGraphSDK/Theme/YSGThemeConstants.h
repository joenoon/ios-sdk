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

@interface YSGThemeConstants : NSObject 

/*!
 *  Default overall color of the theme  
 *  @Discussion: Default: r: 0.9, g: 0.11, b: 0.17
 *
 */
+ (nonnull UIColor *)defaultMainColor;

/*!
 *  Default color for the twitter share button
 *  @Discussion: Default: r: 0.31, g: 0.67, b: 0.95
 *
 */
+ (nonnull UIColor *)defaultTwitterColor;

/*!
 *  Default overall color of the theme  
 *  @Discussion: Default: r: 0.28, g: 0.38, b: 64
 *
 */
+ (nonnull UIColor *)defaultFacebookColor;

/*!
 *  Default background view color  
 *  @Discussion: Default: White color
 *
 */
+ (nonnull UIColor *)defaultBackgroundColor;

/*!
 *  Default text color  
 *  @Discussion: Default: r: 0.33, g: 0.33, b:0.33
 *
 */
+ (nonnull UIColor *)defaultTextColor;

// Font settings

/*!
 *  Default font family
 *  @Discussion: Default: System, size 12
 *
 */
+ (nonnull const NSString * const)defaultFontFamily;

/*!
 *  Default share button cell size
 *  @Discussion: Default: 36.0f
 *
 */
+ (CGFloat)defaultShareButtonFontSize;

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
