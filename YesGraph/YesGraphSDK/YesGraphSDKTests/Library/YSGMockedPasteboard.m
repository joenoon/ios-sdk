//
//  YSGMockedPasteboard.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 01/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGMockedPasteboard.h"
@import ObjectiveC;
@import UIKit;

@interface YSGMockedPasteboard ()
{
    NSString *_string;
}

@property (nonatomic) Method originalImplementationSetString;
@property (nonatomic) Method replacedImplementationSetString;
@property (nonatomic) Method originalImplementationGetString;
@property (nonatomic) Method replacedImplementationGetString;

@end

@implementation YSGMockedPasteboard

- (instancetype)init
{
    if ((self = [super init]))
    {
        static dispatch_once_t onceToken;
        __weak YSGMockedPasteboard *preventRetainCycle = self;
        dispatch_once(&onceToken, ^{
            UIPasteboard *pb = [UIPasteboard generalPasteboard];
            SEL setStringSelector = @selector(setString:);
            SEL getStringSelector = @selector(string);
            preventRetainCycle.originalImplementationSetString = class_getInstanceMethod([pb class], setStringSelector);
            preventRetainCycle.replacedImplementationSetString = class_getInstanceMethod([preventRetainCycle class], setStringSelector);
            preventRetainCycle.originalImplementationGetString = class_getInstanceMethod([pb class], getStringSelector);
            preventRetainCycle.replacedImplementationGetString = class_getInstanceMethod([preventRetainCycle class], getStringSelector);
            [preventRetainCycle exchangeImplementations];
            pb.string = nil;
        });
    }
    return self;
}

- (void)exchangeImplementations
{
    if (self.originalImplementationGetString && self.replacedImplementationGetString && self.replacedImplementationSetString && self.originalImplementationSetString)
    {
        method_exchangeImplementations(self.originalImplementationSetString, self.replacedImplementationSetString);
        method_exchangeImplementations(self.originalImplementationGetString, self.replacedImplementationGetString);
    }
}

- (void)setString:(NSString *)string
{
    _string = string;
}

- (NSString *)string
{
    return _string;
}

- (void)dealloc
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeImplementations];
    });
}

@end
