//
//  YSGDrawableView.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 07/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGDrawableView.h"


@implementation YSGDrawableView

- (void)drawRect:(CGRect)rect
{
    if (self.drawingBlock)
    {
        self.drawingBlock(rect, nil);
    }
}

@end
