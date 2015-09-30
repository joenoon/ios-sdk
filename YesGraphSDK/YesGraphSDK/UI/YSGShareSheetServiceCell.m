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

- (void)setText:(NSString *)text {
    _text = text;
    self.textLabel.text = text;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.textLabel.font = font;
}

- (void)setShape:(YSGShareSheetServiceCellShape)shape {
    
    _shape = shape;
    
    if (_shape == YSGShareSheetServiceCellShapeSquare) {
        self.serviceLogo.layer.cornerRadius = 0;
    }
    else if (_shape == YSGShareSheetServiceCellShapeRoundedSquare) {
        self.serviceLogo.layer.cornerRadius = self.serviceLogo.frame.size.height/10;
    }
    else {
        self.serviceLogo.layer.cornerRadius = self.serviceLogo.frame.size.height/2;
    }
}

- (void)setIcon:(UIImage *)iconImage {
    _icon = iconImage;
    
    [self setImageViewWithIcon:_icon];
}

- (void)setIconWithString:(NSString *)iconImageString {
    _icon = [UIImage imageNamed:iconImageString];
    
    [self setImageViewWithIcon:_icon];
}

- (void)setTextColor:(UIColor *)textColor {
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
    self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [UIColor grayColor];
    //NSLog(@"TEXT LABEL: %@", self.textLabel.text);
    [self addSubview:self.textLabel];
    
    CGFloat serviceLogoSize = (self.frame.size.width > self.frame.size.height) ? self.frame.size.height : self.frame.size.width;
    
    CGFloat centerX = self.frame.size.width/2;
    CGFloat centerY = self.frame.size.height/2;
    
    self.serviceLogo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, serviceLogoSize, serviceLogoSize)];
    self.serviceLogo.center = CGPointMake(centerX, centerY);
    self.serviceLogo.backgroundColor = [UIColor grayColor];
    [self addSubview:self.serviceLogo];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.serviceLogo.frame.size.width * 0.6, self.serviceLogo.frame.size.height * 0.6)];
    
    self.imageView.center = CGPointMake(self.serviceLogo.frame.size.width/2, self.serviceLogo.frame.size.height/2);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.serviceLogo addSubview:self.imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cellHeight = self.frame.size.height;
    CGFloat cellWidth = self.frame.size.width;

    CGFloat centerX = self.frame.size.width/2;
    CGFloat centerY = self.frame.size.height/2;
    
    self.serviceLogo.center = CGPointMake(centerX, centerY);
    
    self.textLabel.frame = CGRectMake(0, cellHeight * 1.1, cellWidth, [self heightForLabelWithFont:self.font]);
}

#pragma mark - Helpers

- (void)setImageViewWithIcon:(UIImage *)icon {
    
    self.imageView.image = _icon;
}

- (float)heightForLabelWithFont:(UIFont *)font {
    CGSize labelSize = [[self text] sizeWithAttributes:@{NSFontAttributeName:font}];
    
    return labelSize.height;
}


@end
