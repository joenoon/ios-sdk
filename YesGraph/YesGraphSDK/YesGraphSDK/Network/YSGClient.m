//
//  YSGClient.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient.h"
#import "YSGConstants.h"
#import "YSGLogging.h"

@interface YSGClient ()

@property (nonatomic, readwrite, copy) NSURL *baseURL;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation YSGClient

#pragma mark - Initialization

- (instancetype)init
{
    return [self initWithBaseURL:[NSURL URLWithString:YSGClientAPIURL]];
}

- (instancetype)initWithClientKey:(NSString *)clientKey
{
    self = [self initWithBaseURL:[NSURL URLWithString:YSGClientAPIURL]];
    
    if (self)
    {
        self.clientKey = clientKey;
    }
    
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    
    if (self)
    {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        self.baseURL = baseURL;
    }
    
    return self;
}

#pragma mark - Public Methods

- (NSURLSessionDataTask *)GET:(NSString *)path parameters:(NSDictionary *)parameters completion:(YSGNetworkRequestCompletion)completion
{
    NSError *error;
    NSURLRequest *request = [self requestForMethod:@"GET" path:path parameters:parameters key:self.clientKey error:&error];
    
    if (error && completion)
    {
        completion(nil, error);
        
        return nil;
    }
    else
    {
        return [self sendRequest:request completion:completion];
    }
}

- (NSURLSessionDataTask *)POST:(NSString *)path parameters:(NSDictionary *)parameters completion:(YSGNetworkRequestCompletion)completion
{
    NSError *error;
    NSURLRequest *request = [self requestForMethod:@"POST" path:path parameters:parameters key:self.clientKey error:&error];
    
    if (error && completion)
    {
        completion(nil, error);
        
        return nil;
    }
    else
    {
        return [self sendRequest:request completion:completion];
    }
}

- (NSURLSessionDataTask *)sendRequest:(NSURLRequest *)request completion:(YSGNetworkRequestCompletion)completion
{
    NSDate* date = [NSDate date];
    
    NSURLSessionDataTask* task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        YSG_LDEBUG(@"Request [%@] %@ finished in: %.6f seconds, error: %@", request.HTTPMethod, request.URL.absoluteString, fabs([date timeIntervalSinceNow]), error.localizedDescription);
        
        if (completion)
        {
            YSGNetworkResponse* networkResponse = [[YSGNetworkResponse alloc] initWithResponse:response data:data error:error];
            completion(networkResponse, networkResponse.error);
        }
    }];
    
    [task resume];
    
    return task;
}

- (NSURLRequest *)requestForMethod:(NSString *)method path:(NSString *)path parameters:(nullable NSDictionary *)parameters key:(nullable NSString *)key error:(NSError *__autoreleasing  __nullable * __nullable)error
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path relativeToURL:self.baseURL]];
    
    request.HTTPMethod = method;
    
    if (key)
    {
        [request addValue:[NSString stringWithFormat:@"Bearer %@", key] forHTTPHeaderField:@"Authorization"];
    }
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //
    // Return nil and error if invalid JSON object
    //
    if (parameters && ![NSJSONSerialization isValidJSONObject:parameters])
    {
        if (error)
        {
            *error = YSGErrorWithErrorCode(YSGErrorCodeParse);
        }
        
        return nil;
    }
    
    if (parameters && [NSJSONSerialization isValidJSONObject:parameters])
    {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:error];
    }
    
    return request.copy;
}

@end
