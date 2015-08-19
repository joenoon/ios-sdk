//
//  YSGContactManager.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 19/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGContact.h"

/*!
 *  Contact manager
 */
@interface YSGContactManager : NSObject

@property (nonatomic, readonly) BOOL didAskForPermission;
@property (nonatomic, readonly) BOOL hasContactsPermission;

+ (instancetype)shared;

- (NSArray<YSGContact *> *)contactListInLocalAddressBook;

- (void)cacheContactList:(NSArray<YSGContact *> *)contacts;

@end
