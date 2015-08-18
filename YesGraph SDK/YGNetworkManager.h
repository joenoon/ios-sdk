//
//  YGNetworkManager.h
//  YesGraph SDK
//
//  Created by Contractor Erik on 6/3/15.
//  Copyright (c) 2015 YesGraph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGNetworkManager : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSString *clientKey;

+ (instancetype)sharedInstance;

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(NSURLResponse *response, NSData *responseData))success
    failure:(void (^)(NSURLResponse *response, NSData *responseData, NSError *error))failure;

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(NSURLResponse *response, NSData *responseData))success
     failure:(void (^)(NSURLResponse *response, NSData *responseData, NSError *error))failure;
@end
