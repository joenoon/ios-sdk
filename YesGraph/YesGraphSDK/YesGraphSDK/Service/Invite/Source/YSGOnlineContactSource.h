//
//  YSGOnlineContactSource.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 25/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;

#import "YSGClient.h"
#import "YSGContactSource.h"
#import "YSGCacheContactSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSGOnlineContactSource : NSObject <YSGContactSource>

/*!
 *  User ID to connects to contact list
 */
@property (nullable, nonatomic, copy) NSString *userId;

/*!
 *  Base source is used when online YesGraph address book entries are not available
 */
@property (nonatomic, readonly) id<YSGContactSource> localSource;

/*!
 *  Client that makes API calls
 */
@property (nonatomic, readonly) YSGClient *client;

/*!
 *  Default initializer is not available
 *
 *  @return nil
 */
- (nullable instancetype)init NS_UNAVAILABLE;

/*!
 *  Instantiate new online contact source
 *
 *  @param client      online client to connect
 *  @param localSource local backup source if cache and local source fail
 *  @param cacheSource optional source that caches online responses
 *
 *  @return instance
 */
- (instancetype)initWithClient:(YSGClient *)client localSource:(id<YSGContactSource>)localSource cacheSource:(YSGCacheContactSource *)cacheSource NS_DESIGNATED_INITIALIZER;
                                
@end

@class YSGContact;
                                
@interface YSGOnlineContactSource (SuggestionsShown)


/*!
 *  This retrieves the contact list from the app cache if it exists, otherwise it retrieves it from the phone. Then it uploads
 * to YesGraph and runs the completion on the results.
 */
- (void)fetchContactListWithCompletion:(void (^)(YSGContactList *, NSError *))completion;

/*!
 *  This method retrieves the contact list from the phone, uploads them to YesGraph, and runs the completion on the response
 */
- (void)updateAndUploadContactListWithCompletion:(void (^)(YSGContactList *, NSError *))completion;

/*!
 * This method uploads a contact list to YesGraph.
 */
- (void)uploadContactList:(YSGContactList *)contactList completion:(void (^)(YSGContactList *, NSError *))completion;

/*!
 *  Every time the suggestions list is shown, it is sent to the YesGraph API
 */
- (void)updateShownSuggestions:(NSArray <YSGContact *> *)contacts contactList:(YSGContactList *)contactList;

@end
                                
NS_ASSUME_NONNULL_END
