//
//  YSGLogger.m
//  YesGraphSDK
//
//  Created by Dal Rupnik on 08/09/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

#import "YSGLog.h"

#import "YSGLogger.h"

@interface YSGLogger ()

@property (nonatomic, strong) NSMutableArray <YSGLog *>*logPool;

@end

@implementation YSGLogger

#pragma mark - Singleton

+ (instancetype)shared
{
    static id shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

#pragma mark - Getters and Setters

- (NSMutableArray <YSGLog *> *)logPool
{
    if (!_logPool)
    {
        _logPool = [NSMutableArray array];
    }
    
    return _logPool;
}

- (NSArray <YSGLog *>*)logs
{
    return self.logPool.copy;
}

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.currentLogLevel = YSGLogLevelDebug;
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)addLog:(YSGLog *)log
{
    if (log.level <= self.currentLogLevel)
    {
        [log print];
    }
    
    [self.logPool addObject:log];
}

#pragma mark - Convenience

+ (void)logLevel:(YSGLogLevel)level file:(const char *)file function:(const char *)function line:(NSUInteger)line format:(NSString *)format, ...
{
    YSGLog* log = [[YSGLog alloc] init];
    
    log.level = level;
    log.file = [[NSString stringWithUTF8String:file] lastPathComponent];
    log.function = [NSString stringWithUTF8String:function];
    log.line = line;
    
    va_list args;
    va_start(args, format);
    
    //NSLog(@"Format: %@", format);
    
    log.message = [[NSString alloc] initWithFormat:format arguments:args];
    
    va_end(args);
    
    [[self shared] addLog:log];
}

+ (void)logError:(NSError *)error file:(const char *)file function:(const char *)function line:(NSUInteger)line
{
    [self logLevel:YSGLogLevelError file:file function:function line:line format:@"Failure: %@", error.localizedDescription];
}

@end
