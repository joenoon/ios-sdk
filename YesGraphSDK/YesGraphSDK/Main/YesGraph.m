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

@interface YesGraph ()

@property (nonatomic, readwrite, copy) NSString *userId;
@property (nonatomic, readwrite, copy) NSString *clientKey;
@property (nonatomic, strong) YSGCacheContactSource *cacheSource;

@end

@implementation YesGraph

#pragma mark - Getters and Setters

+ (instancetype)shared
{
    static id shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
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
    //
    // TODO: Upload Local Address Book, if allowed + was uploaded last 24 hours
    //
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

- (YSGShareSheetController *)defaultShareSheetControllerWithDelegate:(id<YSGShareSheetDelegate>)delegate
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
