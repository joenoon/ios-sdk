//
//  YSGContactSource.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 25/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@class YSGContactList;

@import Foundation;

@protocol YSGContactSource <NSObject>

- (void)requestContactPermission:(void (^)(BOOL granted, NSError *error))completion;
- (void)fetchContactListWithCompletion:(void (^)(YSGContactList *contactList, NSError *error))completion;

@end