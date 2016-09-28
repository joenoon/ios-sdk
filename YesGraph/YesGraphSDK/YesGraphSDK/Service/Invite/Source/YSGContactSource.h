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

- (void)fetchContactListWithCompletion:(nullable void (^)(YSGContactList * _Nullable contactList, NSError  * _Nullable error))completion;

@optional
- (void)requestContactPermission:(nullable void (^)(BOOL granted, NSError * _Nullable error))completion;
- (void)requestContactPermission2:(nullable void (^)(BOOL granted, NSError * _Nullable error))completion;

@end
