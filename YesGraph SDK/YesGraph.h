//
//  YesGraph.h
//  YesGraph SDK
//
//  Copyright (c) 2015 YesGraph. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YGYesGraphClient : NSObject
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *clientKey;

+ (instancetype)sharedInstance;
+ (void)configureWithClientKey:(NSString *)clientKey;

// TODO: IMPLEMENT
// - (void)identifyWithTraits:(NSDictionary *)traits;
// - (void)rankedAddressBook;
// - (void)rankedAddressBookWithLimit:(NSInteger)limit;

- (void)postAddressBook;
- (void)fetchAddressBook;

- (void)test;
@end
