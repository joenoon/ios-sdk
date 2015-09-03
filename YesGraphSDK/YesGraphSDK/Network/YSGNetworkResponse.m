//
//  YSGNetworkResponse.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGConstants.h"
#import "YSGNetworkResponse.h"
#import "YSGParsing.h"

@interface YSGNetworkResponse ()

//
// Received Data
//
@property (nonatomic, strong, readwrite) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong, readwrite) NSURLResponse *response;
@property (nonatomic, copy, readwrite) NSData *data;


//
// Received Error
//
@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, strong, readwrite) id responseObject;

@end

@implementation YSGNetworkResponse

#pragma mark - Initialization

- (nonnull instancetype)init
{
    [[NSException exceptionWithName:@"Invalid call" reason:@"Cannot initialize empty network response." userInfo:nil] raise];
    
    return [self initWithDataTask:nil response:nil data:nil];
}

- (nonnull instancetype)initWithDataTask:(NSURLSessionDataTask *)dataTask response:(NSURLResponse *)response data:(NSData *)data
{
    self = [super init];
    
    if (self)
    {
        self.dataTask = dataTask;
        self.data = data;
        self.response = response;
        
        if (dataTask.error)
        {
            self.error = [NSError errorWithDomain:YSGErrorDomain code:YSGErrorCodeNetwork userInfo:@{ NSUnderlyingErrorKey : dataTask.error }];
        }
        else if (data.length)
        {
            //
            // Check URL response and status code
            //
            
            if ([response isKindOfClass:[NSHTTPURLResponse class]])
            {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode / 200 != 1)
                {
                    self.error = [NSError errorWithDomain:YSGErrorDomain code:YSGErrorCodeServer userInfo:@{ YSGErrorNetworkStatusCodeKey : @(httpResponse.statusCode) }];
                }
            }
            
            NSError* parseError;
            self.responseObject = [self parseJSONfromData:data error:&parseError];
            
            if (parseError && !self.error)
            {
                self.error = [NSError errorWithDomain:YSGErrorDomain code:YSGErrorCodeParse userInfo:@{ NSUnderlyingErrorKey : parseError }];
            }
        }
    }
    
    return self;
}

- (id)parseJSONfromData:(NSData *)data error:(NSError **)error
{
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
}

#pragma mark - Public Methods

- (nullable id)responseObjectSerializedToClass:(nonnull Class)class
{
    if (![class conformsToProtocol:@protocol(YSGParsable)])
    {
        return nil;
    }
    
    id object = [class ysg_objectWithDictionary:self.responseObject];
    return object;
}

@end
