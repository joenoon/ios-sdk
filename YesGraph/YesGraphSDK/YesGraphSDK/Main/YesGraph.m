//
//  YesGraph.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YesGraph.h"

#import "YSGLogging.h"
#import "YSGServices.h"
#import "YSGSources.h"
#import "YSGMessageCenter.h"

#import "YSGClient+AddressBook.h"

#import "YSGClient+SuggestionsShown.h"

static NSString *const YSGLocalContactFetchDateKey = @"YSGLocalContactFetchDateKey";
static NSString *const YSGConfigurationClientKey = @"YSGConfigurationClientKey";
static NSString *const YSGConfigurationUserIdKey = @"YSGConfigurationUserIdKey";

@interface YesGraph ()

@property (nonatomic, readwrite, copy) NSString *userId;
@property (nonatomic, readwrite, copy) NSString *clientKey;

@property (nonatomic, strong) YSGLocalContactSource *localSource;
@property (nonatomic, strong) YSGCacheContactSource *cacheSource;
@property (nonatomic, strong) YSGOnlineContactSource *onlineSource;

@property (nonatomic, strong) YSGMessageCenter *messageCenter;
@property (nonatomic, strong) YSGClient* client;

/*!
 * Customization
 */
@property (nullable, nonatomic, strong) YSGTheme *theme;

/*!
 * Settings
 */
@property (nonatomic, assign) NSUInteger numberOfSuggestions;
@property (nullable, nonatomic, copy) NSString *shareSheetText;
@property (nullable, nonatomic, copy) NSString *contactAccessPromptMessage;
@property (nonatomic, assign) NSTimeInterval contactBookTimePeriod;

/*!
 * Logging
 */
@property (nonatomic, assign) YSGLogLevel logLevel;


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

- (YSGMessageCenter *)messageCenter
{
    if (!_messageCenter)
    {
        _messageCenter = [YSGMessageCenter shared];
    }
    
    return _messageCenter;
}

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


- (YSGOnlineContactSource *)onlineSource
{
    if (!_onlineSource)
    {
        if ([self isConfigured]) {
            _onlineSource = [[YSGOnlineContactSource alloc] initWithClient:self.client localSource:self.localSource cacheSource:self.cacheSource];
        }

    }
    
    return _onlineSource;
}

- (YSGMessageHandlerBlock)messageHandler
{
    return self.messageCenter.messageHandler;
}

- (void)setMessageHandler:(YSGMessageHandlerBlock)messageHandler
{
    self.messageCenter.messageHandler = messageHandler;
}

- (YSGErrorHandlerBlock)errorHandler
{
    return self.messageCenter.errorHandler;
}

- (void)setErrorHandler:(YSGErrorHandlerBlock)errorHandler
{
    self.messageCenter.errorHandler = errorHandler;
}

- (YSGClient *)client
{
    if (!_client)
    {
        _client = [[YSGClient alloc] init];
    }
    
    return _client;
}

- (NSString *)clientKey
{
    if (!_clientKey)
    {
        _clientKey = [self.userDefaults objectForKey:YSGConfigurationClientKey];
    }
    
    return _clientKey;
}

- (NSString *)userId
{
    if (!_userId)
    {
        _userId = [self.userDefaults objectForKey:YSGConfigurationUserIdKey];
    }
    
    return _userId;
}

- (YSGTheme *)theme
{
    if (!_theme)
    {
        _theme = [YSGTheme new];
    }
    return _theme;
}

- (YSGSource *)contactOwnerMetadata
{
    return self.localSource.contactSourceMetadata;
}

- (void)setContactOwnerMetadata:(YSGSource *)contactOwnerMetadata
{
    self.localSource.contactSourceMetadata = contactOwnerMetadata;
}

#pragma mark - Initialization

+ (void)load
{
    [[NSNotificationCenter defaultCenter] addObserver:[self shared] selector:@selector(applicationNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
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
    
    if (![[self.localSource class] hasPermission])
    {
        return;
    }
    
    [self.localSource fetchContactListWithCompletion:^(YSGContactList * _Nullable contactList, NSError * _Nullable error)
     {
         [self updateAndUploadContactList:contactList completion:nil];
     }];
}


#pragma mark - Private Methods
- (void)updateAndUploadContactList:(YSGContactList *)contactList completion:(void (^)(YSGContactList *, NSError *))completion
{
    if ([self isConfigured]) {
        if (contactList.entries.count)
        {
            [self.onlineSource uploadContactList:contactList completion:completion];
        }
        else
        {
            YSG_LWARN(@"No contacts to upload.");
        }
    }
    else
    {
        YSG_LWARN(@"YesGraph is not configured.");
    }
}

#pragma mark - Configuration

- (void)configureWithClientKey:(NSString *)clientKey
{
    if (clientKey.length)
    {
        self.clientKey = clientKey;
        self.client.clientKey = clientKey;
        
        [self.userDefaults setObject:clientKey forKey:YSGConfigurationClientKey];
        [self.userDefaults synchronize];
    }
}

- (void)configureWithUserId:(NSString *)userId
{
    if (userId.length)
    {
        self.userId = userId;
        
        [self.userDefaults setObject:userId forKey:YSGConfigurationUserIdKey];
        [self.userDefaults synchronize];
    }
}

- (BOOL)isConfigured
{
    
    //
    // No client key, cannot create the share sheet.
    //
    if (!self.clientKey.length)
    {
        YSG_LWARN(@"No client key was set for share sheet. Call configureWithClientKey first.");
        return NO;
    }
    //
    // No user id, cannot create the share sheet.
    //
    if (!self.userId.length)
    {
        YSG_LWARN(@"No userId was set for share sheet. Call configureWithUserId first.");
        return NO;
    }
    return YES;
}

#pragma mark - Public Methods

// This retrieves the contact list from the app cache if it exists, otherwise it retrieves it from the phone. Then it uploads to
// YesGraph and runs the completion on the results.
- (void)fetchContactListWithCompletion:(void (^)(YSGContactList *, NSError *))completion
{

    if ([self isConfigured]) {
        [self.onlineSource fetchContactListWithCompletion:^(YSGContactList *contactList, NSError *error){
            if (!error) {
                [self setLastFetchDate:[NSDate date]];
            }
            if (completion) {
                completion(contactList, error);
            }
        }];
    }
    else
    {
        YSG_LWARN(@"YesGraph is not configured. Please check that the userId and clientKey are set.");
    }
}



- (YSGShareSheetController *)shareSheetControllerForAllServices
{
    return [self shareSheetControllerForServicesWithDelegate:nil socialServices:YES];
}

- (YSGShareSheetController *)shareSheetControllerForAllServicesWithDelegate:(nullable id<YSGShareSheetDelegate>)delegate
{
    return [self shareSheetControllerForServicesWithDelegate:delegate socialServices:YES];
}

- (YSGShareSheetController *)shareSheetControllerForInviteService
{
    return [self shareSheetControllerForServicesWithDelegate:nil socialServices:NO];
}

- (YSGShareSheetController *)shareSheetControllerForInviteServiceWithDelegate:(nullable id<YSGShareSheetDelegate>)delegate
{
    return [self shareSheetControllerForServicesWithDelegate:delegate socialServices:NO];
}


- (YSGShareSheetController *)shareSheetControllerForServicesWithDelegate:(nullable id<YSGShareSheetDelegate>)delegate socialServices:(BOOL)socialServices
{
    if (!self.isConfigured) {
        
        YSG_LERR(@"Error: YesGraph is not configured. Please check that the clientKey and userId are set");
        return nil;
    }
    
    if (!self.contactAccessPromptMessage.length) {
        YSG_LWARN(@"No contact access prompt message is set.");
    }
    
    if (!self.shareSheetText.length) {
        YSG_LWARN(@"No share sheet text is set.");
    }
    
    // Initialize the invite messages
    self.localSource.contactAccessPromptMessage = self.contactAccessPromptMessage;
    self.localSource.contactSourceMetadata = self.contactOwnerMetadata;
    
    YSGInviteService *inviteService = [[YSGInviteService alloc] initWithContactSource:self.onlineSource userId:self.userId];
    inviteService.numberOfSuggestions = self.numberOfSuggestions;
    inviteService.theme = self.theme;
    
    //
    // Check if social services such as Facebook & Twitter are available
    //
    
    NSMutableArray <YSGShareService *> * services = [NSMutableArray array];
    
    if (socialServices)
    {
        NSArray <YSGSocialService *> *allSocialServices = @[ [YSGFacebookService new], [YSGTwitterService new] ];
        
        for (YSGSocialService* service in allSocialServices)
        {
            if (service.isAvailable)
            {
                service.theme = self.theme;
                [services addObject:service];
            }
        }
    }
    
    [services addObject:inviteService];
    
    YSGShareSheetController *shareController = [[YSGShareSheetController alloc] initWithServices:services.copy delegate:delegate theme:self.theme];
    shareController.shareText = self.shareSheetText;
    return shareController;
}


@end