//
//  YSGConstants.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 28/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGThemeConstants.h"

@implementation YSGThemeConstants

+ (nonnull UIColor *)defaultMainColor
{
    return [UIColor colorWithRed:0.00 green:0.47 blue:0.74 alpha:1];
}

+ (nonnull UIColor *)defaultTwitterColor
{
    return [UIColor colorWithRed:0.31 green:0.67 blue:0.95 alpha:1];
}

+ (nonnull UIColor *)defaultFacebookColor
{
    return [UIColor colorWithRed:0.28 green:0.38 blue:0.64 alpha:1];
}

+ (nonnull UIColor *)defaultBackgroundColor
{
    return [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
}

+ (nonnull UIColor *)defaultTextColor
{
    return [UIColor colorWithRed:0.10 green:0.11 blue:0.13 alpha:1];
}

+ (nonnull NSString *)defaultFontFamily
{
    return [UIFont systemFontOfSize:12].familyName;
}

+ (CGFloat)defaultShareLabelFontSize
{
    return 60.f;
}

+ (NSTextAlignment)defaultTextAlignment
{
    return NSTextAlignmentCenter;
}

+ (YSGShareSheetServiceCellShape)defaultShareButtonShape
{
    return YSGShareSheetServiceCellShapeCircle;
}

+ (YSGShareButtonFadeFactors)defaultShareButtonAlphaFactors
{
    return (YSGShareButtonFadeFactors)
    {
        .AlphaFadeFactor = 0.8f,
        .AlphaUnfadeFactor = 1.f
    };
}

@end
