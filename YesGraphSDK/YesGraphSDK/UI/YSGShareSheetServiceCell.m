//
//  YSGShareSheetServiceCell.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 20/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGShareSheetServiceCell.h"

@interface YSGShareSheetServiceCell ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation YSGShareSheetServiceCell

#pragma mark - Getters and Setters

- (void)setFont:(UIFont *)font {
    _font = font;
    self.textLabel.font = font;
}

- (void)setCellShape:(NSString *)cellShape {
    
    _cellShape = cellShape;
    
    if ([cellShape isEqualToString:@"Circle"]) {
        self.layer.cornerRadius = self.frame.size.height/2;
    }
    else if ([cellShape isEqualToString:@"Square"]) {
        self.layer.cornerRadius = 0;
    }
    else if ([cellShape isEqualToString:@"RoundedSquare"]) {
        self.layer.cornerRadius = self.frame.size.height/10;
    }
    else {
        self.layer.cornerRadius = self.frame.size.height/2;
    }
    
}

- (void)setIcon:(UIImage *)iconImage {
    _icon = iconImage;
    
    [self addImageViewWithIcon:_icon];
}

- (void)setIconWithString:(NSString *)iconImageString {
    _icon = [UIImage imageNamed:iconImageString];
    
    [self addImageViewWithIcon:_icon];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.textLabel.textColor = color;
}

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [UIColor grayColor];
    
    [self addSubview:self.textLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float cellHeight = self.frame.size.height;
    float cellWidth = self.frame.size.width;
    
    self.textLabel.frame = CGRectMake(0, cellHeight * 1.05, cellWidth, [self heightForLabelWithFont:self.font]);
}

#pragma mark - Helpers

- (void)addImageViewWithIcon:(UIImage *)icon {
    
    float frameWidth = self.frame.size.width;
    float center = self.frame.size.width/2;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth * 0.6, frameWidth * 0.6)];
    
    imageView.image = _icon;
    imageView.center = CGPointMake(center, center);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:imageView];
}

- (float)heightForLabelWithFont:(UIFont *)font {
    CGSize labelSize = [[self text] sizeWithAttributes:@{NSFontAttributeName:font}];
    
    return labelSize.height;
}


@end
