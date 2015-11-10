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
@property (nonatomic, strong) UIView *serviceLogo;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YSGShareSheetServiceCell

#pragma mark - Getters and Setters

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = text;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.textLabel.font = font;
}

- (void)setShape:(YSGShareSheetServiceCellShape)shape
{
    _shape = shape;
    
    if (_shape == YSGShareSheetServiceCellShapeSquare)
    {
        self.serviceLogo.layer.cornerRadius = 0;
    }
    else if (_shape == YSGShareSheetServiceCellShapeRoundedSquare)
    {
        self.serviceLogo.layer.cornerRadius = self.serviceLogo.frame.size.height / 10;
    }
    else
    {
        self.serviceLogo.layer.cornerRadius = self.serviceLogo.frame.size.height / 2;
    }
}

- (void)setIcon:(UIImage *)iconImage
{
    _icon = iconImage;
    
    [self setImageViewWithIcon:_icon];
}

- (void)setIconWithString:(NSString *)iconImageString
{
    _icon = [UIImage imageNamed:iconImageString];
    
    [self setImageViewWithIcon:_icon];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textLabel.textColor = _textColor;
}

- (void)setServiceColor:(UIColor *)serviceColor
{
    _serviceColor = serviceColor;
    
    if (!_textColor)
    {
        [self setTextColor:serviceColor];
    }
    
    self.serviceLogo.backgroundColor = _serviceColor;
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
    CGFloat serviceLogoSize = fmin(self.frame.size.width, self.frame.size.height);
    self.serviceLogo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, serviceLogoSize, serviceLogoSize)];
    [self addSubview:self.serviceLogo];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.serviceLogo.frame.size.width * 0.6, self.serviceLogo.frame.size.height * 0.6)];
    self.imageView.center = CGPointMake(serviceLogoSize / 2.0, serviceLogoSize / 2.0);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.serviceLogo addSubview:self.imageView];
    
    CGFloat textLabelHeight = 25.0;
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.serviceLogo.frame.size.height, serviceLogoSize, textLabelHeight)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.textLabel];
}

#pragma mark - Helpers

- (void)setImageViewWithIcon:(UIImage *)icon
{
    self.imageView.image = _icon;
}

- (float)heightForLabelWithFont:(UIFont *)font
{
    CGSize labelSize = [[self text] sizeWithAttributes:@{NSFontAttributeName:font}];
    
    return labelSize.height;
}


@end
