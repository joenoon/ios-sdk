//
//  YSGNetworkResponse+ParsingMock.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 23/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGNetworkResponse+ParsingMock.h"

static NSDictionary *responseObj;

@implementation YSGNetworkResponse (ParsingMock)

- (void)setResponseObject:(id)responseObject
{
    responseObj = responseObject;
}

- (id)responseObject
{
    return responseObj;
}

- (void)setupResponse:(NSDictionary *)dictionary
{
    self.responseObject = dictionary;
}

@end
