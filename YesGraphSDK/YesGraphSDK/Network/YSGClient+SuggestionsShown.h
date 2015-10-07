//
//  YSGClient+InvitesShown.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 05/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient.h"
#import "YSGContactList.h"

NS_ASSUME_NONNULL_BEGIN
@interface YSGClient (SuggestionsShown)

/*!
 *  This send all shown suggestions to YesGraph
 *
 *  @param  suggestionsShown list of all the contact suggestions shown to the user
 *  @param  userId           ID of the user that was shown the suggestions
 *  @param  completion       called when completed
 *
 */
- (void)updateSuggestionsSeen:(NSArray <YSGContact *> *)suggestionsShown forUserId:(NSString *)userId withCompletion:(nullable void (^)(NSError * _Nullable error))completion;

@end
NS_ASSUME_NONNULL_END
