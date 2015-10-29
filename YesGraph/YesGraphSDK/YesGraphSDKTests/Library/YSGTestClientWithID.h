//
//  YSGTestClientWithID.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 29/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient+Private.h"

@interface YSGTestClientWithID : YSGClient

#define GENERATE_ID() ([NSString stringWithFormat:@"%s_%s", __FILE__, __FUNCTION__])

@property (strong, nonatomic) NSString *clientID;

- (instancetype)initWithId:(NSString *)clientId;

@end
