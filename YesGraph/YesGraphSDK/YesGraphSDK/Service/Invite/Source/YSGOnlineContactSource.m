//
//  YSGOnlineContactSource.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 25/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGOnlineContactSource.h"
#import "YSGNetwork.h"
#import "YSGClient+SuggestionsShown.h"
#import "YSGLogging.h"

@interface YSGOnlineContactSource ()

@property (nonatomic, strong, readwrite) id<YSGContactSource> localSource;
@property (nonatomic, strong, readwrite) YSGClient *client;
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
    [self.cacheSource fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error)
    {
        if (!contactList.entries.count || error)
        {
            [self.localSource fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error)
            {
                if (contactList.entries.count)
                {
                    [self.client updateAddressBookWithContactList:contactList forUserId:self.userId completion:^(id  _Nullable responseObject, NSError * _Nullable error)
                    {
                        [self.cacheSource updateCacheWithContactList:contactList completion:nil];
                        
                        if (completion)
                        {
                            completion(contactList, error);
                        }
                    }];
                }
                else if (completion)
                {
                    completion(contactList, error);
                }
            }];
        }
        else if (completion)
        {
            completion(contactList, error);
        }
    }];
}

#pragma mark - Suggestions shown implementation

- (void)sendShownSuggestions:(NSArray <YSGContact *> *)contacts
{
    [self.client updateSuggestionsSeen:contacts forUserId:self.userId completion:^(NSError * _Nullable error)
    {
        if (error)
        {
            YSG_LERROR(error);
        }
    }];
}


@end
