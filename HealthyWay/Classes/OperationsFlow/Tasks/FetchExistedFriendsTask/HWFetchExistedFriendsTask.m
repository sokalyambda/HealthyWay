//
//  HWFetchExistedFriendsTask.m
//  HealthyWay
//
//  Created by se on 19/07/2017.
//  Copyright © 2017 Eugenity. All rights reserved.
//

#import "HWFetchExistedFriendsTask.h"

#import "HWUserProfileService.h"

@interface HWFetchExistedFriendsTask ()

@property (strong, nonatomic, readwrite) NSArray *existedFriends;

@end

@implementation HWFetchExistedFriendsTask

#pragma mark - Actions

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    WEAK_SELF;
    [HWUserProfileService fetchExistedFriendsOnCompletion:^(NSArray *existedFriends) {
        weakSelf.existedFriends = existedFriends;
        if (success) {
            success();
        }
    }];
}

@end
