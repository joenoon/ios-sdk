//
//  YSGLocalContactSource+OverrideContactStore.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 23/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGLocalContactSource+OverrideContactStore.h"
#import "YSGTestMockData.h"

static BOOL shouldReturnNilContactStore = YES;

@implementation YSGLocalContactSource (OverrideContactStore)

- (CNContactStore *)contactStore
{
    return [YSGTestMockCNContactStore new];
}

+ (void)shouldReturnNil:(BOOL)returnNil
{
    shouldReturnNilContactStore = returnNil;
}

@end

@implementation YSGTestMockCNContactStore

- (BOOL)enumerateContactsWithFetchRequest:(CNContactFetchRequest *)fetchRequest error:(NSError *__autoreleasing  _Nullable *)error usingBlock:(void (^)(CNContact * _Nonnull, BOOL * _Nonnull))block
{
    if (!shouldReturnNilContactStore)
    {
        
    }
    
    return YES;
}

@end