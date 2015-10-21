//
//  YSGMockClient.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 21/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
#import "YSGClient.h"

@interface YSGMockClient : NSObject

- (YSGClient *)createMockedClient:(BOOL)shouldSucceed;

@end
