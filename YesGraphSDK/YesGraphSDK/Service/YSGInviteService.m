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
#import "YSGContactSource.h"

NSString * const YSGInviteContactsKey = @"YSGInviteContactsKey";

@interface YSGInviteService ()

@property (nonatomic, strong, readwrite) id<YSGContactSource> contactSource;

@end

@implementation YSGInviteService

- (NSString *)name
{
    return @"Contacts";
}

- (instancetype)initWithContactSource:(id<YSGContactSource>)contactSource
{
    self = [super init];
    
    if (self)
    {
        self.contactSource = contactSource;
        
        self.allowSearch = YES;
    }
    
    return self;
}

- (void)triggerServiceWithViewController:(nonnull UIViewController *)viewController
{
    [self.contactSource requestContactPermission:^(BOOL granted, NSError *error)
    {
        if (granted)
        {
            [self openInviteControllerWithController:viewController];
        }
        else if (error)
        {
            [[[UIAlertView alloc] initWithTitle:@"YesGraph" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }];
}

- (void)openInviteControllerWithController:(nonnull UIViewController *)viewController
{
    YSGAddressBookViewController *addressBookViewController = [[YSGAddressBookViewController alloc] init];
    
    addressBookViewController.service = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addressBookViewController];
    
    [viewController presentViewController:navigationController animated:YES completion:nil];
}

@end
