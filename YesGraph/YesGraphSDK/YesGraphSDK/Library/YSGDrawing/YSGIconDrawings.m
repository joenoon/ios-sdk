//
//  TwitterCode.m
//  YesGraphSDK
//
//  Created by Lea Marolt on 9/18/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGIconDrawings.h"

@implementation YSGIconDrawings

#pragma mark Cache

static UIImage* _twitterImage = nil;
static UIImage* _facebookImage = nil;
static UIImage* _phoneImage = nil;

#pragma mark Drawing Methods

+ (void)drawTwitterCanvas
{
    //// Color Declarations
    UIColor* fillColor = [UIColor whiteColor];

    //// Page-1
    {
        //// Twitter Drawing
        UIBezierPath* twitterPath = [UIBezierPath bezierPath];
        [twitterPath moveToPoint: CGPointMake(81.17, 30.6)];
        [twitterPath addCurveToPoint: CGPointMake(81.23, 32.85) controlPoint1: CGPointMake(81.21, 31.34) controlPoint2: CGPointMake(81.23, 32.09)];
        [twitterPath addCurveToPoint: CGPointMake(32.27, 82.14) controlPoint1: CGPointMake(81.23, 55.75) controlPoint2: CGPointMake(63.92, 82.14)];
        [twitterPath addCurveToPoint: CGPointMake(5.9, 74.36) controlPoint1: CGPointMake(22.56, 82.14) controlPoint2: CGPointMake(13.51, 79.28)];
        [twitterPath addCurveToPoint: CGPointMake(10, 74.6) controlPoint1: CGPointMake(7.25, 74.52) controlPoint2: CGPointMake(8.62, 74.6)];
        [twitterPath addCurveToPoint: CGPointMake(31.37, 67.19) controlPoint1: CGPointMake(18.07, 74.6) controlPoint2: CGPointMake(25.48, 71.83)];
        [twitterPath addCurveToPoint: CGPointMake(15.3, 55.15) controlPoint1: CGPointMake(23.84, 67.05) controlPoint2: CGPointMake(17.49, 62.04)];
        [twitterPath addCurveToPoint: CGPointMake(18.53, 55.46) controlPoint1: CGPointMake(16.35, 55.35) controlPoint2: CGPointMake(17.43, 55.46)];
        [twitterPath addCurveToPoint: CGPointMake(23.07, 54.86) controlPoint1: CGPointMake(20.1, 55.46) controlPoint2: CGPointMake(21.63, 55.26)];
        [twitterPath addCurveToPoint: CGPointMake(9.27, 37.87) controlPoint1: CGPointMake(15.2, 53.27) controlPoint2: CGPointMake(9.27, 46.27)];
        [twitterPath addCurveToPoint: CGPointMake(9.27, 37.65) controlPoint1: CGPointMake(9.27, 37.8) controlPoint2: CGPointMake(9.27, 37.72)];
        [twitterPath addCurveToPoint: CGPointMake(17.06, 39.81) controlPoint1: CGPointMake(11.59, 38.94) controlPoint2: CGPointMake(14.24, 39.73)];
        [twitterPath addCurveToPoint: CGPointMake(9.41, 25.39) controlPoint1: CGPointMake(12.45, 36.71) controlPoint2: CGPointMake(9.41, 31.41)];
        [twitterPath addCurveToPoint: CGPointMake(11.74, 16.68) controlPoint1: CGPointMake(9.41, 22.22) controlPoint2: CGPointMake(10.26, 19.24)];
        [twitterPath addCurveToPoint: CGPointMake(47.2, 34.79) controlPoint1: CGPointMake(20.22, 27.17) controlPoint2: CGPointMake(32.9, 34.06)];
        [twitterPath addCurveToPoint: CGPointMake(46.75, 30.84) controlPoint1: CGPointMake(46.9, 33.52) controlPoint2: CGPointMake(46.75, 32.2)];
        [twitterPath addCurveToPoint: CGPointMake(63.96, 13.51) controlPoint1: CGPointMake(46.75, 21.27) controlPoint2: CGPointMake(54.46, 13.51)];
        [twitterPath addCurveToPoint: CGPointMake(76.51, 18.98) controlPoint1: CGPointMake(68.9, 13.51) controlPoint2: CGPointMake(73.37, 15.61)];
        [twitterPath addCurveToPoint: CGPointMake(87.44, 14.77) controlPoint1: CGPointMake(80.44, 18.2) controlPoint2: CGPointMake(84.11, 16.77)];
        [twitterPath addCurveToPoint: CGPointMake(79.87, 24.36) controlPoint1: CGPointMake(86.15, 18.82) controlPoint2: CGPointMake(83.43, 22.22)];
        [twitterPath addCurveToPoint: CGPointMake(89.75, 21.64) controlPoint1: CGPointMake(83.35, 23.95) controlPoint2: CGPointMake(86.67, 23.02)];
        [twitterPath addCurveToPoint: CGPointMake(81.17, 30.6) controlPoint1: CGPointMake(87.45, 25.11) controlPoint2: CGPointMake(84.54, 28.16)];
        [twitterPath addLineToPoint: CGPointMake(81.17, 30.6)];
        [twitterPath closePath];
        twitterPath.miterLimit = 4;

        twitterPath.usesEvenOddFillRule = YES;

        [fillColor setFill];
        [twitterPath fill];
    }
}

+ (void)drawFacebookCanvas
{
    
    //// Color Declarations
    UIColor* fillColor = [UIColor whiteColor];
    
    //// Page-1
    {
        //// facebook Drawing
        UIBezierPath* facebookPath = [UIBezierPath bezierPath];
        [facebookPath moveToPoint: CGPointMake(60.18, 45.72)];
        [facebookPath addLineToPoint: CGPointMake(49.81, 45.72)];
        [facebookPath addLineToPoint: CGPointMake(49.81, 83.1)];
        [facebookPath addLineToPoint: CGPointMake(34.44, 83.1)];
        [facebookPath addLineToPoint: CGPointMake(34.44, 45.72)];
        [facebookPath addLineToPoint: CGPointMake(27.13, 45.72)];
        [facebookPath addLineToPoint: CGPointMake(27.13, 32.51)];
        [facebookPath addLineToPoint: CGPointMake(34.44, 32.51)];
        [facebookPath addLineToPoint: CGPointMake(34.44, 23.96)];
        [facebookPath addCurveToPoint: CGPointMake(49.95, 8.28) controlPoint1: CGPointMake(34.44, 17.84) controlPoint2: CGPointMake(37.31, 8.28)];
        [facebookPath addLineToPoint: CGPointMake(61.34, 8.33)];
        [facebookPath addLineToPoint: CGPointMake(61.34, 21.15)];
        [facebookPath addLineToPoint: CGPointMake(53.07, 21.15)];
        [facebookPath addCurveToPoint: CGPointMake(49.81, 24.75) controlPoint1: CGPointMake(51.73, 21.15) controlPoint2: CGPointMake(49.81, 21.83)];
        [facebookPath addLineToPoint: CGPointMake(49.81, 32.51)];
        [facebookPath addLineToPoint: CGPointMake(61.52, 32.51)];
        [facebookPath addLineToPoint: CGPointMake(60.18, 45.72)];
        [facebookPath addLineToPoint: CGPointMake(60.18, 45.72)];
        [facebookPath closePath];
        facebookPath.miterLimit = 4;
        
        facebookPath.usesEvenOddFillRule = YES;
        
        [fillColor setFill];
        [facebookPath fill];
    }
}

+ (void)drawPhoneCanvas
{
    //// Color Declarations
    UIColor* fillColor = [UIColor whiteColor];
    
    //// Page-
    {
        //// Phone Drawing
        UIBezierPath* phonePath = [UIBezierPath bezierPath];
        [phonePath moveToPoint: CGPointMake(58.15, 8)];
        [phonePath addLineToPoint: CGPointMake(31.85, 8)];
        [phonePath addCurveToPoint: CGPointMake(26, 13.98) controlPoint1: CGPointMake(28.62, 8) controlPoint2: CGPointMake(26, 10.68)];
        [phonePath addLineToPoint: CGPointMake(26, 78.36)];
        [phonePath addCurveToPoint: CGPointMake(31.85, 84.34) controlPoint1: CGPointMake(26, 81.66) controlPoint2: CGPointMake(28.62, 84.34)];
        [phonePath addLineToPoint: CGPointMake(58.15, 84.34)];
        [phonePath addCurveToPoint: CGPointMake(64, 78.36) controlPoint1: CGPointMake(61.38, 84.34) controlPoint2: CGPointMake(64, 81.66)];
        [phonePath addLineToPoint: CGPointMake(64, 13.98)];
        [phonePath addCurveToPoint: CGPointMake(58.15, 8) controlPoint1: CGPointMake(64, 10.68) controlPoint2: CGPointMake(61.38, 8)];
        [phonePath addLineToPoint: CGPointMake(58.15, 8)];
        [phonePath closePath];
        [phonePath moveToPoint: CGPointMake(61.08, 70.97)];
        [phonePath addLineToPoint: CGPointMake(28.92, 70.97)];
        [phonePath addLineToPoint: CGPointMake(28.92, 21.37)];
        [phonePath addLineToPoint: CGPointMake(61.08, 21.37)];
        [phonePath addLineToPoint: CGPointMake(61.08, 70.97)];
        [phonePath addLineToPoint: CGPointMake(61.08, 70.97)];
        [phonePath closePath];
        phonePath.miterLimit = 4;
        
        phonePath.usesEvenOddFillRule = YES;
        
        [fillColor setFill];
        [phonePath fill];
    }
}

#pragma mark Generated Images

+ (UIImage *)twitterImage
{
    if (_twitterImage)
    {
        return _twitterImage;
    }

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(90, 90), NO, 0.0f);
    [YSGIconDrawings drawTwitterCanvas];

    _twitterImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return _twitterImage;
}

+ (UIImage *)facebookImage
{
    if (_facebookImage)
    {
        return _facebookImage;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(90, 90), NO, 0.0f);
    [YSGIconDrawings drawFacebookCanvas];
    
    _facebookImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return _facebookImage;
}

+ (UIImage *)phoneImage
{
    if (_phoneImage)
    {
        return _phoneImage;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(90, 90), NO, 0.0f);
    [YSGIconDrawings drawPhoneCanvas];
    
    _phoneImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return _phoneImage;
}

#pragma mark Customization Infrastructure

- (void)setTwitterTargets: (NSArray*)targets
{
    self.twitterTargets = targets;

    for (id target in self.twitterTargets)
    {
        [target performSelector:@selector(setImage:) withObject:YSGIconDrawings.twitterImage];
    }
}

- (void)setFacebookTargets:(NSArray *)targets
{
    self.facebookTargets = targets;
    
    for (id target in self.facebookTargets)
    {
        [target performSelector:@selector(setImage:) withObject:YSGIconDrawings.facebookImage];
    }
}

- (void)setPhoneTargets:(NSArray *)targets
{
    self.phoneTargets = targets;
    
    for (id target in self.phoneTargets)
    {
        [target performSelector:@selector(setImage:) withObject:YSGIconDrawings.phoneImage];
    }
}

@end
