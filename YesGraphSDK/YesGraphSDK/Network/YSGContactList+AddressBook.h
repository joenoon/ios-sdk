//
//  YSGContactList+AddressBook.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGContactList.h"
#import "YSGNetworkDefines.h"

@interface YSGContactList (AddressBook)

- (void)updateAddressBookWithCompletion:(nullable YSGNetworkFetchCompletion)completion;

+ (void)fetchAddressBookWithCompletion:(nullable YSGNetworkFetchCompletion)completion;

@end
