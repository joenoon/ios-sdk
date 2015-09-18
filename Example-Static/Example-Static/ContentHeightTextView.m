//
//  ContentHeightTextView.m
//  Example-Static
//
//  Created by Miha Gresak on 18/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "ContentHeightTextView.h"

@implementation ContentHeightTextView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, FLT_MAX)];
    
    if (!self.heightConstraint) {
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0f constant:size.height];
        [self addConstraint:self.heightConstraint];
    }
    
    self.heightConstraint.constant = size.height;
    
    [super layoutSubviews];
}

@end
