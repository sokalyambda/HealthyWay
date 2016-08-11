//
//  HWFetchUsersService.m
//  HealthyWay
//
//  Created by Eugenity on 11.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFetchUsersService.h"

@interface HWFetchUsersService ()

@property (strong, nonatomic) NSOperationQueue *fetchUsersOperations;

@property (assign, nonatomic) HWFetchUsersOperationType fetchType;

@end

@implementation HWFetchUsersService

#pragma mark - Accessors

- (NSOperationQueue *)fetchUsersOperations
{
    if (!_fetchUsersOperations) {
        _fetchUsersOperations = [[NSOperationQueue alloc] init];
        _fetchUsersOperations.name = @"com_fetch_users_operations_queue";
        _fetchUsersOperations.maxConcurrentOperationCount = 10;
    }
    return _fetchUsersOperations;
}

#pragma mark - Lifecycle

- (instancetype)initWithFetchUsersOperationType:(HWFetchUsersOperationType)fetchType
{
    self = [super init];
    if (self) {
        _fetchType = fetchType;
    }
    return self;
}

#pragma mark - Actions

- (HWFetchUsersOperation *)fetchUsersWithCompletion:(HWFetchUsersCompletion)completion
{
    HWFetchUsersOperation *operation = [[HWFetchUsersOperation alloc] initWithFetchingType:self.fetchType];
    [self.fetchUsersOperations addOperation:operation];
    
    __block HWFetchUsersOperation *weakOperation = operation;
    
    [operation setCompletionBlock:^{
        
        NSError *error = weakOperation.error;
        /**
         *  We have to guarantee that UI things will be performed on the main thread;
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(weakOperation.users, error);
            }
        });
    }];
    return operation;
}

@end
