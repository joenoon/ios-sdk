//
//  YSGDrawingConstants.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 07/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

/*!
 *  Defines drawable code block, called in drawRect: method.
 *
 *  @param frame for drawing to be drawn in
 *  @param additional parameters such as colors
 */
typedef void (^YSGDrawableBlock)(CGRect frame, NSDictionary *parameters);

extern NSString *const YSGDrawingForegroundColorKey;
