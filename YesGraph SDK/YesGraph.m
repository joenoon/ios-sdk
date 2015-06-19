//
//  YesGraph.m
//  YesGraph SDK
//
//  Copyright (c) 2015 YesGraph. All rights reserved.
//

#import "YesGraph.h"
#import "YGNetworkManager.h"


@implementation YGYesGraphClient


+ (instancetype)sharedInstance
{
    static dispatch_once_t dispatch_token;
    static YGYesGraphClient *client = nil;
    
    dispatch_once(&dispatch_token, ^{
        client = [[self alloc] init];
    });
    return client;
}


+ (void)configureWithClientKey:(NSString *)clientKey
{
    [[self sharedInstance] setClientKey:clientKey];
}


- (void)setClientKey:(NSString *)clientKey
{
    _clientKey  = clientKey;
    
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    networkManager.clientKey            = clientKey;
}


//-------------------------------------------------------------------
// Posting Data
//-------------------------------------------------------------------

// Address Book
- (void)postAddressBook:(NSArray *)addressBookArray
              forSource:(NSDictionary *)source
  withCompletionHandler:(YGCompletionBlock)completionHandler
{
    if (nil == _userId)
    {
        // Note - TODO - might want to create an NSError and call the completion handler with the error
        NSLog(@"YesGraph Error - postAddressBook requires the user_id parameter to be set");
        return;
    }
    
    if (nil == addressBookArray)
    {
        // Note - TODO - might want to create an NSError and call the completion handler with the error
        NSLog(@"YesGraph Error - postAddressBook requires an address book array");
        return;
    }
    
    if (nil == source)
    {
        // Note - TODO - might want to create an NSError and call the completion handler with the error
        NSLog(@"YesGraph Error - postAddressBook requires a source dictionary");
        return;
    }
    
    
    // Note - TODO - might also want to check for well-formed source dictionary before blindly sending
    //               unsanitized data to the servers

    
    NSMutableDictionary *dataPayload    = [[NSMutableDictionary alloc] init];
    dataPayload[@"user_id"]             = _userId;
    dataPayload[@"source"]              = source;
    dataPayload[@"entries"]             = addressBookArray;

    
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString = @"https://api.yesgraph.com/v0/address-book";
    [networkManager POST:urlString
              parameters:dataPayload
                 success:^(NSURLResponse *response, NSData *responseData)
     {
         // Success
         NSError *error;
         NSDictionary *responseDictionary   = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
         
         completionHandler(responseDictionary, error);
     }
                 failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
     {
         // Failure
         completionHandler(nil, error);
     }];
}



// Facebook
- (void)postFacebookData:(NSArray *)friendsArray
       forFacebookSource:(NSDictionary *)source
   withCompletionHandler:(YGCompletionBlock)completionHandler
{
    if (nil == _userId)
    {
        // Note - TODO - might want to create an NSError and call the completion handler with the error
        NSLog(@"YesGraph Error - postFacebookData requires the user_id parameter to be set");
        return;
    }
    
    if (nil == friendsArray)
    {
        // Note - TODO - might want to create an NSError and call the completion handler with the error
        NSLog(@"YesGraph Error - postFacebookData requires a friends array");
        return;
    }
    
    if (nil == source)
    {
        // Note - TODO - might want to create an NSError and call the completion handler with the error
        NSLog(@"YesGraph Error - postFacebookData requires a source dictionary");
        return;
    }
    
    
    // Note - TODO - might also want to check for well-formed source dictionary and friends array before
    //               blindly sending unsanitized data to the servers
    
    
    NSMutableDictionary *dataPayload    = [[NSMutableDictionary alloc] init];
    dataPayload[@"user_id"]             = _userId;
    dataPayload[@"self"]                = source;
    dataPayload[@"friends"]             = friendsArray;
    
    
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString = @"https://api.yesgraph.com/v0/facebook";
    [networkManager POST:urlString
              parameters:dataPayload
                 success:^(NSURLResponse *response, NSData *responseData)
     {
         // Success
         NSError *error;
         NSDictionary *responseDictionary   = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
         
         completionHandler(responseDictionary, error);
     }
                 failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
     {
         // Failure
         completionHandler(nil, error);
     }];
}


// Users
- (void)postUserArray:(NSArray *)usersArray
withCompletionHandler:(YGCompletionBlock)completionHandler
{
    if (nil == usersArray)
    {
        // Note - TODO - might want to create an NSError and call the completion handler with the error
        NSLog(@"YesGraph Error - postUserArray requires a users array");
        return;
    }
    
    
    // Note - TODO - might also want to check for well-formed users array before
    //               blindly sending unsanitized data to the servers
    

    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString = @"https://api.yesgraph.com/v0/users";
    [networkManager POST:urlString
              parameters:usersArray
                 success:^(NSURLResponse *response, NSData *responseData)
     {
         // Success
         NSError *error;
         NSDictionary *responseDictionary   = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
         
         completionHandler(responseDictionary, error);
     }
                 failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
     {
         // Failure
         completionHandler(nil, error);
     }];
}



- (void)postInviteSentToEmail:(NSString *)email
                      orPhone:(NSString *)phoneNumber
                       atTime:(NSString *)timestamp
        withCompletionHandler:(YGCompletionBlock)completionHandler
{
    if (nil == _userId)
    {
        // Note - TODO - might want to create an NSError and call the completion handler with the error
        NSLog(@"YesGraph Error - postInviteSentToEmail requires the user_id parameter to be set");
        return;
    }
    
    if (nil == email && nil == phoneNumber)
    {
        // Note - TODO - might want to create an NSError and call the completion handler with the error
        NSLog(@"YesGraph Error - postInviteSentToEmail requires a phone number or email address");
        return;
    }
    
    
    // Note - TODO - might also want to check for well-formed input paramaters before
    //               blindly sending unsanitized data to the servers
    
    
    NSMutableDictionary *dataPayload    = [[NSMutableDictionary alloc] init];
    dataPayload[@"user_id"]             = _userId;
    if (nil != email)
        dataPayload[@"email"]           = email;
    if (nil != phoneNumber)
        dataPayload[@"phone"]           = phoneNumber;
    if (nil != timestamp)
        dataPayload[@"sent_at"]         = timestamp;
    
    
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString = @"https://api.yesgraph.com/v0/invite-sent";
    [networkManager POST:urlString
              parameters:dataPayload
                 success:^(NSURLResponse *response, NSData *responseData)
     {
         // Success
         NSError *error;
         NSDictionary *responseDictionary   = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
         
         completionHandler(responseDictionary, error);
     }
                 failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
     {
         // Failure
         completionHandler(nil, error);
     }];
}



- (void)postInviteAcceptedWithEmail:(NSString *)email
                            orPhone:(NSString *)phoneNumber
                             atTime:(NSString *)timestamp
              withCompletionHandler:(YGCompletionBlock)completionHandler
{
    if (nil == _userId)
    {
        // Note - TODO - might want to create an NSError and call the completion handler with the error
        NSLog(@"YesGraph Error - postInviteAcceptedWithEmail requires the user_id parameter to be set");
        return;
    }
    
    if (nil == email && nil == phoneNumber)
    {
        // Note - TODO - might want to create an NSError and call the completion handler with the error
        NSLog(@"YesGraph Error - postInviteAcceptedWithEmail requires a phone number or email address");
        return;
    }
    
    
    // Note - TODO - might also want to check for well-formed input paramaters before
    //               blindly sending unsanitized data to the servers
    
    
    NSMutableDictionary *dataPayload    = [[NSMutableDictionary alloc] init];
    dataPayload[@"new_user_id"]         = _userId;
    if (nil != email)
        dataPayload[@"email"]           = email;
    if (nil != phoneNumber)
        dataPayload[@"phone"]           = phoneNumber;
    if (nil != timestamp)
        dataPayload[@"accepted_at"]     = timestamp;
    
    
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString = @"https://api.yesgraph.com/v0/invite-accepted";
    [networkManager POST:urlString
              parameters:dataPayload
                 success:^(NSURLResponse *response, NSData *responseData)
     {
         // Success
         NSError *error;
         NSDictionary *responseDictionary   = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
         
         completionHandler(responseDictionary, error);
     }
                 failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
     {
         // Failure
         completionHandler(nil, error);
     }];
}




//-------------------------------------------------------------------
// Fetching Data
//-------------------------------------------------------------------

// Address Book
- (void)fetchRankedAddressBookWithCompletionHandler:(void (^)(NSDictionary *, NSError *))completionHandler
{
    if (nil == _userId)
    {
        NSLog(@"YesGraph Error - fetchAddressBook requires the user_id parameter to be set");
        return;
    }
    
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString                 = [NSString stringWithFormat:@"https://api.yesgraph.com/v0/address-book/%@", _userId];
    
    [networkManager GET:urlString parameters:nil success:^(NSURLResponse *response, NSData *responseData)
     {
         NSError *error;
         NSDictionary *addressBook  = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
         completionHandler(addressBook, error);
     }
                failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
     {
         completionHandler(nil, error);
     }];
}



// Facebook
- (void)fetchRankedFacebookFriendsWithCompletionHandler:(YGCompletionBlock)completionHandler
{
    if (nil == _userId)
    {
        NSLog(@"YesGraph Error - fetchRankedFacebookFriendsWithCompletionHandler requires the user_id parameter to be set");
        return;
    }
    
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString                 = [NSString stringWithFormat:@"https://api.yesgraph.com/v0/facebook/%@", _userId];
    
    [networkManager GET:urlString parameters:nil success:^(NSURLResponse *response, NSData *responseData)
     {
         NSError *error;
         NSDictionary *responseDictionary   = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
         completionHandler(responseDictionary, error);
     }
                failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
     {
         completionHandler(nil, error);
     }];
}


// Users
- (void)fetchUsersWithCompletionHandler:(YGCompletionBlock)completionHandler
{
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString                 = [NSString stringWithFormat:@"https://api.yesgraph.com/v0/users"];
    
    [networkManager GET:urlString parameters:nil success:^(NSURLResponse *response, NSData *responseData)
     {
         NSError *error;
         NSDictionary *responseDictionary   = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
         completionHandler(responseDictionary, error);
     }
                failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
     {
         completionHandler(nil, error);
     }];
}



- (void)test
{    
    YGNetworkManager *networkManager    = [YGNetworkManager sharedInstance];
    NSString *urlString                 = @"https://api.yesgraph.com/v0/test";
    
    [networkManager GET:urlString parameters:nil success:^(NSURLResponse *response, NSData *responseData)
    {
    }
                failure:^(NSURLResponse *response, NSData *responseData, NSError *error)
    {
    }];
}


// TODO: IMPLEMENT
/*
- (void)identifyWithTraits:(NSDictionary *)traits {
}


- (void)promptForAddressBookAccess {
}


- (NSArray *)readAddressBook {
}


- (void)sendAddressBook {
}


- (void)sendAddressBookIfNeeded {
}


- (void)rankedAddressBook {
}


- (void)rankedAddressBookWithLimit:(NSInteger)limit {
}
*/

@end
