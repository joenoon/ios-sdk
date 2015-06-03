//
//  YGNetworkOperation.h
//  YesGraph SDK
//
//  Created by Contractor Erik on 6/3/15.
//  Copyright (c) 2015 YesGraph. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^YGNetworkFailureBlock) (NSURLResponse *response, NSData *responseData, NSError *error);
typedef void (^YGNetworkSuccessBlock) (NSURLResponse *response, NSData *responseData);

@interface YGNetworkOperation : NSObject
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, assign) YGNetworkFailureBlock failureBlock;
@property (nonatomic, assign) YGNetworkSuccessBlock successBlock;
@end
