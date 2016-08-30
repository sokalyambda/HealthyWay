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

- (instancetype)initWithUsersFetchingType:(HWFetchUsersTaskType)fetchType
                             searchString:(NSString *)searchedText
{
    self = [self initWithUsersFetchingType:fetchType];
    
    if (self) {
        _searchedText = searchedText;
    }
    
    return self;
}

#pragma mark - Actions

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    [super performCurrentTaskOnSuccess:success onFailure:failure];
    WEAK_SELF;
    switch (self.taskType) {
        case HWFetchUsersTaskTypeTypeAll: {
            [HWUserProfileService fetchUsersDataWithSearchString:self.searchedText onCompletion:^(NSArray *users, NSError *error) {
                [weakSelf completeTaskWithUsers:users error:error];
            }];
            break;
        }
        case HWFetchUsersTaskTypeCurrent: {
            [HWUserProfileService fetchCurrentUserDataWithCompletion:^(NSArray *users, NSError *error) {
                [weakSelf completeTaskWithUsers:users error:error];
            }];
            break;
        }
    }
}

- (void)completeTaskWithUsers:(NSArray *)users error:(NSError *)error
{
    self.users = users;
    self.error = error;
    
    if (error && self.failureBlock) {
        return self.failureBlock(error);
    }
    if (!error && self.successBlock) {
        return self.successBlock(users);
    }
}

@end
