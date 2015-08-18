//
//  YGNetworkManager.m
//  YesGraph SDK
//
//  Created by Contractor Erik on 6/3/15.
//  Copyright (c) 2015 YesGraph. All rights reserved.
//

#import "YGNetworkManager.h"
#import "YGNetworkOperation.h"

@interface YGNetworkManager ()
@property (nonatomic, strong) NSMutableDictionary *requestDictionary;
@property (nonatomic, strong) NSOperationQueue *requestQueue;
@end


@implementation YGNetworkManager

static NSString *baseUrlString  = @"https://api.yesgraph.com/v0";

+ (instancetype)sharedInstance {
    static dispatch_once_t dispatch_token;
    static YGNetworkManager *manager = nil;
    
    dispatch_once(&dispatch_token, ^{
        manager = [[YGNetworkManager alloc] init];
    });
    return manager;
}


- (instancetype)init
{
    if (self = [super init])
    {
        _requestDictionary  = [[NSMutableDictionary alloc] init];
        _requestQueue       = [[NSOperationQueue alloc] init];
    }
    return self;
}


- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(NSURLResponse *response, NSData *responseData))success
    failure:(void (^)(NSURLResponse *response, NSData *responseData, NSError *error))failure
{
    YGNetworkOperation *operation   = [[YGNetworkOperation alloc] init];
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    request.HTTPMethod              = @"GET";
    operation.request               = request;
    operation.successBlock          = success;
    operation.failureBlock          = failure;
    
    // Auth
    if (nil != _clientKey)
    {
        [request addValue:[NSString stringWithFormat:@"Bearer %@", _clientKey] forHTTPHeaderField:@"Authorization"];
    }
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:_requestQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (nil == connectionError)
        {
            NSString *dataString    = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"YesGraph Network Success - %@", dataString);

            success(response, data);
        }
        else
        {
            NSString *errorString   = [[connectionError userInfo] description];
            NSLog(@"YesGraph Network Failure - %@", errorString);
            
            failure(response, data, connectionError);
        }
    }];
}


- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(NSURLResponse *response, NSData *responseData))success
     failure:(void (^)(NSURLResponse *response, NSData *responseData, NSError *error))failure
{
    YGNetworkOperation *operation   = [[YGNetworkOperation alloc] init];
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    request.HTTPMethod              = @"POST";
    operation.request               = request;
    operation.successBlock          = success;
    operation.failureBlock          = failure;
    
    // Body
    if (nil != parameters)
    {
        NSData *requestData = nil;
        if (YES == [parameters isKindOfClass:[NSString class]])
        {
            requestData = [parameters dataUsingEncoding:NSUTF8StringEncoding];
        }
        else if (YES == [parameters isKindOfClass:[NSDictionary class]])
        {
            NSError *error;
            requestData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        }

        request.HTTPBody    = requestData;
    }
    
    // Headers
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Auth
    if (nil != _clientKey)
    {
        [request addValue:[NSString stringWithFormat:@"Bearer %@", _clientKey] forHTTPHeaderField:@"Authorization"];
    }
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:_requestQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (nil == connectionError)
         {
             NSString *dataString    = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"YesGraph Network Success - %@", dataString);

             success(response, data);
         }
         else
         {
             NSString *errorString   = [[connectionError userInfo] description];
             NSLog(@"YesGraph Network Failure - %@", errorString);

             failure(response, data, connectionError);
         }
     }];
}


#pragma mark NSURLConnectionDataDelegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}


#pragma mark NSURLConnectionDelegate Methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

@end
