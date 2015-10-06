//
//  YSGOnlineContactSource.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 25/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGOnlineContactSource.h"
#import "YSGNetwork.h"

@interface YSGOnlineContactSource ()

@property (nonatomic, strong, readwrite) id<YSGContactSource> localSource;
@property (nonatomic, strong) YSGClient *client;
@property (nonatomic, strong) YSGCacheContactSource *cacheSource;

@end

@implementation YSGOnlineContactSource

#pragma mark - Getters and Setters

#pragma mark - Initialization

- (instancetype)initWithClient:(YSGClient *)client localSource:(id<YSGContactSource>)localSource cacheSource:(YSGCacheContactSource *)cacheSource
{
    self = [super init];
    
    if (self)
    {
        self.client = client;
        self.localSource = localSource;
        self.cacheSource = cacheSource;
    }
    
    return self;
}

#pragma mark - YSGContactSource

- (void)requestContactPermission:(void (^)(BOOL granted, NSError *error))completion
{
    [self.localSource requestContactPermission:completion];
}

- (void)fetchContactListWithCompletion:(void (^)(YSGContactList *, NSError *))completion
{
    [self.client fetchAddressBookForUserId:self.userId completion:^(YSGContactList *contactList, NSError * _Nullable error)
    {
        if (!contactList.entries.count || error)
        {
            if (self.cacheSource)
            {
                [self.cacheSource fetchContactListWithCompletion:^(YSGContactList *contactList, NSError *error)
                {
                    if (!contactList.entries.count || error)
                    {
                        [self.localSource fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error)
                        {
                            if (contactList.entries.count)
                            {
                                [self.client updateAddressBookWithContactList:contactList forUserId:self.userId completion:nil];
                            }
                            
                            if (completion)
                            {
                                completion(contactList, error);
                            }
                        }];
                    }
                    else
                    {
                        completion(contactList, nil);
                    }
                }];
            }
            else
            {
                [self.localSource fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error)
                {
                    if (contactList)
                    {
                        [self.client updateAddressBookWithContactList:contactList forUserId:self.userId completion:nil];
                    }
                    
                    if (completion)
                    {
                        completion(contactList, error);
                    }
                }];
            }
        }
        else if (completion)
        {
            if (self.cacheSource)
            {
                [self.cacheSource updateCacheWithContactList:contactList completion:nil];
            }
            
            completion(contactList, nil);
        }
    }];
}

@end
