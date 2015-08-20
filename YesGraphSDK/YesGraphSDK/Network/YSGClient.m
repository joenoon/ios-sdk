//
//  YSGClient.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 18/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGClient.h"

NSString *const YSGClientAPIURL = @"https://api.yesgraph.com/v0/";

@interface YSGClient ()

@property (nonatomic, copy) NSURL *baseURL;
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

#pragma mark - Private Methods

#pragma mark - URL Connection

- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completion
{
    NSError *error;
    NSURLRequest *request = [self requestForMethod:@"GET" path:path parameters:parameters error:&error];
    
    [self request:request completion:completion];
}

- (void)POST:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completion
{
    NSError *error;
    NSURLRequest *request = [self requestForMethod:@"POST" path:path parameters:parameters error:&error];
    
    [self request:request completion:completion];
}

- (void)request:(NSURLRequest *)request completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion
{
    [[self.session dataTaskWithRequest:request completionHandler:completion] resume];
}

- (NSURLRequest *)requestForMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters error:(NSError **)error
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path relativeToURL:self.baseURL]];
    
    request.HTTPMethod = method;
    
    if (self.clientKey)
    {
        [request addValue:[NSString stringWithFormat:@"Bearer %@", self.clientKey] forHTTPHeaderField:@"Authorization"];
    }
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:error];
    
    return request;
}

- (id)parseJSONfromData:(NSData *)data error:(NSError **)error
{
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
}

@end
