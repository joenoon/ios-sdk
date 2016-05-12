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

// This retrieves the contact list from the app cache if it exists, otherwise it retrieves it from the phone. Then it uploads to
// YesGraph and runs the completion on the results.
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
                    [self uploadContactList:unrankedContactList completion:completion];
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

// This method retrieves the contact list from the phone, uploads them to YesGraph, and runs the completion on the response
- (void)updateAndUploadContactListWithCompletion:(void (^)(YSGContactList *, NSError *))completion
{
    [self.localSource fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error)
     {
         [self uploadContactList:contactList completion:completion];
     }];
}

- (void)uploadContactList:(YSGContactList *)contactList completion:(void (^)(YSGContactList *, NSError *))completion
{
    [self.client updateAddressBookWithContactList:contactList forUserId:self.userId completionWaitForFinish:YES completion:^(YSGContactList*  _Nullable rankedContactList, NSError * _Nullable error)
     {
         if (rankedContactList)
         {
             // If the addressbook is too large, we should break it into batches and get the first result right away, while getting the rest of the results
             // in the background. So we have something to show to the user while the rest of the addressbook is posting.
             if (YSGBatchCount < contactList.entries.count) {
                 NSArray <YSGContact *> *lowerContacts;
                 lowerContacts = [contactList.entries subarrayWithRange:NSMakeRange(YSGBatchCount, contactList.entries.count - YSGBatchCount)];
                 rankedContactList.entries = [rankedContactList.entries arrayByAddingObjectsFromArray:lowerContacts];
             }
             [self.cacheSource updateCacheWithContactList:rankedContactList completion:nil];
         }
         if (completion)
         {
             completion(rankedContactList ?: contactList, error);
         }
         else {
             [self.cacheSource updateCacheWithContactList:(rankedContactList ?: contactList) completion:nil];
             NSLog(@"Error with HTTP request");
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
