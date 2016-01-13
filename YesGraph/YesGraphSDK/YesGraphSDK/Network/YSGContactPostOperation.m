//
//  YSGContactPostOperation.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 12/01/16.
//  Copyright © 2016 YesGraph. All rights reserved.
//

#import "YSGContactPostOperation.h"

@interface YSGContactPostOperation ()
{
    BOOL _executing;
    BOOL _finished;
}

@property (strong, nonatomic) YSGClient *client;
@property (strong, nonatomic) YSGContactList *contactList;
@property (strong, nonatomic) NSString *userId;

@end

@implementation YSGContactPostOperation

- (instancetype)initWithClient:(YSGClient *)client contactsList:(YSGContactList *)partialList andUserId:(NSString *)userId
{
    if ((self = [super init]))
    {
        self.client = client;
        self.contactList = partialList;
        self.userId = userId;
        _executing = NO;
        _finished = NO;
    }
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return _executing;
}

- (BOOL)isFinished
{
    return _finished;
}

- (void)start
{
    if ([self isCancelled])
    {
        [self setIsFinished];
        return;
    }
    if ([self isExecuting])
    {
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    __weak YSGContactPostOperation *postOp = self;
    [self.client updateAddressBookWithContactList:self.contactList forUserId:self.userId completion:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        postOp.responseObject = responseObject;
        postOp.responseError = error;
        [postOp setIsFinished];
        
    }];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setIsFinished
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    _finished = YES;
    _executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
