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

- (void)fillArray:(NSMutableString *)array fromChar:(char)start toChar:(char)end
{
    for(char c = start; c <= end; ++c)
    {
        [array appendFormat:@"%c", c];
    }
}

- (NSString *)randomID
{
    //
    // TODO: Random
    //
    
    const unsigned int totalLength = ('9' - '0') + ('Z' - 'A') + ('z' - 'a');
    NSMutableString *characters = [[NSMutableString alloc] initWithCapacity:totalLength];
    [self fillArray:characters fromChar:'0' toChar:'9'];
    [self fillArray:characters fromChar:'a' toChar:'z'];
    [self fillArray:characters fromChar:'A' toChar:'Z'];
    const unsigned int totalStringLength = 16;
    NSMutableString *returnString = [[NSMutableString alloc] initWithCapacity:totalStringLength];
    for(unsigned int i = 0; i < totalStringLength; ++i)
    {
        uint32_t randomIndex = arc4random_uniform((uint32_t)characters.length);
        [returnString appendFormat:@"%c", [characters characterAtIndex:randomIndex]];
    }
    return returnString;
}

@end
