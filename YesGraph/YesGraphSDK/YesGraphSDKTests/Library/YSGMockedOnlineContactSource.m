//
//  YSGMockedOnlineContactSource.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 02/11/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGMockedOnlineContactSource.h"

@implementation YSGMockedOnlineContactSource

- (void)sendShownSuggestions:(NSArray<YSGContact *> *)contacts
{
    if (self.suggestionsShown)
    {
        self.suggestionsShown(contacts);
    }
}

@end
