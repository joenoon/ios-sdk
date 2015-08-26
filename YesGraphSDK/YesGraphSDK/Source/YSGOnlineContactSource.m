//
//  YSGOnlineContactSource.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 25/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGOnlineContactSource.h"

@interface YSGOnlineContactSource ()

@property (nonatomic, strong, readwrite) id<YSGContactSource> baseSource;

@end

@implementation YSGOnlineContactSource

- (instancetype)initWithBaseSource:(id<YSGContactSource>)baseSource
{
    self = [super init];
    
    if (self)
    {
        self.baseSource = baseSource;
    }
    
    return self;
}

#pragma mark - YSGContactSource

- (void)requestContactPermission:(void (^)(BOOL granted, NSError *error))completion
{
    [self.baseSource requestContactPermission:completion];
}

- (void)fetchContactListWithCompletion:(void (^)(YSGContactList *, NSError *))completion
{
    //
    // TODO: Go online and fetch from YesGraph
    //
    [self.baseSource fetchContactListWithCompletion:completion];
}

@end
