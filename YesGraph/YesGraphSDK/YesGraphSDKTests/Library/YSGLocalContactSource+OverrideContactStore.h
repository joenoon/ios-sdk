//
//  YSGLocalContactSource+OverrideContactStore.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 23/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGLocalContactSource.h"
@import Contacts;

@interface YSGLocalContactSource (OverrideContactStore)

+ (void)shouldReturnNil:(BOOL)returnNil;

@end

@interface YSGTestMockCNContactStore : CNContactStore

@end
