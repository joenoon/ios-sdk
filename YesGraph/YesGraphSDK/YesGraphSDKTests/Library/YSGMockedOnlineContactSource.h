//
//  YSGMockedOnlineContactSource.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 02/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGOnlineContactSource.h"

typedef void (^SendShownSuggestionsHandler)(NSArray <YSGContact *> *sentSuggestions);

@interface YSGMockedOnlineContactSource : YSGOnlineContactSource

@property (strong, nonatomic) SendShownSuggestionsHandler suggestionsShown;

@property (nonatomic, strong) YSGCacheContactSource *cacheSource;

@end
