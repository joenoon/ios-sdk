//
//  YSGClient+AddressBook.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient.h"
#import "YSGContactList.h"

@interface YSGClient (AddressBook)

- (void)fetchAddressBookForUserId:(nonnull NSString *)userId completion:(nullable YSGNetworkFetchCompletion)completion;

- (void)updateAddressBookWithContactList:(nonnull YSGContactList *)contactList completion:(nullable YSGNetworkFetchCompletion)completion;

@end
