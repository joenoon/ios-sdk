//
//  YGNetworkManager.h
//  YesGraph SDK
//
//  Created by Contractor Erik on 6/3/15.
//  Copyright (c) 2015 YesGraph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGNetworkManager : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
+ (instancetype)sharedInstance;


@end
