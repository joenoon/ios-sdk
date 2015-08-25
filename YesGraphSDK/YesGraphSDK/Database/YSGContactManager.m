//
//  YSGContactManager.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 19/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGContactManager.h"

@interface YSGContactManager ()

@end

@implementation YSGContactManager

#pragma mark - Getters and Setters

#pragma mark - Public Methods

+ (instancetype)shared
{
    static id shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
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
    
    //[self fetchLocalAddressBookWithCompletion:completion];
}

#pragma mark - Private Methods

@end
