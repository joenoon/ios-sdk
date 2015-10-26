//
//  YSGTestImageData.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 25/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGTestImageData.h"

@implementation YSGTestImageData

+ (NSData *)getDataForImageFile:(NSString *)fileName
{
    NSString *file = [NSString stringWithFormat:@"%@_%.2f", fileName, [UIScreen mainScreen].scale];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imageDataPath = [bundle pathForResource:file ofType:@"bin"];
    NSData *imageData = [NSData dataWithContentsOfFile:imageDataPath];
    
    return imageData;
}

@end
