//
//  HWFetchRequestedFriendsTask.m
//  HealthyWay
//
//  Created by Eugenity on 22.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFetchRequestedFriendsTask.h"

#import "HWUserProfileService.h"

@interface HWFetchRequestedFriendsTask ()

@property (assign, nonatomic) HWFetchRequestedFriendsTaskType type;

@property (nonatomic, readwrite) NSDictionary *outputFields;

@end

@implementation HWFetchRequestedFriendsTask

@synthesize outputFields = _outputFields;

#pragma mark - Lifecycle

- (instancetype)initWithFetchType:(HWFetchRequestedFriendsTaskType)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

#pragma mark - Actions

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    switch (self.type) {
        case HWFetchRequestedFriendsTaskTypeIds: {
            WEAK_SELF;
            [HWUserProfileService fetchRequestedFriendsIdsOnCompletion:^(NSArray *requestedFriendsIds) {

                weakSelf.outputFields = @{
                                          TaskKeyRequestedFriendsIds: requestedFriendsIds
                                          };
                if (success) {
                    success();
                }
            }];
            break;
        }
        case HWFetchRequestedFriendsTaskTypeEntities: {
            WEAK_SELF;
            [HWUserProfileService fetchRequestedFriendsOnCompletion:^(NSArray *requestedFriends) {
                weakSelf.outputFields = @{
                                          TaskKeyRequestedFriends: requestedFriends
                                          };
                if (success) {
                    success();
                }
            }];
            break;
        }
    }
}

@end
