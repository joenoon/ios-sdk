//
//  YSGShareAddressBookTheme.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 17/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface YSGShareAddressBookTheme : NSObject

NS_ASSUME_NONNULL_BEGIN

/*!
 *  Background of the address book view
 *  @discussion: Default: nil (system)
 *
 */

@property (nullable, nonatomic, strong) UIColor *viewBackground;

/*!
 *  Background of the address book cells (when not selected)
 *  @discussion: Default: White
 *
 */

@property (nullable, nonatomic, strong) UIColor *cellBackground;

/*!
 *  Background of the address book cells (when selected)
 *  @discussion: Default: nil (system)
 *
 */

@property (nullable, nonatomic, strong) UIColor *cellSelectedBackground;

/*!
 *  Background of the address book section headers
 *  @discussion: Default: nil (system)
 *
 */

@property (nullable, nonatomic, strong) UIColor *sectionBackground;

/*!
 *  Size of the cell label font
 *  @discussion: Default: 17
 *
 */

@property (nonatomic) CGFloat cellFontSize;

/*!
 *  Size of the cell detail label font
 *  @discussion: Default: 12
 *
 */

@property (nonatomic) CGFloat cellDetailFontSize;

/*!
 *  Size of the section label font
 *  @discussion: Default: 17
 *
 */

@property (nonatomic) CGFloat sectionFontSize;

NS_ASSUME_NONNULL_END

@end
