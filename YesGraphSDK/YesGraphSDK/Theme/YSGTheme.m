//
//  YSGTheme.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 19/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGTheme.h"
#import "YSGThemeConstants.h"

@implementation YSGTheme

- (instancetype)init
{
    if ((self = [super init]))
    {
        // set default color values
        self.mainColor = [YSGThemeConstants defaultMainColor]; 
        self.twitterColor = [YSGThemeConstants defaultTwitterColor]; 
        self.facebookColor = [YSGThemeConstants defaultFacebookColor];
        self.textColor = [YSGThemeConstants defaultTextColor]; 
        self.baseColor = [YSGThemeConstants defaultBackgroundColor];
        // set default font details
        self.fontFamily = [YSGThemeConstants defaultFontFamily];
        self.shareButtonLabelFontSize = [YSGThemeConstants defaultShareButtonFontSize]; 
        self.shareButtonLabelTextAlignment = [YSGThemeConstants defaultTextAlignment]; 
        self.shareLabelTextAlignment =  [YSGThemeConstants defaultTextAlignment]; 
        // set default share button shape
        self.shareButtonShape = [YSGThemeConstants defaultShareButtonShape];
        // set default share button alpha factors for both states
        self.shareButtonFadeFactors = [YSGThemeConstants defaultShareButtonAlphaFactors]; 
        self.shareAddressBookTheme = [YSGShareAddressBookTheme new];
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
