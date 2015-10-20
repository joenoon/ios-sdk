//
//  TwitterCode.h
//  YesGraphSDK
//
//  Created by Lea Marolt on 9/18/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface YSGIconDrawings : NSObject

// iOS Controls Customization Outlets
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* twitterTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* facebookTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* phoneTargets;

// Drawing Methods
+ (void)drawTwitterCanvas;
+ (void)drawFacebookCanvas;
+ (void)drawPhoneCanvas;

// Generated Images
+ (UIImage *)twitterImage;
+ (UIImage *)facebookImage;
+ (UIImage *)phoneImage;

@end
