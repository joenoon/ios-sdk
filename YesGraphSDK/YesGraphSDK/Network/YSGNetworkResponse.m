//
//  YSGNetworkResponse.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 27/08/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGNetworkResponse.h"

@interface YSGNetworkResponse ()

//
// Received Data
//
@property (nonatomic, strong, readwrite) NSURLSessionDataTask *dataTask;
@property (nonatomic, copy, readwrite) NSData *data;


//
// Received Error
//
@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, strong, readwrite) id responseObject;

@end

@implementation YSGNetworkResponse

- (nonnull instancetype)init
{
    [[NSException exceptionWithName:@"Invalid call" reason:@"Cannot initialize empty network response." userInfo:nil] raise];
    
    return [self initWithDataTask:nil data:nil];
}

- (nonnull instancetype)initWithDataTask:(NSURLSessionDataTask *)dataTask data:(NSData *)data
{
    self = [super init];
    
    if (self)
    {
        self.dataTask = dataTask;
        self.data = data;
        
        if (dataTask.error)
        {
            self.error = dataTask.error;
        }
        else if (data.length)
        {
            NSError* parseError;
            self.responseObject = [self parseJSONfromData:data error:&parseError];
            
            if (parseError)
            {
                self.error = parseError;
            }
        }
    }
    
    return self;
}

- (id)parseJSONfromData:(NSData *)data error:(NSError **)error
{
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
}

@end
