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

- (instancetype)init
{
    [[NSException exceptionWithName:@"Invalid call" reason:@"Cannot initialize empty network response." userInfo:nil] raise];
    
    return [self initWithResponse:nil data:nil error:nil];
}

- (instancetype)initWithResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error
{
    self = [super init];
    
    if (self)
    {
        self.data = data;
        self.response = response;
        
        if (error)
        {
            self.error = [NSError errorWithDomain:YSGErrorDomain code:YSGErrorCodeNetwork userInfo:@{ NSUnderlyingErrorKey : error }];
        }
        else if (data.length)
        {
            //
            // Check URL response and status code
            //
            
            if ([response isKindOfClass:[NSHTTPURLResponse class]])
            {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode < 200 || httpResponse.statusCode > 399)
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

- (nullable id)responseObjectSerializedToClass:(Class)class
{
    if (![class conformsToProtocol:@protocol(YSGParsable)])
    {
        return nil;
    }
    
    id object = [class ysg_objectWithDictionary:self.responseObject];
    return object;
}

@end
