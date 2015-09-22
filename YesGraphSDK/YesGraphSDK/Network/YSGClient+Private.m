//
//  YSGClient+Private.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient+Private.h"

@implementation YSGClient (Private)

#pragma mark - Public Methods

- (void)fetchRandomClientKeyWithSecretKey:(NSString *)secretKey completion:(void (^)(NSString *clientKey, NSError *error))completion
{
    [self fetchClientKeyWithSecretKey:secretKey forUser:[self randomID] completion:completion];
}

- (void)fetchClientKeyWithSecretKey:(NSString *)secretKey forUser:(NSString *)user completion:(void (^)(NSString *clientKey, NSError *error))completion
{
    NSURLRequest *request = [self requestForMethod:@"POST" path:@"client-key" parameters:@{ @"user_id" : user } key:secretKey error:nil];
    
    [self sendRequest:request completion:^(YSGNetworkResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error && completion)
        {
            completion(nil, error);
        }
        else if (completion)
        {
            if (response.responseObject[@"client_key"])
            {
                completion(response.responseObject[@"client_key"], nil);
            }
            else
            {
                completion(nil, nil);
            }
        }
    }];
}

#pragma mark - Private Methods

- (NSString *)randomID
{
    //
    // TODO: Random
    //
    const NSInteger stringLength = 16 / sizeof(UInt32);
    UInt32 stringBytes[stringLength];
    arc4random_buf(stringBytes, stringLength * sizeof(UInt32));
    return @"";
}

@end
