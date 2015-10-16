//
//  YSGParsableMocked.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 16/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import Foundation;
#import "NSObject+YSGParsable.h"

@interface YSGObjectParsableMocked : NSObject

@property (strong, nonatomic) NSString *prop1;
@property (strong, nonatomic) NSArray <NSString *> *prop2;
@property (strong, nonatomic) NSData *prop3;

- (NSDictionary *)mappedKvp;

@end
