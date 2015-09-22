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
        self.layer.cornerRadius = 0;
    }
    else if (_shape == YSGShareSheetServiceCellShapeRoundedSquare) {
        self.layer.cornerRadius = self.frame.size.height/10;
    }
    else {
        self.layer.cornerRadius = self.frame.size.height/2;
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
    
    float frameWidth = self.frame.size.width;
    float center = self.frame.size.width/2;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth * 0.6, frameWidth * 0.6)];
    
    self.imageView.center = CGPointMake(center, center);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cellHeight = self.frame.size.height;
    CGFloat cellWidth = self.frame.size.width;
    
    //NSNumber *height = [NSNumber numberWithFloat:cellHeight];
    
    UILabel *textLabel = self.textLabel;
    //textLabel.backgroundColor = [UIColor yellowColor];
//    
//    NSDictionary *views = NSDictionaryOfVariableBindings(textLabel);
//    
//    NSArray *horizontalConstraints = [NSLayoutConstraint
//                                      constraintsWithVisualFormat:@"H:|-20-[textLabel]-0-|"
//                                      options:0
//                                      metrics:@{@"cellHeight": height}
//                                      views:views];
//    
//    [self addConstraints:horizontalConstraints];
//    
//    [self layoutIfNeeded];
    
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
