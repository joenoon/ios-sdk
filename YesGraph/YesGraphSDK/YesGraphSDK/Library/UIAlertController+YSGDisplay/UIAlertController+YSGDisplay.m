//
//  UIAlertController+YSGDisplay.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 25/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

//
// Code ported from: https://github.com/agilityvision/FFGlobalAlertController
//

//
// Copyright (c) 2015 Eric Larson <eric@agilityvision.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

@import ObjectiveC.runtime;

#import "UIAlertController+YSGDisplay.h"

#pragma mark - Private Methods

@interface UIAlertController (YSGPrivate)

@property (nonatomic, strong) UIWindow *ysg_alertWindow;

@end

@implementation UIAlertController (YSGPrivate)

@dynamic ysg_alertWindow;

- (void)setYsg_alertWindow:(UIWindow *)alertWindow
{
    objc_setAssociatedObject(self, @selector(ysg_alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)ysg_alertWindow
{
    return objc_getAssociatedObject(self, @selector(ysg_alertWindow));
}

@end

#pragma mark - Public methods

@implementation UIAlertController (YSGDisplay)

- (void)ysg_show
{
    [self ysg_show:YES];
}

- (void)ysg_show:(BOOL)animated
{
    [self ysg_show:animated completion:nil];
}

- (void)ysg_show:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    [self ysg_createWindow];
    
    [self.ysg_alertWindow makeKeyAndVisible];
    [self.ysg_alertWindow.rootViewController presentViewController:self animated:animated completion:completion];
}

- (void)ysg_createWindow
{
    if (!self.ysg_alertWindow)
    {
        self.ysg_alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    if (!self.ysg_alertWindow.rootViewController)
    {
        self.ysg_alertWindow.rootViewController = [[UIViewController alloc] init];
    }
    
    self.ysg_alertWindow.windowLevel = UIWindowLevelAlert + 1;
}

@end
