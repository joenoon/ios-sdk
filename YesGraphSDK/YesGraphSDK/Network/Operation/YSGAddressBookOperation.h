//
//  YSGAddressBookOperation.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 20/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGContact.h"

@interface YSGAddressBookOperation : NSOperation

- (instancetype _Nonnull)initWithContacts:(NSArray <YSGContact *> * _Nonnull)
entries;

@end
