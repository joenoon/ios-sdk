//
//  YSGClient+Private.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient+Private.h"
#import "YSGUtility.h"

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

- (void)fillArray:(NSMutableString *)array fromChar:(char)start toChar:(char)end
{
    for(char c = start; c <= end; ++c)
    {
        [array appendFormat:@"%c", c];
    }
}

- (NSString *)randomID
{
    return [YSGUtility randomUserId];
}

@end
