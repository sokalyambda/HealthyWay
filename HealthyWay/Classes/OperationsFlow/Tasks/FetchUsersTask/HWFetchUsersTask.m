//
//  HWFetchUsersTask.m
//  HealthyWay
//
//  Created by Eugenity on 15.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFetchUsersTask.h"

#import "HWUserProfileService.h"

@interface HWFetchUsersTask ()

@property (assign, nonatomic) HWFetchUsersTaskType taskType;

@property (nonatomic) NSArray<id<HWUserProfile>> *users;

@property (nonatomic) NSError *error;

@end

@implementation HWFetchUsersTask

@synthesize error = _error;

#pragma mark - Lifecycle

- (instancetype)initWithUsersFetchingType:(HWFetchUsersTaskType)fetchType
{
    self = [super init];
    if (self) {
        _taskType = fetchType;
    }
    return self;
}

#pragma mark - Actions

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    WEAK_SELF;
    switch (self.taskType) {
        case HWFetchUsersTaskTypeTypeAll: {
//            [HWUserProfileService fetchAllUsersDataWithCompletion:^(NSArray *users, NSError *error) {
//                
//            }];
            break;
        }
        case HWFetchUsersTaskTypeCurrent: {
            
            [HWUserProfileService fetchCurrentUserDataWithCompletion:^(NSArray *users, NSError *error) {
                
                weakSelf.users = users;
                weakSelf.error = error;
                
                if (error && failure) {
                    return failure(error);
                }
                if (!error && success) {
                    return success(users);
                }
                
            }];
            break;
        }
    }
}

@end
