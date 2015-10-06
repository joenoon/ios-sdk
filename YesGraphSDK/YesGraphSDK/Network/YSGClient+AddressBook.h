//
//  YSGClient+AddressBook.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient.h"
#import "YSGContactList.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSGClient (AddressBook)

- (void)fetchAddressBookForUserId:(NSString *)userId completion:(nullable YSGNetworkFetchCompletion)completion;

- (void)updateAddressBookWithContactList:(YSGContactList *)contactList forUserId:(NSString *)userId completion:(nullable YSGNetworkFetchCompletion)completion;

@end

NS_ASSUME_NONNULL_END
