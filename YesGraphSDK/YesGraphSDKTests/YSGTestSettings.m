//
//  YSGTestSettings.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGTestSettings.h"

//
// TODO: Enter your client key to run tests
//
NSString *const YSGTestClientKey = @"";
NSString *const YSGTestClientID = @"1234";

NS_RETURNS_RETAINED NSString *getCombinedAuthHeader(void)
{
    return [NSString stringWithFormat:@"Bearer %@", YSGTestClientKey];
}
