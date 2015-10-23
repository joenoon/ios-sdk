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
NSString *const YSGTestClientKey = @"live-WzEsMCwieWVzZ3JhcGhfc2RrX3Rlc3QiXQ.COM_zw.A76PgpT7is1P8nneuSg-49y4nW8";
NSString *const YSGTestClientID = @"1234";

NS_RETURNS_RETAINED NSString *getCombinedAuthHeader(void)
{
    return [NSString stringWithFormat:@"Bearer %@", YSGTestClientKey];
}
