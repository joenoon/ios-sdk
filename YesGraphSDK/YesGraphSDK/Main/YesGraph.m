//
//  YesGraph.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YesGraph.h"
#import "YSGServices.h"
#import "YSGSources.h"

#import "YSGClient+AddressBook.h"

static NSString *const YSGLocalContactFetchDateKey = @"YSGLocalContactFetchDateKey";

@interface YesGraph ()

@property (nonatomic, readwrite, copy) NSString *userId;
@property (nonatomic, readwrite, copy) NSString *clientKey;

@property (nonatomic, strong) YSGLocalContactSource *localSource;
@property (nonatomic, strong) YSGCacheContactSource *cacheSource;

/*!
 *  This holds last date that contacts were fetched. This can be used to test whether to upload them again.
 */
@property (nullable, nonatomic, copy) NSDate* lastFetchDate;

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation YesGraph

#pragma mark - Singleton

+ (instancetype)shared
{
    static id shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

#pragma mark - Getters and Setters

- (NSUserDefaults *)userDefaults
{
    if (!_userDefaults)
    {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return _userDefaults;
}

- (NSDate *)lastFetchDate
{
    return [self.userDefaults objectForKey:YSGLocalContactFetchDateKey];
}

- (void)setLastFetchDate:(NSDate *)lastFetchDate
{
    [self.userDefaults setObject:lastFetchDate forKey:YSGLocalContactFetchDateKey];
    [self.userDefaults synchronize];
}

- (YSGLocalContactSource *)localSource
{
    if (!_localSource)
    {
        _localSource = [YSGLocalContactSource new];
    }
    
    return _localSource;
}

- (YSGCacheContactSource *)cacheSource
{
    if (!_cacheSource)
    {
        _cacheSource = [YSGCacheContactSource new];
    }
    
    return _cacheSource;
}

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        //
        // Defaults
        //
        
        self.contactBookTimePeriod = YSGDefaultContactBookTimePeriod;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)applicationNotification:(NSNotification *)notification
{
    if (fabs([self.lastFetchDate timeIntervalSinceNow]) < self.contactBookTimePeriod)
    {
        return;
    }
    
    [self.localSource fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error)
    {
        if (contactList)
        {
            YSGClient* client = [[YSGClient alloc] init];
            client.clientKey = self.clientKey;
            
            [client updateAddressBookWithContactList:contactList completion:^(id  _Nullable responseObject, NSError * _Nullable error)
            {
                if (!error)
                {
                    //
                    // Store last fetch date
                    //
                    self.lastFetchDate = [NSDate date];
                }
            }];
        }
    }];
}

#pragma mark - Configuration

- (void)configureWithClientKey:(NSString *)clientKey
{
    self.clientKey = clientKey;
}

- (void)configureWithUserId:(NSString *)userId
{
    self.userId = userId;
}

#pragma mark - Public Methods

- (YSGShareSheetController *)defaultShareSheetController
{
    return [self defaultShareSheetControllerWithDelegate:nil];
}

- (YSGShareSheetController *)defaultShareSheetControllerWithDelegate:(nullable id<YSGShareSheetDelegate>)delegate
{
    YSGLocalContactSource *localSource = [YSGLocalContactSource new];
    localSource.contactAccessPromptMessage = self.contactAccessPromptMessage;
    
    YSGClient* client = [[YSGClient alloc] init];
    client.clientKey = self.clientKey;
    
    YSGOnlineContactSource *onlineSource = [[YSGOnlineContactSource alloc] initWithClient:client localSource:localSource cacheSource:nil];
    
    YSGInviteService *inviteService = [[YSGInviteService alloc] initWithContactSource:onlineSource userId:self.userId];
    inviteService.numberOfSuggestions = self.numberOfSuggestions;
    
    //
    // TODO: Check if Facebook & Twitter are available
    //
    
    YSGShareSheetController *shareController = [[YSGShareSheetController alloc] initWithServices:@[ [YSGFacebookService new], [YSGTwitterService new], inviteService ] delegate:delegate];
    
    return shareController;
}

#pragma mark - Private Methods

@end
