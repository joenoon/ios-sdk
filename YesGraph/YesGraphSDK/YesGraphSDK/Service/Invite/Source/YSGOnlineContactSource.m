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
#import "YSGContactList+Operations.h"
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
            [self.localSource fetchContactListWithCompletion:^(YSGContactList * _Nullable unrankedContactList, NSError * _Nullable error)
            {
                if (unrankedContactList.entries.count)
                {
                    [self.client updateAddressBookWithContactList:unrankedContactList forUserId:self.userId completionWaitForFinish:YES completion:^(YSGContactList*  _Nullable rankedContactList, NSError * _Nullable error)
                     {
                         if (rankedContactList)
                         {
                             if (YSGBatchCount < unrankedContactList.entries.count) {
                                 NSArray <YSGContact *> *lowerContacts;
                                 lowerContacts = [unrankedContactList.entries subarrayWithRange:NSMakeRange(YSGBatchCount, unrankedContactList.entries.count - YSGBatchCount)];
                                 rankedContactList.entries = [rankedContactList.entries arrayByAddingObjectsFromArray:lowerContacts];
                             }
                             [self.cacheSource updateCacheWithContactList:rankedContactList completion:nil];
                         }
                         
                         if (completion)
                         {
                             completion(rankedContactList ?: unrankedContactList, error);
                         }
                     }];
                }
                else if (completion)
                {
                    completion(nil, error);
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

- (void)updateShownSuggestions:(NSArray <YSGContact *> *)contacts contactList:(YSGContactList *)contactList
{
    NSArray <YSGContact *> *shownSuggestions = [contacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"wasSuggested == 1"]];
    
    for (YSGContact *contact in contacts)
    {
        [contact setSuggested:YES];
    }
    
    //
    // Check if there are any contacts left that were not suggested
    //
    
    NSArray <YSGContact *>* notSuggested = [[contactList removeDuplicatedContacts:contactList.entries] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"wasSuggested == 0"]];
    
    if (notSuggested.count == 0)
    {
        // Reset suggested flag, so we keep showing them
        [contactList.entries makeObjectsPerformSelector:@selector(setSuggested:) withObject:@(NO)];
        
        for (YSGContact *contact in shownSuggestions)
        {
            [contact setSuggested:YES];
        }
    }

    //
    // Update cache
    //
    
    [self.cacheSource updateCacheWithContactList:contactList completion:nil];
    
    [self.client updateSuggestionsSeen:contacts forUserId:self.userId completion:^(NSError * _Nullable error)
    {
        if (error)
        {
            YSG_LERROR(error);
        }
    }];
}


@end
