//
//  YSGClient+AddressBook.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient+AddressBook.h"
#import "YSGContactList.h"
#import "YSGRankedContact.h"

@implementation YSGClient (AddressBook)

- (void)fetchAddressBookForUserId:(nonnull NSString *)userId completion:(YSGNetworkFetchCompletion)completion
{
    [self GET:[NSString stringWithFormat:@"address-book/%@", userId] parameters:nil completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
    {
        if (completion)
        {
            if (!error)
            {
                NSMutableArray <YSGRankedContact *> *contacts = [NSMutableArray array];
                
                for (id object in response.responseObject[@"data"])
                {
                    YSGRankedContact* rankedContact = [YSGRankedContact ysg_objectWithDictionary:object];
                    
                    if (rankedContact)
                    {
                        [contacts addObject:rankedContact];
                    }
                }
                
                YSGContactList *contactList = [[YSGContactList alloc] init];
                contactList.entries = contacts.copy;
                contactList.useSuggestions = YES;
                
                completion(contactList, error);
            }
            else
            {
                completion(nil, error);
            }
        }
    }];
}

- (void)updateAddressBookWithContactList:(YSGContactList *)contactList completion:(YSGNetworkFetchCompletion)completion
{
    [self POST:@"address-book" parameters:[contactList ysg_toDictionary] completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
    {
        if (completion)
        {
            completion(response.responseObject, error);
        }
    }];
}

@end
