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
    return [UIColor colorWithRed:0.9 green:0.11 blue:0.17 alpha:1];
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
    return [UIColor whiteColor];
}

+ (nonnull UIColor *)defaultTextColor
{
    return [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1];
}

+ (nonnull const NSString *)defaultFontFamily
{
    return [UIFont systemFontOfSize:12].familyName;
}

+ (CGFloat)defaultShareButtonFontSize
{
    return 36.f;
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
