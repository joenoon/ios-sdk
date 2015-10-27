//
//  YSGCacheContactSource+ExposeFileProperties.h
//  YesGraphSDK
//
//  Created by Nejc Vivod on 26/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGCacheContactSource.h"

@interface YSGCacheContactSource (ExposeFileProperties)

@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSDate *lastUpdateDate;

//- (NSString *)filePath;

@end
