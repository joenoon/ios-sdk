//
//  YSGContactList.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 26/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGContact.h"

/*!
 *  Wraps contact list for storage and serialization
 */
@interface YSGContactList : NSObject

@property (nonatomic, assign) BOOL useSuggestions;

@property (nonnull, nonatomic, copy) NSArray <YSGContact *> *contacts;

@end
