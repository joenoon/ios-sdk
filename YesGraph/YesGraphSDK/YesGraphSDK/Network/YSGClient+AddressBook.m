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

- (void)fetchAddressBookForUserId:(NSString *)userId completion:(YSGNetworkFetchCompletion)completion
{
    [self GET:[NSString stringWithFormat:@"address-book/%@", userId] parameters:nil completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
    {
        if (completion)
        {
            if (!error)
            {
                YSGContactList *contactList = [self contactListForResponseDictionary:response.responseObject[@"data"]];
                
                completion(contactList, error);
            }
            else
            {
                completion(nil, error);
            }
        }
    }];
}

- (void)updateAddressBookWithContactList:(YSGContactList *)contactList forUserId:(NSString *)userId completion:(nullable YSGNetworkFetchCompletion)completion
{
    NSMutableDictionary *parameters = [[contactList ysg_toDictionary] mutableCopy];
    parameters[@"user_id"] = userId;
    
    [self POST:@"address-book" parameters:parameters completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
    {
        if (completion)
        {
            if (!error)
            {
                YSGContactList *contactList = [self contactListForResponseDictionary:response.responseObject[@"data"]];
                
                completion(contactList, error);
            }
            else
            {
                completion(nil, error);
            }
        }
    }];
}

- (YSGContactList *)contactListForResponseDictionary:(NSDictionary *)data
{
    NSMutableArray <YSGRankedContact *> *contacts = [NSMutableArray array];
    
    for (id object in data)
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
    
    return contactList;
}

@end
