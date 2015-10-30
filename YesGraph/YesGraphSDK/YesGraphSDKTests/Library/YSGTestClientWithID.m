//
//  YSGTestClientWithID.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 29/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGTestClientWithID.h"

@implementation YSGTestClientWithID

- (instancetype)initWithId:(NSString *)clientId
{
    if ((self = [super init]))
    {
        self.clientID = clientId;
    }
    return self;
}

- (NSURLRequest *)requestForMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters key:(NSString *)key error:(NSError * _Nullable __autoreleasing *)error
{
    NSMutableURLRequest *req = (NSMutableURLRequest *)[super requestForMethod:method path:path parameters:parameters key:key error:error];
    [req addValue:self.clientID forHTTPHeaderField:@"YSGClientID"];
    return req;
}

@end
