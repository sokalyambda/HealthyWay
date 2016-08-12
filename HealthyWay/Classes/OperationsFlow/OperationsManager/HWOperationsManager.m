//
//  HWOperationsManager.m
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWOperationsManager.h"

@interface HWOperationsManager ()

@property (strong, nonatomic) NSOperationQueue *operations;

@end

@implementation HWOperationsManager

#pragma mark - Accessors

- (NSOperationQueue *)operations
{
    if (!_operations) {
        _operations = [[NSOperationQueue alloc] init];
        _operations.name = @"com.operations.queue";
        _operations.maxConcurrentOperationCount = 50;
    }
    return _operations;
}

#pragma mark - Lifecycle

+ (instancetype)sharedManager
{
    static HWOperationsManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

#pragma mark - Actions

- (void)enqueueOperation:(HWBaseOperation *)operation
               onSuccess:(SuccessOperationBlock)success
               onFailure:(FailureOperationBlock)failure
{
    [self.operations addOperation:operation];
    
    __block HWBaseOperation *weakOperation = operation;
    
    [operation setCompletionBlock:^{
        
        NSError *error = weakOperation.error;
        /**
         *  We have to guarantee that UI things will be performed on the main thread;
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error && success) {
                success(weakOperation);
            } else if (error && failure) {
                failure(weakOperation, error, weakOperation.isCancelled);
            }
        });
    }];
}

@end
