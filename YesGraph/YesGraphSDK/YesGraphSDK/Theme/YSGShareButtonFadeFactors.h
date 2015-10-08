//
//  YSGShareButtonFadeFactors.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 28/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

typedef union
{
    struct
    {
        CGFloat AlphaFadeFactor;
        CGFloat AlphaUnfadeFactor;
    };
    CGFloat AlphaPair[2];
} YSGShareButtonFadeFactors;
