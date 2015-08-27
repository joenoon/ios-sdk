//
//  YSGClient.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient.h"

static NSString *const YSGClientAPIURL = @"https://api.yesgraph.com/v0/";

@interface YSGClient ()

@property (nonatomic, readwrite, copy) NSURL *baseURL;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation YSGClient

+ (instancetype)shared
{
    static id shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        self.baseURL = [NSURL URLWithString:YSGClientAPIURL];
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
    NSURLSessionDataTask* task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (completion)
        {
            YSGNetworkResponse* networkResponse = [[YSGNetworkResponse alloc] initWithDataTask:task response:response data:data];
            completion(networkResponse, networkResponse.error);
        }
    }];
    
    [task resume];
    
    return task;
}

- (nonnull NSURLRequest *)requestForMethod:(nonnull NSString *)method path:(nonnull NSString *)path parameters:(nullable NSDictionary *)parameters key:(nullable NSString *)key error:(NSError *__autoreleasing  __nullable * __nullable)error
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path relativeToURL:self.baseURL]];
    
    request.HTTPMethod = method;
    
    if (key)
    {
        [request addValue:[NSString stringWithFormat:@"Bearer %@", key] forHTTPHeaderField:@"Authorization"];
    }
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (parameters)
    {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:error];
    }
    
    return request.copy;
}

@end
