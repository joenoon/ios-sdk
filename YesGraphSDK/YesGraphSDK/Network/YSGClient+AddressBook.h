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

/*!
 *  Retrieves the address book for the given User ID
 *  
 *  @param userId       ID of the user
 *  @param completion   called when completed
 */
- (void)fetchAddressBookForUserId:(nonnull NSString *)userId completion:(nullable YSGNetworkFetchCompletion)completion;

/*!
 *
 *  Updates the address book with the provided contact list
 *
 *  @param contactList  list of contacts that are to be updated
 *  @param completion   called when completed
 */
- (void)updateAddressBookWithContactList:(nonnull YSGContactList *)contactList completion:(nullable YSGNetworkFetchCompletion)completion;

@end
