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

@property (nonatomic, readwrite) NSArray *requestedFriends;

@end

@implementation HWFetchRequestedFriendsTask

#pragma mark - Actions

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    WEAK_SELF;
    [HWUserProfileService fetchRequestedFriendsIdsOnCompletion:^(NSArray *requestedFriendsIds) {
        weakSelf.requestedFriends = requestedFriendsIds;
        if (success) {
            success();
        }
    }];
}

@end
