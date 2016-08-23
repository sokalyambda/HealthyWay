//
//  HWFetchRequestingFriendsTask.m
//  HealthyWay
//
//  Created by Eugenity on 22.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFetchRequestingFriendsTask.h"

#import "HWUserProfileService.h"

@interface HWFetchRequestingFriendsTask ()

@property (nonatomic, readwrite) NSArray *requestingFriends;

@end

@implementation HWFetchRequestingFriendsTask

#pragma mark - Actions

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    WEAK_SELF;
    [HWUserProfileService fetchRequestingFriendsOnCompletion:^(NSArray *requestingFriends) {
        weakSelf.requestingFriends = requestingFriends;
        if (success) {
            success();
        }
    }];
}

@end
