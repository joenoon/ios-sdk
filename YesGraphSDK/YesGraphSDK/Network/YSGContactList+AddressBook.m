//
//  YSGContactList+AddressBook.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient.h"
#import "YSGContactList+AddressBook.h"

@implementation YSGContactList (AddressBook)

- (void)updateAddressBookWithCompletion:(YSGNetworkFetchCompletion)completion
{
    [[YSGClient shared] POST:@"address-book" parameters:[self ysg_toDictionary] completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
}

@end
