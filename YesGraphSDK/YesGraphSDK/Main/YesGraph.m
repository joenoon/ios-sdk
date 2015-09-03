//
//  YesGraph.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YesGraph.h"
#import "YSGServices.h"

@implementation YesGraph

+ (instancetype)shared
{
    static id shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (void)configureWithClientKey:(NSString *)key
{
    
}

- (void)configureWithUserId:(NSString *)userId
{
    
}

- (YSGShareSheetController *)defaultShareSheetControllerWithDelegate:(id<YSGShareSheetDelegate>)delegate
{
    return nil;
}

@end
