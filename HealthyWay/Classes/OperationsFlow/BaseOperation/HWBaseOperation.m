//
//  HWBaseOperation.m
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseOperation.h"

@implementation HWBaseOperation {
    BOOL _isFinished;
    BOOL _isExecuting;
    BOOL _isReady;
}

#pragma mark - Accessors

- (NSError *)error
{
    return self.task.error;
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (BOOL)isFinished
{
    return _isFinished;
}

- (BOOL)isReady
{
    return _isReady;
}

- (BOOL)isAsynchronous
{
    return YES;
}

#pragma mark - Lifecycle

+ (instancetype)operationWithTask:(id<HWTask>)task
{
    return  [[self alloc] initWithTask:task];
}

- (instancetype)initWithTask:(id<HWTask>)task
{
    self = [super init];
    if (self) {
        _isExecuting = NO;
        _isFinished = NO;
        _isReady = NO;
        
        _task = task;
        [self makeReady];
    }
    return self;
}

#pragma mark - Actions

- (void)start
{
    if (![NSThread isMainThread]) {
        return [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
    }
    
    if (self.isCancelled) {
        return [self finish:YES];
    }
    
    /**
     *  The operation begins executing now
     */
    [self execute];
    WEAK_SELF;
    [self.task performCurrentTaskOnSuccess:^{
        [weakSelf completeTheExecution];
    } onFailure:^(NSError *error) {
        [weakSelf completeTheExecution];
    }];
}

/**
 *  Finish the current operation
 */
- (void)completeTheExecution
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)finish:(BOOL)finish
{
    [self willChangeValueForKey:@"isFinished"];
    _isFinished = finish;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)execute
{
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)makeReady
{
    [self willChangeValueForKey:@"isReady"];
    _isReady = YES;
    [self didChangeValueForKey:@"isReady"];
}

@end
