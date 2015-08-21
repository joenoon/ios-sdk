//
//  YSGInviteService.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGInviteService.h"
#import "YSGShareSheetController.h"
#import "YSGAddressBookViewController.h"

NSString * const YSGInviteContactsKey = @"YSGInviteContactsKey";

@interface YSGInviteService ()

@property (nonatomic, strong) YSGContactManager *contactManager;

@end

@implementation YSGInviteService

- (NSString *)name
{
    return @"Invite";
}

- (instancetype)initWithContactManager:(YSGContactManager *)contactManager
{
    self = [super init];
    
    if (self)
    {
        self.contactManager = contactManager;
        
        self.allowSearch = YES;
    }
    
    return self;
}

- (void)triggerServiceWithViewController:(nonnull UIViewController *)viewController
{
    YSGAddressBookViewController *addressBookViewController = [[YSGAddressBookViewController alloc] init];
    
    addressBookViewController.service = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addressBookViewController];
    
    [viewController presentViewController:navigationController animated:YES completion:nil];
}

@end
