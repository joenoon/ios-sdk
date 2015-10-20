//
//  YSGRankedContact.h
//  YesGraphSDK
//
//  Created by Dal Rupnik on 19/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGContact.h"

@interface YSGRankedContact : YSGContact

@property (nullable, nonatomic, strong) NSNumber *rank;
@property (nullable, nonatomic, strong) NSNumber *score;

@end
