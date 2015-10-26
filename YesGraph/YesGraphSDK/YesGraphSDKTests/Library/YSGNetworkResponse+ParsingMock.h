//
//  YSGNetworkResponse+ParsingMock.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 23/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSGNetworkResponse.h"

@interface YSGNetworkResponse (ParsingMock)

@property (readwrite, nonatomic, strong) id responseObject;

- (void)setupResponse:(NSDictionary *)dictionary;

@end
