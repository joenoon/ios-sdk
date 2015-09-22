//
//  YSGTheme.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 19/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGTheme.h"

@implementation YSGTheme

- (instancetype)init
{
    if ((self = [super init]))
    {
        // set default color values
        self.mainColor = [UIColor colorWithRed:0.9 green:0.11 blue:0.17 alpha:1];
        self.twitterColor = [UIColor colorWithRed:0.31 green:0.67 blue:0.95 alpha:1];
        self.facebookColor = [UIColor colorWithRed:0.28 green:0.38 blue:0.64 alpha:1];
        self.textColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1];
        self.baseColor = [UIColor whiteColor];
        // set default font details
        self.fontFamily = @"Helvetica";
        self.shareButtonLabelFontSize = 36.f;
        self.shareButtonLabelTextAlignment = NSTextAlignmentCenter;
        self.shareLabelTextAlignment = NSTextAlignmentCenter;
        // set default share button shape
        self.shareButtonShape = YSGShareSheetServiceCellShapeCircle;
        // set default share button alpha factors for both states
        self.shareButtonFadeFactors = (YSGShareButtonFadeFactors)
        {
            .AlphaFadeFactor = 0.8f,
            .AlphaUnfadeFactor = 1.f
        };
    }
    return self;
}

// overriden setter method so we can clamp the values between 0.f and 1.f
- (void)setShareButtonFadeFactors:(YSGShareButtonFadeFactors)shareButtonFadeFactors
{
    unsigned short components = sizeof(shareButtonFadeFactors.AlphaPair) / sizeof(shareButtonFadeFactors.AlphaPair[0]);
    for (unsigned short i = 0; i < components; ++i)
    {
        CGFloat c = shareButtonFadeFactors.AlphaPair[i];
        if (c > 1.f)
        {
            c = 1.f;
        }
        else if (c < 0.f)
        {
            c = 0.f;
        }
        _shareButtonFadeFactors.AlphaPair[i] = c;
    }
}

- (void)setShareButtonFadeFactorsWithFadeAlpha:(CGFloat)fadedAlpha andUnfadeAlpha:(CGFloat)unfadedAlpha
{
    YSGShareButtonFadeFactors factors =
    {
        .AlphaFadeFactor = fadedAlpha,
        .AlphaUnfadeFactor = unfadedAlpha
    };
    [self setShareButtonFadeFactors:factors];
}

@end
