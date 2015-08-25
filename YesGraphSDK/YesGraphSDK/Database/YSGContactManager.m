//
//  YSGContactManager.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 19/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGContactSource.h"
#import "YSGContactManager.h"
#import "YSGLocalContactSource.h"
#import "YSGOnlineContactSource.h"

@interface YSGContactManager ()

@end

@implementation YSGContactManager

#pragma mark - Getters and Setters

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.defaultSource = [[YSGOnlineContactSource alloc] initWithBaseSource:[YSGLocalContactSource new]];
    }
    
    return self;
}

#pragma mark - Public Methods

+ (instancetype)shared
{
    static id shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (void)fetchContactListWithCompletion:(void (^)(NSArray<YSGContact *> *contacts, NSError *error))completion
{
    if (!completion)
    {
        return;
    }
    
    [self.defaultSource fetchContactListWithCompletion:completion];
}

#pragma mark - Private Methods

@end
