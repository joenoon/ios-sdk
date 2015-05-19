//
//  YesGraph.h
//  YesGraph SDK
//
//  Copyright (c) 2015 YesGraph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGYesGraphClient : NSObject

@property (nonatomic, strong) NSString *clientKey;

+(instancetype)sharedInstance;
+(void)configureWithClientKey:(NSString *)clientKey;

@end
