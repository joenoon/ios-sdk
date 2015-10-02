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

static NSString *const YSGLocalContactFetchDateKey = @"YSGLocalContactFetchDateKey";
static NSString *const YSGConfigurationClientKey = @"YSGConfigurationClientKey";
static NSString *const YSGConfigurationUserIdKey = @"YSGConfigurationUserIdKey";

@interface YesGraph ()

@property (nonatomic, readwrite, copy) NSString *userId;
@property (nonatomic, readwrite, copy) NSString *clientKey;

@property (nonatomic, strong) YSGLocalContactSource *localSource;
@property (nonatomic, strong) YSGCacheContactSource *cacheSource;

@property (nonatomic, strong) YSGMessageCenter *messageCenter;

/*!
 * Customization
 */
@property (nullable, nonatomic, strong) YSGTheme *theme;

/*!
 * Settings
 */
@property (nonatomic, assign) NSUInteger numberOfSuggestions;
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
    /*if (fabs([self.lastFetchDate timeIntervalSinceNow]) < self.contactBookTimePeriod)
    {
        return;
    }*/
    
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
    
    [self.userDefaults setObject:clientKey forKey:YSGConfigurationClientKey];
    [self.userDefaults synchronize];
}

- (void)configureWithUserId:(NSString *)userId
{
    self.userId = userId;
    
    [self.userDefaults setObject:userId forKey:YSGConfigurationUserIdKey];
    [self.userDefaults synchronize];
}

- (BOOL)isConfigured
{
    if (self.userId.length && self.clientKey.length)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Public Methods

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
    //
    // No client key, cannot create the share sheet.
    //
    if (!self.clientKey.length)
    {
        YSG_LERR(@"No client key was set for share sheet. Call configureWithClientKey: first.");
        return nil;
    }
    
    //
    // No user id, cannot create the share sheet.
    //
    if (!self.userId.length)
    {
        YSG_LERR(@"No client key was set for share sheet. Call configureWithUserId: first.");
        return nil;
    }
    
    if (!self.contactAccessPromptMessage.length) {
        YSG_LWARN(@"No contact access prompt message is set.");
    }
    
    YSGLocalContactSource *localSource = [YSGLocalContactSource new];
    localSource.contactAccessPromptMessage = self.contactAccessPromptMessage;
    
    YSGClient* client = [[YSGClient alloc] init];
    client.clientKey = self.clientKey;
    
    YSGOnlineContactSource *onlineSource = [[YSGOnlineContactSource alloc] initWithClient:client localSource:localSource cacheSource:nil];
    onlineSource.userId = self.userId;
    
    YSGInviteService *inviteService = [[YSGInviteService alloc] initWithContactSource:onlineSource userId:self.userId];
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
    
    YSGShareSheetController *shareController = [[YSGShareSheetController alloc] initWithServices:services.copy delegate:delegate];
    shareController.baseColor = self.theme.baseColor;
    return shareController;
}

#pragma mark - Private Methods

@end
