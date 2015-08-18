//
//  YesGraph.h
//  YesGraph SDK
//
//  Copyright (c) 2015 YesGraph. All rights reserved.
//

#import <Foundation/Foundation.h>

// YGCompletionBlock
typedef void(^YGCompletionBlock)(NSDictionary *response, NSError *error);


@interface YGYesGraphClient : NSObject
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *clientKey;

+ (instancetype)sharedInstance;
+ (void)configureWithClientKey:(NSString *)clientKey;

// TODO: IMPLEMENT
// - (void)identifyWithTraits:(NSDictionary *)traits;
// - (void)rankedAddressBook;
// - (void)rankedAddressBookWithLimit:(NSInteger)limit;


//-------------------------------------------------------------------
// Posting Data
//-------------------------------------------------------------------

// Address Book
- (void)postAddressBook:(NSArray *)addressBookArray
              forSource:(NSDictionary *)source
  withCompletionHandler:(YGCompletionBlock)completionHandler;



// Facebook
- (void)postFacebookData:(NSArray *)friendsArray
       forFacebookSource:(NSDictionary *)source
   withCompletionHandler:(YGCompletionBlock)completionHandler;



// Users
- (void)postUserArray:(NSArray *)usersArray
withCompletionHandler:(YGCompletionBlock)completionHandler;



// Invite Sent
- (void)postInviteSentToEmail:(NSString *)email
                      orPhone:(NSString *)phoneNumber
                       atTime:(NSString *)timestamp
        withCompletionHandler:(YGCompletionBlock)completionHandler;



// Invite Accepted
- (void)postInviteAcceptedWithEmail:(NSString *)email
                            orPhone:(NSString *)phoneNumber
                             atTime:(NSString *)timestamp
              withCompletionHandler:(YGCompletionBlock)completionHandler;



//-------------------------------------------------------------------
// Fetching Data
//-------------------------------------------------------------------

// Address Book
- (void)fetchRankedAddressBookWithCompletionHandler:(void (^)(NSDictionary *addressBook, NSError *error))completionHandler;


// Facebook
- (void)fetchRankedFacebookFriendsWithCompletionHandler:(YGCompletionBlock)completionHandler;


// Users
- (void)fetchUsersWithCompletionHandler:(YGCompletionBlock)completionHandler;


// Test
- (void)test;
@end
