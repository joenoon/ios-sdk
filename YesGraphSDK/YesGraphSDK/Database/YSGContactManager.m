//
//  YSGContactManager.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 19/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Contacts;
@import AddressBook;

#import "YSGContactManager.h"

@implementation YSGContactManager

#pragma mark - Public Methods

- (void)fetchContactListWithCompletion:(void (^)(NSArray<YSGContact *> *))completion
{
    if (!completion)
    {
        return;
    }
}

#pragma mark - Private Methods

- (void)fetchLocalAddressBookWithCompletion:(void (^)(NSArray<YSGContact *> *))completion
{
    
}

@end
