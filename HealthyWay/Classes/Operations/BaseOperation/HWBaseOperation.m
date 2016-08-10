//
//  HWBaseOperation.m
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseOperation.h"

@implementation HWBaseOperation

#pragma mark - Accessors

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

#pragma mark - Actions

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
