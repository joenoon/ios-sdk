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

- (ABAddressBookRef)addressBookRefWithError:(CFErrorRef *)err
{
    if (shouldReturnNilContactStore)
    {
        return nil;
    }
    return ABAddressBookCreateWithOptions(NULL, err);
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
        return [super enumerateContactsWithFetchRequest:fetchRequest error:error usingBlock:block];
    }
    return YES;
}

- (void)requestAccessForEntityType:(CNEntityType)entityType completionHandler:(void (^)(BOOL, NSError * _Nullable))completionHandler
{
    if (completionHandler)
    {
        completionHandler(YES, nil);
    }
}

@end